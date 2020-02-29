// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.meego 1.1
import com.nokia.extras 1.1

Item {
    property string name: "AAA"

    width: 300
    height: 400

    Tumbler {
        columns: [ char1, char2, char3 ]

        onChanged: {
            name = char1.items.get(char1.selectedIndex).value +
                    char2.items.get(char2.selectedIndex).value +
                    char3.items.get(char3.selectedIndex).value
        }
    }

    TumblerColumn {
        id: char1
        items: character
    }

    TumblerColumn {
        id: char2
        items: character
    }

    TumblerColumn {
        id: char3
        items: character
    }

    ListModel {
        id: character
        ListElement { value: "A" }
        ListElement { value: "B" }
        ListElement { value: "C" }
        ListElement { value: "D" }
        ListElement { value: "E" }
        ListElement { value: "F" }
        ListElement { value: "G" }
        ListElement { value: "H" }
        ListElement { value: "I" }
        ListElement { value: "J" }
        ListElement { value: "K" }
        ListElement { value: "L" }
        ListElement { value: "M" }
        ListElement { value: "N" }
        ListElement { value: "O" }
        ListElement { value: "P" }
        ListElement { value: "Q" }
        ListElement { value: "R" }
        ListElement { value: "S" }
        ListElement { value: "T" }
        ListElement { value: "U" }
        ListElement { value: "V" }
        ListElement { value: "W" }
        ListElement { value: "X" }
        ListElement { value: "Y" }
        ListElement { value: "Z" }
    }
}
