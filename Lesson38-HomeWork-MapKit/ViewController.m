//
//  ViewController.m
//  Lesson38-HomeWork-MapKit
//
//  Created by Nick Bibikov on 1/22/15.
//  Copyright (c) 2015 Nick Bibikov. All rights reserved.
//

#import "ViewController.h"
#import "NBStudent.h"
#import "NBInfoView.h"
#import "UIView+MKAnnotationView.h"
#import "NBMeeting.h"

#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

@interface ViewController ()

@property (weak, nonatomic) NBInfoView* infoView;
@property (strong, nonatomic) NBMeeting* meeting;
@property (strong, nonatomic) NSArray* studentsArray;
@property (strong, nonatomic) UIPopoverController *pop;
@property (assign, nonatomic) CLLocationCoordinate2D locationMeeting;
@property (strong, nonatomic) MKDirections* directions;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //For show current location in iOS8
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    
    if(IS_OS_8_OR_LATER) {
        [self.locationManager requestAlwaysAuthorization];
    }
    
    [self.locationManager startUpdatingLocation];

    self.mapView.showsUserLocation         = YES;
    [self.mapView setMapType:MKMapTypeStandard];
    [self.mapView setZoomEnabled:YES];
    [self.mapView setScrollEnabled:YES];

    //Initializing transparent infoView for show additional information
    NBInfoView* infoView                   = [[NBInfoView alloc] initWithFrame:CGRectMake(10, 75, 210, 100)];
    self.infoView                          = infoView;
    [self.mapView addSubview:self.infoView];

    //Call method for create students
    [self createStudentsAndLocatons];

    //Add button for show all pins and call method
    UIBarButtonItem* showAllPin            = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch
                                                                                target:self
                                                                                action:@selector(showAllPin)];
    self.navigationItem.rightBarButtonItem = showAllPin;

    //Add a meeting point
    CLLocationCoordinate2D locationMeeting;
    locationMeeting.latitude  = 50.457596;
    locationMeeting.longitude = 30.474251;
    self.locationMeeting      = locationMeeting;

    self.meeting              = [[NBMeeting alloc] initWithNameMeeting:@"Fixed Cup 2015"
                                                           andLocation:locationMeeting];

    [self.mapView addAnnotation:self.meeting];

    [self addOverlayCircleWithCoordinate:locationMeeting];
    
}


    //Zoom to meeting point
- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(self.locationMeeting, 5000, 5000);
    [self.mapView setRegion:[self.mapView regionThatFits:region] animated:YES];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Actions

- (void) createStudentsAndLocatons {
    
    NSMutableArray* tempArray = [NSMutableArray array];
    
    for (int i = 0; i < 20; i++) {
        NBStudent* student = [[NBStudent alloc] init];
        [tempArray addObject:student];
        
    }
    
    self.studentsArray = tempArray;
    [self.mapView addAnnotations:self.studentsArray];
    
}

    //Zoom out and show all pins
- (void)showAllPin {
    
    MKMapRect zoomRect = MKMapRectNull;
    
    for (id <MKAnnotation> annotation in self.mapView.annotations) {
        
        CLLocationCoordinate2D location = annotation.coordinate;
        MKMapPoint center = MKMapPointForCoordinate(location);
        
        static double delta = 1000;
        
        MKMapRect rect = MKMapRectMake(center.x - delta, center.y - delta, delta * 2, delta * 2);
        zoomRect = MKMapRectUnion(zoomRect, rect);
    }
    
    zoomRect = [self.mapView mapRectThatFits:zoomRect];
    
    [self.mapView setVisibleMapRect:zoomRect edgePadding:UIEdgeInsetsMake(50, 50, 50, 50) animated:YES];
}

