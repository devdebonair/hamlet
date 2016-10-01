platform :ios, '10.0'
use_frameworks!

target 'Hamlet' do
	pod 'Alamofire', '~> 4.0.1'
	pod 'ModelMapper', :git => 'https://github.com/lyft/mapper', :branch => 'swift-3.0'
	pod 'SnapKit', '~> 3.0.0'
    pod 'Kingfisher', '~> 3.1.1'
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '3.0'
        end
    end
end
