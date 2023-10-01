declare module "node-mac-detect-browsers" {
	export type DetectedBrowser = {
		name: string;
		path: string;
		default?: boolean;
	};
	export function detect(
		callback?: (err: Error | null, results: DetectedBrowser[]) => void,
	): void | AsyncFunction<DetectedBrowser[]>;
}
