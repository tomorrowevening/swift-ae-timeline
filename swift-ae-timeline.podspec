Pod::Spec.new do |spec|
  spec.name         							= "swift-ae-timeline"
  spec.version      							= "0.0.1"
  spec.summary      							= "Code to recreate After Effects animation."
  spec.description  							= <<-DESC
  Code to recreate After Effects animation, along with animation handlers.
                   DESC
  spec.homepage     							= "https://github.com/tomorrowevening/swift-ae-timeline"
  spec.license      							= "Apache"
  spec.author             				= { "Colin Duffy" => "colin@tomorrowevening.com" }
  spec.social_media_url   				= "https://twitter.com/tomorrowevening"
  spec.source       							= { :git => "https://github.com/tomorrowevening/swift-ae-timeline.git", :tag => "#{spec.version}" }
  spec.ios.deployment_target      = "12.4"
  spec.source_files  							= "swift-ae-timeline/*.h", "swift-ae-timeline/**/*.{h,m,swift}"
  spec.exclude_files 							= "Classes/Exclude"
  spec.module_name   							= "AETimeline"
  spec.swift_version 							= "5.1"
end
