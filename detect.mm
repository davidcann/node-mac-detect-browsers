#import <AppKit/AppKit.h>

#include "detect.h"

void detect(const Napi::CallbackInfo &info) {
	Napi::Env env = info.Env();

	NSMutableArray *urls = [[NSMutableArray alloc] init];
	NSArray *urlHandlers = (__bridge NSArray *)LSCopyAllHandlersForURLScheme((CFStringRef) @"https");
	NSArray *roleHandlers = (__bridge NSArray *)LSCopyAllRoleHandlersForContentType(kUTTypeHTML, kLSRolesViewer);
	for (id handler in roleHandlers) {
		if ([urlHandlers containsObject:handler]) {
			NSURL *url = [[NSWorkspace sharedWorkspace] URLForApplicationWithBundleIdentifier:handler];
			if (url) {
				[urls addObject:url];
			}
		}
	}

	NSURL *defaultAppUrl =
	    [[NSWorkspace sharedWorkspace] URLForApplicationToOpenURL:[NSURL URLWithString:@"https:///"]];
	NSMutableArray *browsers = [[NSMutableArray alloc] init];

	for (id url in urls) {
		NSMutableDictionary *browser = [[NSMutableDictionary alloc] init];
		NSString *name = [[url lastPathComponent] substringToIndex:[[url lastPathComponent] length] - 4];
		NSString *path = [[url absoluteString] substringFromIndex:7];
		path = [[path substringToIndex:[path length] - 1] stringByRemovingPercentEncoding];
		[browser setObject:name forKey:@"name"];
		[browser setObject:path forKey:@"path"];
		if (url == defaultAppUrl) {
			[browser setObject:@YES forKey:@"default"];
		}
		[browsers addObject:browser];
	}

	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
	[browsers sortUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];

	Napi::Array arr = Napi::Array::New(env);
	uint32_t index = 0;

	for (id browser in browsers) {
		Napi::Object obj = Napi::Object::New(env);
		obj.Set(Napi::String::New(env, "name"),
			Napi::String::New(env, [[browser objectForKey:@"name"] UTF8String]));
		obj.Set(Napi::String::New(env, "path"),
			Napi::String::New(env, [[browser objectForKey:@"path"] UTF8String]));
		if ([[browser objectForKey:@"default"] boolValue]) {
			obj.Set(Napi::String::New(env, "default"), Napi::Boolean::New(env, true));
		}
		arr.Set(index, obj);
		index++;
	}

	// TODO: New code for macOS 12.0+
	// NSArray *urls =
	//     [[NSWorkspace sharedWorkspace] URLsForApplicationsToOpenURL:[NSURL
	//     URLWithString:@"https://example.com"]];
	// for (id url in urls) {
	// 	Napi::Object obj = Napi::Object::New(env);
	// 	NSString *name = [[url lastPathComponent] substringToIndex:[[url lastPathComponent] length] - 4];
	// 	NSString *path = [[url absoluteString] substringFromIndex:7];
	// 	NSLog(@"%@", name);
	// 	NSLog(@"%@", url);
	// 	obj.Set(Napi::String::New(env, "name"), Napi::String::New(env, [name UTF8String]));
	// 	obj.Set(Napi::String::New(env, "path"), Napi::String::New(env, [path UTF8String]));
	// 	arr.Set(index, obj);
	// 	index++;
	// }

	Napi::Function cb = info[0].As<Napi::Function>();

	if ([browsers count] == 0) {
		Napi::Error error = Napi::Error::New(env, "Failed to find any browsers");
		cb.Call(env.Global(), {error.Value(), arr});
		return;
	}

	cb.Call(env.Global(), {Napi::Boolean::New(env, false), arr});
}
