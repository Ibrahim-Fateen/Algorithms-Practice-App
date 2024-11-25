// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import "./code_editor"

// Initialize CodeMirror
document.addEventListener('turbo:load', () => {
    const editorElement = document.getElementById('code-editor')
    if (editorElement) {
        const editor = CodeMirror.fromTextArea(editorElement, {
            mode: 'python',
            theme: 'monokai',
            lineNumbers: true,
            autoCloseBrackets: true,
            indentUnit: 4,
            tabSize: 4,
            lineWrapping: true,
            viewportMargin: Infinity,
            extraKeys: {
                "Tab": function(cm) {
                    cm.replaceSelection("    ", "end");
                }
            }
        })

        // Update hidden form field with code content when submitting
        const form = document.getElementById('submission-form')
        if (form) {
            form.addEventListener('submit', () => {
                const codeContent = editor.getValue()
                document.getElementById('submission_code').value = codeContent
            })
        }
    }
})