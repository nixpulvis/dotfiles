import type { ExtensionAPI, ExtensionContext } from "@oh-my-pi/pi-coding-agent";

// Publishes the session name as an extension status so the `status` status-line
// segment can show it on the left. The built-in `session_name` segment has no
// length limit, and on overflow the status line drops right-side segments
// (model, context, usage) before it shortens anything on the left.
//
// The cap scales with terminal width: RESERVE columns are kept for every other
// segment, MAX_LEN is the ceiling, and below MIN_LEN the name is hidden.
const MAX_LEN = 40;
const MIN_LEN = 10;
const RESERVE = 100;
const STATUS_KEY = "session-title";

function fit(name: string, columns: number): string | undefined {
	const clean = name.replace(/\s+/g, " ").trim();
	if (!clean) return undefined;
	const cap = Math.min(MAX_LEN, columns - RESERVE);
	if (cap < MIN_LEN) return undefined;
	return clean.length > cap ? `${clean.slice(0, cap - 1).trimEnd()}\u2026` : clean;
}

export default function (pi: ExtensionAPI) {
	let current: ExtensionContext | undefined;
	const sync = () => {
		current?.ui.setStatus(STATUS_KEY, fit(pi.getSessionName() ?? "", process.stdout.columns ?? 80));
	};
	pi.on("session_start", async (_event, ctx) => {
		const first = current === undefined;
		current = ctx;
		sync();
		// No rename/resize event exists; setStatus is a no-op when the text is unchanged.
		if (first) ctx.setInterval(sync, 1000);
	});
	// Managed timers are cleared on shutdown; let the next session_start re-arm.
	pi.on("session_shutdown", () => {
		current = undefined;
	});
}