- (void) pinCallOutPressed:(UIButton*) sender {
    
    NBStudent* student = (NBStudent <MKAnnotation> *)[[sender superAnnotationView]annotation];
    NBPopViewController* vc = [[NBPopViewController alloc] init];
    vc.student = student;
    vc.delegate = self;
    
    UINavigationController* nc = [[UINavigationController alloc] initWithRootViewController:vc];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {

        UIPopoverController* pop = [[UIPopoverController alloc] initWithContentViewController:nc];
        pop.delegate             = self;
        pop.popoverContentSize   = CGSizeMake(300, 300);
        self.pop                 = pop;
        [self.pop presentPopoverFromRect:sender.bounds inView:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];

    } else {
        [self presentViewController:nc animated:YES completion:nil];

    }
    
}



- (void) pinRoute:(UIButton*) sender {
    
    if ([self.directions isCalculating]) {
        [self.directions cancel];
    }
    
    for (id <MKAnnotation> object in [self countStudentsInCircle:self.meeting.coordinate forRadius:6000]) {
        
        [self buildRouteForAnnotationCoordinate:[object coordinate] startCoordinate:self.meeting.coordinate];
        
    }

    
    
}

    //Add 3 circles over meeting point
- (void) addOverlayCircleWithCoordinate:(CLLocationCoordinate2D) location {
    
    CLLocationCoordinate2D circleMiddlePoint = CLLocationCoordinate2DMake(location.latitude, location.longitude);
    MKCircle* circle1 = [MKCircle circleWithCenterCoordinate:circleMiddlePoint radius:2000];
    MKCircle* circle2 = [MKCircle circleWithCenterCoordinate:circleMiddlePoint radius:4000];
    MKCircle* circle3 = [MKCircle circleWithCenterCoordinate:circleMiddlePoint radius:6000];
    
    [self countStudentsInCircle:location forRadius:2000];
    [self countStudentsInCircle:location forRadius:4000];
    [self countStudentsInCircle:location forRadius:6000];
    
    NSArray* overlaysArray = @[circle1, circle2, circle3];
    [self.mapView addOverlays:overlaysArray];
    
}

    //Count students in circles and return array
- (NSArray*) countStudentsInCircle:(CLLocationCoordinate2D)location forRadius:(int)radius {
    
    CLLocation* startLocation = [[CLLocation alloc] initWithLatitude:location.latitude
                                                           longitude:location.longitude];
    
    int count = 0;
    NSMutableArray* tempArray = [NSMutableArray new];
    
    for (id <MKAnnotation> annotation in self.mapView.annotations) {
        if ([annotation isKindOfClass:[NBStudent class]]) {
            CLLocation* studentsLocation = [[CLLocation alloc] initWithLatitude:annotation.coordinate.latitude
                                                                      longitude:annotation.coordinate.longitude];
            CLLocationDistance studentsDistance = [startLocation distanceFromLocation:studentsLocation];
            
            if (radius > studentsDistance) {
                count++;
                [tempArray addObject:annotation];
            
            }
        }
    }
    
    if (radius == 2000) {
        self.infoView.infoLabel1.text = [NSString stringWithFormat:@"In arrea %dm students - %d", radius, count];

    } else if (radius == 4000) {
        self.infoView.infoLabel2.text = [NSString stringWithFormat:@"In arrea %dm students - %d", radius, count];

    } else if (radius == 6000) {
        self.infoView.infoLabel3.text = [NSString stringWithFormat:@"In arrea %dm students - %d", radius, count];

    }
    return tempArray;
}


    //Build routes from students to Meet Point

- (void) buildRouteForAnnotationCoordinate:(CLLocationCoordinate2D)endCoordinate startCoordinate:(CLLocationCoordinate2D)startCoordinate {
    
    MKDirectionsRequest* request = [[MKDirectionsRequest alloc] init];
    
    MKPlacemark* startPlacemark = [[MKPlacemark alloc] initWithCoordinate:startCoordinate
                                                        addressDictionary:nil];
    
    MKMapItem* startDestination = [[MKMapItem alloc] initWithPlacemark:startPlacemark];
    
    request.source = startDestination;
    
    MKPlacemark* endPlacemark = [[MKPlacemark alloc] initWithCoordinate:endCoordinate
                                                      addressDictionary:nil];
    
    MKMapItem* endDestination = [[MKMapItem alloc] initWithPlacemark:endPlacemark];
    
    request.destination = endDestination;
    request.transportType = MKDirectionsTransportTypeAutomobile;
    request.requestsAlternateRoutes = YES;
    
    self.directions = [[MKDirections alloc] initWithRequest:request];
    
    [self.directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error) {
        
        if (error) {
            
        } else if ([response.routes count] == 0) {
            
        } else {
            
            [self.mapView addOverlay:[[response.routes firstObject] polyline] level:MKOverlayLevelAboveRoads];
        }
    }];
}

