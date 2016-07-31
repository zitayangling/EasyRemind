//
//  JZMTBtnView.m
//  meituan
//  自定义美团菜单view
//  Created by jinzelu on 15/6/30.
//  Copyright (c) 2015年 jinzelu. All rights reserved.
//

#import "JZMTBtnView.h"

@implementation JZMTBtnView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(id)initWithFrame:(CGRect)frame title:(NSString *)title imageStr:(NSString *)imageStr{
    self = [super initWithFrame:frame];
    if (self) {
        //
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(frame.size.width/2-15, 15, 28, 28)];
        _imageView.image = [UIImage imageNamed:imageStr];
        [self addSubview:_imageView];
        //
        _titleLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 15+40, frame.size.width, 20)];
        _titleLable.text = title;
        _titleLable.textAlignment = NSTextAlignmentCenter;
        _titleLable.font = [UIFont systemFontOfSize:11];
        [self addSubview:_titleLable];
    }
    return self;
}

@end
