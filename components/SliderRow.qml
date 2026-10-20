import QtQuick
import QtQuick.Layouts
import ".."

RowLayout {
    id: row
    property string icon: ""
    property real value: 0.5
    signal moved(real value)

    Layout.fillWidth: true
    spacing: 12

    Text {
        text: row.icon
        font.pixelSize: 18
        color: Theme.mauve
        Layout.preferredWidth: 24
        horizontalAlignment: Text.AlignHCenter
    }

    Item {
        id: track
        Layout.fillWidth: true
        implicitHeight: 24

        Rectangle {
            anchors.verticalCenter: parent.verticalCenter
            width: parent.width
            height: 6
            radius: 3
            color: Theme.surface1

            Rectangle {
                width: parent.width * row.value
                height: parent.height
                radius: 3
                color: Theme.mauve
            }
        }

        Rectangle {
            x: (track.width - width) * row.value
            anchors.verticalCenter: parent.verticalCenter
            width: 16
            height: 16
            radius: 8
            color: Theme.mauve
            border.width: 3
            border.color: Theme.base
        }

        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            function update(mouse) {
                row.value = Math.max(0, Math.min(1, mouse.x / track.width));
                row.moved(row.value);
            }
            onPressed: mouse => update(mouse)
            onPositionChanged: mouse => { if (pressed) update(mouse); }
        }
    }

    Text {
        text: Math.round(row.value * 100)
        font.family: Theme.font
        font.pixelSize: 12
        color: Theme.subtext0
        Layout.preferredWidth: 28
        horizontalAlignment: Text.AlignRight
    }
}
