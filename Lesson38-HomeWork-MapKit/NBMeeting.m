//
//  NBMeeting.m
//  Lesson38-HomeWork-MapKit
//
//  Created by Nick Bibikov on 2/3/15.
//  Copyright (c) 2015 Nick Bibikov. All rights reserved.
//

#import "NBMeeting.h"

@implementation NBMeeting


- (id) initWithNameMeeting:(NSString*)name andLocation:(CLLocationCoordinate2D)location {
    
    self = [super init];
    if (self) {
        self.coordinate = location;
        self.title = name;
        
    }
    return self;
    
}

@end
