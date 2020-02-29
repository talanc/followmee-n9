var __numColors = 4
var score = 0
var says = []
var __currentGuessIdx = 0

function newGame(numCols) {
    __numColors = numCols || 4
    score = 0
    says.length = 0
    __addRandomColor()
    __currentGuessIdx = 0
}

function __addRandomColor() {
    says.push(Math.floor(Math.random() * __numColors))
}

var GUESS_WRONG = 0
var GUESS_RIGHT = 1
var GUESS_LEVEL = 2

function makeGuess(guess) {
    if (says[__currentGuessIdx] !== guess) {
        return GUESS_WRONG
    }

    __currentGuessIdx++
    if (__currentGuessIdx < says.length) {
        return GUESS_RIGHT
    }

    score++
    __addRandomColor()
    __currentGuessIdx = 0
    return GUESS_LEVEL
}

function resetGuess() {
    __currentGuessIdx = 0
}
