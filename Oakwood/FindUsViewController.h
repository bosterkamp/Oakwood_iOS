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
{
    UITextView *findUsText;
}
@property (strong, nonatomic) IBOutlet UIView *findUsWindow;

@property(nonatomic,retain) UITextView *findUsText;

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end
