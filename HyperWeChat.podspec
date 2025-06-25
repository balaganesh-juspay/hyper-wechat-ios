Pod::Spec.new do |s|
    s.name         = 'HyperWeChat'
    s.version      = "0.0.1"
    s.summary      = "SDK to handle native functionality for WeChatpay"
    s.description  = 'To use native functions related to WeChatpay that is integrated via HyperSDK'

    s.homepage     = 'https://juspay.in/'
    s.license      = { :type => "LGPL", :file => "LICENSE" }
    s.author       = { "Jusapy Technologies PVT LTD" => "support@juspay.in" }

    s.platform     = :ios, '12.0'
    s.source       = { :git => "https://bitbucket.juspay.net/scm/~selvam.s_juspay.in/hyper-wechat-ios.git"}  
    s.dependency 'WechatOpenSDK' 
    s.dependency 'HyperSDK'
    s.source_files = 'Sources/**/*.{h,m}'
    s.public_header_files = 'Sources/**/*.h'
    s.static_framework = true   
end                                                                                                               