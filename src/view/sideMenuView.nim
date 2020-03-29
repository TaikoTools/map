import karax / [vdom, karaxdsl, karax]
import sugar
import dom
import strutils
from ../view/mapView import addInstrument, initMap, loadMap, saveMap
import ../helper/constants
import ../model/mapModel
import ../helper/imgExporter

var selectedType : InstrumentType

proc addNewInstrument(ev: Event, n: VNode) =
    case selectedType:
        of Okedo:
            addInstrument(0, 0, 40, int(1.5*shaku), 0, selectedType)
        of Shime:
            addInstrument(0, 0, 15, int(1*shaku), 0, selectedType)
        of Nagado:
            addInstrument(0, 0, 40, int(1.6*shaku), 0, selectedType)
        of Oodaiko:
            addInstrument(0, 0, 45, int(3*shaku), 0, selectedType)

proc showNewMapMenu(ev: Event, n: VNode) =
    if document.getElementById("newMap").classList.contains("down"):
        document.getElementById("newMap").classList.remove("down")
    else:
        document.getElementById("newMap").classList.add("down")

proc selectInstrumentType(ev: Event, n: VNode) =
    for item in document.getElementById("instrumentType").children:
        Element(item).classList.remove("selected")
        if (item.innerHTML == $ev.target.innerHTML):
            Element(item).classList.add("selected")
    selectedType = parseEnum[InstrumentType]($ev.target.innerHTML)

proc renderSideMenu*(): VNode =
    result = buildHtml(tdiv(id = "sideMenu")):
        tdiv(class = "btn", onclick = showNewMapMenu):
            text("Novo mapa")
        tdiv(class = "dropdown", id = "newMap"):
            tdiv():
                label(`for` = "heightNew", class = "floatLabel"):
                    text("Comprimento")
                input(`type` = "number", id = "heightNew", value = "0")
                label(`for` = "widthNew", class = "floatLabel"):
                    text("Largura")
                input(`type` = "number", id = "widthNew", value = "0")
            tdiv():
                label(`for` = "sequenceNew", class = "floatLabel"):
                    text("Ordem da apresentação")
                input(id = "sequenceNew")
            tdiv():
                label(`for` = "cityNew", class = "floatLabel"):
                    text("Cidade")
                input(id = "cityNew")
            tdiv():
                label(`for` = "teamNew", class = "floatLabel"):
                    text("Equipe")
                input(id = "teamNew")
            tdiv():
                label(`for` = "musicNew", class = "floatLabel"):
                    text("Música")
                input(id = "musicNew")
            tdiv(class = "btn", onclick = () => initMap()):
                text("Criar")
        label(`for` = "load", class = "btn"):
            text("Carregar mapa")
        input(`type` = "file" , onchange = () => loadMap(), id = "load", class = "hidden", accept = ".taiko", download = "a.taiko")
        tdiv(class = "btn", onclick = () => saveMap()):
            text("Salvar mapa")
        tdiv(class = "btn", onclick = () => exportMap()):
            text("Exportar imagem")
        tdiv(id = "addInstrumentMenu", class = "showLater"):
            tdiv(id = "instrumentType", class = "list"):
                tdiv(onclick = selectInstrumentType):
                    text("Okedo")
                tdiv(onclick = selectInstrumentType):
                    text("Shime")
                tdiv(onclick = selectInstrumentType):
                    text("Nagado")
                tdiv(onclick = selectInstrumentType):
                    text("Oodaiko")
            tdiv(class = "btn", onclick = addNewInstrument):
                text("Novo taiko")