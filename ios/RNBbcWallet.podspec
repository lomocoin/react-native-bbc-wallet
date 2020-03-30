
Pod::Spec.new do |s|
  s.name         = "RNBbcWallet"
  s.version      = "1.0.0"
  s.summary      = "RNBbcWallet"
  s.description  = <<-DESC
                  RNBbcWallet
                   DESC
  s.homepage     = "https://gitlab.dabank.io/pockmine/react-native-bbc-wallet"
  s.license      = "MIT"
  # s.license      = { :type => "MIT", :file => "FILE_LICENSE" }
  s.author             = { "author" => "author@domain.cn" }
  s.platform     = :ios, "7.0"
  s.source       = { :git => "https://github.com/author/RNBbcWallet.git", :tag => "master" }
  s.source_files  = "RNBbcWallet/**/*.{h,m}"
  s.requires_arc = true


  s.dependency "React"
  #s.dependency "others"

end

  