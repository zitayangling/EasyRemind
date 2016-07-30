//
//  colorAtPixel.h
//  HJB
//
//  Created by ChangRJey on 16/5/30.
//  Copyright © 2016年 yangling. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface colorAtPixel : UIColor
@property (strong, nonatomic) UIColor *imageColor;
-(instancetype)initWithImage : (UIImage *)image point : (CGPoint) colorPoint;
@end
