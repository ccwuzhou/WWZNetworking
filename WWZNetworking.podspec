Pod::Spec.new do |s|
  s.name         = "WWZNetworking"
  s.version      = "0.0.2"
  s.summary      = "A short description of WWZNetworking."

  s.homepage     = "http://github.com/ccwuzhou/WWZNetworking"

  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "wwz" => "wwz@zgkjd.com" }

  s.ios.deployment_target = "7.0"
  # s.platform     = :ios
  # s.platform     = :ios, "5.0"

  # s.ios.deployment_target = "5.0"
  # s.osx.deployment_target = "10.7"
  # s.watchos.deployment_target = "2.0"
  # s.tvos.deployment_target = "9.0"

  s.source       = { :git => "http://github.com/ccwuzhou/WWZNetworking.git", :tag => "#{s.version}" }

  s.source_files  = "WWZNetworking/*.{h,m}"


  # s.framework  = "SomeFramework"
  # s.frameworks = "SomeFramework", "AnotherFramework"




  s.dependency "AFNetworking"

end
