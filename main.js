const detect = require("bindings")("NativeExtension");

function asyncDetect(callback = null) {
	if (callback) {
		return detect(callback);
	}
	return new Promise((resolve, reject) => {
		detect((err, results) => {
			if (err) {
				reject(err);
			} else {
				resolve(results);
			}
		});
	});
}

module.exports = { detect: asyncDetect };
