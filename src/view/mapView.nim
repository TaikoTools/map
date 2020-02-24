import dom
import strutils
import sequtils
import ../helper/dragable
import ../helper/seq
import ../helper/constants
import ../viewModel/mapViewModel
import ../model/mapModel
import ./infoView

const svg="""<svg width="100%" height="100%">
  <ellipse stroke="black" stroke-width="1" fill="#c0c0c0" cx="50%" rx="50%" ry="10%" cy="90%"></ellipse>
  <rect x="0" stroke="black" stroke-width="1" fill="#c0c0c0" width="100%" height="80%" y="10%"></rect>
  <ellipse stroke-width="0" fill="#c0c0c0" cx="50%" rx="50%" ry="10%" cy="90%"></ellipse>
  <ellipse stroke="black" stroke-width="1" fill="#c0c0c0" cx="50%" rx="50%" ry="10%" cy="10%"></ellipse> 
Sorry, your browser does not support inline SVG.
</svg>"""

type InstrumentElement = ref object of RootObj
    e: Element
    data: Instrument

var instruments: seq[InstrumentElement] = newSeq[InstrumentElement]()
var selected*: InstrumentElement

proc updateInstrument(instrument: InstrumentElement, x, y, height, width, angle: int) =
    instrument.e.style.height = $height & "px"
    instrument.e.style.width = $width & "px"
    instrument.e.style.left = $(int((mapViewModel.map.width - width) / 2) + x) & "px"
    instrument.e.style.top = $(int((mapViewModel.map.height - height) / 2) + y) & "px"
    instrument.e.style.transform = "rotate(" & $angle & "deg)"
    instrument.data.x = x
    instrument.data.y = y
    instrument.data.height = height
    instrument.data.width = width
    instrument.data.angle = angle

proc addInstrument*(x, y, width, height, angle: int) =
    var instrument = createInstrument()
    let map = document.getElementById("map")
    let element = document.createElement("div")
    element.innerHTML = svg
    element.style.position = "absolute"
    map.appendChild(element)
    let instrumentElement = InstrumentElement(e: element, data: instrument)
    instrumentElement.updateInstrument(x, y, width, height, angle)
    instruments.add(instrumentElement)
    element.addEventListener("mousedown", proc (ev: Event) =
        if selected != nil:
            selected.e.classList.remove("selected")
        selected = instrumentElement
        selected.e.classList.add("selected")
        updateInfo(selected.data)
    )
    makeDragable(element, proc (e: Element) =
        let left = parseInt(($element.style.left).replace("px",""))
        let width = parseInt(($element.offsetWidth).replace("px", ""))
        let top = parseInt(($element.style.top).replace("px", ""))
        let height = parseInt(($element.offsetHeight).replace("px", ""))
        instrument.x = left - int((mapViewModel.map.width - width) / 2)
        instrument.y = top - int((mapViewModel.map.height - height) / 2)
        updateInfo(selected.data)
    )

proc deleteSelected*() =
    selected.e.parentNode.removeChild(selected.e)
    instruments.delete(selected)

proc clear() =
    mapViewModel.clear()
    for instrument in instruments:
        instrument.e.parentNode.removeChild(instrument.e)
    instruments.deleteAll()

proc initMap*() =
    let height = parseInt($document.getElementById("height").value) * meter
    let width = parseInt($document.getElementById("width").value) * meter
    let map = document.getElementById("map")
    initInfo()
    clear()
    mapViewModel.initMap(height, width)
    map.style.height = $height & "px"
    map.style.width = $width & "px"
    map.style.backgroundPosition = $(height / 2) & "px " & $(width / 2) & "px"
    map.style.display = "block"

infoView.updateSelected = proc(x, y, height, width, angle: int) =
    selected.updateInstrument(x, y, height, width, angle)
