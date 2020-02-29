// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

Column {
    Component.onCompleted: {
        // center align items horizontally
        for (var i = 0, count = children.length; i < count; i++) {
            var item = children[i]
            item.anchors.horizontalCenter = item.parent.horizontalCenter
        }
    }
}
