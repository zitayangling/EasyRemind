//
//  Const.h
//  Timi
//
//  Created by chairman on 16/5/19.
//  Copyright © 2016年 LaiYoung. All rights reserved.
//

#ifndef Const_h
#define Const_h

//define this constant if you want to use Masonry without the 'mas_' prefix
#define MAS_SHORTHAND

//define this constant if you want to enable auto-boxing for default syntax
#define MAS_SHORTHAND_GLOBALS

/** 弱引用 */
#define WEAKSELF __weak typeof(self) weakSelf = self;
/** 屏幕的SIZE */
#define SCREEN_SIZE [[UIScreen mainScreen] bounds].size 
/** 时光轴颜色 */
#define LineColor [UIColor colorWithWhite:0.800 alpha:1.000];
/** 时光轴按钮 */
#define kTimeLineBtnWidth 32.0
/** 时光轴动画时间 */
#define kAnimationDuration .2f

/** 时光轴空白区域宽度 */
#define kBlankWidth ((SCREEN_SIZE.width - kTimeLineBtnWidth)/2/2 + (SCREEN_SIZE.width - kTimeLineBtnWidth)/2/2/3)

/** navigationBar的高 */
#define kNavigationBarMaxY CGRectGetMaxY(self.navigationController.navigationBar.frame)
/** 时光轴HeaderView的height */
#define kHeaderViewHeight 220

/**  CreateScrollView的Y值 */
#define KCreateScrollY [UIScreen mainScreen].bounds.size.height/2 - 169 - 40
/**  CreateScrollView的宽度 */
#define KCreateScrollW [UIScreen mainScreen].bounds.size.width
/**  CreateScrollView的高度 */
#define KCreateScrollH 169+56

#endif /* Const_h */
