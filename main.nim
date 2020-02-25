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
                    label(`for` = "height", class = "floatLabel"):
                        text("Comprimento")
                    input(`type` = "number", id = "height", value = "0")
                    label(`for` = "width", class = "floatLabel"):
                        text("Largura")
                    input(`type` = "number", id = "width", value = "0")
                tdiv(class = "btn", onclick = () => initMap()):
                    text("Criar")
            label(`for` = "load", class = "btn"):
                text("Carregar")
            input(`type` = "file" , onchange = () => loadMap(), id = "load", class = "hidden", accept = ".taiko", download = "a.taiko")
            tdiv(class = "btn", onclick = () => saveMap()):
                text("Salvar")
            a(id = "download", class = "hidden")
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
        tdiv(id = "map")
        tdiv(id = "instrumentInfo"):
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
