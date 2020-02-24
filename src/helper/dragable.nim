import dom

proc makeDragable*(e: Element, onMove: proc (e: Element) {. closure .}) =
    proc onmousedown(event: Event) = 
        event.preventDefault()
        let parent = Element(e.parentNode)
        let shiftX = MouseEvent(event).clientX - e.offsetLeft
        let shiftY = MouseEvent(event).clientY - e.offsetTop

        proc onmousemove(event: Event) =
            let newLeft = min(max(MouseEvent(event).clientX - shiftX, 0), parent.clientWidth - e.clientWidth)
            let newTop = min(max(MouseEvent(event).clientY - shiftY, 0), parent.clientHeight - e.clientHeight)
            e.style.left = $newLeft & "px"
            e.style.top = $newTop & "px"
            onMove(e)

        proc onmouseup(event: Event) =
            document.removeEventListener("mousemove", onmousemove)
            document.removeEventListener("mouseup", onmouseup)
        
        document.addEventListener("mousemove", onmousemove)
        document.addEventListener("mouseup", onmouseup)

    e.addEventListener("mousedown", onmousedown)
