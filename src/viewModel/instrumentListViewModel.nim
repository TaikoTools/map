import dom
import strformat
import tables
import ../model/mapModel

proc updateList*(instruments: seq[Instrument]) =
    var counter = initTable[string, int]()
    for instrument in instruments:
        if counter.contains($instrument.instrumentType):
            counter[$instrument.instrumentType] += 1
        else:
            counter[$instrument.instrumentType] = 1
    let list = document.getElementById("instrumentList")
    list.innerHTML = ""
    for instrument, count in counter.pairs:
        if instrument != $Text:
            list.innerHTML = $list.innerHTML & fmt"<tr><td>{instrument}</td><td>{count}</td></tr>"
