Pod::Spec.new do |s|
    s.name         = 'HyperWeChat'
    s.version      = "2.2.3.5"
    s.summary      = "SDK to handle native functionality for WeChatpay"
    s.description  = 'To use native functions related to WeChatpay that is integrated via HyperSDK'

    s.homepage     = 'https://juspay.in/'
    s.license      = { :type => "LGPL", :file => "LICENSE" }
    s.author       = { "Jusapy Technologies PVT LTD" => "support@juspay.in" }

    s.platform     = :ios, '12.0'
    s.source       = { :git => "https://github.com/balaganesh-juspay/hyper-wechat-ios.git", :tag => s.version }  
    s.dependency 'WechatOpenSDK' 
    s.dependency 'HyperSDK'
    s.source_files = 'Sources/**/*.{h,m}'
    s.public_header_files = 'Sources/**/*.h'
    s.static_framework = true   
end                                                                                                               