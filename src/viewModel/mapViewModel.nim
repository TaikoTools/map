import ../helper/seq
import ../model/mapModel

var instruments*:seq[Instrument] = newSeq[Instrument]()
var map*: Map = Map()

proc createInstrument*(): Instrument =
    var instrument = Instrument()
    instrument.x = 10
    instrument.y = 10
    instrument.angle = 0
    instruments.add(instrument)
    result = instrument

proc clear*() =
    instruments.deleteAll()

proc initMap*(height, width = 0) =
    map = Map(height: height, width: width)
