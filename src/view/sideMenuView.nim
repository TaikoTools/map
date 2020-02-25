import dom
import strutils
import ../view/mapView
import ../helper/constants
import ../model/mapModel

proc showNewMapMenu*() =
    if document.getElementById("newMap").classList.contains("down"):
        document.getElementById("newMap").classList.remove("down")
    else:
        document.getElementById("newMap").classList.add("down")

var selectedType : InstrumentType

proc selectInstrumentType*(instrumentType: string) =
    for item in document.getElementById("instrumentType").children:
        Element(item).classList.remove("selected")
        if (item.innerHTML == instrumentType):
            Element(item).classList.add("selected")
    selectedType = parseEnum[InstrumentType](instrumentType)

proc addNewInstrument*() =
    case selectedType:
        of Okedo:
            addInstrument(0, 0, 40, int(1.5*shaku), 0, selectedType)
        of Shime:
            addInstrument(0, 0, 15, int(1*shaku), 0, selectedType)
        of Nagado:
            addInstrument(0, 0, 40, int(1.6*shaku), 0, selectedType)
        of Oodaiko:
            addInstrument(0, 0, 45, int(3*shaku), 0, selectedType)
