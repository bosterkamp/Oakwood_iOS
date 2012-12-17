//
//  FindUsViewController.h
//  Oakwood
//
//  Created by The Osterkamps on 11/25/12.
//  Copyright (c) 2012 Oakwood Baptist Church. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

#define METERS_PER_MILE 1609.344

@interface FindUsViewController : UIViewController <MKMapViewDelegate>

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (weak, nonatomic) IBOutlet MKMapView *_mapView;


@end
