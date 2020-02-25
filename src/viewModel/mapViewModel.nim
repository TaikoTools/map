import json
import strutils
import ../helper/seq
import ../model/mapModel

var instruments*:seq[Instrument] = newSeq[Instrument]()
var map*: Map = Map()

proc createInstrument*(x, y, height, width, angle: int, instrumentType: InstrumentType): Instrument =
    var instrument = Instrument(
            x: x,
            y: y,
            height: height,
            width: width,
            angle: angle,
            instrumentType: instrumentType
        )
    instruments.add(instrument)
    result = instrument

proc clear*() =
    instruments.deleteAll()

proc initMap*(height, width = 0) =
    map = Map(height: height, width: width)

proc dataJson*(): string =
    result = $ %* {"map": map, "instruments": instruments}

proc loadJson*(json: JsonNode) =
    clear()
    map.height = json["map"]["height"].getInt()
    map.width = json["map"]["width"].getInt()
    for instrumentJson in json["instruments"]:
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