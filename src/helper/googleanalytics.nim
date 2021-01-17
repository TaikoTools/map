proc gaSend*(category, action, label: string) {. importcpp: "try { ga('send', 'event', '@', '@', '@') } catch (e) {}" .}
proc gaSend*(category, action: string) {. importcpp: "try { ga('send', 'event', '@', '@') } catch (e) {}" .}
proc gaSend*(category: string) {. importcpp: "try { ga('send', 'event', '@') } catch (e) {}" .}
