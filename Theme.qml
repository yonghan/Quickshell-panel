pragma Singleton
import QtQuick

// Catppuccin Mocha, with Mauve as the accent.
QtObject {
    readonly property color base: "#1e1e2e"
    readonly property color mantle: "#181825"
    readonly property color crust: "#11111b"
    readonly property color surface0: "#313244"
    readonly property color surface1: "#45475a"
    readonly property color surface2: "#585b70"
    readonly property color overlay0: "#6c7086"
    readonly property color subtext0: "#a6adc8"
    readonly property color text: "#cdd6f4"
    readonly property color mauve: "#cba6f7"
    readonly property color red: "#f38ba8"

    readonly property int radius: 20
    readonly property int innerRadius: 14
    readonly property int spacing: 10
    readonly property int panelWidth: 380
    readonly property string font: "Inter"
}
