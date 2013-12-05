Pod::Spec.new do |s|
  s.name     = 'XSlidableTabViewController'
  s.version  = '1.0'
  s.license  = 'GPL v2'
  s.summary  = 'slidable tab view controller, may use to create news column. '
  s.homepage = 'https://github.com/EuanChan/SlidableTabViewController'
  s.authors  = { 'EuanChan' => 'euan1022@gmail.com' }
  s.source   = { :git => 'https://github.com/EuanChan/SlidableTabViewController.git', :tag => s.version.to_s }
  s.source_files = 'XSlidableTabViewController/classes/*.{h,m}'
  s.requires_arc = true

  s.platform = :ios, '5.0'
end