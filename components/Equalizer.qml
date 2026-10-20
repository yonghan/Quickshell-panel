import QtQuick
import Quickshell
import Quickshell.Io
import ".."

// Live spectrum bars fed by `cava` (see cava.conf). Falls back to flat bars
// when cava is missing or nothing is playing.
Item {
    id: eq
    property bool active: false
    property var levels: []
    readonly property int barCount: 24

    implicitHeight: Theme.px(40)

    Process {
        command: ["cava", "-p", Quickshell.shellPath("cava.conf")]
        running: eq.active
        stdout: SplitParser {
            onRead: data => {
                const v = data.split(";").filter(s => s.length > 0).map(s => Number(s) / 100);
                if (v.length > 0) eq.levels = v;
            }
        }
        onRunningChanged: if (!running) eq.levels = []
    }

    Row {
        anchors.fill: parent
        spacing: Theme.px(3)

        Repeater {
            model: eq.barCount
            delegate: Rectangle {
                required property int index
                readonly property real level: eq.active ? (eq.levels[index] ?? 0) : 0
                width: (eq.width - (eq.barCount - 1) * Theme.px(3)) / eq.barCount
                height: Math.max(Theme.px(3), level * eq.height)
                anchors.bottom: parent.bottom
                radius: width / 2
                color: Qt.tint(Theme.surface2, Qt.rgba(Theme.mauve.r, Theme.mauve.g, Theme.mauve.b, level))

                Behavior on height { NumberAnimation { duration: 60 } }
            }
        }
    }
}
