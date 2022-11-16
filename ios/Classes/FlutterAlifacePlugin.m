#import "FlutterAlifacePlugin.h"
#if __has_include(<flutter_aliface/flutter_aliface-Swift.h>)
#import <flutter_aliface/flutter_aliface-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "flutter_aliface-Swift.h"
#endif

@implementation FlutterAlifacePlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFlutterAlifacePlugin registerWithRegistrar:registrar];
}
@end
