proc gaSend*(category, action, label: string) {. importcpp: "ga('send', 'event', '@', '@', '@')" .}
proc gaSend*(category, action: string) {. importcpp: "ga('send', 'event', '@', '@')" .}
proc gaSend*(category: string) {. importcpp: "ga('send', 'event', '@')" .}
