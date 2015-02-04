//
//  NBInfoView.m
//  Lesson38-HomeWork-MapKit
//
//  Created by Nick Bibikov on 1/23/15.
//  Copyright (c) 2015 Nick Bibikov. All rights reserved.
//

#import "NBInfoView.h"

@implementation NBInfoView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        self.layer.cornerRadius = 10.f;
        self.backgroundColor = [UIColor grayColor];
        self.alpha = 0.7f;
        
        UILabel* label1 = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 200, 33)];
        UILabel* label2 = [[UILabel alloc] initWithFrame:CGRectMake(10, 35, 200, 33)];
        UILabel* label3 = [[UILabel alloc] initWithFrame:CGRectMake(10, 65, 200, 33)];
        
    
        UIFont* font = [UIFont fontWithName:@"Avenir" size:15];
        
        label1.font = label2.font = label3.font = font;
        label1.textColor = label2.textColor = label3.textColor = [UIColor whiteColor];
        
        self.infoLabel1 = label1;
        self.infoLabel2 = label2;
        self.infoLabel3 = label3;
        
        [self addSubview:self.infoLabel1];
        [self addSubview:self.infoLabel2];
        [self addSubview:self.infoLabel3];
    }
    
    return self;
}


@end
