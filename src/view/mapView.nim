import dom
import strutils
import json
from sequtils import mapIt
import ../helper/dragable
import ../helper/seq
import ../helper/constants
import ../helper/storage
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
        of Tekkan:
            svgTekkan
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
        quickSave()
    )
    quickSave()
    updateList(instruments.mapIt(it.data))

proc addInstrument*(x, y, height, width, angle: int, instrumentType: InstrumentType) =
    var instrument = createInstrument(x, y, height, width, angle, instrumentType)
    addInstrument(instrument)

proc clear() =
    for instrument in instruments:
        instrument.e.parentNode.removeChild(instrument.e)
    instruments.deleteAll()
    updateList(instruments.mapIt(it.data))

proc contains(e, t: Node) : bool {. importcpp .}
proc removeSelection(e: Event) =
    let map = Node(document.getElementById("map"))
    if (not map.contains(e.target) or e.target.id == "map") and selected != nil:
        updateInfoInstrument(nil)
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
    document.getElementById("placeholder").style.display = "none"
    document.getElementById("mainView").classList.remove("showLater")
    document.getElementById("rightSideMenu").classList.remove("showLater")
    document.getElementById("addInstrumentMenu").classList.remove("showLater")
    clear()
    updateHeader(mapViewModel.map)
    updateInfoMap(mapViewModel.map)
    quickSave()

proc initMap*() =
    let height = parseInt($document.getElementById("heightNew").value) * meter
    let width = parseInt($document.getElementById("widthNew").value) * meter
    let sequence = $document.getElementById("sequenceNew").value
    let city = $document.getElementById("cityNew").value
    let team = $document.getElementById("teamNew").value
    let music = $document.getElementById("musicNew").value
    mapViewModel.initMap(height, width, sequence, city, team, music)
    updateMapElement()

proc loadMapFromJson*(json: string) = 
    let data = loadJson(json)
    map = data.map
    updateMapElement()
    for instrument in data.instruments:
        addInstrument(instrument)

proc loadMap*() =
    var reader = FileReader()
    var file = InputElement(document.getElementById("load")).files[0]
    reader.onload = proc (e: FLoad) =
        loadMapFromJson($reader.result)
    
    reader.readAsText(file)

proc saveMap*() =
    var link = document.createElement("a")
    link.setAttr("download", "mapa.taiko")
    link.setAttr("href", "data:text/json;charset=utf-8," & dataJson())
    link.click()

proc moveSelected*(dx, dy: int) =
    selected.data.x += dx
    selected.data.y += dy
    selected.updateInstrument(selected.data)
    updateInfoInstrument(selected.data)

proc copySelected*() =
    storage.setItem("clipboard", $ %* selected.data)

proc pasteSelected*() =
    let instrument = instrumentFromJson($ storage.getItem("clipboard"))
    addInstrument(instrument)