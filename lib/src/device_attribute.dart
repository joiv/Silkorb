/*
 * device_attribute.dart
 * copyright (c) 2014 Joachim Ivarsson 
 */

part of silkorb;

class SilkorbProtocolTag extends Stream<TagEvent> implements Tag, SilkorbProtocol {
  
  static const int READ = 0x01;
  static const int WRITE = 0x02;
  static const int WRITE_ACK = 0x03;
  static const int READ_CONFIG = 0x11;
  static const int WRITE_CONFIG = 0x12;
  
  final int _tagId;
  PrimitiveType _primitive;
  bool isSubscribed;
  
  /** Input stream. */
  Stream<TagEvent> _source;

  /** Subscription on [source] while subscribed. */
  StreamSubscription<TagEvent> _subscription;

  /** Controller for output stream. */
  StreamController<TagEvent> _controller;

  SilkorbProtocolTag(
    this._tagId, 
    PrimitiveType prim, 
    Stream<TagEvent> source) : _source = source {
    
    this._primitive = prim;
    this._controller = new StreamController<TagEvent>(
      onListen: _onListen,
      onPause: _onPause,
      onResume: _onResume,
      onCancel: _onCancel);
    isSubscribed = true;
  }
  
  factory SilkorbProtocolTag.fromPrimitive(PrimitiveType prim, Stream<TagEvent> source) {
    return new SilkorbProtocolTag(prim.silkorbTagId, prim, source);
  }

  StreamSubscription<TagEvent> listen(void onData(TagEvent event), 
                    { void onError(Error error), 
                    void onDone(), 
                    bool cancelOnError }) {
    return this._controller.stream.listen(onData, 
                        onError: onError, 
                        onDone: onDone, 
                        cancelOnError: cancelOnError);
  }

  void _onListen() {
    this._subscription = this._source.listen(_onData,
                         onError: this._controller.addError,
                         onDone: _onDone);
  }

  void _onCancel() {
    this._subscription.cancel();
    this._subscription = null;
  }

  void _onPause() {
    this._subscription.pause();
  }

  void _onResume() {
    this._subscription.resume();
  }

  void _onData(TagEvent input) {
    _controller.add(input);
  }

  void _onDone() {
    this._controller.close();
  }
  
  void invokeTagEvent(TagEvent e) {
    if(this._controller != null) {
      this._controller.add(e);
    }
  }
  
  int get tagId => this._tagId;
  //set tagId(int value) => this._tagId = value;
  PrimitiveType get primitive => this._primitive;
  
  Uint8List _createRequest(int protoPrefix) {
    Uint8List req = new Uint8List(3);
    ByteData bd = new ByteData.view(req.buffer);
    bd.setUint8(0, protoPrefix);
    bd.setUint16(1, this._tagId, Endianness.BIG_ENDIAN);
    return req;
  }
  
  Uint8List _createConfigRequest(int protoPrefix, [bool subscribe]) {
    Uint8List req = new Uint8List(7);
    ByteData bd = new ByteData.view(req.buffer);
    bd.setUint8(0, protoPrefix);
    bd.setUint16(1, this._tagId);
    bd.setUint8(3, this.primitive.s7Type.value);
    if(subscribe != null && subscribe == true) {
      bd.setUint8(4, 0x01);
    }
    return req;
  }
  
  Uint8List readRequest() {
    return _createRequest(READ);
  }
  
  Uint8List readResponse() {
    throw new UnimplementedError();
  }
  
  Uint8List writeRequest() {
    Uint8List header = _createRequest(WRITE);
    Uint8List dataVect = this._primitive.getValueData();
    List<int> request = new List<int>();
    request.addAll(header);
    request.addAll(dataVect);
    return new Uint8List.fromList(request);
  }
  
  Uint8List writeResponse() {
    throw new UnimplementedError();
  }
  
  Uint8List writeAckRequest() {
    Uint8List header = _createRequest(WRITE_ACK);
    Uint8List dataVect = this._primitive.getValueData();
    List<int> request = new List<int>();
    request.addAll(header);
    request.addAll(dataVect);
    return new Uint8List.fromList(request);
  }
  
  Uint8List writeAckResponse() {
    throw new UnimplementedError();
  }
  
  Uint8List readConfigRequest() {
    return _createConfigRequest(READ_CONFIG);
  }
  
  Uint8List readConfigResponse() {
    throw new UnimplementedError();
  }
  
  Uint8List writeConfigRequest() {
    return _createConfigRequest(WRITE_CONFIG, this.isSubscribed);
  }
  
  Uint8List writeConfigSubscribeRequest() {
    Uint8List req = _createConfigRequest(WRITE_CONFIG);
    ByteData bd = new ByteData.view(req.buffer);
    bd.setUint8(3, this.primitive.s7Type.value);
    if(this.isSubscribed) bd.setUint8(4, 1);
    return req;
  }
  
  Uint8List writeconfigResponse() {
    throw new UnimplementedError();
  }
  
}

class TagEvent<T> {
  int id;
  T value;

  TagEvent(int identity, T newValue) {
    this.id = identity;
    this.value = newValue;
  }
}

abstract class Tag {
  
  int get tagId;
  //set tagId(int value);

  PrimitiveType get primitive;
}

abstract class SilkorbProtocol {
  
  Uint8List readRequest();
  Uint8List readResponse();
  Uint8List writeRequest();
  Uint8List writeResponse();
  Uint8List writeAckRequest();
  Uint8List writeAckResponse();
  Uint8List readConfigRequest();
  Uint8List readConfigResponse();
  Uint8List writeConfigRequest();
  Uint8List writeconfigResponse();
}

