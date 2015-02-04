//
//  UIView+MKAnnotationView.m
//  Lesson38-HomeWork-MapKit
//
//  Created by Nick Bibikov on 2/2/15.
//  Copyright (c) 2015 Nick Bibikov. All rights reserved.
//

#import "UIView+MKAnnotationView.h"
#import <MapKit/MKAnnotationView.h>

@implementation UIView (MKAnnotationView)

- (MKAnnotationView*) superAnnotationView {
    
    if ([self isKindOfClass:[MKAnnotationView class]]) {
        return (MKAnnotationView*)self;
        
    } else if (!self.superview) {
        return nil;
        
    }
    
    return [self.superview superAnnotationView];
}


@end
