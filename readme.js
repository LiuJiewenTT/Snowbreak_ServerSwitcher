function loadScript_Promise(src, async_flag=true) {
  return new Promise((resolve, reject) => {
    const script = document.createElement('script');
    script.src = src;
    script.async = async_flag;
    script.onload = () => resolve(script);
    script.onerror = () => reject(new Error(`Failed to load script: ${src}`));
    document.head.appendChild(script);
  });
}


async function await_add_scripts() {
    await loadScript_Promise('https://code.jquery.com/jquery-3.6.0.min.js', false);
    loadScript_Promise('docs/doc_res/js/go_to_top.js');
    await loadScript_Promise('docs/doc_res/js/github-markdown-alert-reproduce.js');
}


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
    process_blockquote_to_markdown_alert();
    // document.body.prepend(process_blockquote_to_markdown_alert);
}


(async () => {
    await await_add_scripts();
    dom_edit();
})();
