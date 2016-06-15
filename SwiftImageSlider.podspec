Pod::Spec.new do |s|
  s.name             = 'SwiftImageSlider'
  s.version          = '0.1.5'
  s.summary          = 'A simple image slide show library by Swift.'
  s.homepage         = 'https://github.com/nanjingboy/SwiftImageSlider'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Tom.Huang' => 'hzlhu.dargon@gmail.com' }
  s.source           = { :git => 'https://github.com/nanjingboy/SwiftImageSlider.git', :tag => s.version.to_s }
  s.ios.deployment_target = '8.0'
  s.source_files = "Source/*.swift"
  s.resources    = 'SwiftImageSlider.bundle'
  s.dependency "Kingfisher", "~> 2.4"
  s.dependency "Toast-Swift", "~> 1.3.0"
end
