import dom
import strutils
from sequtils import mapIt
import ../helper/dragable
import ../helper/seq
import ../helper/constants
import ../helper/svg
import ../helper/fileReader
import ../viewModel/mapViewModel
import ../model/mapModel
import ./instrumentInfoView
import ./headerView
import ../viewModel/instrumentListViewModel
import ./mapInfoView

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
    updateList(instruments.mapIt(it.data))

proc addInstrument*(x, y, height, width, angle: int, instrumentType: InstrumentType) =
    var instrument = createInstrument(x, y, height, width, angle, instrumentType)
    addInstrument(instrument)

proc clear() =
    for instrument in instruments:
        instrument.e.parentNode.removeChild(instrument.e)
    instruments.deleteAll()
    updateList(instruments.mapIt(it.data))

proc removeSelection(e: Event) = 
    if e.target.id == "map" and selected != nil:
        updateInfoInstrument(Instrument())
        selected.e.classList.remove("selected")
        selected = nil

proc updateMapElement() =
    let map = document.getElementById("map")
    let height = mapViewModel.map.height
    let width = mapViewModel.map.width
    map.style.height = $height & "px"
    map.style.width = $width & "px"
    map.style.backgroundPosition = $(height / 2) & "px " & $(width / 2) & "px"
    map.style.display = "block"
    document.getElementById("newMap").classList.remove("down")
    document.getElementById("map").addEventListener("mousedown", removeSelection)

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
