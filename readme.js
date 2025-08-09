function add_script(src) {
    var script = document.createElement('script');
    script.src = src;
    script.async = false;
    document.head.appendChild(script);
}

add_script('https://code.jquery.com/jquery-3.6.0.min.js');
add_script('docs/doc_res/js/go_to_top.js');

document.addEventListener("DOMContentLoaded", function() {
    old_version_link = document.getElementById("old-version-link");
    old_version_link.setAttribute("href", 'old/');
});
