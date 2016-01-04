Pod::Spec.new do |s|
  s.name         = 'TTTAttributedLabel-WithMore'
  s.version      = '1.13.4'
  s.authors      = { 'Bob Wei' => 'fealonelei@gmail.com' }
  s.homepage     = 'https://github.com/fealonelei/TTTAttributedLabel-WithMore'
  s.platform     = :ios
  s.summary      = 'A drop-in replacement for UILabel that supports attributes, data detectors, links, and social media common detectors.'
  s.source       = { :git => 'https://github.com/fealonelei/TTTAttributedLabel-WithMore.git', :tag => s.version.to_s }
  s.license      = 'MIT'
  s.frameworks   = 'UIKit', 'CoreText', 'CoreGraphics', 'QuartzCore'
  s.source_files = 'TTTAttributedLabel'
  s.requires_arc = true
  s.ios.deployment_target = '4.3'
  s.tvos.deployment_target = '9.0'
  s.social_media_url = 'https://twitter.com/mattt'
end
