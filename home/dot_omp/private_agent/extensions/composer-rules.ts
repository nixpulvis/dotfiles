import type { ComposerShape, ExtensionAPI } from "@oh-my-pi/pi-coding-agent";
import { lookup } from "@oh-my-pi/pi-coding-agent/config/registry";

// Prompt between two full-width rules, status bar directly below:
//
//   ---------------
//   <input>
//   ---------------
//   <status>
//
// No prompt gutter, no side padding, no background fill, no gap row.
const composerRules: ComposerShape & { label: string } = {
	id: "nate.rules",
	label: "Rules",
	description: "Prompt between two rules, status bar directly below",
	filled: false,
	sideBorders: false,
	bottomBar: "full",
	bottomBarGap: false,
	paddingX: 0,
	sideWidth: () => 0,
	top: cx => cx.border(cx.box.horizontal.repeat(cx.width)),
	row: cx => [cx.gutter + cx.text + cx.pad],
	bottom: cx => cx.border(cx.box.horizontal.repeat(cx.width)),
};

export default function (pi: ExtensionAPI) {
	pi.registerComposerShape(composerRules);

	// omp paints the composer before extensions load, so this shape starts as
	// `box`, and the status bar keeps `box`'s placement (none) until the shape
	// setting changes. Bounce the setting through `box` (runtime only, never
	// saved) to re-place it. A change made during session_start, or in the same
	// tick as its undo, is never seen, so each step waits a tick.
	const shape = lookup("composer.shape");
	pi.on("session_start", () => {
		if (shape?.get(pi.pi.settings) !== composerRules.id) return;
		setTimeout(() => {
			shape.override(pi.pi.settings, "box");
			setTimeout(() => shape.clearOverride(pi.pi.settings), 0);
		}, 0);
	});
}
