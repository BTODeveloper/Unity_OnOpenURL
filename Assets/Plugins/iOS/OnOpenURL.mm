//

#import "AppDelegateListener.h"
#import <string.h>

@interface OnOpenURLListener : NSObject<AppDelegateListener>
@property (nonatomic, copy) NSString *openURLString;
@end

static OnOpenURLListener *_instance;

@implementation OnOpenURLListener

+ (OnOpenURLListener *)sharedInstance {
    return _instance;
}

+ (void)load {
    if(!_instance) {
        _instance = [[OnOpenURLListener alloc] init];
    }
}

- (id)init {
    if(_instance)
        return _instance;
    self = [super init];
    if (!self)
        return nil;
    _instance = self;
    UnityRegisterAppDelegateListener(self);
    return self;
}

- (void)onOpenURL:(NSNotification *)notification {
    NSURL *url = notification.userInfo[@"url"];
    NSLog(@"onOpenURL: ");
    self.openURLString = [url absoluteString];
    UnitySendMessage("Receiver", "OnOpenURL",
                     [self.openURLString cStringUsingEncoding:NSUTF8StringEncoding]);
}

- (const char*)getOpenURLString {
    if (!self.openURLString) {
        return nil;
    }
    const char *str = [self.openURLString cStringUsingEncoding:NSUTF8StringEncoding];
    return strdup(str);
}

@end

extern "C" const char *OnOpenURLListener_GetOpenURLString()
{
    return [[OnOpenURLListener sharedInstance] getOpenURLString];
}
