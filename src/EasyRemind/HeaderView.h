//
//  HeaderView.h
//  HJB
//
//  Created by zitayangling on 16/6/2.
//  Copyright © 2016年 yangling. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HeaderView : UIView
@property (retain, nonatomic) IBOutlet UILabel *month;
@property (retain, nonatomic) IBOutlet UILabel *Surplus;
@property (retain, nonatomic) IBOutlet UIImageView *image;

@property (copy, nonatomic) NSString * theMonth;
@property (copy, nonatomic) NSString * theYear;

@property (assign, nonatomic) NSInteger sectionIndex;
@property (assign, nonatomic) BOOL isExpand;
@end
