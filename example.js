const { detect } = require("./");

// Using a callback
detect(function (err, results) {
	if (err) {
		console.error(err);
	}
	console.log(results);
});

// Using async/await
(async () => {
	try {
		const browsers = await detect();
		console.log(browsers);
	} catch (err) {
		console.error(err);
	}
})();
