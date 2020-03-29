proc exportMap*() {. importcpp: """
domtoimage.toBlob(document.getElementById('mainView'))
    .then(function (blob) {
        let link = document.createElement("a")
        let url = URL.createObjectURL(blob)
        link.setAttribute("download", "mapa.png")
        link.setAttribute("href", url)
        link.click()
    });
""" .}
