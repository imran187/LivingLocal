//
//  SPUtils.h
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface SPUtils : NSObject

#pragma mark - Distance from current location

+(NSString *)getDistanceOfUserFrom:(CLLocation *)location_1 currentLocation:(CLLocation *)currentLocation;

#pragma mark Connection
+(BOOL)connected ;

#pragma mark Check Nulls
+(NSString*)checkNullOrBlankString:(NSString*)string;

@end
