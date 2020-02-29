.pragma library

var COLORS = ["#3aee2c", "#ee2c3a", "#eee02c", "#2c3aee"]

var TITLE = "<font color=\"" + COLORS[0] + "\">Follow</font>" +
        "<font color=\"" + COLORS[1] + "\">M</font>" +
        "<font color=\"" + COLORS[2] + "\">e</font>" +
        "<font color=\"" + COLORS[3] + "\">e</font>";

var NEW_HIGH_SCORE =
        "<font color=\"" + COLORS[0] + "\">new</font>" +
        "<font color=\"" + COLORS[1] + "\">high</font>" +
        "<font color=\"" + COLORS[2] + "\">score</font>" +
        "<font color=\"" + COLORS[3] + "\">!!!</font>";

function __sp(sound) {
    return "../../audio/" + sound + ".wav"
}
var SOUNDS = [__sp("green"), __sp("red"), __sp("yellow"), __sp("blue")]
var SOUND_WRONG = __sp("wrong")

