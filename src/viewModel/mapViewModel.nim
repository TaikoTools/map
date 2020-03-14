import json
import strutils
import sequtils
import sugar
import dom
import ../helper/seq
import ../model/mapModel

var map*: Map = Map()
type InstrumentElement* = ref object of RootObj
    e*: Element
    data*: Instrument

var instruments*: seq[InstrumentElement] = newSeq[InstrumentElement]()
var selected*: InstrumentElement

proc createInstrument*(x, y, height, width, angle: int, instrumentType: InstrumentType): Instrument =
    var instrument = Instrument(
            x: x,
            y: y,
            height: height,
            width: width,
            angle: angle,
            instrumentType: instrumentType
        )
    result = instrument

proc initMap*(height, width = 0) =
    map = Map(height: height, width: width)

proc dataJson*(): string =
    let data = instruments.mapIt(it.data)
    result = $ %* {"map": map, "instruments": data}

proc loadJson*(json: JsonNode): seq[Instrument] =
    result = newSeq[Instrument]()
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
        result.add(instrument)

proc updateInstrument*(element: InstrumentElement, instrument: Instrument) =
    element.e.style.height = $instrument.height & "px"
    element.e.style.width = $instrument.width & "px"
    element.e.style.left = $(int((mapViewModel.map.width - instrument.width) / 2) + instrument.x) & "px"
    element.e.style.top = $(int((mapViewModel.map.height - instrument.height) / 2) + instrument.y) & "px"
    element.e.style.transform = "rotate(" & $instrument.angle & "deg)"

proc updateInstrument*(instrument: InstrumentElement, x, y, height, width, angle: int) =
    instrument.data.x = x
    instrument.data.y = y
    instrument.data.height = height
    instrument.data.width = width
    instrument.data.angle = angle
    instrument.updateInstrument(instrument.data)
