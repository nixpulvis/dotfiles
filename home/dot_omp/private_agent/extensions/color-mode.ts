import { type FSWatcher, readlinkSync, watch } from "node:fs";
import { homedir } from "node:os";
import { join } from "node:path";
import type { ExtensionAPI, ExtensionContext } from "@oh-my-pi/pi-coding-agent";
import { lookup } from "@oh-my-pi/pi-coding-agent/config/registry";

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

export default function (pi: ExtensionAPI) {
	if (process.platform !== "darwin") return;

	const themes = { dark: lookup("theme.dark"), light: lookup("theme.light") };
	let current: ExtensionContext | undefined;
	let watcher: FSWatcher | undefined;
	let applied: string | undefined;

	const sync = async () => {
		const mode = currentMode();
		const name = mode && themes[mode]?.get(pi.pi.settings);
		if (!current || typeof name !== "string" || name === applied) return;
		const result = await current.ui.setTheme(name);
		if (result.success) applied = name;
	};

	pi.on("session_start", async (_event, ctx) => {
		current = ctx;
		// The link is swapped by rename, so watch the directory, not the link.
		watcher ??= watch(DIRECTORY, () => void sync());
		await sync();
	});
	pi.on("session_shutdown", () => {
		current = undefined;
		applied = undefined;
		watcher?.close();
		watcher = undefined;
	});
}
