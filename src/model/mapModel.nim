import json

type
    InstrumentType* = enum 
        Okedo,
        Nagado,
        Shime,
        Oodaiko

    Instrument* = ref InstrumentObj
    InstrumentObj* = object of RootObj
        x*: int
        y*: int
        height*: int
        width*: int
        angle*: int
        instrumentType*: InstrumentType

    Map* = ref MapObj
    MapObj* = object of RootObj
        height*: int
        width*: int
