/*
 * client.dart
 * copyright (c) 2014 Joachim Ivarsson
 */

part of silkorb;

class BWS7Client {

  RawDatagramSocket _socket;
  HashMap<int, SilkorbProtocolTag> _tagMap;
  List<int> sendBuffer;
  Queue<Uint8List> sendQueue;
  InternetAddress clientAddress;
  int udpPort;
  
  BWS7Client(List<SilkorbProtocolTag> items) {
    _tagMap = new HashMap.fromIterable(items,
                                       key: (SilkorbProtocolTag item) => item.tagId,
                                       value: (SilkorbProtocolTag item) => item);
    sendQueue = new Queue<Uint8List>();
    _subscribeWriteRequests();
  }
  
  Future connect() {
    return RawDatagramSocket.bind(InternetAddress.ANY_IP_V4, 0).then(_onValue);
  }
  
  void _subscribeWriteRequests() {
    for (SilkorbProtocolTag tag in _tagMap.values) {
      tag.primitive.plcWriteRequest().listen(_onTagPLCWriteRequest);
    }
  }
  
  void _onTagPLCWriteRequest(PrimitiveType pt) {
    SilkorbProtocolTag tag = _tagMap[pt.silkorbTagId];
    if(tag != null) this.addToSendQueue(tag.writeAckRequest());
  } 

  void _onValue(RawDatagramSocket socket) {
    _socket = socket;
    _socket.listen(_onSocketData);
  }
  
  void _onSocketData(RawSocketEvent e) {
    switch(e) {
      case RawSocketEvent.READ :
        //print(e.toString());
        Datagram dg = this._socket.receive();
        if(dg != null) handleReceivedData(dg);
        if(!_socket.writeEventsEnabled && sendQueue.isNotEmpty) _socket.writeEventsEnabled = true;
        break;
      case RawSocketEvent.WRITE :
        //print(e.toString());
        checkSendQueue();
        /*
         if(sendBuffer != null && sendBuffer.length > 0) {
          _socket.send(sendBuffer, clientAddress, udpPort);
          sendBuffer = null;
        }
        */
        break;
    }
  }
  
  void checkSendQueue() {
    if(sendQueue.isNotEmpty) {
      String timestamp = new DateTime.now().toString();
      String data = sendQueue.last.toString();
      print('$timestamp  Sending request: $data');
      _socket.send(sendQueue.removeLast(), clientAddress, udpPort);
    }
  }
  
  void handleReceivedData(Datagram dg) {
    int i = 0;
    int len = dg.data.length;
    //List<int> data = dg.data;
    Uint8List data = new Uint8List.fromList(dg.data);
    while(i < len) {
      int method = data[i];
      ProtocolPrefix prefix = new ProtocolPrefix(method);
      //if(method == 1) {
      // prefix = ProtocolPrefix.READ;
      //}
      ++i;
      int id = (new ByteData.view(data.buffer, i, 2)).getUint16(0);
      i+=2;
      switch(prefix) {
        case ProtocolPrefix.SUBSCRIBE_RESPONSE :
          if(_tagMap.containsKey(id)) {
            i = _tagMap[id].primitive.writeData(data, i);
            PrimitiveType pt = _tagMap[id].primitive;
            var val = pt.value;
            String timestamp = new DateTime.now().toString();
            print('$timestamp  Received subscribe response for id: $id, value: $val');
            }
          break;
        case ProtocolPrefix.WRITE_CONFIG :
          i+=5;
          break;
        case ProtocolPrefix.READ :
        case ProtocolPrefix.WRITE_ACK :
          //print(prefix);
          if(_tagMap.containsKey(id)) {
            i = _tagMap[id].primitive.writeData(data, i);
            PrimitiveType pt = _tagMap[id].primitive;
            var val = pt.value;
            String timestamp = new DateTime.now().toString();
            print('$timestamp  Received value for id: $id, value: $val');
            }
          break;
        default : 
          print(prefix);
      }
    }
  }
  
  void addToSendQueue(Uint8List data) {
    sendQueue.addFirst(data);
    if(_socket != null && _socket.writeEventsEnabled == false)
      _socket.writeEventsEnabled = true;
  }
  
  void sendData(Uint8List data) {
    if(sendBuffer != null && sendBuffer.length > 0) {
       List<int> growList = sendBuffer.toList(growable: true);
       growList.addAll(data);
       sendBuffer = new Uint8List.fromList(growList);
    } else {
      sendBuffer = data;
    }
    if(_socket != null) 
      _socket.writeEventsEnabled = true;
  }
  
  Uint8List readAllTagsRequest() {
    List<int> data = new List<int>();
    for (SilkorbProtocolTag tag in _tagMap.values) {
      data.addAll(tag.readRequest());
    }
    Uint8List result = new Uint8List.fromList(data);
    return result;
  }

  void updateAllTags() {
    addToSendQueue(readAllTagsRequest());
  }
  
  void writeConfigAllTags() {
    print('Writing config to all tags..');
    for (SilkorbProtocolTag tag in _tagMap.values) {
      addToSendQueue(tag.writeConfigRequest());
    }
  }
  
 }