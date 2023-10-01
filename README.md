# node-mac-detect-browsers

> Detect web browsers on macOS from Node.js or Electron via a native module

## Installing

    npm install node-mac-detect-browsers

## API

**detect([callback])** (macOS only)

- `callback` Receives an `error`, if any, and an array of `results` sorted by the `name` property.

Each `result` is an object with the following properties:

- `name` string
- `path` string – absolute path to executable
- `default` bool (optional) – indicates the default application

Note: an error occurs if no browsers were found.

## Usage

In main process:

    const { detect } = require("node-mac-detect-browsers");
    detect((err, results) => {
    	if (err) {
    		console.error(err);
    	}
    	console.log(results);
    });

or async:

    (async () => {
    	try {
    		const browsers = await detect();
    		console.log(browsers);
    	} catch (err) {
    		console.error(err);
    	}
    })();

Example output:

    [
    	{
    		"name": "Arc",
    		"path": "/Applications/Arc.app"
    	},
    	{
    		"name": "Brave Browser",
    		"path": "/Applications/Brave Browser.app"
    	},
    	{
    		"name": "Chromium",
    		"path": "/Applications/Chromium.app"
    	},
    	{
    		"name": "Firefox",
    		"path": "/Applications/Firefox.app"
    	},
    	{
    		"name": "Google Chrome",
    		"path": "/Applications/Google Chrome.app"
    	},
    	{
    		"default": true,
    		"name": "Safari",
    		"path": "/System/Volumes/Preboot/Cryptexes/App/System/Applications/Safari.app"
    	},
    	{
    		"name": "Tor Browser",
    		"path": "/Applications/Tor Browser.app"
    	}
    ]

## License

MIT License

## Acknowledgements

- [RSWeb](https://github.com/Ranchero-Software/RSWeb), part of NetNewsWire
