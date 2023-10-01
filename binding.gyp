{
	"targets": [{
		"target_name": "NativeExtension",
		"sources": ["NativeExtension.cc"],
			"conditions": [[
				'OS=="mac"', {
					"sources": [
						"detect.mm"
					],
				}],
			],
		"include_dirs": [
			"<!@(node -p \"require('node-addon-api').include\")"
		],
		"libraries": [],
		"dependencies": [
			"<!(node -p \"require('node-addon-api').gyp\")"
		],
		"defines": [
			"NAPI_DISABLE_CPP_EXCEPTIONS"
		],
		"xcode_settings": {
			"MACOSX_DEPLOYMENT_TARGET": "10.15",
			"OTHER_CPLUSPLUSFLAGS": [
				"-std=c++14",
				"-stdlib=libc++",
				"-fobjc-arc"
			],
			"OTHER_LDFLAGS": [
				"-framework CoreFoundation -framework AppKit"
			]
		}
	}],
}