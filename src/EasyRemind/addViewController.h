//
//  addViewController.h
//  takingNote
//
//  Created by 刘鑫 on 16/5/27.
//  Copyright © 2016年 LinXin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol passValuesDelegate <NSObject>

@optional

@end

@interface addViewController : UIViewController
@property (weak, nonatomic)id<passValuesDelegate> passValueDelegeta;

@end
