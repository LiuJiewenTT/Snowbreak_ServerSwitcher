function add_script(src) {
    var script = document.createElement('script');
    script.src = src;
    script.async = false;
    document.head.appendChild(script);
}

add_script('https://code.jquery.com/jquery-3.6.0.min.js');
add_script('docs/doc_res/js/go_to_top.js');


function edit_old_version_link() {
    try {
        old_version_link = document.getElementById("old-version-link");
        old_version_link.setAttribute("href", 'old/');
    } catch (e) {
        setTimeout(edit_old_version_link, 500);
    }
}

function dom_edit() {
    edit_old_version_link();
}

dom_edit();
