platform :ios, '10.0'
use_frameworks!

target 'Hamlet' do
	pod 'Alamofire', '~> 4.0.1'
	pod 'ModelMapper', '~> 5.0.0'
    pod 'AsyncDisplayKit', :git => 'https://github.com/facebook/AsyncDisplayKit', :branch => 'master'
    pod 'NVActivityIndicatorView', '~> 3.0'
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '3.0'
        end
    end
end
