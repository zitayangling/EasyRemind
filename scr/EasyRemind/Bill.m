//
//  Bill.m
//  HJB
//
//  Created by zitayangling on 16/5/17.
//  Copyright © 2016年 yangling. All rights reserved.
//

#import "Bill.h"

@implementation Bill
//-(UIImage *)billImage
//{
//    return [UIImage imageNamed:self.imageName];
//}
- (NSString *)description {
    return [NSString stringWithFormat:@"balance ====%f",self.balance];
}
@end
