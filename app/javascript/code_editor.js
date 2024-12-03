document.addEventListener('DOMContentLoaded', () => {
    const editorElements = document.querySelectorAll('.code-editor');

    editorElements.forEach(editorElement => {
        if (window.CodeMirror) {
            const editor = window.CodeMirror.fromTextArea(editorElement, {
                mode: 'python',
                theme: 'monokai',
                lineNumbers: true,
                indentUnit: 4,
                tabSize: 4,
                indentWithTabs: false,
                autofocus: false,
                lineWrapping: true,
                extraKeys: {
                    "Tab": (cm) => {
                        cm.replaceSelection("    ", "end");
                    }
                }
            });

            // Ensure form submission captures the editor content
            const form = editorElement.closest('form');
            if (form) {
                form.addEventListener('submit', () => {
                    editorElement.value = editor.getValue();
                });
            }

            // Set initial size
            editor.setSize(null, 400);
        }
    });
});