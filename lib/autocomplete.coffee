{_} = require 'atom'

AutocompleteView = require './autocomplete-view'

module.exports =
  configDefaults:
    includeCompletionsFromAllBuffers: false

  autocompleteViews: []
  editorSubscription: null

  activate: ->
    @editorSubscription = atom.rootView.eachEditor (editor) =>
      if editor.attached and not editor.mini
        autocompleteView = new AutocompleteView(editor)
        editor.on 'editor:will-be-removed', =>
          autocompleteView.remove() unless autocompleteView.hasParent()
          _.remove(@autocompleteViews, autocompleteView)
        @autocompleteViews.push(autocompleteView)

  deactivate: ->
    @editorSubscription?.off()
    @editorSubscription = null
    @autocompleteViews.forEach (autocompleteView) -> autocompleteView.remove()
    @autocompleteViews = []
