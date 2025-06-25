#import "HyperWeChatJSInterface.h"

@implementation HyperWeChatJSInterface {
    NSString *_callback;
}

+ (instancetype)sharedInstance {
    static HyperWeChatJSInterface *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[HyperWeChatJSInterface alloc] init];
    });
    return sharedInstance;
}

- (void)startWeChatPayWalletFlow:(nullable NSString *)deeplink :(nullable NSString *)env :(nullable NSString *)callback {
    _callback = callback;

    if (deeplink == nil) {
        [self sendCallbackWithResult:@{@"is_successful": @"false", @"error": @"Deeplink is missing"}];
        return;
    }

    NSData *jsonData = [deeplink dataUsingEncoding:NSUTF8StringEncoding];
    if (!jsonData) {
        [self sendCallbackWithResult:@{@"is_successful": @"false", @"error": @"Invalid JSON data"}];
        return;
    }

    NSError *error;
    NSDictionary *paymentData = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
    if (error || !paymentData) {
        [self sendCallbackWithResult:@{@"is_successful": @"false", @"error": @"JSON parse error"}];
        return;
    }

    if (![WXApi isWXAppInstalled]) {
        [self sendCallbackWithResult:@{@"is_successful": @"false", @"error": @"WeChat not installed"}];
        return;
    }

    PayReq *req = [[PayReq alloc] init];
    req.openID    = paymentData[@"appid"];
    req.partnerId = paymentData[@"partnerid"];
    req.prepayId  = paymentData[@"prepayid"];
    req.nonceStr  = paymentData[@"noncestr"];
    req.package   = paymentData[@"package"];

    NSString *timestampStr = [paymentData[@"timestamp"] description];
    req.timeStamp = (UInt32)[timestampStr integerValue];
    req.sign = paymentData[@"sign"];

    [WXApi sendReq:req completion:^(BOOL success) {
        if (!success) {
            [self sendCallbackWithResult:@{@"is_successful": @"false", @"error": @"sendReq failed"}];
        }
    }];
}


- (void)onResp:(BaseResp *)resp {
    if (![resp isKindOfClass:[PayResp class]]) return;

    PayResp *payResp = (PayResp *)resp;
    NSString *result = payResp.errCode == 0 ? @"true" : @"false";

    [self sendCallbackWithResult:@{@"is_successful": result}];
}

- (void)sendCallbackWithResult:(NSDictionary *)resultDict {
    if (!_callback || !_bridgeComponent) return;

    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:resultDict options:0 error:&error];
    if (!jsonData) return;

    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    jsonString = [jsonString stringByReplacingOccurrencesOfString:@"'" withString:@"\\'"];

    NSString *js = [NSString stringWithFormat:@"window.callUICallback('%@', '%@')", _callback, jsonString];
    [_bridgeComponent executeOnWebView:js];
}

@end
