import QtQuick
import QtQuick.Layouts
import ".."

// Notification centre: lists every notification tracked by the server.
Rectangle {
    id: centre
    property var model        // ObjectModel of Notification
    property bool muted: false

    radius: Theme.innerRadius
    color: Theme.mantle

    ColumnLayout {
        anchors { fill: parent; margins: Theme.px(14) }
        spacing: Theme.px(10)

        RowLayout {
            Layout.fillWidth: true
            Text {
                text: "Notifications"
                color: Theme.text
                font.family: Theme.font
                font.pixelSize: Theme.px(15)
                font.weight: Font.Medium
            }
            Item { Layout.fillWidth: true }
            Text {
                text: "Clear all"
                visible: list.count > 0
                color: clearArea.containsMouse ? Theme.text : Theme.mauve
                font.family: Theme.font
                font.pixelSize: Theme.px(12)
                MouseArea {
                    id: clearArea
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        const all = centre.model.values.slice();
                        all.forEach(n => n.dismiss());
                    }
                }
            }
        }

        ListView {
            id: list
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true
            spacing: Theme.px(8)
            model: centre.model
            boundsBehavior: Flickable.StopAtBounds
            visible: !centre.muted

            delegate: Rectangle {
                id: item
                required property var modelData
                width: ListView.view.width
                implicitHeight: col.implicitHeight + Theme.px(24)
                height: implicitHeight
                radius: Theme.px(12)
                color: Theme.surface0
                border.width: modelData.urgency === NotificationUrgency.Critical ? 1 : 0
                border.color: Theme.red

                ColumnLayout {
                    id: col
                    anchors { fill: parent; margins: Theme.px(12) }
                    spacing: Theme.px(4)

                    RowLayout {
                        Layout.fillWidth: true
                        Text {
                            Layout.fillWidth: true
                            text: item.modelData.appName
                            elide: Text.ElideRight
                            color: Theme.mauve
                            font.family: Theme.font
                            font.pixelSize: Theme.px(11)
                            font.capitalization: Font.AllUppercase
                        }
                        Text {
                            text: "󰅖"
                            font.pixelSize: Theme.px(14)
                            color: closeArea.containsMouse ? Theme.red : Theme.overlay0
                            MouseArea {
                                id: closeArea
                                anchors { fill: parent; margins: -6 }
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onClicked: item.modelData.dismiss()
                            }
                        }
                    }
                    Text {
                        Layout.fillWidth: true
                        text: item.modelData.summary
                        wrapMode: Text.Wrap
                        color: Theme.text
                        font.family: Theme.font
                        font.pixelSize: Theme.px(14)
                        font.weight: Font.Medium
                    }
                    Text {
                        Layout.fillWidth: true
                        visible: text.length > 0
                        text: item.modelData.body
                        textFormat: Text.StyledText
                        wrapMode: Text.Wrap
                        maximumLineCount: 4
                        elide: Text.ElideRight
                        color: Theme.subtext0
                        font.family: Theme.font
                        font.pixelSize: Theme.px(12)
                    }
                    RowLayout {
                        Layout.fillWidth: true
                        visible: item.modelData.actions.length > 0
                        spacing: Theme.px(6)
                        Repeater {
                            model: item.modelData.actions
                            delegate: Rectangle {
                                required property var modelData
                                implicitWidth: label.implicitWidth + Theme.px(20)
                                implicitHeight: Theme.px(26)
                                radius: Theme.px(8)
                                color: actArea.containsMouse ? Theme.mauve : Theme.surface1
                                Text {
                                    id: label
                                    anchors.centerIn: parent
                                    text: parent.modelData.text
                                    color: actArea.containsMouse ? Theme.crust : Theme.text
                                    font.family: Theme.font
                                    font.pixelSize: Theme.px(12)
                                }
                                MouseArea {
                                    id: actArea
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: parent.modelData.invoke()
                                }
                            }
                        }
                    }
                }
            }
        }

        Text {
            Layout.alignment: Qt.AlignHCenter
            Layout.fillHeight: !list.visible || list.count === 0
            visible: centre.muted || list.count === 0
            verticalAlignment: Text.AlignVCenter
            text: centre.muted ? "Do not disturb is on" : "No new notifications"
            font.family: Theme.font
            font.pixelSize: Theme.px(14)
            color: Theme.overlay0
        }
    }
}
