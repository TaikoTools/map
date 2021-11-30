proc exportMap*(filename: cstring) {. importcpp: """
domtoimage.toBlob(document.getElementById('mainView'))
    .then(function (blob) {
        let link = document.createElement("a")
        let url = URL.createObjectURL(blob)
        link.setAttribute("download", @)
        link.setAttribute("href", url)
        link.click()
    });
""" .}
