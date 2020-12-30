import json
import strutils

type
    InstrumentType* = enum 
        Okedo,
        Nagado,
        Shime,
        Oodaiko,
        Tekkan

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

proc instrumentFromJson*(json: string): Instrument =
    let jsonObj = parseJson(json)
    let
        x = jsonObj["x"].getInt()
        y = jsonObj["y"].getInt()
        height = jsonObj["height"].getInt()
        width = jsonObj["width"].getInt()
        angle = jsonObj["angle"].getInt()
        instrumentType = parseEnum[InstrumentType](jsonObj["instrumentType"].getStr())
    result = Instrument(
        x: x,
        y: y,
        height: height,
        width: width,
        angle: angle,
        instrumentType: instrumentType
    )


proc fromJson*(json: string): SaveData =
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
        instruments.add(instrumentFromJson($ instrumentJson))
    result = SaveData(instruments: instruments, map: map)

