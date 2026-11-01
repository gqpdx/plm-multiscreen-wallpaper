import QtQuick
import QtQuick.Controls as QQC2
import QtQuick.Dialogs
import QtQuick.Layouts
import org.kde.kirigami as Kirigami

Kirigami.FormLayout {
    id: root

    property var parentLayout
    property var wallpaper
    property var configDialog

    property string cfg_ScreenMappings: "[]"
    property string cfg_FallbackImage: ""

    twinFormLayouts: parentLayout

    ListModel {
        id: mappingModel
    }

    function loadMappings() {
        mappingModel.clear()

        try {
            const parsed = JSON.parse(cfg_ScreenMappings || "[]")

            if (Array.isArray(parsed)) {
                for (let i = 0; i < parsed.length; ++i) {
                    const entry = parsed[i]

                    if (entry && typeof entry.screen === "string"
                            && typeof entry.image === "string") {
                        mappingModel.append({
                            screen: entry.screen,
                            image: entry.image
                        })
                    }
                }
            }
        } catch (error) {
            console.warn("PLM Multi-Screen Wallpaper: could not parse saved mappings:", error)
        }
    }

    function saveMappings() {
        const mappings = []

        for (let i = 0; i < mappingModel.count; ++i) {
            const entry = mappingModel.get(i)

            mappings.push({
                screen: entry.screen,
                image: entry.image
            })
        }

        cfg_ScreenMappings = JSON.stringify(mappings, null, 2)
    }

    function updateMapping(index, key, value) {
        mappingModel.setProperty(index, key, value)
        saveMappings()
    }

    FileDialog {
        id: mappingImageDialog
        title: "Choose wallpaper image"
        nameFilters: ["Images (*.jpg *.jpeg *.png *.webp *.bmp *.tif *.tiff)"]
        property int targetIndex: -1

        onAccepted: {
            if (targetIndex >= 0 && targetIndex < mappingModel.count) {
                root.updateMapping(targetIndex, "image", selectedFile.toString())
            }
        }
    }

    FileDialog {
        id: fallbackImageDialog
        title: "Choose fallback wallpaper"
        nameFilters: ["Images (*.jpg *.jpeg *.png *.webp *.bmp *.tif *.tiff)"]

        onAccepted: root.cfg_FallbackImage = selectedFile.toString()
    }

    RowLayout {
        Kirigami.FormData.label: "Fallback image:"

        QQC2.TextField {
            Layout.fillWidth: true
            text: root.cfg_FallbackImage
            readOnly: true
            placeholderText: "No fallback image selected"
        }

        QQC2.Button {
            text: "Browse…"
            icon.name: "document-open"
            onClicked: fallbackImageDialog.open()
        }

        QQC2.Button {
            text: "Clear"
            enabled: root.cfg_FallbackImage.length > 0
            onClicked: root.cfg_FallbackImage = ""
        }
    }

    Repeater {
        model: mappingModel

        delegate: RowLayout {
            required property int index
            required property string screen
            required property string image

            Kirigami.FormData.label: index === 0 ? "Display mappings:" : ""

            QQC2.TextField {
                Layout.preferredWidth: 130
                text: screen
                placeholderText: "Display name"
                onTextEdited: root.updateMapping(index, "screen", text)
            }

            QQC2.TextField {
                Layout.fillWidth: true
                text: image
                readOnly: true
                placeholderText: "No image selected"
            }

            QQC2.Button {
                text: "Browse…"
                icon.name: "document-open"
                onClicked: {
                    mappingImageDialog.targetIndex = index
                    mappingImageDialog.open()
                }
            }

            QQC2.Button {
                text: "Remove"
                icon.name: "list-remove"
                onClicked: {
                    mappingModel.remove(index)
                    root.saveMappings()
                }
            }
        }
    }

    RowLayout {
        Kirigami.FormData.label: " "

        QQC2.Button {
            text: "Add display mapping"
            icon.name: "list-add"
            onClicked: {
                mappingModel.append({ screen: "", image: "" })
                root.saveMappings()
            }
        }
    }

    QQC2.Label {
        Kirigami.FormData.label: " "
        Layout.fillWidth: true
        wrapMode: Text.WordWrap
        text: "Use the display name reported to the greeter (for example DP-2). The PLM service account must be able to read each selected image."
        opacity: 0.8
    }

    Component.onCompleted: loadMappings()
}
