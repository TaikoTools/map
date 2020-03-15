import dom
import strutils
import ../model/mapModel
import ../viewModel/mapViewModel
import ./headerView

proc updateSelected*(x, y, height, width, angle: int) = 
    if selected != nil:
        selected.updateInstrument(x, y, height, width, angle)

proc listener(_: Event) = 
    let x = parseInt($document.getElementById("x").value)
    let y = parseInt($document.getElementById("y").value)
    let height = parseInt($document.getElementById("heightInfo").value)
    let width = parseInt($document.getElementById("widthInfo").value)
    let angle = parseInt($document.getElementById("angleInfo").value)
    let sequence = $document.getElementById("sequenceInput").value
    let city = $document.getElementById("cityInput").value
    let team = $document.getElementById("teamInput").value
    let music = $document.getElementById("musicInput").value
    updateSelected(x, y, height, width, angle)
    updateHeader(sequence, city, team, music)

proc updateInfoInstrument*(instrument: Instrument) =
    document.getElementById("x").value = $instrument.x
    document.getElementById("y").value = $instrument.y
    document.getElementById("heightInfo").value = $instrument.height
    document.getElementById("widthInfo").value = $instrument.width
    document.getElementById("angleInfo").value = $instrument.angle

proc updateInfoMap*(map: Map) =
    document.getElementById("sequenceInput").value = $map.sequence
    document.getElementById("cityInput").value = $map.city
    document.getElementById("teamInput").value = $map.team
    document.getElementById("musicInput").value = $map.music


proc initInfo*() =
    let elementIds = @[
        "x",
        "y",
        "heightInfo",
        "widthInfo",
        "angleInfo",
        "sequenceInput",
        "cityInput",
        "teamInput",
        "musicInput"
    ]
    for id in elementIds:
        document.getElementById(id).removeEventListener("input", listener)
        document.getElementById(id).addEventListener("input", listener)
