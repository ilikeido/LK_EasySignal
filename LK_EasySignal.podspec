Pod::Spec.new do |s|
  s.name          = "LK_EasySignal"
  s.version       = "0.0.1"
  s.summary       = "LK_EasySignal is a util Libary for UIComponents,that you can abandon delegate."
  s.homepage      = "https://github.com/ilikeido/LK_EasySignal"
  s.license       = { :type => "MIT", :file => 'LICENSE' }
  s.author        = { "ilikeido" => "ilikeido@163.com" }
  s.source        = { :git => "https://github.com/ilikeido/LK_EasySignal.git", :tag => "0.0.1" }
  s.platform      = :ios, '5.0'
  s.source_files  = 'LK_EasySignal', 'LK_EasySignal/*.{h,m}'
  s.framework     = 'Foundation'
  s.requires_arc  = true
  s.dependency 'BlockInjection', '~> 0.6.4'
end
