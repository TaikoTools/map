import dom
import strutils
import ../model/mapModel
import ../viewModel/mapViewModel

proc updateSelected*(x, y, height, width, angle: int) = 
    selected.updateInstrument(x, y, height, width, angle)

proc listener() = 
    let x = parseInt($document.getElementById("x").value)
    let y = parseInt($document.getElementById("y").value)
    let height = parseInt($document.getElementById("heightInfo").value)
    let width = parseInt($document.getElementById("widthInfo").value)
    let angle = parseInt($document.getElementById("angleInfo").value)
    updateSelected(x, y, height, width, angle)

proc updateInfo*(instrument: Instrument) =
    document.getElementById("x").value = $instrument.x
    document.getElementById("y").value = $instrument.y
    document.getElementById("heightInfo").value = $instrument.height
    document.getElementById("widthInfo").value = $instrument.width
    document.getElementById("angleInfo").value = $instrument.angle

proc initInfo*() =
    document.getElementById("x").addEventListener("input", proc (ev: Event) =
        listener()
    )
    document.getElementById("y").addEventListener("input", proc (ev: Event) =
        listener()
    )
    document.getElementById("heightInfo").addEventListener("input", proc (ev: Event) =
        listener()
    )
    document.getElementById("widthInfo").addEventListener("input", proc (ev: Event) =
        listener()
    )
    document.getElementById("angleInfo").addEventListener("input", proc (ev: Event) =
        listener()
    )
