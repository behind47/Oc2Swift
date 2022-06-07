workspace 'learnios'

flutter_application_path = '../../learnflutter'
load File.join(flutter_application_path, '.ios', 'Flutter', 'podhelper.rb')

target :Oc2Swift do
  install_all_flutter_pods(flutter_application_path)
end

post_install do |installer|
  flutter_post_install(installer) if defined?(flutter_post_install)
end



