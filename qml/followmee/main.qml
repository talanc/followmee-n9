import QtQuick 1.1
import com.nokia.meego 1.0

PageStackWindow {
    id: window

    initialPage: mainPage

    MainPage {
        id: mainPage
    }

    showToolBar: false
    //showStatusBar: false
    Component.onCompleted: theme.inverted = true
}
