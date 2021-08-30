#import "FlutterwavePaymentPlugin.h"
#if __has_include(<flutterwave_payment/flutterwave_payment-Swift.h>)
#import <flutterwave_payment/flutterwave_payment-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "flutterwave_payment-Swift.h"
#endif

@implementation FlutterwavePaymentPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFlutterwavePaymentPlugin registerWithRegistrar:registrar];
}
@end
