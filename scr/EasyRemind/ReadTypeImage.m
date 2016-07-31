//
//  ReadTypeImage.m
//  HJB
//
//  Created by ChangRJey on 16/5/28.
//  Copyright © 2016年 yangling. All rights reserved.
//

#import "ReadTypeImage.h"

@implementation ReadTypeImage
+ (instancetype)imageWithImageDic:(NSDictionary *)imageDic {
    ReadTypeImage *image = [[ReadTypeImage alloc] init];
    image.typeName = imageDic[@"name"];
    image.typeIcon = imageDic[@"icon"];
    image.income = nil;
    image.typeID = nil;
    return image;
}

@end

