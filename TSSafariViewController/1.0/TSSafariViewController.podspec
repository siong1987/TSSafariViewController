Pod::Spec.new do |s|
  s.name                  = "TSSafariViewController"
  s.version               = "1.0"
  s.summary               = "SFSafariViewController but with push/pop animation."
  s.description           = "SFSafariViewController but with push/pop animation without the loss of the default bar behavior."
  s.homepage              = "https://github.com/siong1987/TSSafariViewController"
  s.license               = { :type => "MIT", :file => "LICENSE" }
  s.author                = { "Teng Siong Ong" => "siong1987@gmail.com" }
  s.social_media_url      = "http://twitter.com/siong1987"
  s.platform              = :ios, "9.0"
  s.ios.deployment_target = "9.0"
  s.source                = { git: "https://github.com/siong1987/TSSafariViewController.git", :tag => s.version }
  s.requires_arc          = true
  s.source_files          = "TSSafariViewController/**/*{.swift}"
end
