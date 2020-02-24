include karax / prelude
import src/view/mapView
import src/view/infoView
import sugar

proc createDom(): VNode =
    result = buildHtml(tdiv):
        tdiv(id = "sideMenu"):
            tdiv():
                label(`for` = "height"):
                    text("Comprimento")
                input(`type` = "number", id = "height", value = "0")
                label(`for` = "width"):
                    text("Largura")
                input(`type` = "number", id = "width", value = "0")
            button(onclick = () => initMap()):
                text("Novo mapa")
            button(onclick = () => addInstrument(0, 0, 40, 30, 0)):
                text("Novo taiko")
        tdiv(id = "map")
        tdiv(id = "instrumentInfo"):
            tdiv():
                label(`for` = "x"):
                    text("x")
                input(`type` = "number", id = "x", value = "0")
                label(`for` = "y"):
                    text("y")
                input(`type` = "number", id = "y", value = "0")
            tdiv():
                label(`for` = "heightInfo"):
                    text("h")
                input(`type` = "number", id = "heightInfo", value = "0")
                label(`for` = "widthInfo"):
                    text("w")
                input(`type` = "number", id = "widthInfo", value = "0")
            tdiv():
                label(`for` = "angleInfo"):
                    text("a")
                input(`type` = "number", id = "angleInfo", value = "0")
            
            button(onclick = deleteSelected):
                text("Delete")

setRenderer createDom
