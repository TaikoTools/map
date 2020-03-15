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
import ./headerView

const svgOkedo="""<svg width="100%" height="100%">
  <ellipse stroke="black" stroke-width="1" fill="#c0c0c0" cx="50%" rx="50%" ry="10%" cy="90%"></ellipse>
  <rect x="0" stroke="black" stroke-width="1" fill="#c0c0c0" width="100%" height="80%" y="10%"></rect>
  <ellipse stroke-width="0" fill="#c0c0c0" cx="50%" rx="50%" ry="10%" cy="90%"></ellipse>
  <ellipse stroke="black" stroke-width="1" fill="#c0c0c0" cx="50%" rx="50%" ry="10%" cy="10%"></ellipse> 
Sorry, your browser does not support inline SVG.
</svg>"""
const svgNagado="""<svg width="100%" height="100%">
  <ellipse stroke="black" stroke-width="1" fill="#c0c0c0" cx="50%" rx="43%" ry="10%" cy="90%"></ellipse>
  <ellipse stroke="black" stroke-width="1" fill="#c0c0c0" cx="7%" rx="7%" ry="40%" cy="50%"></ellipse>
    <ellipse stroke="black" stroke-width="1" fill="#c0c0c0" cx="93%" rx="7%" ry="40%" cy="50%"></ellipse>
  <ellipse stroke="black" stroke-width="1" fill="#c0c0c0" cx="50%" rx="43%" ry="10%" cy="90%"></ellipse>
  <rect x="7%" stroke="black" stroke-width="0" fill="#c0c0c0" width="84%" height="80%" y="10%"></rect>
  <ellipse stroke-width="0" fill="#c0c0c0" cx="50%" rx="43%" ry="10%" cy="90%"></ellipse>
  <ellipse stroke="black" stroke-width="1" fill="#c0c0c0" cx="50%" rx="43%" ry="10%" cy="10%"></ellipse> 
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
        updateInfoInstrument(selected.data)
    )
    makeDragable(element, proc (e: Element) =
        let left = parseInt(($element.style.left).replace("px",""))
        let width = parseInt(($element.offsetWidth).replace("px", ""))
        let top = parseInt(($element.style.top).replace("px", ""))
        let height = parseInt(($element.offsetHeight).replace("px", ""))
        instrument.x = left - int((mapViewModel.map.width - width) / 2)
        instrument.y = top - int((mapViewModel.map.height - height) / 2)
        updateInfoInstrument(selected.data)
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
    let height = parseInt($document.getElementById("heightNew").value) * meter
    let width = parseInt($document.getElementById("widthNew").value) * meter
    let sequence = $document.getElementById("sequenceNew").value
    let city = $document.getElementById("cityNew").value
    let team = $document.getElementById("teamNew").value
    let music = $document.getElementById("musicNew").value
    initInfo()
    clear()
    mapViewModel.initMap(height, width, sequence, city, team, music)
    updateHeader(map)
    updateInfoMap(map)
    updateMapElement()

proc loadMap*() =
    var reader = FileReader()
    var file = InputElement(document.getElementById("load")).files[0]
    reader.onload = proc (e: FLoad) =
        let data = loadJson($reader.result)
        map = data.map
        initInfo()
        clear()
        updateMapElement()
        updateHeader(map)
        updateInfoMap(map)
        echo $map.sequence
        for instrument in data.instruments:
            addInstrument(instrument)
    
    reader.readAsText(file)

proc saveMap*() =
    var link = document.createElement("a")
    link.setAttr("download", "mapa.taiko")
    link.setAttr("href", "data:text/json;charset=utf-8," & dataJson())
    link.click()
