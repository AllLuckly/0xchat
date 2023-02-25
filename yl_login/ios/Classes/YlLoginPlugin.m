#import "YlLoginPlugin.h"
#if __has_include(<yl_login/yl_login-Swift.h>)
#import <yl_login/yl_login-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "yl_login-Swift.h"
//#import "WalletConnect-Swift.h"
//#import "FCLWalletConnect-Swift.h"

#endif


#import <Foundation/Foundation.h>
#import <YYModel/YYModel.h>

//#import <ReactiveObjC/ReactiveObjC.h>
//#import "YLEThemeManager.h"
//#import <ThemeManager/zhTheme.h>
//#import "UIColor+Extension.h"
//#import "YLECommonHintDialog.h"



#define FlutterMethod(methodName)                         \
+ (void)methodName:(NSDictionary *)__params_name_params    \
           result:(FlutterResult)__params_name_callback   \

#define FlutterParams __params_name_params
#define FlutterCallback __params_name_callback

#define FlutterIsNotEmpty(value) (![value isKindOfClass:NSNull.class] && value != nil)
#define FlutterValue(value, default) (FlutterIsNotEmpty(value) ? value : default)

typedef void *(*fn)(id,SEL,id,FlutterResult);


static FlutterMethodChannel *channel;
static SwiftYlLoginPlugin *swiftInstance;
static NSString *address;

@interface YlLoginPlugin()<
FlutterStreamHandler
>

@property (nonatomic, strong) FlutterEventSink chatSink;

@end


@implementation YlLoginPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    [SwiftYlLoginPlugin registerWithRegistrar:registrar];
    YlLoginPlugin *instance = [[YlLoginPlugin alloc] init];
    
    swiftInstance = [[SwiftYlLoginPlugin alloc] init];
//    swiftInstance.delegate = instance;
    channel = [FlutterMethodChannel
                                     methodChannelWithName:@"yl_login"
                                     binaryMessenger:[registrar messenger]];
    FlutterEventChannel *eventChannel = [FlutterEventChannel eventChannelWithName:@"yl_login_handler" binaryMessenger:[registrar messenger]];
    [eventChannel setStreamHandler:instance];
//    [YlLoginPlugin registerOCWith:registrar channel:channel instance:instance];
    [registrar addMethodCallDelegate:instance channel:channel];
    address = @"";
//    swiftInstance.connectWalletSuccessSelectBlock = ^(NSString * _Nonnull successJsonStr) {
//        address = successJsonStr;
//    };
}




#pragma mark FlutterStreamHandler
- (FlutterError *)onListenWithArguments:(id)arguments eventSink:(FlutterEventSink)events {
    self.chatSink = events;
    return nil;
}

- (FlutterError *)onCancelWithArguments:(id)arguments {
    self.chatSink = nil;
    return nil;
}

- (void)handleMethodCall:(FlutterMethodCall *)call result:(FlutterResult)result{
    NSString *methodName = call.method;
    id params = call.arguments;
    SEL sel = NSSelectorFromString([NSString stringWithFormat:@"%@:result:",  methodName]);
    Method method = class_getClassMethod(self.class, sel);
    IMP imp = method_getImplementation(method);
    if (imp != nil && result != nil) {
        fn f = (fn)imp;
        f(self.class, sel, params, result);
        return;
    }
}

FlutterMethod(checkAvailability){
    NSString *uri = @"";
    NSDictionary *params = FlutterParams;
    uri = params[@"uri"];
    bool isCanOpenURL = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:uri]];
    FlutterCallback(isCanOpenURL ? @"YES" : @"NO");
}

FlutterMethod(connectWallet){
//    address = @"";
//    NSDictionary *params = FlutterParams;
//    [swiftInstance connectWalletWithSchemaStr:params[@"schema"]];
//    swiftInstance.successSelectBlock = ^(NSString * _Nonnull successJsonStr) {
//        FlutterCallback(successJsonStr);
//    };
    
}


FlutterMethod(initFlow){
//    address = @"";
//    NSDictionary *params = FlutterParams;
   
    [swiftInstance initFlow];
    
}

FlutterMethod(authLogin){
//    address = @"";
//    NSDictionary *params = FlutterParams;
    [swiftInstance authLogin:^(NSString * _Nonnull address) {
        FlutterCallback(address);
    }];
    
}

FlutterMethod(authorizedTransactionsFCLWallet){
//    address = @"";
//    NSDictionary *params = FlutterParams;
    NSString *authorized = [swiftInstance authorizedTransactionsFCLWallet];
    FlutterCallback(authorized);
}





FlutterMethod(connectQrWallet){
    address = @"";
//    swiftInstance.successSelectBlock = ^(NSString * _Nonnull successJsonStr) {
//        FlutterCallback(successJsonStr);
//    };
}

FlutterMethod(getWalletAddress){
    if (address.length > 0) {
        FlutterCallback(address);
    }else{
//        swiftInstance.connectWalletSuccessSelectBlock = ^(NSString * _Nonnull successJsonStr) {
//            FlutterCallback(successJsonStr);
//        };
    }
}




- (void)didConnect {
    
}

- (void)didDisconnect {
    
}

- (void)failedToConnect {
    
}

@end
