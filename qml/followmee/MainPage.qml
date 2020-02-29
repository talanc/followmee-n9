import QtQuick 1.1
import com.nokia.meego 1.1
import QtMultimediaKit 1.1
import QtMobility.feedback 1.1
import "helper.js" as Helper
import "game.js" as Game

Page {
    id: gamePage
    orientationLock: PageOrientation.LockPortrait

    function newGame() {
        Game.newGame(Helper.COLORS.length)
        simonSays()
    }

    function gameOver() {
        state = ""
        mainMenu.show(Game.score)
    }

    function simonSays(startInterval) {
        if (!startInterval) {
            startInterval = 500
        }
        state = "simon"
        simon.say(startInterval)
    }

    Grid {
        id: grid
        anchors.centerIn: parent
        columns: 2
        spacing: 20

        Repeater {
            id: buttons
            model: Helper.COLORS

            /*Rectangle {
                property color mycolor: modelData

                width: gamePage.width / 2 - grid.spacing
                height: gamePage.height / 2 - grid.spacing
                color: mycolor
                border.color: Qt.darker(mycolor, 1.5)
                radius: 15

                Behavior on color {
                    ColorAnimation { duration: 100 }
                }

                Timer {
                    id: timer
                    interval: 100
                    onTriggered: parent.color = parent.mycolor
                }

                function press(guess) {
                    color = Qt.darker(mycolor)
                    timer.start()
                    if (guess === Game.GUESS_WRONG) {
                        // feedback undefined in simulator
                        if (buzz.start) {
                            buzz.start()
                        }
                        wrong.play()
                    } else {
                        sound.play()
                    }
                }

                SoundEffect {
                    id: sound
                    source: Helper.SOUNDS[index]
                }

                MouseArea {
                    enabled: gamePage.state === "guess"
                    anchors.fill: parent
                    onPressed: {
                        var guess = Game.makeGuess(index)
                        press(guess)

                        if (guess === Game.GUESS_WRONG) {
                            gamePage.gameOver()
                            return
                        } else if (guess === Game.GUESS_LEVEL) {
                            simonSays()
                        }
                    }
                }
            }*/

            Rectangle {
                property color mycolor: modelData

                width: gamePage.width / 2 - grid.spacing
                height: gamePage.height / 2 - grid.spacing
                color: mycolor
                border.color: Qt.darker(mycolor, 2)
                radius: width * 0.1

                gradient: Gradient {
                    GradientStop {
                        position: 0.0
                        color: index < grid.columns ? Qt.darker(mycolor, 1.4) : mycolor
                    }
                    GradientStop {
                        position: 1.0
                        color: index < grid.columns ? mycolor : Qt.darker(mycolor, 1.4)
                    }
                }

                Rectangle {
                    id: mask
                    anchors.fill: parent
                    color: "black"
                    opacity: 0

                    Behavior on opacity {
                        NumberAnimation { duration: 100 }
                    }
                }

                Timer {
                    id: timer
                    interval: 100
                    onTriggered: mask.opacity = 0
                }

                function press(guess) {
                    mask.opacity = 0.3
                    timer.start()
                    if (guess === Game.GUESS_WRONG) {
                        // feedback undefined in simulator
                        if (buzz.start) {
                            buzz.start()
                        }
                        wrong.play()
                    } else {
                        sound.play()
                    }
                }

                SoundEffect {
                    id: sound
                    source: Helper.SOUNDS[index]
                }

                MouseArea {
                    enabled: gamePage.state === "guess"
                    anchors.fill: parent
                    onPressed: {
                        var guess = Game.makeGuess(index)
                        press(guess)

                        if (guess === Game.GUESS_WRONG) {
                            gamePage.gameOver()
                            return
                        } else if (guess === Game.GUESS_LEVEL) {
                            simonSays()
                        }
                    }
                }
            }
        }
    }

    SoundEffect {
        id: wrong
        source: Helper.SOUND_WRONG
    }

    HapticsEffect {
        id: buzz
        intensity: 0.7
        duration: 400
    }

    Rectangle {
        id: notice
        width: 128
        height: width
        radius: width
        anchors.centerIn: parent

        color: (gamePage.state === "guess" ? "lime" : "crimson")
        border.width: 2

        MouseArea {
            anchors {
                fill: parent
                margins: parent.width * 0.16
            }
            onClicked: {
                Game.resetGuess()
                simonSays(300)
            }
            enabled: gamePage.state === "guess"
        }
    }

    MainMenu {
        id: mainMenu

        width: parent.width
        height: parent.height

        onNewGame: {
            parent.newGame()
        }
    }

    Timer {
        id: simon
        repeat: true

        property int i

        onTriggered: {
            if (i < Game.says.length) {
                // press next button
                var btn = buttons.itemAt(Game.says[i])
                btn.press()
                i++
                interval = 300
            } else {
                // simon has said everything
                state = "guess"
                stop()
            }
        }

        function say(startInterval) {
            i = 0
            interval = startInterval
            start()
        }
    }
}
