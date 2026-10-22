import type { ExtensionAPI } from "@oh-my-pi/pi-coding-agent";
import type { ComposerStyle } from "@oh-my-pi/pi-tui";

// Prompt between two full-width rules, status bar directly below:
//
//   ---------------
//   <input>
//   ---------------
//   <status>
//
// No prompt gutter, no side padding, no background fill, no gap row.
const composerRules: ComposerStyle = {
	id: "nate.rules",
	filledSurface: false,
	sideBorders: false,
	verticalChrome: 2,
	statusAttachment: "none",
	bottomBar: "full",
	bottomBarGap: false,
	defaultPromptGutter: undefined,
	defaultPaddingX: () => 0,
	sideChromeWidth: () => 0,
	renderTop: ({ box, width, borderColor }) => borderColor(box.horizontal.repeat(width)),
	renderRow: ({ gutter, text, pad }) => [gutter + text + pad],
	renderBottom: ({ box, width, borderColor }) => borderColor(box.horizontal.repeat(width)),
};

export default function (pi: ExtensionAPI) {
	pi.registerComposerShape({
		label: "Rules",
		description: "Prompt between two rules, status bar directly below",
		style: composerRules,
	});
}
