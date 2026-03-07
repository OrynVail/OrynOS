import QtQuick
import Quickshell
import Quickshell.Io
import qs.Commons
import qs.Services.UI
import qs.Services.Noctalia
import qs.Services.Compositor

Item {
    IpcHandler {
        target: "plugin:screenshot"

        function takeScreenshot(mode: string): bool {
            if (CompositorService.isHyprland) {
                Quickshell.execDetached([
                    "hyprshot",
                    "--freeze",
                    "--clipboard-only",
                    "--mode", mode,
                    "--silent"
                ])
            } else if (CompositorService.isNiri) {
                Quickshell.execDetached([
                    "niri", "msg", "action", "screenshot"
                ])
            } else if (CompositorService.isSway) {
                var args = ["grimshot"]

                if (mode === "screen") {
                    args.push("copy", "output")
                } else if (mode === "region") {
                    args.push("copy", "area")
                } else {
                    args.push("copy", "area")
                }

                var started = Quickshell.execDetached(args)
                if (!started) {
                    UIService.showNotification({
                        title: "Screenshot Error",
                        message: "Failed to run grimshot. Please ensure grimshot is installed and in PATH.",
                        icon: "alert",
                        timeout: 3000
                    })
                }
            } else {
                // Fallback: notify user that screenshots are unsupported
                UIService.showNotification({
                    title: "Screenshot Error",
                    message: "Screenshots are not supported in this compositor.",
                    icon: "alert",
                    timeout: 3000
                })
            }

            return true
        }
    }
}
