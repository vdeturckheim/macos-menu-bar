import Cocoa
import SwiftUI

@main
class AppDelegate: NSObject, NSApplicationDelegate {
    private var statusItem: NSStatusItem!
    private var timer: Timer?
    private var compactMode: Bool {
        get { UserDefaults.standard.bool(forKey: "compactMode") }
        set {
            UserDefaults.standard.set(newValue, forKey: "compactMode")
            updateCountdown()
            buildMenu()
        }
    }

    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApp.setActivationPolicy(.accessory)

        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)

        guard let button = statusItem.button else { return }

        // Draw a monochrome Y template icon programmatically
        let icon = makeMenuBarIcon()
        icon.isTemplate = true
        button.image = icon
        button.imagePosition = .imageLeading

        updateCountdown()
        buildMenu()

        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.updateCountdown()
        }
        RunLoop.current.add(timer!, forMode: .common)
    }

    private func makeMenuBarIcon() -> NSImage {
        let size = NSSize(width: 18, height: 18)
        let image = NSImage(size: size, flipped: false) { rect in
            let path = NSBezierPath()
            // Draw a Y shape
            let midX = rect.midX
            let top: CGFloat = rect.maxY - 2
            let junction: CGFloat = rect.midY - 1
            let bottom: CGFloat = rect.minY + 2
            let spread: CGFloat = 6

            // Left arm of Y
            path.move(to: NSPoint(x: midX - spread, y: top))
            path.line(to: NSPoint(x: midX, y: junction))
            // Right arm of Y
            path.move(to: NSPoint(x: midX + spread, y: top))
            path.line(to: NSPoint(x: midX, y: junction))
            // Stem of Y
            path.move(to: NSPoint(x: midX, y: junction))
            path.line(to: NSPoint(x: midX, y: bottom))

            path.lineWidth = 2.5
            path.lineCapStyle = .round
            path.lineJoinStyle = .round
            NSColor.black.setStroke()
            path.stroke()
            return true
        }
        return image
    }

    private func updateCountdown() {
        guard let button = statusItem.button else { return }
        if compactMode {
            button.title = ""
        } else if let remaining = Countdown.remaining() {
            button.title = " \(remaining.formatted)"
        } else {
            button.title = " It's here!"
        }
    }

    private func buildMenu() {
        let menu = NSMenu()

        // YC Logo header with live countdown
        let logoItem = NSMenuItem()
        let logoView = NSHostingView(rootView: MenuHeaderView())
        logoView.frame = NSRect(x: 0, y: 0, width: 260, height: 100)
        logoItem.view = logoView
        menu.addItem(logoItem)

        menu.addItem(.separator())

        // Event info
        let dateItem = NSMenuItem(
            title: "\(Countdown.eventName) — \(Countdown.eventDateString)",
            action: nil,
            keyEquivalent: ""
        )
        dateItem.isEnabled = false
        menu.addItem(dateItem)

        menu.addItem(.separator())

        // Display mode toggle
        let modeItem = NSMenuItem(
            title: compactMode ? "Show Countdown in Menu Bar" : "Compact Mode (Icon Only)",
            action: #selector(toggleCompactMode),
            keyEquivalent: ""
        )
        modeItem.target = self
        menu.addItem(modeItem)

        menu.addItem(.separator())

        // Quit
        let quitItem = NSMenuItem(
            title: "Quit",
            action: #selector(NSApplication.terminate(_:)),
            keyEquivalent: "q"
        )
        menu.addItem(quitItem)

        statusItem.menu = menu
    }

    @objc private func toggleCompactMode() {
        compactMode.toggle()
    }
}

struct MenuHeaderView: View {
    var body: some View {
        HStack(spacing: 12) {
            YCLogoView(size: 48)
            VStack(alignment: .leading, spacing: 4) {
                Text(Countdown.eventName)
                    .font(.headline)
                    .foregroundColor(.primary)
                if let remaining = Countdown.remaining() {
                    Text(remaining.formatted)
                        .font(.system(.title3, design: .monospaced))
                        .foregroundColor(YCBrand.orange)
                } else {
                    Text("It's here!")
                        .font(.title3)
                        .foregroundColor(YCBrand.orange)
                }
            }
        }
        .padding(12)
    }
}
