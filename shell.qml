//@ pragma UseQApplication
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Services.Notifications
import Quickshell.Wayland
import "components"

// Toggle with:  qs ipc call panel toggle
Scope {
    id: root
    property bool shown: true
    property bool dnd: false

    // We are the notification daemon: keep everything until dismissed.
    NotificationServer {
        id: notifServer
        keepOnReload: true
        bodySupported: true
        actionsSupported: true
        onNotification: n => n.tracked = true
    }

    IpcHandler {
        target: "panel"
        function toggle(): void { root.shown = !root.shown; }
        function show(): void { root.shown = true; }
        function hide(): void { root.shown = false; }
    }

    Process { id: runner }
    function run(cmd) {
        runner.command = ["sh", "-c", cmd];
        runner.running = true;
    }

    PanelWindow {
        id: win
        visible: root.shown
        // Docked flush to the right edge like a bar, reserving its width.
        anchors { top: true; right: true; bottom: true }
        implicitWidth: Theme.panelWidth
        exclusiveZone: Theme.panelWidth
        color: "transparent"
        WlrLayershell.namespace: "quickshell-panel"
        WlrLayershell.layer: WlrLayer.Top
        WlrLayershell.keyboardFocus: WlrKeyboardFocus.OnDemand

        // Clip so only the inner (left) corners are rounded; the right
        // corners are pushed off-screen to sit flush with the edge.
        Item {
            anchors.fill: parent
            clip: true

        Rectangle {
            anchors { fill: parent; rightMargin: -Theme.radius }
            radius: Theme.radius
            color: Theme.base
            border.width: 1
            border.color: Theme.surface1

            ColumnLayout {
                anchors { fill: parent; margins: 22; rightMargin: 22 + Theme.radius }
                spacing: 20

                Header {}

                GridLayout {
                    Layout.fillWidth: true
                    columns: 3
                    rowSpacing: Theme.spacing
                    columnSpacing: Theme.spacing

                    QuickTile {
                        icon: "󰖩"; label: "Wi-Fi"; active: true
                        onToggled: a => root.run("nmcli radio wifi " + (a ? "on" : "off"))
                    }
                    QuickTile {
                        icon: "󰂯"; label: "Bluetooth"
                        onToggled: a => root.run("bluetoothctl power " + (a ? "on" : "off"))
                    }
                    QuickTile {
                        icon: "󰂛"; label: "Do not disturb"
                        onToggled: a => root.dnd = a
                    }
                    QuickTile {
                        icon: "󰌾"; label: "Night light"
                        onToggled: a => root.run(a ? "wlsunset -t 4000 -T 4001 &" : "pkill wlsunset")
                    }
                    QuickTile {
                        icon: "󰀝"; label: "Airplane"
                        onToggled: a => root.run("nmcli radio all " + (a ? "off" : "on"))
                    }
                    QuickTile {
                        icon: "󰍃"; label: "Lock"
                        onToggled: root.run("loginctl lock-session")
                    }
                }

                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 6
                    SliderRow {
                        icon: "󰕾"; value: 0.5
                        onMoved: v => root.run("wpctl set-volume @DEFAULT_AUDIO_SINK@ " + v.toFixed(2))
                    }
                    SliderRow {
                        icon: "󰃠"; value: 0.8
                        onMoved: v => root.run("brightnessctl set " + Math.max(1, Math.round(v * 100)) + "%")
                    }
                }

                MediaPlayer {}

                Notifications {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    Layout.minimumHeight: 140
                    model: notifServer.trackedNotifications
                    muted: root.dnd
                }

                // Power row
                RowLayout {
                    Layout.fillWidth: true
                    spacing: Theme.spacing
                    Repeater {
                        model: [
                            { i: "󰐥", c: "systemctl poweroff", col: Theme.red },
                            { i: "󰜉", c: "systemctl reboot", col: Theme.mauve },
                            { i: "󰤄", c: "systemctl suspend", col: Theme.mauve }
                        ]
                        delegate: Rectangle {
                            required property var modelData
                            Layout.fillWidth: true
                            implicitHeight: 44
                            radius: Theme.innerRadius
                            color: pm.containsMouse ? Theme.surface1 : Theme.surface0
                            Text {
                                anchors.centerIn: parent
                                text: parent.modelData.i
                                font.pixelSize: 20
                                color: parent.modelData.col
                            }
                            MouseArea {
                                id: pm
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onClicked: root.run(parent.modelData.c)
                            }
                        }
                    }
                }
            }
        }
        }
    }
}
