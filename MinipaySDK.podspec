#
# Be sure to run `pod lib lint MinipaySDK.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'MinipaySDK'
  s.version          = '1.0.1'
  s.summary          = 'iOS SDK for Minipay'
  s.description      = 'The MinipaySDK framework is a thin wrapper around the Minipay API. It is fully open source and compatible with apps supporting iOS versions 10 or above.'
  s.homepage         = 'https://github.com/jacksoncheek/minipay-ios-sdk'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'jacksoncheek' => 'jackson.cheek@gmail.com' }
  s.source           = { :git => 'https://github.com/jacksoncheek/minipay-ios-sdk.git', :tag => s.version.to_s }

  s.ios.deployment_target = '10.0'
  s.swift_version    = '4.0'

  s.source_files = 'MinipaySDK/Classes/**/*'
  s.frameworks = 'UIKit'
  s.dependency 'SnapKit', '~> 5.0.0'
end
