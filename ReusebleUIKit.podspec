Pod::Spec.new do |s|
  s.name             = 'ReusebleUIKit'
  s.version          = '0.1.0'
  s.summary          = 'Base implementation UIKit units for UI implementation'
  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/skibinalexander/ReusebleUIKit.git'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Skibin Alexander' => 'skibinalexander@gmail.com' }
  s.source           = { :git => 'https://github.com/skibinalexander/ReusebleUIKit.git', :tag => s.version.to_s }

  s.ios.deployment_target = '11.0'
  s.swift_version = "5.0"
  s.source_files = 'ReusebleUIKit/Classes/**/*'
  s.dependency 'SnapKit'
end
