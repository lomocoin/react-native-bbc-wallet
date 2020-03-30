
require 'json'

package = JSON.parse(File.read(File.join(__dir__, 'package.json')))

Pod::Spec.new do |s|
  s.name         = "RNBbcWallet"
  s.version      = package['version']
  s.summary      = package["description"]
  s.description  = package["description"]
  s.homepage     = package["homepage"]
  s.license      = "MIT"
  s.author       = package["author"]
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/lomocoin/RNBbcWallet.git", :tag => "master" }
  s.source_files  = "ios/*.{h,m}"

  s.dependency "React"
  s.vendored_frameworks = 'ios/bbc.framework'

end

  