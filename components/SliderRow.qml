import QtQuick
import QtQuick.Layouts
import ".."

RowLayout {
    id: row
    property string icon: ""
    property real value: 0.5
    signal moved(real value)

    Layout.fillWidth: true
    spacing: Theme.px(12)

    Text {
        text: row.icon
        font.pixelSize: Theme.px(18)
        color: Theme.mauve
        Layout.preferredWidth: Theme.px(24)
        horizontalAlignment: Text.AlignHCenter
    }

    Item {
        id: track
        Layout.fillWidth: true
        implicitHeight: Theme.px(24)

        Rectangle {
            anchors.verticalCenter: parent.verticalCenter
            width: parent.width
            height: Theme.px(6)
            radius: Theme.px(3)
            color: Theme.surface1

            Rectangle {
                width: parent.width * row.value
                height: parent.height
                radius: Theme.px(3)
                color: Theme.mauve
            }
        }

        Rectangle {
            x: (track.width - width) * row.value
            anchors.verticalCenter: parent.verticalCenter
            width: Theme.px(16)
            height: Theme.px(16)
            radius: Theme.px(8)
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
        font.pixelSize: Theme.px(12)
        color: Theme.subtext0
        Layout.preferredWidth: Theme.px(28)
        horizontalAlignment: Text.AlignRight
    }
}
