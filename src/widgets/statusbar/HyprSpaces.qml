pragma ComponentBehavior: Bound
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts

Item {
    id: root
    required property color textColor

    implicitHeight: parent.implicitHeight

    Layout.fillWidth: false
    Layout.alignment: Qt.AlignLeft

    Item {
        id: layout
        implicitWidth: parent.implicitWidth
        implicitHeight: parent.implicitHeight
        Repeater {
            model: Hyprland.workspaces
            Text {
                id: workspaceText
                visible: false
                x: index * width
                Behavior on x {
                    SmoothedAnimation {
                        velocity: 400
                    }
                }

                // wait a little bit to avoid visual glitch when workspace before it is being removed
                Timer {
                    interval: 1
                    running: true
                    onTriggered: workspaceText.visible = true
                }

                function getWorkspace(workspace) {
                    if (workspace == null) {
                        return "";
                    }

                    if (workspace.focused === true) {
                        swipeDown.running = true;
                        swipeUp.running = true;
                        return `[${workspace.id}]`;
                    } else {
                        return ` ${workspace.id} `;
                    }
                }

                property list<HyprlandWorkspace> ws_list: Hyprland.workspaces.values
                required property int index
                text: getWorkspace(ws_list[index])

                leftPadding: 10
                rightPadding: 10
                color: root.textColor

                NumberAnimation {
                    id: swipeUp
                    target: workspaceText
                    from: 2
                    to: 0
                    properties: "y"
                    duration: 200
                    easing.type: Easing.InQuad
                    running: true
                }

                NumberAnimation {
                    id: swipeDown
                    target: workspaceText
                    from: 0
                    to: 2
                    properties: "y"
                    duration: 200
                    easing.type: Easing.InQuad
                    running: true
                }
            }
        }
    }
}
