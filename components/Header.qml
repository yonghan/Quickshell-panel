import QtQuick
import QtQuick.Layouts
import Quickshell
import ".."

// Large time with today's date underneath.
ColumnLayout {
    spacing: 2

    SystemClock {
        id: clock
        precision: SystemClock.Seconds
    }

    Text {
        Layout.alignment: Qt.AlignLeft
        text: Qt.formatTime(clock.date, "hh:mm")
        color: Theme.text
        font.family: Theme.font
        font.pixelSize: 64
        font.weight: Font.Light
    }

    Text {
        text: Qt.formatDate(clock.date, "dddd, d MMMM yyyy")
        color: Theme.mauve
        font.family: Theme.font
        font.pixelSize: 15
    }
}
