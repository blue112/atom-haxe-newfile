{CompositeDisposable} = require 'atom'

module.exports = HaxeNewfile =
  haxeNewfileView: null
  modalPanel: null
  subscriptions: null

  activate: (state) ->
    @subscriptions = new CompositeDisposable

    @subscriptions.add atom.workspace.observeTextEditors((editor) => @_editorGiven(editor))

  _editorGiven: (editor) ->
      @subscriptions.add editor.onDidSave (obj) =>
          @fill(editor, obj.path)

  deactivate: ->
      @subscriptions.dispose()

  serialize: ->
      haxeNewfileViewState: @haxeNewfileView.serialize()

  fill: (editor, path) ->
      if editor.getText() == ""
          p = atom.project.getPaths()[0]

          pack = ""
          if path.indexOf(p) != -1
              sp = path.substr(path.indexOf(p) + p.length + 1).split("/")
              sp.pop()
              dirName = sp.join(".")
              pack = dirName
              console.log(sp, path, p, dirName)

          fileName = path.split("/").pop().split(".").shift()

          if pack != ""
              cls = "package "+pack+";\n\n"

          cls += """
            class #{fileName}
            {
                public function new()
                {
                    
                }
            }
          """
          editor.setText(cls)

          editor.moveUp(2)
          editor.moveToEndOfLine()

          editor.save()
