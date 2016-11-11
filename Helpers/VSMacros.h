//
//  VSMacros.h
//
//  Created by Vishal Sharma on 09/12/14.
//  Copyright © 2015 vishal. All rights reserved.
//

/*
 * Application Name
 */
#define APP_NAME @"Living Local"

#define APPDelegate                                                            \
  ((AppDelegate *)[[UIApplication sharedApplication] delegate])

#define ServiceManager [LLWebServiceManager sharedManager]

/*
 * Application fonts
 */
#define FONT_DEFAULT_LIGHT(fontSize)                                           \
  [UIFont fontWithName:@"Roboto-Thin"                                          \
                  size:fontSize + (IS_IPHONE_6 ? 0.5 : 0) +                    \
                       (IS_IPHONE_6P ? 2 : 0)]
#define FONT_DEFAULT_REGULAR(fontSize)                                         \
  [UIFont fontWithName:@"Roboto-Regular"                                       \
                  size:fontSize + (IS_IPHONE_6 ? 0.5 : 0) +                    \
                       (IS_IPHONE_6P ? 2 : 0)]
#define FONT_DEFAULT_MEDIUM(fontSize)                                          \
  [UIFont fontWithName:@"Roboto-Medium"                                        \
                  size:fontSize + (IS_IPHONE_6 ? 0.5 : 0) +                    \
                       (IS_IPHONE_6P ? 2 : 0)]
#define FONT_DEFAULT_BOLD(fontSize)                                            \
  [UIFont fontWithName:@"Roboto-Bold"                                          \
                  size:fontSize + (IS_IPHONE_6 ? 0.5 : 0) +                    \
                       (IS_IPHONE_6P ? 2 : 0)]

#define HEIGHT_SCALE (SCREEN_HEIGHT / 568.0)
#define WIDTH_SCALE (SCREEN_WIDTH / 320.0)

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)                             \
  ([[[UIDevice currentDevice] systemVersion]                                   \
       compare:(v)                                                             \
       options:NSNumericSearch] != NSOrderedAscending)

#define SCREEN_WIDTH                                                           \
  (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")                             \
       ? [UIScreen mainScreen].bounds.size.width                               \
       : MIN([UIScreen mainScreen].bounds.size.width,                          \
             [UIScreen mainScreen].bounds.size.height))

#define SCREEN_HEIGHT                                                          \
  (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")                             \
       ? [UIScreen mainScreen].bounds.size.height                              \
       : MAX([UIScreen mainScreen].bounds.size.width,                          \
             [UIScreen mainScreen].bounds.size.height))

#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)

#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))

#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)

/*
 * Application colour
 */

#define THEME_BLUE_COLOR RGB(28, 117, 187)
#define THEME_ORANGE_COLOR RGB(243, 176, 25)

#define UIColorFromRGB(rgbValue)                                               \
  [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16)) / 255.0         \
                  green:((float)((rgbValue & 0x00FF00) >> 8)) / 255.0          \
                   blue:((float)((rgbValue & 0x0000FF) >> 0)) / 255.0          \
                  alpha:1.0]

/*
 * Custom Alert
 */

#define kCustomAlertWithOkCancel(msg)                                          \
  [[[UIAlertView alloc] initWithTitle:APP_NAME                                 \
                              message:msg                                      \
                             delegate:self                                     \
                    cancelButtonTitle:@"Cancel"                                \
                    otherButtonTitles:@"Ok", nil] show]

#define AlertViewShow(Title, Message, Delegate)                                \
  {                                                                            \
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Title              \
                                                    message:Message            \
                                                   delegate:Delegate           \
                                          cancelButtonTitle:@"OK"              \
                                          otherButtonTitles:nil];              \
    [alert show];                                                              \
  }

/*
 * Singleton for .h file
 */

#define AUSINGLETON_FOR_CLASS(classname) +(classname *)shared##classname

/*
 * Singleton for .m file
 */

#define AUSINGLETON_IMPL_FOR_CLASS(classname)                                  \
                                                                               \
  static classname *shared##classname = nil;                                   \
                                                                               \
  +(classname *)shared##classname {                                            \
    @synchronized(self) {                                                      \
      if (shared##classname == nil) {                                          \
        shared##classname = [[self alloc] init];                               \
      }                                                                        \
    }                                                                          \
                                                                               \
    return shared##classname;                                                  \
  }

/*
 * custom Singleton category helper
 */

