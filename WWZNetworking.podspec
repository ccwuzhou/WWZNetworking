#
# Be sure to run `pod lib lint WWZNetworking.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'WWZNetworking'
  s.version          = '1.0.0'
  s.summary          = 'A short description of WWZNetworking.'


  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/ccwuzhou/WWZNetworking'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'ccwuzhou' => 'ccwuzhou@163.com' }
  s.source           = { :git => 'https://github.com/ccwuzhou/WWZNetworking.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'

  s.source_files = 'WWZNetworking/Classes/**/*'
  
  # s.resource_bundles = {
  #   'WWZNetworking' => ['WWZNetworking/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
    s.dependency 'AFNetworking'
end
