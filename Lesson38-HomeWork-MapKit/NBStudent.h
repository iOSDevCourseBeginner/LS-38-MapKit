//
//  NBStudent.h
//  Lesson38-HomeWork-MapKit
//
//  Created by Nick Bibikov on 1/23/15.
//  Copyright (c) 2015 Nick Bibikov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

typedef enum {
    NBMale,
    NBFamale
}NBGender;

@interface NBStudent : NSObject <MKAnnotation>

@property (strong, nonatomic) NSString* firstName;
@property (strong, nonatomic) NSString* lastName;
@property (assign, nonatomic) NBGender gender;
@property (assign, nonatomic) NSInteger birhYear;
@property (assign, nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;

@end