#define CATEGORY_SINGLETON_LAZY_LOADING_PROPERTY_IMP(classname, property,      \
                                                     setter)                   \
                                                                               \
  -(classname *)property {                                                     \
    classname *object = objc_getAssociatedObject(self, @selector(property));   \
    if (object == nil) {                                                       \
      object = [classname shared##classname];                                  \
      self.property = object;                                                  \
    }                                                                          \
    return object;                                                             \
  }                                                                            \
  -(void)setter(classname *) property {                                        \
    objc_setAssociatedObject(self, @selector(property), property,              \
                             OBJC_ASSOCIATION_ASSIGN);                         \
  }

#define CATEGORY_PROPERTY_IMP(classname, property, setter)                     \
                                                                               \
  -(classname *)property {                                                     \
    classname *object = objc_getAssociatedObject(self, @selector(property));   \
    return object;                                                             \
  }                                                                            \
  -(void)setter(classname *) property {                                        \
    objc_setAssociatedObject(self, @selector(property), property,              \
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);               \
  }

/*
 * custom DLog
 */

#ifdef DEBUG
#define DLog(fmt, ...)                                                         \
  NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#define DLog(...)
#endif

/*
 * ALog always displays output regardless of the DEBUG setting
 */

#define ALog(fmt, ...)                                                         \
  DLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#define RB_SocketLog(fmt)                                                      \
  [Rollbar                                                                     \
      logWithLevel:@"info"                                                     \
           message:[NSString stringWithFormat:@"%s [Line %d]",                 \
                                              __PRETTY_FUNCTION__, __LINE__]   \
              data:@{@"body" : fmt}];
#define RB_APILog(fmt, ...)                                                    \
  [Rollbar                                                                     \
      logWithLevel:@"info"                                                     \
           message:[NSString stringWithFormat:@"%s [Line %d]",                 \
                                              __PRETTY_FUNCTION__, __LINE__]   \
              data:@{@"message" : fmt}];
#define RB_APITaskLog(task, fmt, ...)                                          \
  [Rollbar                                                                     \
      logWithLevel:@"info"                                                     \
           message:[NSString stringWithFormat:@"%s [Line %d]",                 \
                                              __PRETTY_FUNCTION__, __LINE__]   \
              data:@{                                                          \
                @"message" : fmt,                                              \
                @"originalURL" :                                               \
                    (task.originalRequest.URL.absoluteString != nil            \
                         ? task.originalRequest.URL.absoluteString             \
                         : @"nil")                                             \
              }];

/*
 * UIColor macros
 */

#define RGB(r, g, b)                                                           \
  [UIColor colorWithRed:r / 255.0 green:g / 255.0 blue:b / 255.0 alpha:1]
#define RGBA(r, g, b, a)                                                       \
  [UIColor colorWithRed:r / 255.0 green:g / 255.0 blue:b / 255.0 alpha:a]
#define HTML(rgb)                                                              \
  RGB((double)(rgb >> 16 & 0xff), (double)(rgb >> 8 & 0xff),                   \
      (double)(rgb & 0xff))
#define HTMLA(rgb, a)                                                          \
  RGBA((double)(rgb >> 16 & 0xff), (double)(rgb >> 8 & 0xff),                  \
       (double)(rgb & 0xff), a)

/*
 * Other
 */

#define openURL(url)                                                           \
  [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
#define openNSURL(url) [[UIApplication sharedApplication] openURL:url];
#define LocalizedText(string) NSLocalizedString(string, nil)

#define DOCUMENTS_DIRECTORY_URL                                                \
  [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory        \
                                          inDomains:NSUserDomainMask]          \
      lastObject]
#define DOCUMENTS_DIRECTORY_PATH                                               \
  [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,  \
                                       YES) firstObject]
#define LOCAL_FILES_DIRECTORY_PATH                                             \
  [DOCUMENTS_DIRECTORY_PATH stringByAppendingPathComponent:@"LocalFiles"]
#define PROFILE_IMAGE_FILENAME @"profileImage"
#define USER_DEFAULTS [NSUserDefaults standardUserDefaults]

#define DEGREES(degrees) @((degrees) / 180.0 * M_PI)
#define DEGREES_TO_RADIANS(angle) ((angle - 90) / 180.0 * M_PI)

#define SCALE_TO_0 CGAffineTransformMakeScale(0.5, 0.5)
#define SCALE_TO_1 CGAffineTransformMakeScale(1.0, 1.0)

/*
 * Device detection
 */

#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)

/*
 * OS detection
 */

#define IS_OS_8_OR_LATER                                                       \
  ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
