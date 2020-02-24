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
        diameter*: int
        instrumentType*: InstrumentType

    Map* = object of RootObj
        height*: int
        width*: int

proc save*() =
    # TODO
    return

proc load*() =
    # TODO
    return

proc `$`*(instrument: Instrument): string = 
    result = $ %* instrument
