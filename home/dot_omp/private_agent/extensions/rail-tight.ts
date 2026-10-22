import type { ExtensionAPI } from "@oh-my-pi/pi-coding-agent";
import type { ComposerStyle } from "@oh-my-pi/pi-tui";

// Built-in "rail" composer with the 1-cell gap between the rail glyph and the
// prompt text removed. Built-in rail hardcodes defaultPaddingX to 1 and ignores
// tui.tight, so the only way to drop it is a custom shape.
const RAIL = "\u258E";

const railTight: ComposerStyle = {
	id: "nate.rail-tight",
	filledSurface: true,
	sideBorders: true,
	verticalChrome: 0,
	statusAttachment: "none",
	bottomBar: "full",
	bottomBarGap: true,
	defaultPromptGutter: undefined,
	defaultPaddingX: () => 0,
	// Left: rail glyph + padding. Right: padding + 1 cell reserved for the cursor.
	sideChromeWidth: paddingX => paddingX + 1,
	renderTop: () => undefined,
	renderRow: ctx => {
		const rail = ctx.accentColor(RAIL);
		const body = " ".repeat(ctx.paddingX) + ctx.gutter + ctx.text;
		if (ctx.imeSafeCursorTail) return [rail + ctx.surfaceColor(body)];
		const right = Math.max(0, ctx.paddingX + 1 - ctx.cursorOverflow);
		if (ctx.scrollbarThumb && right > 0) {
			return [rail + ctx.surfaceColor(body + ctx.pad + " ".repeat(right - 1)) + ctx.accentColor("\u2588")];
		}
		return [rail + ctx.surfaceColor(body + ctx.pad + " ".repeat(right))];
	},
	renderBottom: () => undefined,
};

export default function (pi: ExtensionAPI) {
	pi.registerComposerShape({
		label: "Rail (tight)",
		description: "Rail composer without the gap between rail and prompt",
		style: railTight,
	});
}
