//
//  ReadTypeImage.h
//  HJB
//
//  Created by ChangRJey on 16/5/28.
//  Copyright © 2016年 yangling. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ReadTypeImage : NSObject
@property (strong, nonatomic) NSString *typeIcon;
@property (strong, nonatomic) NSString *typeName;
@property (strong, nonatomic) NSString *typeID;

@property (nonatomic, assign) NSNumber* income;


+ (instancetype)imageWithImageDic:(NSDictionary *)imageDic;
@end
