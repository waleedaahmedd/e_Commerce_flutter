#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run pod lib lint simple_ocr_plugin.podspec' to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'simple_ocr_plugin'
  s.version          = '0.0.1'
  s.summary          = 'A new flutter plugin project.'
  s.description      = <<-DESC
A new flutter plugin project.
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  # [DOC]
  s.dependency 'GoogleMLKit/TextRecognition', "~> 2.2.0"
  # [DOC] not sure why... but GooglMLKit/TextRecognition requires linking static instead of dynamic libraries... add this line
  s.static_framework = true
  
  # [DOC]
  s.platform = :ios, '10.0'

  # Flutter.framework does not contain a i386 slice. Only x86_64 simulators are supported.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'VALID_ARCHS[sdk=iphonesimulator*]' => 'x86_64' }
  s.swift_version = '5.0'
end
