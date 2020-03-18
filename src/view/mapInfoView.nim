import karax / [vdom, karaxdsl, karax]
import dom
import ../model/mapModel
import ./headerView

proc updateInfoMap*(map: Map) =
    document.getElementById("sequenceInput").value = $map.sequence
    document.getElementById("cityInput").value = $map.city
    document.getElementById("teamInput").value = $map.team
    document.getElementById("musicInput").value = $map.music

proc renderMapInfo*(): VNode =
    proc handler(ev: dom.Event, n: VNode) =
        let sequence = $document.getElementById("sequenceInput").value
        let city = $document.getElementById("cityInput").value
        let team = $document.getElementById("teamInput").value
        let music = $document.getElementById("musicInput").value
        updateHeader(sequence, city, team, music)

    buildHtml(tdiv):
        tdiv():
            label(`for` = "sequenceInput", class = "floatLabel"):
                text("Ordem da apresentação")
            input(id = "sequenceInput", oninput = handler)
        tdiv():
            label(`for` = "cityInput", class = "floatLabel"):
                text("Cidade")
            input(id = "cityInput", oninput = handler)
        tdiv():
            label(`for` = "teamInput", class = "floatLabel"):
                text("Equipe")
            input(id = "teamInput", oninput = handler)
        tdiv():
            label(`for` = "musicInput", class = "floatLabel"):
                text("Música")
            input(id = "musicInput", oninput = handler)