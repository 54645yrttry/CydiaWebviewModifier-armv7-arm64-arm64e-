#import <UIKit/UIKit.h>

static BOOL tweakEnabled;
static NSString *customURL;

static NSString *GetModifiedURL(NSString *original) {
    if (!customURL || [customURL length] == 0) {
        customURL = @"http://cydia.saurik.com";
    }

    if ([original hasPrefix:@"https://cydia.saurik.com"]) {
        return [original stringByReplacingOccurrencesOfString:@"https://cydia.saurik.com"
                                                   withString:customURL];
    }

    return original;
}

static NSString *const kPrefsDomain = @"com.lukezgd.cydiawebviewmodifierprefs";
static NSString *const kPrefsPath = @"/var/mobile/Library/Preferences/com.lukezgd.cydiawebviewmodifierprefs.plist";

static void loadPreferences(void) {
    // Cydia runs as root, so its own preference domain points at /var/root.
    // Settings writes to the mobile user's plist, so read that file directly.
    NSDictionary *prefs = [NSDictionary dictionaryWithContentsOfFile:kPrefsPath];
    if (!prefs) {
        prefs = [[NSUserDefaults standardUserDefaults] persistentDomainForName:kPrefsDomain];
    }

    id enabled = [prefs objectForKey:@"tweakEnabled"];
    tweakEnabled = enabled ? [enabled boolValue] : YES;

    id value = [prefs objectForKey:@"customURL"];
    if ([value isKindOfClass:[NSString class]] && [value length] > 0) {
        customURL = value;
    } else {
        customURL = @"http://cydia.saurik.com";
    }
}

static void preferencesChanged(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
    loadPreferences();
}

%ctor {
    loadPreferences();

    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, preferencesChanged, CFSTR("com.lukezgd.cydiawebviewmodifierprefs-updated"), NULL, CFNotificationSuspensionBehaviorDeliverImmediately);
}

%hook UIWebView

- (void)loadRequest:(NSURLRequest *)request {
    if (!tweakEnabled) {
        %orig(request);
        return;
    }

    NSURL *url = [request URL];
    NSString *urlString = [url absoluteString];

    NSString *modified = GetModifiedURL(urlString);

    if (![modified isEqualToString:urlString]) {
        NSMutableURLRequest *newRequest = [request mutableCopy];
        NSURL *newURL = [NSURL URLWithString:modified];
        [newRequest setURL:newURL];
        request = newRequest;
    }

    %orig(request);
}

%end


%hook CydiaWebViewController

+ (void)didClearWindowObject:(id)window
                    forFrame:(id)frame
                   withCydia:(id)cydia {

    [window setValue:cydia forKey:@"cydia"];

    %orig;
}

%end
