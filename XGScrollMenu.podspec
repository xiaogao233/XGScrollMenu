
Pod::Spec.new do |s|
  s.name         = "XGScrollMenu"
  s.version      = "1.0.2"
  s.platform     = :ios, "7.0"
  s.ios.deployment_target = '7.0'
  s.summary      = "A simple menu bar component for iOS."
  s.homepage     = "https://github.com/xiaogao233/XGScrollMenu.git"
  s.license      = "MIT"
  s.author             = { "高昇" => "xiaogao233@163.com" }
  s.source       = { :git => "https://github.com/xiaogao233/XGScrollMenu.git", :tag => "#{s.version}" }
  s.public_header_files = 'XGScrollMenu/*.{h}'
  s.source_files  = "XGScrollMenu/*.{h,m}"
end
