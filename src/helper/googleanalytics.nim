proc gaSend*(category, action, label: string) {. importcpp: "try { ga('send', 'event', '@', '@', '@') }" .}
proc gaSend*(category, action: string) {. importcpp: "try { ga('send', 'event', '@', '@') }" .}
proc gaSend*(category: string) {. importcpp: "try { ga('send', 'event', '@') }" .}
