/*
 *  protocol_prefix.dart
 *  Copyright (c) 2014 Joachim Ivarsson 
 */

part of silkorb;


/**
 * Protocol method for the Silkorb protocol
 */
class ProtocolPrefix {
  static const ProtocolPrefix READ = const ProtocolPrefix._this(1);
  static const ProtocolPrefix WRITE = const ProtocolPrefix._this(2);
  static const ProtocolPrefix WRITE_ACK = const ProtocolPrefix._this(3);
  static const ProtocolPrefix SUBSCRIBE_RESPONSE = const ProtocolPrefix._this(0x0A);
  static const ProtocolPrefix READ_CONFIG = const ProtocolPrefix._this(0x11);
  static const ProtocolPrefix WRITE_CONFIG = const ProtocolPrefix._this(0x12);
  final int _value;
  
  const ProtocolPrefix._this(this._value);
  
  factory ProtocolPrefix(int value) {
    switch(value) {
      case 1 : 
        return ProtocolPrefix.READ;
      case 2 :
        return ProtocolPrefix.WRITE;
      case 3 :
        return ProtocolPrefix.WRITE_ACK;
      case 0x0A :
        return ProtocolPrefix.SUBSCRIBE_RESPONSE;
      case 0x11 :
        return ProtocolPrefix.READ_CONFIG;
      case 0x12 : 
        return ProtocolPrefix.WRITE_CONFIG;
      default :
        return ProtocolPrefix.READ;
    }
  }
  
  String toString() {
    return {0x01: 'ProtocolPrefix:READ',
            0x02: 'ProtocolPrefix:WRITE',
            0x03: 'ProtocolPrefix:WRITE_ACK',
            0x0A: 'ProtocolPrefix:SUBSRIBE_RESPONSE',
            0x11: 'ProtocolPrefix:READ_CONFIG',
            0x12: 'ProtocolPrefix:WRITE_CONFIG'}[_value];
  }
}