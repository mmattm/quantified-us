
if (("standalone" in window.navigator) && window.navigator.standalone) {

    var noddy, remotes = false;

    document.addEventListener('click', function(event) {
        noddy = event.target;
        
        while (noddy.nodeName !== "A" && noddy.nodeName !== "HTML") {
            noddy = noddy.parentNode;
        }
        if ('href' in noddy && noddy.href.indexOf('http') !== -1 && (noddy.href.indexOf(document.location.host) !== -1 || remotes)) {
           // event.preventDefault();
            if ( (" " + noddy.className + " ").replace(/[\n\t]/g, " ").indexOf(" external ") > -1 ) {
            	console.log("YES");
            	event.preventDefault();
            	document.location.href = noddy.href;
            }
           // document.location.href = noddy.href;
        }
    }, false);
}

// document.addEventListener('click', function(event) {
//     noddy = event.target;
    
//     while (noddy.nodeName !== "A" && noddy.nodeName !== "HTML") {
//         noddy = noddy.parentNode;
//     }
//     if ('href' in noddy && noddy.href.indexOf('http') !== -1 && (noddy.href.indexOf(document.location.host) !== -1 || remotes)) {
//        // event.preventDefault();
//         if ( (" " + noddy.className + " ").replace(/[\n\t]/g, " ").indexOf(" external ") > -1 ) {
//         	console.log("YES");
//         	event.preventDefault();
//         	document.location.href = noddy.href;
//         }
//        // document.location.href = noddy.href;
//     }
// }, false);