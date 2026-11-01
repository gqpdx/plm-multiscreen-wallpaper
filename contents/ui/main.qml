import QtQuick
import QtQuick.Window

Item {
    id: root

    property var configuration
    property string pluginName

    readonly property string outputName: Screen.name

    readonly property string wallpaperSource: {
        if (!configuration) {
            return ""
        }

        let mappings = []

        try {
            mappings = JSON.parse(configuration.ScreenMappings || "[]")
        } catch (error) {
            console.warn("PLM Multi-Screen Wallpaper: invalid ScreenMappings JSON:", error)
            mappings = []
        }

        if (Array.isArray(mappings)) {
            for (let i = 0; i < mappings.length; ++i) {
                const mapping = mappings[i]

                if (mapping
                        && mapping.screen === outputName
                        && typeof mapping.image === "string"
                        && mapping.image.length > 0) {
                    return mapping.image
                }
            }
        }

        return configuration.FallbackImage || ""
    }

    Image {
        anchors.fill: parent
        source: root.wallpaperSource
        fillMode: Image.PreserveAspectCrop
        asynchronous: true
        cache: true
        smooth: true

        onStatusChanged: {
            if (status === Image.Error) {
                console.warn(
                    "PLM Multi-Screen Wallpaper: failed to load",
                    source,
                    "on display",
                    root.outputName
                )
            }
        }
    }

    Component.onCompleted: {
        console.log(
            "PLM Multi-Screen Wallpaper initialized on",
            outputName,
            "using",
            wallpaperSource
        )
    }
}
