#
# Be sure to run `pod lib lint RSUIControls.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'RSUIControls'
  s.version          = '0.0.1'
  s.summary          = 'Collection of ready-to-use iOS controls'
  s.description      = "Fully customized collection of iOS controls"

  s.homepage         = 'https://github.com/vojerr/RSUIControls'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Ruslan Samsonov' => 'ruslan.samsonov91@gmail.com' }
  s.source           = { :git => 'https://github.com/vojerr/RSUIControls.git', :tag => s.version.to_s }

  s.ios.deployment_target = '11.0'
  s.swift_versions = ['5.0']
  s.source_files = 'RSUIControls/Classes/**/*'
end
