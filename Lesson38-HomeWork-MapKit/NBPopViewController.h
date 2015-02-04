//
//  NBPopViewController.h
//  Lesson38-HomeWork-MapKit
//
//  Created by Nick Bibikov on 1/23/15.
//  Copyright (c) 2015 Nick Bibikov. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NBStudent;

@protocol NBPopViewControllerDelegate;

@interface NBPopViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) id <NBPopViewControllerDelegate> delegate;
@property (strong, nonatomic) NBStudent* student;

@end

@protocol NBPopViewControllerDelegate <NSObject>

- (void) hidePopover;

@end
