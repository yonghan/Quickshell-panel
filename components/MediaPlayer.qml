import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.Mpris
import ".."

// MPRIS now-playing card with transport controls and an equalizer.
Rectangle {
    id: card

    readonly property var player: {
        const list = Mpris.players.values;
        return list.find(p => p.isPlaying) ?? list[0] ?? null;
    }
    readonly property bool playing: player !== null && player.isPlaying

    visible: player !== null
    Layout.fillWidth: true
    implicitHeight: content.implicitHeight + 28
    radius: Theme.innerRadius
    color: Theme.mantle

    // MPRIS does not push position updates, so poll while playing.
    Timer {
        interval: 1000
        repeat: true
        running: card.playing
        onTriggered: card.player.positionChanged()
    }

    ColumnLayout {
        id: content
        anchors { fill: parent; margins: 14 }
        spacing: 10

        RowLayout {
            Layout.fillWidth: true
            spacing: 12

            Rectangle {
                Layout.preferredWidth: 56
                Layout.preferredHeight: 56
                radius: 12
                color: Theme.surface0
                clip: true

                Image {
                    anchors.fill: parent
                    source: card.player?.trackArtUrl ?? ""
                    fillMode: Image.PreserveAspectCrop
                    visible: status === Image.Ready
                }
                Text {
                    anchors.centerIn: parent
                    text: "󰎆"
                    font.pixelSize: 24
                    color: Theme.mauve
                    visible: !(card.player?.trackArtUrl)
                }
            }

            ColumnLayout {
                Layout.fillWidth: true
                spacing: 2
                Text {
                    Layout.fillWidth: true
                    text: card.player?.trackTitle || "Unknown title"
                    elide: Text.ElideRight
                    color: Theme.text
                    font.family: Theme.font
                    font.pixelSize: 15
                    font.weight: Font.Medium
                }
                Text {
                    Layout.fillWidth: true
                    text: card.player?.trackArtist || card.player?.identity || ""
                    elide: Text.ElideRight
                    color: Theme.subtext0
                    font.family: Theme.font
                    font.pixelSize: 12
                }
            }
        }

        Equalizer {
            Layout.fillWidth: true
            active: card.playing
        }

        // Progress / seek bar
        Rectangle {
            Layout.fillWidth: true
            implicitHeight: 4
            radius: 2
            color: Theme.surface1
            visible: card.player?.lengthSupported ?? false

            Rectangle {
                width: parent.width * Math.min(1, card.player.length > 0 ? card.player.position / card.player.length : 0)
                height: parent.height
                radius: 2
                color: Theme.mauve
            }
            MouseArea {
                anchors { fill: parent; topMargin: -8; bottomMargin: -8 }
                enabled: card.player?.canSeek ?? false
                onClicked: mouse => card.player.position = card.player.length * mouse.x / width
            }
        }

        RowLayout {
            Layout.alignment: Qt.AlignHCenter
            spacing: 18

            Repeater {
                model: [
                    { icon: "󰒮", act: "prev" },
                    { icon: "play", act: "toggle" },
                    { icon: "󰒭", act: "next" }
                ]
                delegate: Rectangle {
                    id: btn
                    required property var modelData
                    readonly property bool main: modelData.act === "toggle"
                    implicitWidth: main ? 44 : 36
                    implicitHeight: implicitWidth
                    radius: width / 2
                    color: main ? Theme.mauve : (ma.containsMouse ? Theme.surface1 : "transparent")

                    Text {
                        anchors.centerIn: parent
                        text: btn.main ? (card.playing ? "󰏤" : "󰐊") : btn.modelData.icon
                        font.pixelSize: btn.main ? 22 : 18
                        color: btn.main ? Theme.crust : Theme.text
                    }
                    MouseArea {
                        id: ma
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            if (!card.player) return;
                            if (btn.modelData.act === "prev") card.player.previous();
                            else if (btn.modelData.act === "next") card.player.next();
                            else card.player.togglePlaying();
                        }
                    }
                }
            }
        }
    }
}
