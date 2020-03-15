include karax / prelude
import src/view/mapView
import src/view/sideMenuView
import sugar

proc createDom(): VNode =
    result = buildHtml(tdiv):
        tdiv(id = "sideMenu"):
            tdiv(class = "btn", onclick = () => showNewMapMenu()):
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
                        text("Ordem da apredentação")
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
                text("Carregar")
            input(`type` = "file" , onchange = () => loadMap(), id = "load", class = "hidden", accept = ".taiko", download = "a.taiko")
            tdiv(class = "btn", onclick = () => saveMap()):
                text("Salvar")
            tdiv(id = "instrumentType", class = "list"):
                tdiv(onclick = () => selectInstrumentType("Okedo")):
                    text("Okedo")
                tdiv(onclick = () => selectInstrumentType("Shime")):
                    text("Shime")
                tdiv(onclick = () => selectInstrumentType("Nagado")):
                    text("Nagado")
                tdiv(onclick = () => selectInstrumentType("Oodaiko")):
                    text("Oodaiko")
            tdiv(class = "btn", onclick = () => addNewInstrument()):
                text("Novo taiko")
        tdiv():
            tdiv(id = "header"):
                tdiv(id = "sequence")
                tdiv(id = "city")
                tdiv(id = "team")
                tdiv(id = "music")
            tdiv(class = "flex"):
                tdiv(id = "map")
                table(id = "instrumentList")
        tdiv(id = "instrumentInfo"):
            tdiv():
                label(`for` = "sequenceInput", class = "floatLabel"):
                    text("Ordem da apredentação")
                input(id = "sequenceInput")
            tdiv():
                label(`for` = "cityInput", class = "floatLabel"):
                    text("Cidade")
                input(id = "cityInput")
            tdiv():
                label(`for` = "teamInput", class = "floatLabel"):
                    text("Equipe")
                input(id = "teamInput")
            tdiv():
                label(`for` = "musicInput", class = "floatLabel"):
                    text("Música")
                input(id = "musicInput")
            tdiv():
                label(`for` = "x", class = "floatLabel"):
                    text("x")
                input(`type` = "number", id = "x", value = "0")
                label(`for` = "y", class = "floatLabel"):
                    text("y")
                input(`type` = "number", id = "y", value = "0")
            tdiv():
                label(`for` = "heightInfo", class = "floatLabel"):
                    text("h")
                input(`type` = "number", id = "heightInfo", value = "0")
                label(`for` = "widthInfo", class = "floatLabel"):
                    text("w")
                input(`type` = "number", id = "widthInfo", value = "0")
            tdiv():
                label(`for` = "angleInfo", class = "floatLabel"):
                    text("a")
                input(`type` = "number", id = "angleInfo", value = "0")
            
            tdiv(class = "btn", onclick = deleteSelected):
                text("Delete")


setRenderer createDom
