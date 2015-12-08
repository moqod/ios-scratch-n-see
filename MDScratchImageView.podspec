Pod::Spec.new do |s|
  s.name         = "MDScratchImageView"
  s.version      = "0.0.1"
  s.summary      = "This is an Objective-C class that helps create a masking effect similar to a scratch card"
  s.homepage     = "https://github.com/moqod/ios-scratch-n-see"
  s.license      = { :type => 'MIT' }
  s.author       = { "Matthew Styles" => "info@moqod.com" }
  s.platform     = :ios, '7.0'
  s.source = {
    :git => 'https://github.com/timominous/ios-scratch-n-see.git'
  }
  s.source_files  = 'Scratch & See/Classes/MDScratchImageView/*.{h,m,mm}'
  s.framework = 'UIKit'
  s.requires_arc = true
end
