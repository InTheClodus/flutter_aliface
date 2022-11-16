#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint flutter_aliface.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'flutter_aliface'
  s.version          = '0.0.1'
  s.summary          = 'A new Flutter project.'
  s.description      = <<-DESC
A new Flutter project.
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.platform = :ios, '9.0'

  s.vendored_frameworks = 'frameworks/AliyunIdentityManager.framework','frameworks/AliyunOSSiOS.framework','frameworks/APBToygerFacade.framework','frameworks/APPSecuritySDK.framework','frameworks/BioAuthAPI.framework','frameworks/BioAuthEngine.framework','frameworks/deviceiOS.framework','frameworks/MPRemoteLogging.framework','frameworks/OCRDetectSDKForTech.framework','frameworks/ToygerNative.framework','frameworks/ToygerService.framework','frameworks/ZolozIdentityManager.framework','frameworks/ZolozMobileRPC.framework','frameworks/ZolozOpenPlatformBuild.framework','frameworks/ZolozSensorServices.framework','frameworks/ZolozUtility.framework'

  s.frameworks = 'CoreGraphics','Accelerate','SystemConfiguration','AssetsLibrary','CoreTelephony','QuartzCore','CoreFoundation','CoreLocation','ImageIO','CoreMedia','CoreMotion','AVFoundation','WebKit','AudioToolbox','CFNetwork','MobileCoreServices','AdSupport'

  s.libraries = 'resolv','z','c++.1','c++abi','z.1.2.8'

  s.resource_bundles = { 'Resources' => 'frameworks/*.framework/*.bundle' }


  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.pod_target_xcconfig = {'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64'   }
  s.user_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }
  s.swift_version = '5.0'
end
