import karax / [vdom, karaxdsl, karax]
import src/view/sideMenuView
import src/view/mapInfoView
import src/view/instrumentInfoView
import src/view/mapView
import src/viewModel/mapViewModel
import src/helper/storage
import dom

proc createDom(): VNode =
    result = buildHtml(tdiv):
        renderSideMenu()
        tdiv(id = "placeholder"):
            img(src = "placeholder.png")
            h2:
                text("Comece criando um mapa novo")
        tdiv(id = "mainView", class="showLater"):
            tdiv(id = "header"):
                tdiv(id = "sequence")
                tdiv(id = "city")
                tdiv(id = "team")
                tdiv(id = "music")
            tdiv(class = "flex"):
                tdiv(id = "map")
                table(id = "instrumentList")
        tdiv(id = "rightSideMenu", class="showLater"):
            renderMapInfo()
            renderInstrumentInfo()

setRenderer createDom, "ROOT", proc () = 
    if (storage.getItem("quickSave") != nil):
        loadMapFromJson($storage.getItem("quickSave"))
    window.addEventListener("keydown", proc (e: Event) =
        let key = KeyboardEvent(e).keyCode
        echo KeyboardEvent(e).keyCode
        case (key)
        of 37: # Left
            e.preventDefault()
            mapView.moveSelected(-1, 0)
        of 38: # Up
            e.preventDefault()
            mapView.moveSelected(0, -1)
        of 39: # Right
            e.preventDefault()
            mapView.moveSelected(1, 0)
        of 40: # Down
            e.preventDefault()
            mapView.moveSelected(0, 1)
        of 46: # Delete
            mapViewModel.deleteSelected()
        else:
            return
    )
