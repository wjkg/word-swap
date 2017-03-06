WordSwap = require '../lib/word-swap'

# Use the command `window:run-package-specs` (cmd-alt-ctrl-p) to run specs.
#
# To run a specific `it` or `describe` block add an `f` to the front (e.g. `fit`
# or `fdescribe`). Remove the `f` to unfocus the block.

describe 'WordSwap', ->
  describe 'swapInLine function', ->
    expectSwapResult = (before, after) ->
      expect(WordSwap.swapInLine(before...)).toEqual(after)

    it 'swaps parts of word when cursor is inside', ->
      expectSwapResult ['abcdef', 3], ['defabc', 3]

    it 'swaps words when cursor is between them', ->
      expectSwapResult ['abc, def', 4], ['def, abc', 4]

    it 'swaps words of different length', ->
      expectSwapResult ['abcdef ghi', 6], ['ghi abcdef', 3]

    it 'swaps words with other words around them', ->
      expectSwapResult(
        ['fugiat enim excepteur sunt cillum irure', 21],
        ['fugiat enim sunt excepteur cillum irure', 16]
      )

    it 'ignores non-word characters', ->
      expectSwapResult(
        ['fugiat enim-excepteur, %sunt cillum irure', 21],
        ['fugiat enim-sunt, %excepteur cillum irure', 16]
      )

    it 'changes nothing without words on both sides', ->
      expectSwapResult ['---#!!.', 3], ['---#!!.', 3]
      expectSwapResult ['-------aaa', 5], ['-------aaa', 5]
      expectSwapResult ['aaa-------', 5], ['aaa-------', 5]

    it 'changes nothing when cursor is on either end', ->
      expectSwapResult ['abcde', 0], ['abcde', 0]
      expectSwapResult ['abcde', 5], ['abcde', 5]
