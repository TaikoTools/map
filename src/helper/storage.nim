proc setItem*(key: cstring, value: cstring) {. importcpp: "window.localStorage.setItem(@, @)" .}
proc getItem*(key: cstring) : cstring {. importcpp: "window.localStorage.getItem(@)" .}
proc clear*() {. importcpp: "window.localStorage.clear()" .}
