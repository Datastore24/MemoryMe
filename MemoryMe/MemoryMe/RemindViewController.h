//
//  RemindViewController.h
//  MemoryMe
//
//  Created by Кирилл Ковыршин on 28.08.15.
//  Copyright (c) 2015 datastore24. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RemindViewController : UIViewController

@property (strong,nonatomic) NSDate * eventDate;
@property (strong,nonatomic) NSString * eventInfo;
@property (assign,nonatomic) BOOL isDetail;

@end
