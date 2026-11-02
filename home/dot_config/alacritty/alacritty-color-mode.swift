// Keeps Alacritty's colors in step with the macOS light/dark appearance.
//
// alacritty.toml imports colors.toml, a symlink this points at
// nixpulvis-dark.toml or nixpulvis-light.toml; Alacritty reloads its config
// when the link changes.
//
//   alacritty-color-mode          follow the system appearance (runs forever)
//   alacritty-color-mode dark     switch to dark once and exit
//   alacritty-color-mode light    switch to light once and exit
//
// chezmoi builds it into ~/.bin and starts it at login through
// ~/Library/LaunchAgents/com.nixpulvis.alacritty-color-mode.plist (see
// run_onchange_after_20-alacritty-color-mode.sh.tmpl). By hand:
//   swiftc -O ~/.config/alacritty/alacritty-color-mode.swift -o ~/.bin/alacritty-color-mode

import AppKit

let directory = FileManager.default.homeDirectoryForCurrentUser
    .appendingPathComponent(".config/alacritty")
let link = directory.appendingPathComponent("colors.toml").path

func use(_ mode: String) {
    let target = "nixpulvis-\(mode).toml"
    if (try? FileManager.default.destinationOfSymbolicLink(atPath: link)) == target {
        return
    }
    // Make the new link beside the old one and rename it into place, so
    // Alacritty never finds colors.toml missing mid-swap.
    let temporary = directory.appendingPathComponent(".colors.toml.\(getpid())").path
    unlink(temporary)
    guard symlink(target, temporary) == 0, rename(temporary, link) == 0 else {
        let reason = String(cString: strerror(errno))
        FileHandle.standardError.write(Data("alacritty-color-mode: \(link): \(reason)\n".utf8))
        return
    }
    print("alacritty-color-mode: \(mode)")
}

let arguments = CommandLine.arguments.dropFirst()
if let mode = arguments.first {
    guard arguments.count == 1, mode == "dark" || mode == "light" else {
        FileHandle.standardError.write(Data("usage: alacritty-color-mode [dark|light]\n".utf8))
        exit(2)
    }
    use(mode)
    exit(0)
}

// stdout is a log file under launchd; flush each line as it's written.
setlinebuf(stdout)

let app = NSApplication.shared
app.setActivationPolicy(.prohibited)

func follow() {
    let dark = app.effectiveAppearance.bestMatch(from: [.darkAqua, .aqua]) == .darkAqua
    use(dark ? "dark" : "light")
}

follow()
let observation = app.observe(\.effectiveAppearance) { _, _ in follow() }
app.run()
