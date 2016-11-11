//
//  EventMapTableViewCell.m
//  FeedApp
//
//  Created by TechLoverr on 24/10/16.
//
//

#import "EventMapTableViewCell.h"

@implementation EventMapTableViewCell

- (void)setEvent:(LLEvent *)event {

  [self setLocationFromAddressString:event.eventVenue];
}

- (CLLocationCoordinate2D)setLocationFromAddressString:(NSString *)addressStr {
  double latitude = 0, longitude = 0;
  NSString *esc_addr = [addressStr
      stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
  NSString *req =
      [NSString stringWithFormat:@"http://maps.google.com/maps/api/geocode/"
                                 @"json?sensor=false&address=%@",
                                 esc_addr];
  NSString *result = [NSString stringWithContentsOfURL:[NSURL URLWithString:req]
                                              encoding:NSUTF8StringEncoding
                                                 error:NULL];
  if (result) {
    NSScanner *scanner = [NSScanner scannerWithString:result];
    if ([scanner scanUpToString:@"\"lat\" :" intoString:nil] &&
        [scanner scanString:@"\"lat\" :" intoString:nil]) {
      [scanner scanDouble:&latitude];
      if ([scanner scanUpToString:@"\"lng\" :" intoString:nil] &&
          [scanner scanString:@"\"lng\" :" intoString:nil]) {
        [scanner scanDouble:&longitude];
      }
    }
  }
  CLLocationCoordinate2D center;
  center.latitude = latitude;
  center.longitude = longitude;
  NSLog(@"View Controller get Location Logitute : %f", center.latitude);
  NSLog(@"View Controller get Location Latitute : %f", center.longitude);
  MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
  [annotation setCoordinate:center];
  // You can set the subtitle too

  [self.map addAnnotation:annotation];

  MKCoordinateRegion viewRegion =
      MKCoordinateRegionMakeWithDistance(center, 10000, 10000);
  MKCoordinateRegion adjustedRegion = [self.map regionThatFits:viewRegion];
  [self.map setRegion:adjustedRegion animated:YES];
  return center;
}

@end
