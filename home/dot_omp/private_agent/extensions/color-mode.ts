import { type FSWatcher, readlinkSync, watch } from "node:fs";
import { homedir } from "node:os";
import { join } from "node:path";
import { type ExtensionAPI, onTerminalAppearanceChange } from "@oh-my-pi/pi-coding-agent";

// Switches between theme.dark and theme.light when the macOS appearance changes.
//
// omp picks the theme from the terminal background at startup, but only follows
// later changes on terminals that announce them (DEC mode 2031) or on WezTerm.
// Alacritty and Zed's terminal do neither, so a switch otherwise waits for
// Alt+L. alacritty-color-mode (see ~/.config/alacritty) repoints colors.toml at
// nixpulvis-dark.toml or nixpulvis-light.toml on every appearance change, and
// Zed follows the same system setting, so that link is the current mode for
// both terminals. This watches it.
const DIRECTORY = join(homedir(), ".config/alacritty");
const LINK = join(DIRECTORY, "colors.toml");

function currentMode(): "dark" | "light" | undefined {
	try {
		return readlinkSync(LINK).match(/-(dark|light)\.toml$/)?.[1] as "dark" | "light" | undefined;
	} catch {
		return undefined;
	}
}

// Reported as the terminal appearance rather than set with ui.setTheme, which
// would turn off omp's auto theme and leave Alt+L unable to switch back.
export default function (pi: ExtensionAPI) {
	if (process.platform !== "darwin") return;

	let watcher: FSWatcher | undefined;

	const sync = () => {
		const mode = currentMode();
		if (mode) onTerminalAppearanceChange(mode);
	};

	pi.on("session_start", () => {
		// The link is swapped by rename, so watch the directory, not the link.
		watcher ??= watch(DIRECTORY, sync);
		sync();
	});
	pi.on("session_shutdown", () => {
		watcher?.close();
		watcher = undefined;
	});
}
