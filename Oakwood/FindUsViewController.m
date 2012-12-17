//
//  FindUsViewController.m
//  Oakwood
//
//  Created by The Osterkamps on 11/25/12.
//  Copyright (c) 2012 Oakwood Baptist Church. All rights reserved.
//

#import "FindUsViewController.h"
#import "OakwoodLocation.h"

@interface FindUsViewController ()

@end

@implementation FindUsViewController

@synthesize _mapView;
@synthesize window=_window;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"How to Find Us";
    
    //Added logic to show Oakwood Location
    // 1
    CLLocationCoordinate2D zoomLocation;
    zoomLocation.latitude = 29.727649;
    zoomLocation.longitude= -98.141727;
    // 2
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 0.5*METERS_PER_MILE, 0.5*METERS_PER_MILE);
    // 3
    MKCoordinateRegion adjustedRegion = [_mapView regionThatFits:viewRegion];
    // 4
    [_mapView setRegion:adjustedRegion animated:YES];
    
    //Add Annotation?
    OakwoodLocation *annotation = [[OakwoodLocation alloc] initWithName:@"Oakwood Baptist Church" address:@"2154 Loop 337 North" coordinate:zoomLocation] ;
    [_mapView addAnnotation:annotation];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    
     NSLog(@"inside view forAnnotation.");
    
    static NSString *identifier = @"OakwoodLocation";
    if ([annotation isKindOfClass:[OakwoodLocation class]]) {
        
        MKAnnotationView *annotationView = (MKAnnotationView *) [_mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        if (annotationView == nil) {
            annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        } else {
            annotationView.annotation = annotation;
        }
        
        annotationView.enabled = YES;
        annotationView.canShowCallout = YES;
         NSLog(@"about to pull in image.");
        annotationView.image=[UIImage imageNamed:@"oakwoodapp_57.png"];//here we use a nice image instead of the default pins
        NSLog(@"pulled in image.");
        return annotationView;
    }
    
    return nil;    
}

@end
