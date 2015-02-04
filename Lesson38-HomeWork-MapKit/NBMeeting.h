//
//  NBMeeting.h
//  Lesson38-HomeWork-MapKit
//
//  Created by Nick Bibikov on 2/3/15.
//  Copyright (c) 2015 Nick Bibikov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface NBMeeting : NSObject <MKAnnotation>

@property (strong, nonatomic) NSString* name;
@property (assign, nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString* title;
@property (nonatomic, copy) NSString* subtitle;

- (id) initWithNameMeeting:(NSString*)name andLocation:(CLLocationCoordinate2D)location;

@end
