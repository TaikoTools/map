import dom
import ../viewModel/mapViewModel
import ../model/mapModel

proc updateHeader*(map: Map) =
    document.getElementById("sequence").innerHTML = map.sequence
    document.getElementById("city").innerHTML = map.city
    document.getElementById("team").innerHTML = map.team
    document.getElementById("music").innerHTML = map.music

proc updateHeader*(sequence: string, city: string, team: string, music: string) =
    map.sequence = sequence
    map.city = city
    map.team = team
    map.music = music
    updateHeader(map)
