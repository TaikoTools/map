import json
import strutils

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
        sequence*: string
        city*: string
        team*: string
        music*: string
        height*: int
        width*: int

    SaveData* = object of RootObj
        instruments*: seq[Instrument]
        map*: Map

func toJson*(map: Map, instruments: seq[Instrument]) : string =
    result = $ %* {"map": map, "instruments": instruments}

func fromJson*(json: string): SaveData =
    let jsonObj = parseJson(json)
    let map = Map()
    var instruments = newSeq[Instrument]()
    map.height = jsonObj["map"]["height"].getInt()
    map.width = jsonObj["map"]["width"].getInt()
    map.sequence = jsonObj["map"]["sequence"].getStr()
    map.team = jsonObj["map"]["team"].getStr()
    map.city = jsonObj["map"]["city"].getStr()
    map.music = jsonObj["map"]["music"].getStr()
    for instrumentJson in jsonObj["instruments"]:
        let
            x = instrumentJson["x"].getInt()
            y = instrumentJson["y"].getInt()
            height = instrumentJson["height"].getInt()
            width = instrumentJson["width"].getInt()
            angle = instrumentJson["angle"].getInt()
            instrumentType = parseEnum[InstrumentType](instrumentJson["instrumentType"].getStr())
            instrument = Instrument(
                x: x,
                y: y,
                height: height,
                width: width,
                angle: angle,
                instrumentType: instrumentType
            )
        instruments.add(instrument)
    result = SaveData(instruments: instruments, map: map)