#pragma mark - NBPopViewControllerDelegate

- (void) hidePopover {
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        [self dismissViewControllerAnimated:YES completion:nil];
    
    } else {
        [self.pop dismissPopoverAnimated:YES];
        self.pop = nil;
        
    }
}



#pragma mark - MKMapViewDelegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
    
    static NSString* identifier = @"annotation";
    MKAnnotationView* pin = [mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
    
    if (!pin) {
        pin = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        pin.canShowCallout = YES;
        
        if ([pin.annotation isKindOfClass:[NBStudent class]]) {
            if ([(NBStudent <MKAnnotation>*) annotation gender] == NBMale) {
                pin.image = [UIImage imageNamed:@"male"];
            
            } else {
                pin.image = [UIImage imageNamed:@"female"];
                
            }
            
            UIButton* infoButton = [UIButton buttonWithType:UIButtonTypeInfoDark];
            [infoButton addTarget:self action:@selector(pinCallOutPressed:) forControlEvents:UIControlEventTouchUpInside];
            pin.rightCalloutAccessoryView = infoButton;
            
        } else if ([pin.annotation isKindOfClass:[NBMeeting class]]) {
            pin.image = [UIImage imageNamed:@"meeting.png"];
            [pin setDraggable:YES];
            
            UIButton* pinRoute = [UIButton buttonWithType:UIButtonTypeContactAdd];
            [pinRoute addTarget:self action:@selector(pinRoute:) forControlEvents:UIControlEventTouchUpInside];
            pin.leftCalloutAccessoryView = pinRoute;
            
        }
        
    } else {
        pin.annotation = annotation;
        
    }
    
    return pin;
}



- (void) mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view didChangeDragState:(MKAnnotationViewDragState)newState fromOldState:(MKAnnotationViewDragState)oldState {
    
    if ([view.annotation isKindOfClass:[NBMeeting class]]) {
        if (newState == MKAnnotationViewDragStateEnding) {
            view.dragState                      = MKAnnotationViewDragStateNone;
            [self addOverlayCircleWithCoordinate:view.annotation.coordinate];

            NSLog(@"latitude - {%f}, longtitude = {%f}", view.annotation.coordinate.latitude,
                  view.annotation.coordinate.longitude);

        } else if (newState == MKAnnotationViewDragStateStarting) {
            [self.mapView removeOverlays:[mapView overlays]];
            
        }
    }
}


- (MKOverlayRenderer*) mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay {
    
    if ([overlay isKindOfClass:[MKCircle class]]) {
        
        MKCircleRenderer* circleRender = [[MKCircleRenderer alloc] initWithCircle:overlay];
        circleRender.strokeColor = [UIColor colorWithRed:0.f green:0.5f blue:1.f alpha:0.6f];
        circleRender.lineWidth = 1.f;
        return circleRender;
        
    } else if ([overlay isKindOfClass:[MKPolyline class]]) {
        
        MKPolylineRenderer* lineRender = [[MKPolylineRenderer alloc] initWithOverlay:overlay];
        lineRender.strokeColor = [UIColor greenColor];
        lineRender.lineWidth = 2.f;
        return lineRender;
    }
    
    return nil;
}





#pragma mark - MyLocation


    /*//Focus on user location
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 1000, 1000);
    [self.mapView setRegion:[self.mapView regionThatFits:region] animated:YES];
}*/

- (NSString *)deviceLocation {
    
    return [NSString stringWithFormat:@"latitude: %f longitude: %f",
            self.locationManager.location.coordinate.latitude, self.locationManager.location.coordinate.longitude];
}

@end
