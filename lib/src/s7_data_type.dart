/*
 * S7DataType represents a Siemens S7 PLC data type.
 * Copyright (c) 2014 Joachim Ivarsson
 */

part of silkorb;

class S7DataType {
  static const S7DataType BYTE = const S7DataType._this(0x02);
  static const S7DataType WORD = const S7DataType._this(0x03);
  static const S7DataType INT = const S7DataType._this(0x04);
  static const S7DataType DWORD = const S7DataType._this(0x06);
  static const S7DataType DINT = const S7DataType._this(0x08);
  static const S7DataType REAL = const S7DataType._this(0x10);
  static const S7DataType STRING = const S7DataType._this(0x13);
  final int _value;
  
  const S7DataType._this(this._value);
  
  int get value => this._value;
  
  String toString() {
    return {0x02: 'S7DataType:BYTE',
            0x03: 'S7DataType:WORD',
            0x04: 'S7DataType:INT',
            0x06: 'S7DataType:DWORD',
            0x08: 'S7DataType:DINT',
            0x10: 'S7DataType:REAL',
            0x13: 'S7DataType:STRING'}[_value];
    }
}