/*
 *  The PrimitiveType<T> represents a
 *  wrapper class for S7 data types.
 */

part of silkorb;

class SOString extends PrimitiveType<String> {
  final S7DataType _s7Type = S7DataType.STRING;
  
  String _value;

  String get value {
    return this._value;
  }

  set value(String newValue) {
    this._value = newValue;
  }
  
  S7DataType get s7Type => this._s7Type;

  int writeData(Uint8List data, int offset, [Endianness endian = Endianness.BIG_ENDIAN]) {
    List<int> codes = new List<int>();
    int cnt = offset;
    bool done = false;
    while(!done && data.length > cnt) {
      int d = data[cnt];
      if(d != 0) {
        codes.add(d);
      }
      else {
        done = true;
      }
      ++cnt;
    }
    this._value = UTF8.decode(codes);
    this._onData(this.value);
    return cnt;
  } 
  
  Uint8List getValueData() {
    //First, add null suffix on byte array.
    var list = new List<int>.from(UTF8.encode(this._value), growable: true);
    list.add(0x0);
    //Then create result set.
    Uint8List res = new Uint8List.fromList(list);
    return res;
  }
}

class SOFloat32 extends PrimitiveType<double> {
  
  final int byteLength = 4;
  final S7DataType _s7Type = S7DataType.REAL;
  
  SOFloat32() {
    this._buffer = new ByteData(byteLength);
  }
  
  double get value {
    return this._buffer.getFloat32(0);
  }
  
  set value(double newValue) {
    this._buffer.setFloat32(0, newValue);
  }
  
  S7DataType get s7Type => this._s7Type;
  
  int writeData(Uint8List data, int offset, [Endianness endian = Endianness.BIG_ENDIAN]) {
    this._buffer = new ByteData.view(data.buffer, offset, byteLength);
    this._onData(this.value);
    return offset+byteLength;
  }
  
  Uint8List getValueData() {
    Uint8List res = new Uint8List(this.byteLength);
    (new ByteData.view(res.buffer, 0, this.byteLength)).setFloat32(0, this.value);
    return res;
  }
  
}

class SOInt16 extends PrimitiveType<int> {
  
  final int byteLength = 2;
  final S7DataType _s7Type = S7DataType.INT;
  
  SOInt16() {
    this._buffer = new ByteData(byteLength);
  }
  
  int get value { 
    return this._buffer.getInt16(0);
  }
  
  set value(int newValue) {
    this._buffer.setInt16(0, newValue);
  }
  
  S7DataType get s7Type => this._s7Type;
  
  int writeData(Uint8List data, int offset, [Endianness endian = Endianness.BIG_ENDIAN]) {
    this._buffer = new ByteData.view(data.buffer, offset, byteLength);
    this._onData(this.value);
    return offset+byteLength;
  }
  
  Uint8List getValueData() {
    Uint8List res = new Uint8List(this.byteLength);
    (new ByteData.view(res.buffer, 0, this.byteLength)).setInt16(0, this.value);
    return res;
  }
}

class SOUInt16 extends PrimitiveType<int> {
  
  final int byteLength = 2;
  final S7DataType _s7Type = S7DataType.WORD;
  
  SOUInt16() {
    this._buffer = new ByteData(byteLength);
  }
  
  int get value {
    return this._buffer.getUint16(0);
  }
  
  set value(int newValue) {
    this._buffer.setUint16(0, newValue);
  }
  
  S7DataType get s7Type => this._s7Type;
  
  int writeData(Uint8List data, int offset, [Endianness endian = Endianness.BIG_ENDIAN]) {
    this._buffer = new ByteData.view(data.buffer, offset, byteLength);
    this._onData(this.value);
    return offset+byteLength;
  }
  
  Uint8List getValueData() {
    Uint8List res = new Uint8List(this.byteLength);
    (new ByteData.view(res.buffer, 0, this.byteLength)).setUint16(0, this.value);
    return res;
  }
}

class SOUInt8 extends PrimitiveType<int> {
  
  final int byteLength = 1;
  final S7DataType _s7Type = S7DataType.BYTE;
  
  SOUInt8() {
    this._buffer = new ByteData(byteLength);
  }
  
  int get value { 
    return this._buffer.getUint8(0);
  }
  
  S7DataType get s7Type => this._s7Type;
  
  set value(int newValue) {
    this._buffer.setUint8(0, newValue);
  }
  
  int writeData(Uint8List data, int offset, [Endianness endian = Endianness.BIG_ENDIAN]) {
    this._buffer = new ByteData.view(data.buffer, offset, byteLength);
    this._onData(this.value);
    return offset+byteLength;
  }
  
