import sequtils
import dom
import ../helper/seq
import ../model/mapModel
import ./instrumentListViewModel
import ../helper/googleanalytics
import ../helper/storage

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
            instrumentType: instrumentType,
            text: "Text"
        )
    result = instrument

proc initMap*(height, width = 0, sequence, city, team, music: string) =
    map = Map(height: height, width: width, sequence: sequence, city: city, team: team, music: music)

proc dataJson*(): string =
    let data = instruments.mapIt(it.data)
    result = toJson(map, data)

proc loadJson*(json: string): SaveData =
    let data = fromJson(json)
    result = data

proc quickSave*() = 
    storage.setItem("quickSave", dataJson())

proc updateInstrument*(element: InstrumentElement, instrument: Instrument) =
    element.e.style.height = $instrument.height & "px"
    element.e.style.width = $instrument.width & "px"
    element.e.style.left = $(int((mapViewModel.map.width - instrument.width) / 2) + instrument.x) & "px"
    element.e.style.top = $(int((mapViewModel.map.height - instrument.height) / 2) + instrument.y) & "px"
    element.e.style.transform = "rotate(" & $instrument.angle & "deg)"
    if (element.data.instrumentType == Text):
        element.e.innerHTML = instrument.text
    quickSave()

proc updateInstrument*(instrument: InstrumentElement, x, y, height, width, angle: int, text: string) =
    instrument.data.x = x
    instrument.data.y = y
    instrument.data.height = height
    instrument.data.width = width
    instrument.data.angle = angle
    instrument.data.text = text
    instrument.updateInstrument(instrument.data)

proc deleteSelected*() =
    document.getElementById("instrumentInfo").style.display = "none" # Gambiarra para funcionar
    selected.e.parentNode.removeChild(selected.e)
    instruments.delete(selected)
    gaSend("Instrument", "Add", $selected.data.instrumentType)
    updateList(instruments.mapIt(it.data))
    quickSave()
