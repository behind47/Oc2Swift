workspace 'learnios'

source 'https://mirrors.tuna.tsinghua.edu.cn/git/CocoaPods/Specs.git'

flutter_application_path = '../learnflutter'
load File.join(flutter_application_path, '.ios', 'Flutter', 'podhelper.rb')

def commonPods
  flutter_application_path = '../learnflutter'
  install_all_flutter_pods(flutter_application_path)
  
  pod 'SnapKit', '5.6.0'
  pod 'AFNetworking', '4.0'
  pod 'SDWebImage', :path => '~/SDWebImage', :branch => 'learn'
#  pod 'SDWebImage', :git => 'https://github.com/behind47/SDWebImage.git', :branch => 'learn'
  pod "BeeHive", '1.1.1'
  pod "Masonry"
end

target :Oc2Swift do
  commonPods
end

target :Oc2SwiftTests do
  commonPods
end

post_install do |installer|
  flutter_post_install(installer) if defined?(flutter_post_install)
end



