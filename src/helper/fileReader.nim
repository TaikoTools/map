import dom
import jsffi

type FLoad* = object of RootObj
    result* {.importcpp: "target.result".}: cstring

type FReader = object of JsObject
    onload*: proc(event: FLoad)
    readAsText*: proc(file: Blob)
    result*: cstring

proc FileReader*() : FReader {.importcpp: "new FileReader()".}
