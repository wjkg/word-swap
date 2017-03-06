{CompositeDisposable} = require 'atom'

module.exports = WordSwap =
  subscriptions: null

  activate: (state) ->
    @subscriptions = new CompositeDisposable
    @subscriptions.add atom.commands.add 'atom-workspace', 'word-swap:swap': => @swap()

  deactivate: ->
    @subscriptions.dispose()

  swap: ->
    editor = atom.workspace.getActiveTextEditor()
    pos = editor.getCursorBufferPosition()
    line = editor.lineTextForBufferRow pos.row

    [newLine, newColumn] = @swapInLine line, pos.column

    lineRange = [[pos.row, 0], [pos.row, line.length]]
    editor.setTextInBufferRange lineRange, newLine
    editor.setCursorBufferPosition [pos.row, newColumn]

  swapInLine: (line, position) ->
    parts = [ @reverse(line[...position]), line[position...] ]
    words = parts.map (part) => part.match /\w+/
    return [line, position] unless words[0] and words[1]

    newParts = parts.map (part, i) =>
      [a, b] = [words[i].index, words[i].index + words[i][0].length]
      return part[...a] + @reverse(words[+!i][0]) + part[b...]
    newPosition = position + (words[1][0].length - words[0][0].length)

    return [ @reverse(newParts[0]) + newParts[1], newPosition ]

  reverse: (text) -> text.split('').reverse().join('')
