//
//  ViewController.h
//  Lesson38-HomeWork-MapKit
//
//  Created by Nick Bibikov on 1/22/15.
//  Copyright (c) 2015 Nick Bibikov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "NBPopViewController.h"

@class MKMapView;

@interface ViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate, NBPopViewControllerDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) CLLocationManager* locationManager;

@end

