Pod::Spec.new do |s|
  s.name             = 'LFTimelineControl'
  s.version          = '0.1.0'
  s.summary          = 'Lofionic TimelineControl'
  
  s.description      = 'A control for visualizing and interacting with a timeline.'
  
  s.homepage         = 'https://github.com/Lofionic/LFTimelineControl.git'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Chris' => 'chris@lofionic.co.uk' }
  s.source           = { :git => 'https://github.com/Lofionic/LFTimelineControl.git', :tag => s.version.to_s }
  
  s.ios.deployment_target = '10.0'
  s.swift_version = '4.2'
  
  s.subspec 'Core' do |core|
    core.framework = 'UIKit'
    core.dependency 'pop'
    core.source_files = 'LFTimelineControl/Core/**/*.swift'
  end
end
