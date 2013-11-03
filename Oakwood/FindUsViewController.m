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

@synthesize findUsText;
UIView *directionsView;


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
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(orientationChanged:)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil];

    
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"How to Find Us";
    
     directionsView = [[UIView alloc] init];
    
    //TextField
    findUsText = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, directionsView.frame.size.width, 20)];
    findUsText.textColor = [UIColor whiteColor];
    findUsText.font = [UIFont systemFontOfSize:12.0];
    findUsText.text = @"Oakwood Baptist Church is located at: 2154 Loop 337 North New Braunfels Texas 78130.  \nWe are on the North side of Loop 337, about 1 mile west of River Road, 1.5 miles east of Walnut past New Braunfels High School.";
    findUsText.backgroundColor = [UIColor clearColor];
    findUsText.editable = FALSE;
    
    
   
    [directionsView addSubview:findUsText];
    [self.view addSubview:directionsView];
    
    UIDeviceOrientation deviceOrientation = [UIDevice currentDevice].orientation;
    
    //NSLog(@"deviceOrientation: %d", deviceOrientation);
    
    if (UIDeviceOrientationIsLandscape(deviceOrientation))
    {
        //NSLog(@"Landscape View");
        [self setLandscapeTextDimensions];
        
    }
    else if (UIDeviceOrientationIsPortrait(deviceOrientation) || deviceOrientation == 0)
    {
        //NSLog(@"Portrait View");
        [self setPortraitTextDimensions];
    }
    
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
    
     //NSLog(@"inside view forAnnotation.");
    
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
         //NSLog(@"about to pull in image.");
        annotationView.image=[UIImage imageNamed:@"oakwoodapp_57.png"];//here we use a nice image instead of the default pins
        //NSLog(@"pulled in image.");
        return annotationView;
    }
    
    return nil;    
}

- (void)orientationChanged:(NSNotification *)notification
{
    UIDeviceOrientation deviceOrientation = [UIDevice currentDevice].orientation;
    if (UIDeviceOrientationIsLandscape(deviceOrientation))
    {
        [self setLandscapeTextDimensions];

    }
    else if (UIDeviceOrientationIsPortrait(deviceOrientation))
    {
        [self setPortraitTextDimensions];
    }
}

- (void)awakeFromNib
{
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(orientationChanged:)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil];
}

- (void) setLandscapeTextDimensions
{
    CGRect frame = findUsText.frame;
    frame.size.height = 85;//findUsText.contentSize.height;
    frame.size.width = 548;
    directionsView.frame = frame;
    findUsText.frame = frame;
}

- (void) setPortraitTextDimensions
{
    CGRect frame = findUsText.frame;
    frame.size.width = 318;
    frame.size.height = 85;//findUsText.contentSize.height;
     directionsView.frame = frame;
    findUsText.frame = frame;
}

@end
