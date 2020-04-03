Pod::Spec.new do |s|
  s.name = 'BubbleTransition'
  s.version = '4.1.0'
  s.license = 'MIT'
  s.summary = 'A custom modal transition that presents and dismiss a controller with a bubble effect'
  s.description  = <<-DESC
                    Easy to use custom modal animation that presents the new controller
                    within a bubble, expanding to cover the whole screen.
                   DESC
  s.homepage = 'https://github.com/andreamazz/BubbleTransition'
  s.social_media_url = 'https://twitter.com/theandreamazz'
  s.authors = { 'Andrea Mazzini' => 'andrea.mazzini@gmail.com' }
  s.source = { :git => 'https://github.com/andreamazz/BubbleTransition.git', :tag => s.version }

  s.ios.deployment_target = '8.0'
  s.swift_version = '5.0'

  s.source_files = 'Source/*.swift'

  s.requires_arc = true
end
