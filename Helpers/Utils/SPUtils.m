//
//  SPUtils.m
//

#import "SPUtils.h"
#import "Reachability.h"

@implementation SPUtils

#pragma mark - Distance from current location

+(NSString *)getDistanceOfUserFrom:(CLLocation *)location_1 currentLocation:(CLLocation *)currentLocation{
    
    CLLocationDistance distance = [location_1 distanceFromLocation:currentLocation];
//    float roundedUp = ceilf(distance/1000.0);
    NSString *str_distance = [NSString stringWithFormat:@"%.2f meters",distance];
    return str_distance;
}

#pragma mark Connection
+(BOOL)connected {
    BOOL reachable = [SPUtils connectionStatus];
    if (!reachable) {
        AlertViewShow(APP_NAME, NSLocalizedString(@"NO_INTERNET", @"NO_INTERNET"), nil);
    }
    return reachable;
}
+(BOOL)connectionStatus {
    BOOL reachable=NO;
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    [reachability startNotifier];
    NetworkStatus internetStatus = [reachability currentReachabilityStatus];
    if (internetStatus != NotReachable) {
        reachable=YES;
    }
    return reachable;
}

#pragma mark Check Nulls
+(NSString*)checkNullOrBlankString:(NSString*)string
{
    if([string isEqual: [NSNull null]] || [string isEqualToString:@"null"] || [string isEqualToString:@"(null)"] || [string isEqualToString:@""] || [string isEqualToString:@"<null>"] || string==nil)
        return @"";
    //    string = [string stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
    string = [SPUtils trimmingText:string];
    if(string != nil &&  string.length >0)
        return string;
    return @"";
}
+(NSString*)trimmingText:(NSString*)string
{
    return [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}
@end
