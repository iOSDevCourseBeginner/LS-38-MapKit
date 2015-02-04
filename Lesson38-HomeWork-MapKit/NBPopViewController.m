//
//  NBPopViewController.m
//  Lesson38-HomeWork-MapKit
//
//  Created by Nick Bibikov on 1/23/15.
//  Copyright (c) 2015 Nick Bibikov. All rights reserved.
//

#import "NBPopViewController.h"
#import "NBStudent.h"

@interface NBPopViewController ()

@property (weak, nonatomic) UITableView* tableView;
@property (strong, nonatomic) CLGeocoder* geoCoder;
@property (strong, nonatomic) NSString* thoroughfare;

@end

@implementation NBPopViewController

- (void) viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem* cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                                  target:self
                                                                                  action:@selector(cancelPressed:)];
    
    self.navigationItem.leftBarButtonItem = cancelButton;
    
    CGRect rect = self.view.bounds;
    rect.origin = CGPointZero;
    UITableView* tableView = [[UITableView alloc] initWithFrame:rect style:UITableViewStylePlain];
    tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.allowsSelection = NO;
    tableView.scrollEnabled = NO;
    
    [self.view addSubview:tableView];
    
    self.tableView = tableView;
    
    self.geoCoder = [[CLGeocoder alloc] init];
    CLLocationCoordinate2D coordinate = self.student.coordinate;
    CLLocation* location = [[CLLocation alloc] initWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    
    if ([self.geoCoder isGeocoding]) {
        [self.geoCoder cancelGeocode];
    }
    
    __weak NBPopViewController* weakSelf = self;
    
    dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
       
        [self.geoCoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
           
            NSString* message = nil;
            
            if (error) {
                message = [error localizedDescription];
            
            } else {
                if ([placemarks count] > 0) {
                    MKPlacemark* placeMark = [placemarks firstObject];
                    message = placeMark.thoroughfare;
                
                } else {
                    message = @"No placemarks found";
                    
                }
            }
            
            weakSelf.thoroughfare = message;
            [weakSelf.tableView reloadData];
            
        }];
    });
}



#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString* indentifier = @"Cell";
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
        
    }
    
    cell.textLabel.font = [UIFont fontWithDescriptor:nil size:0.5f];
    
    if (indexPath.row == 0) {
        cell.textLabel.text = [NSString stringWithFormat:@"%@, %@", [self.student firstName], [self.student lastName]];
        
    } else if (indexPath.row == 1) {
        cell.textLabel.text = [NSString stringWithFormat:@"%ld", (long)[self.student birhYear]];
        
    } else if (indexPath.row == 2) {
        cell.textLabel.text = [NSString stringWithFormat:@"%@", [self position:[self.student coordinate]]];
        
    } else if (indexPath.row == 3) {
        cell.textLabel.text = self.thoroughfare;
        
    }
    
    return cell;
}


#pragma mark - Help Methods

- (void) cancelPressed:(UIBarButtonItem*) sender {
    
    [self.delegate hidePopover];
}


- (NSString*) position:(CLLocationCoordinate2D) coordinate {
    
    double latitude = coordinate.latitude;
    double longitude = coordinate.longitude;
    
    int latSeconds = (int)round(abs(latitude * 3600));
    int latDegrees = latSeconds / 3600;
    latSeconds = latSeconds % 3600;
    int latMinutes = latSeconds / 60;
    
    latSeconds %= 60;
    
    int longSeconds = (int)round(abs(longitude * 3600));
    
    int longDegrees = longSeconds / 3600;
    
    longSeconds = longSeconds % 3600;
    
    int longMinutes = longSeconds / 60;
    
    longSeconds %= 60;
    
    char latDirection = (latitude >= 0) ? 'N' : 'S';
    char longDirection = (longitude >= 0) ? 'E' : 'W';
    
    return [NSString stringWithFormat:@"%i° %i' %i\" %c, %i° %i' %i\" %c", latDegrees, latMinutes, latSeconds, latDirection, longDegrees, longMinutes, longSeconds, longDirection];
}


- (void) dealloc {
    
    NSLog(@"Popover deallocated");
}


@end