  Uint8List getValueData() {
    Uint8List res = new Uint8List(this.byteLength);
    (new ByteData.view(res.buffer, 0, this.byteLength)).setUint8(0, this.value);
    return res;
  }
}

class SOInt32 extends PrimitiveType<int> {
  
  final int byteLength = 4;
  final S7DataType _s7Type = S7DataType.DINT;
  
  SOInt32() { this._buffer = new ByteData(byteLength);}
    
  int get value {
    return this._buffer.getInt32(0);
  }
  
  set value(int newValue) {
    this._buffer.setInt32(0, newValue);
  }
  
  S7DataType get s7Type => this._s7Type;
  
  int writeData(Uint8List data, int offset, [Endianness endian = Endianness.BIG_ENDIAN]) {
    this._buffer = new ByteData.view(data.buffer, offset, byteLength);
    this._onData(this.value);
    //print(this.value);
    //printBuffer();
    return offset+byteLength;
  }
  
  Uint8List getValueData() {
    Uint8List res = new Uint8List(this.byteLength);
    (new ByteData.view(res.buffer, 0, this.byteLength)).setInt32(0, this.value);
    return res;
  }
}

class SOUInt32 extends PrimitiveType<int> {
  final int byteLength = 4;
  final S7DataType _s7Type = S7DataType.DWORD;
  
  SOUInt32() { 
    this._buffer = new ByteData(byteLength);
  }
  
  int get value {
    return this._buffer.getUint32(0);
  }
  
  set value(int newValue) {
    this._buffer.setUint32(0, newValue);
  }
  
  S7DataType get s7Type => this._s7Type;
  
  int writeData(Uint8List data, int offset, [Endianness endian = Endianness.BIG_ENDIAN]) {
    this._buffer = new ByteData.view(data.buffer, offset, byteLength);
    this._onData(this.value);
    return offset+byteLength;
  }
  
  Uint8List getValueData() {
    Uint8List res = new Uint8List(this.byteLength);
    (new ByteData.view(res.buffer, 0, this.byteLength)).setUint32(0, this.value);
    return res;
  }
  
}

abstract class PrimitiveType<T> extends Stream<T> {

  T get value;
  
  set value(T newValue);
  
  S7DataType get s7Type;
  
  ByteData _buffer;

  StreamController<T> _controller;
  StreamController<PrimitiveType<T>> _plcWriteController;
  
  bool isStreamListening;
  bool _isPlcWriteStreamListening;
  
  int silkorbTagId;
  
  PrimitiveType() {
    this.isStreamListening = false;
    _controller = new StreamController<T>(onListen: _onListen, 
                                          onPause: _onPause,
                                          onResume: _onResume,
                                          onCancel: _onCancel);
    
  }
  
  void _onListen() {
    this.isStreamListening = true;
  }
  
  void _onCancel() {
    this.isStreamListening = false;  
  }
  
  void _onPause() {
    this.isStreamListening = false;
  }
  
  void _onResume() {
   this.isStreamListening = true; 
  }
  
  void _onData(T arg) {
    if(this.isStreamListening && _controller != null) {
      this._controller.add(arg);
    }
  }
  
  StreamSubscription<T> listen(void onData(T event), { void onError(Error error), void onDone(), bool cancelOnError }) {
    return this._controller.stream.listen(onData, onError: onError, onDone: onDone, cancelOnError: cancelOnError);
  }

  void _onPlcWriteListen() {
    _isPlcWriteStreamListening = true;
  }

  void _plcWriteStreamClosed() {
    _isPlcWriteStreamListening = false;
  }

  void _plcWriteStreamResumed() {
    _isPlcWriteStreamListening = true;
  }

  Stream<PrimitiveType<T>> plcWriteRequest() {
    _plcWriteController = new StreamController<PrimitiveType<T>>(onListen: _onPlcWriteListen, onPause: _plcWriteStreamClosed, onResume: _plcWriteStreamResumed, onCancel: _plcWriteStreamClosed);
    return _plcWriteController.stream;
  }
  
  int writeData(Uint8List data, int offset, [Endianness endian = Endianness.BIG_ENDIAN]);
  
  void printBuffer() {
      print(this._buffer.buffer.toString());
  }
  
  void invokeValueChangedEvent() {
    this._onData(this.value);
  }

  void invokePlcWriteRequestEvent() {
    if(this._isPlcWriteStreamListening) this._plcWriteController.add(this);
  }
  
  Uint8List getValueData();
  
}