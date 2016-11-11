//
//  EventMapTableViewCell.h
//  FeedApp
//
//  Created by TechLoverr on 24/10/16.
//
//

#import <MapKit/MapKit.h>
#import <UIKit/UIKit.h>

@interface EventMapTableViewCell : UITableViewCell
@property(weak, nonatomic) IBOutlet MKMapView *map;
@property(strong, nonatomic) LLEvent *event;

@end
