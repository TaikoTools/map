import dom
import strutils
import json
import ../helper/dragable
import ../helper/seq
import ../helper/constants
import ../helper/fileReader
import ../viewModel/mapViewModel
import ../model/mapModel
import ./infoView

const svgOkedo="""<svg width="100%" height="100%">
  <ellipse stroke="black" stroke-width="1" fill="#c0c0c0" cx="50%" rx="50%" ry="10%" cy="90%"></ellipse>
  <rect x="0" stroke="black" stroke-width="1" fill="#c0c0c0" width="100%" height="80%" y="10%"></rect>
  <ellipse stroke-width="0" fill="#c0c0c0" cx="50%" rx="50%" ry="10%" cy="90%"></ellipse>
  <ellipse stroke="black" stroke-width="1" fill="#c0c0c0" cx="50%" rx="50%" ry="10%" cy="10%"></ellipse> 
Sorry, your browser does not support inline SVG.
</svg>"""
const svgNagado="""<svg width="100%" height="100%">
  <ellipse stroke="black" stroke-width="1" fill="#c0c0c0" cx="50%" rx="45%" ry="10%" cy="90%"></ellipse>
  <ellipse stroke="black" stroke-width="1" fill="#c0c0c0" cx="5%" rx="5%" ry="40%" cy="50%"></ellipse>
    <ellipse stroke="black" stroke-width="1" fill="#c0c0c0" cx="95%" rx="5%" ry="40%" cy="50%"></ellipse>
  <ellipse stroke="black" stroke-width="1" fill="#c0c0c0" cx="50%" rx="45%" ry="10%" cy="90%"></ellipse>
  <rect x="5%" stroke="black" stroke-width="0" fill="#c0c0c0" width="90%" height="80%" y="10%"></rect>
  <ellipse stroke-width="0" fill="#c0c0c0" cx="50%" rx="45%" ry="10%" cy="90%"></ellipse>
  <ellipse stroke="black" stroke-width="1" fill="#c0c0c0" cx="50%" rx="45%" ry="10%" cy="10%"></ellipse> 
Sorry, your browser does not support inline SVG.
</svg>"""

proc addInstrument(instrument: Instrument) =
    let map = document.getElementById("map")
    let element = document.createElement("div")
    let svg = case instrument.instrumentType:
        of Okedo:
            svgOkedo
        of Shime:
            svgOkedo
        of Nagado:
            svgNagado
        of Oodaiko:
            svgNagado
    element.innerHTML = svg
    element.style.position = "absolute"
    map.appendChild(element)
    let instrumentElement = InstrumentElement(e: element, data: instrument)
    instrumentElement.updateInstrument(instrument)
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
    updateList()


proc addInstrument*(x, y, height, width, angle: int, instrumentType: InstrumentType) =
    var instrument = createInstrument(x, y, height, width, angle, instrumentType)
    addInstrument(instrument)

proc deleteSelected*() =
    selected.e.parentNode.removeChild(selected.e)
    instruments.delete(selected)
    updateList()

proc clear() =
    for instrument in instruments:
        instrument.e.parentNode.removeChild(instrument.e)
    instruments.deleteAll()

proc updateMapElement() =
    let map = document.getElementById("map")
    let height = mapViewModel.map.height
    let width = mapViewModel.map.width
    map.style.height = $height & "px"
    map.style.width = $width & "px"
    map.style.backgroundPosition = $(height / 2) & "px " & $(width / 2) & "px"
    map.style.display = "block"
    document.getElementById("newMap").classList.remove("down")

proc initMap*() =
    let height = parseInt($document.getElementById("height").value) * meter
    let width = parseInt($document.getElementById("width").value) * meter
    initInfo()
    clear()
    mapViewModel.initMap(height, width)
    updateMapElement()

proc loadMap*() =
    var reader = FileReader()
    var file = InputElement(document.getElementById("load")).files[0]
    reader.onload = proc (e: FLoad) =
        let data = loadJson($reader.result)
        initInfo()
        clear()
        updateMapElement()
        for instrument in data:
            addInstrument(instrument)
    
    reader.readAsText(file)

proc saveMap*() =
    var a = document.getElementById("download")
    a.setAttr("download", "mapa.taiko")
    a.setAttr("href", "data:text/json;charset=utf-8," & dataJson())
    a.click()
