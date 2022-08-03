workspace 'learnios'

flutter_application_path = '../learnflutter'
load File.join(flutter_application_path, '.ios', 'Flutter', 'podhelper.rb')

target :Oc2Swift do
  install_all_flutter_pods(flutter_application_path)
  
  pod 'SnapKit', '5.6.0'
  pod 'AFNetworking', '4.0'
  pod 'MGJRouter', :git => 'https://github.com/lyujunwei/MGJRouter.git' #蘑菇街的组件化路由方案
  pod 'SDWebImage', :path => '~/SDWebImage', :branch => 'learn'
#  pod 'SDWebImage', :git => 'https://github.com/behind47/SDWebImage.git', :branch => 'learn'
end

target :Oc2SwiftTests do
  install_all_flutter_pods(flutter_application_path)
  
  pod 'SnapKit', '5.6.0'
  pod 'AFNetworking', '4.0'
  pod 'MGJRouter', :git => 'https://github.com/lyujunwei/MGJRouter.git' #蘑菇街的组件化路由方案
  pod 'SDWebImage', :path => '~/SDWebImage', :branch => 'learn'
#  pod 'SDWebImage', :git => 'https://github.com/behind47/SDWebImage.git', :branch => 'learn'
end

post_install do |installer|
  flutter_post_install(installer) if defined?(flutter_post_install)
end



