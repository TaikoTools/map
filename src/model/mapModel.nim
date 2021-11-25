import json
import strutils
import sequtils

type
    InstrumentType* = enum 
        Okedo,
        Nagado,
        Shime,
        Oodaiko,
        Tekkan,
        Dora,
        Text

    Instrument* = ref InstrumentObj
    InstrumentObj* = object of RootObj
        x*: int
        y*: int
        height*: int
        width*: int
        angle*: int
        text*: string
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
    let filteredInstruments = instruments.filterIt(it.instrumentType != Text or it.text != "")
    result = $ %* {"map": map, "instruments": filteredInstruments}

proc instrumentFromJson*(json: string): Instrument =
    let jsonObj = parseJson(json)
    let
        x = jsonObj["x"].getInt()
        y = jsonObj["y"].getInt()
        height = jsonObj["height"].getInt()
        width = jsonObj["width"].getInt()
        angle = jsonObj["angle"].getInt()
        text = jsonObj["text"].getStr()
        instrumentType = parseEnum[InstrumentType](jsonObj["instrumentType"].getStr())
    result = Instrument(
        x: x,
        y: y,
        height: height,
        width: width,
        angle: angle,
        text: text,
        instrumentType: instrumentType
    )
    echo repr result


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

