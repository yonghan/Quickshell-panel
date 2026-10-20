import QtQuick
import QtQuick.Layouts
import ".."

// Windows 10 action-center style toggle tile.
Rectangle {
    id: tile
    property string icon: ""
    property string label: ""
    property bool active: false
    signal toggled(bool active)

    Layout.fillWidth: true
    implicitHeight: Theme.px(72)
    radius: Theme.innerRadius
    color: active ? Theme.mauve : (area.containsMouse ? Theme.surface1 : Theme.surface0)

    Behavior on color { ColorAnimation { duration: 120 } }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Theme.px(10)
        spacing: Theme.px(2)

        Text {
            Layout.alignment: Qt.AlignHCenter
            text: tile.icon
            font.pixelSize: Theme.px(22)
            color: tile.active ? Theme.crust : Theme.text
        }
        Text {
            Layout.alignment: Qt.AlignHCenter
            text: tile.label
            elide: Text.ElideRight
            font.family: Theme.font
            font.pixelSize: Theme.px(12)
            color: tile.active ? Theme.crust : Theme.subtext0
        }
    }

    MouseArea {
        id: area
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: {
            tile.active = !tile.active;
            tile.toggled(tile.active);
        }
    }
}
