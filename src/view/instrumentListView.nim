import dom
import strformat
import tables
import ../viewModel/mapViewModel

proc updateList*() =
    var counter = initTable[string, int]()
    for instrument in instruments:
        if counter.contains($instrument.data.instrumentType):
            counter[$instrument.data.instrumentType] += 1
        else:
            counter[$instrument.data.instrumentType] = 1
    let list = document.getElementById("instrumentList")
    list.innerHTML = ""
    for instrument, count in counter.pairs:
        list.innerHTML = $list.innerHTML & fmt"<tr><td>{instrument}</td><td>{count}</td></tr>"
