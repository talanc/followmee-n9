import QtQuick 1.1
import com.nokia.meego 1.0
import com.nokia.extras 1.1
import "helper.js" as Helper
import "storage.js" as Storage


Item {
    id: menu

    state: "init"

    property int score: -1
    property int highScoreIdx: -1
    property bool enterHighScore: false

    signal newGame()

    function show(newScore) {
        score = newScore
        enterHighScore = Storage.isHighScore(score)
        highScoreIdx = Storage.NUM_SCORES

        // update lowest high score
        // it won't get shown if its in the top 3
        var scoreMsg = score + "... :("
        var scores = highScores.model
        if (scores.length === Storage.NUM_SCORES) {
            scores.push( { name: "YOU", score: scoreMsg } )
        } else {
            scores[Storage.NUM_SCORES].score = scoreMsg
        }
        highScores.model = scores

        state = ""
    }

    transitions: [
        Transition {
            to: "hide"
            SequentialAnimation {
                NumberAnimation {
                    target: menu
                    property: "y"
                    duration: 500
                    easing.type: Easing.InQuad
                    to: -parent.height
                }
                /*PropertyAction {
                    target: menu
                    property: "visible"
                    value: false
                }*/
                PropertyAction {
                    target: menu
                    property: "highScoreIdx"
                    value: -1
                }
            }
        },
        Transition {
            to: ""
            SequentialAnimation {
                PauseAnimation { duration: 150 }
                /*PropertyAction {
                    target: menu
                    property: "visible"
                    value: true
                }*/
                NumberAnimation {
                    target: menu
                    property: "y"
                    duration: 1200
                    easing.type: Easing.OutBounce
                    easing.amplitude: 0.15
                    to: 0
                }
            }
        }
    ]

    // background
    Rectangle {
        anchors.fill: parent
        color: "black"
        opacity: 0.70
    }

    // A small invisible square in the bottom-right corner, which when pressed 7 times
    // within 3 seconds of each press, will reset the scoreboard with low dummy values
    MouseArea {
        property date d: new Date()
        property int hitCount: 0

        width: 100
        height: 100

        anchors {
            bottom: parent.bottom
            right: parent.right
        }

        onClicked: {
            var now = new Date()
            if (now - d <= 3000) {
                hitCount++

                switch (hitCount) {
                case 4:
                case 5:
                    banner.showText("Click " + (7 - hitCount) + " more times to reset high scores")
                    break
                case 6:
                    banner.showText("Click once more to reset high scores")
                    break
                case 7:
                    banner.showText("Resetting high scores")

                    hitCount = 0
                    Storage.insertDummyScores()
                    highScoreIdx = -1
                    highScores.refresh()
                    break
                }
            } else {
                hitCount = 1
            }
            d = now
        }
    }

    Item {
        x: !enterHighScore ? 0 : -width
        width: parent.width
        height: parent.height

        Behavior on x {
            SwipeAnimation { }
        }

        // title
        Label {
            anchors {
                top: parent.top
                topMargin: 40
                horizontalCenter: parent.horizontalCenter
            }

            font {
                pixelSize: 80
                bold: true
            }

            text: Helper.TITLE
        }

        // scores
        CenterColumn {
            anchors {
                centerIn: parent
                verticalCenterOffset: -60
            }

            spacing: 25

            Repeater {
                id: highScores
                Label {
                    font.pixelSize: Math.max(50 - index * 5, 10)
                    color: index === highScoreIdx ? "orange" : "white"
                    text: modelData.name + ": <b>" + modelData.score + "</b>"

                    onParentChanged: {
                        // parent becomes undefined when model is refreshed
                        if (parent) {
                            anchors.horizontalCenter = parent.horizontalCenter
                        }
                    }
                }

                Component.onCompleted: refresh()

                function refresh() {
                    model = Storage.getHighScores()
                }
            }
        }

        // buttons
        CenterColumn {
            spacing: 35

            anchors {
                bottom: parent.bottom
                bottomMargin: 100
                horizontalCenter: parent.horizontalCenter
            }

            Button {
                text: qsTr("New Game")

                onClicked: {
                    menu.state = "hide"
                    menu.newGame()
                }
            }

            Button {
                text: qsTr("About")

                onClicked: aboutDialog.open()
            }
        }
    }

    // enter high score
    CenterColumn {
        spacing: 50

        anchors {
            centerIn: parent
            horizontalCenterOffset: (enterHighScore ? 0 : parent.width)

            Behavior on horizontalCenterOffset {
                enabled: menu.state === ""
                SwipeAnimation { }
            }
        }

        Label {
            text: Helper.NEW_HIGH_SCORE
            font.pixelSize: 55
        }

        NameTumbler {
            id: nameTumbler
            width: 300
            height: 350
        }

        Button {
            text: qsTr("Submit")
            onClicked: {
                highScoreIdx = Storage.postHighScore(nameTumbler.name, score)
                highScores.refresh()
                enterHighScore = false
            }
        }
    }

    QueryDialog {
        id: aboutDialog
        icon: "/usr/share/icons/hicolor/80x80/apps/followmee80.png"
        titleText: Helper.TITLE
        message: "© 2014\nLicenced under GPLv2\n\nSource code available on website"
        acceptButtonText: "Website"
        rejectButtonText: "Close"
        onAccepted: Qt.openUrlExternally("https://github.com/talanc/followmee-n9")
    }

    InfoBanner {
        id: banner

        function showText(text) {
            banner.text = text
            banner.show()
        }
    }
}
