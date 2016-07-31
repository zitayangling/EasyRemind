//
//  budgetViewController.m
//  HJB
//
//  Created by 周建臣 on 16/5/31.
//  Copyright © 2016年 yangling. All rights reserved.
//

#import "budgetViewController.h"
#import "VWWWaterView.h"
#import "SqliteManager.h"

#define kTheScreenWidth [UIScreen mainScreen].bounds.size.width
#define mainHeight     [[UIScreen mainScreen] bounds].size.height

@interface budgetViewController ()
@property (strong, nonatomic) UILabel *budgetLabel;//显示预算金额
@property (strong, nonatomic) UITextField *budgetText;//设置预算金额
@property (strong, nonatomic) UILabel *AllMoneyLabel;//显示总消费情况
@property (strong, nonatomic) UILabel *dismoney; //余额
@property (strong, nonatomic) NSUserDefaults *usrDefaults;
@property (strong, nonatomic) UIButton *saveBudget;
@property (strong, nonatomic) SqliteManager *SQLmanager;
@property (strong, nonatomic) NSString *Year;
@property (strong, nonatomic) NSString *Month;
@property (strong, nonatomic) NSString *monthMoney;



@end

@implementation budgetViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"本月预算";
    self.SQLmanager = [[SqliteManager alloc]init];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"back"]];
    [self year];
    [self month];
    [self initWithView];
    [self waterView];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewDidAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
}
-(void)year{
    NSDate * now = [NSDate date];
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy"];
    NSString * date1 = [dateFormatter stringFromDate:now];
    self.Year = date1;
}
-(void)month{
    NSDate * now = [NSDate date];
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"MM"];
    NSString * date1 = [dateFormatter stringFromDate:now];
    self.Month = date1;
}
- (void)waterView
{
    VWWWaterView *waterView = [[VWWWaterView alloc]initWithFrame:CGRectMake(0, 0, 300, 300)];
    waterView.center = self.view.center;
    waterView.backgroundColor = [UIColor grayColor];//页面背景颜色改背景
    waterView.currentWaterColor = [UIColor greenColor];//水波颜色
  
        NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
        NSString *budget=[defaults objectForKey:@"budget"];
        NSLog(@"budget=%@",budget);
        
        float a=_AllMoneyLabel.text.floatValue;
    NSLog(@"a=====%f",a);
        CGFloat b= a/budget.floatValue;
        b = [[NSString stringWithFormat:@"%.2f", b] floatValue];
    NSLog(@"b======%f",b);

    waterView.percentum = b * (1.0f);//设置动画百分比

    [self.view addSubview:waterView];
}
-(void)initWithView
{
    //添加一个textField 用来设置预算
    _budgetText = [[UITextField alloc]initWithFrame:CGRectMake(50, 70, 100, 25)];
    _budgetText.layer.borderWidth = 2.0f;
    _budgetText.layer.cornerRadius = 5;
    self.budgetText.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:_budgetText];
    //添加一个设置预算的按钮
    _saveBudget = [[UIButton alloc]initWithFrame:CGRectMake(250, 70, 100, 25)];
    [_saveBudget setTitle:@"设置预算" forState:UIControlStateNormal];
    [_saveBudget setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [ _saveBudget addTarget:self action:@selector(button:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_saveBudget];
    
    //添加一个label用来显示总支出情况
    _budgetLabel = [[UILabel alloc]initWithFrame:CGRectMake(kTheScreenWidth/2, 100, 50, 50)];
    [self read];
    [self.view addSubview:_budgetLabel];
    
    
    _AllMoneyLabel = [[UILabel alloc]initWithFrame:CGRectMake(kTheScreenWidth/2, mainHeight-150, 100, 50)];

    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    //读取保存的数据
    NSString *balance= [defaults objectForKey:@"balance"];
    self.AllMoneyLabel.text = balance;
    [self.view addSubview:_AllMoneyLabel];
    
    _dismoney = [[UILabel alloc]initWithFrame:CGRectMake(50, mainHeight-150, 100, 50)];
    _dismoney.text = @"余额";
    [self.view addSubview:_dismoney];
}
-(void)viewWillAppear:(BOOL)animated
{    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    //读取保存的数据
    NSString *budget=[defaults objectForKey:@"budget"];
    self.budgetLabel.text = budget;
    
    NSString *str = [NSString stringWithFormat:@"%.2f",budget.floatValue-[[SqliteManager sharedManager] oneDayOfmoney:self.Year :self.Month]];
    _AllMoneyLabel.text = str;
    [self waterView];
}


-(void) button:(UIButton *)sender
{

    //获取NSUserDefaults对象
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    //保存数据(如果设置数据之后没有同步, 会在将来某一时间点自动将数据保存到Preferences文件夹下面)
    [defaults setObject:self.budgetText.text forKey:@"budget"];
    self.budgetLabel.text = self.budgetText.text;
    NSString *str = [NSString stringWithFormat:@"%.2f",self.budgetText.text.floatValue-[[SqliteManager sharedManager] oneDayOfmoney:self.Year :self.Month]];
    _AllMoneyLabel.text = str;
    [defaults setObject:str forKey:@"balance"];

    //强制让数据立刻保存
    [defaults synchronize];
    [self waterView];
//    NSString *a  = @(self.budgetLabel.text.floatValue-self.AllMoneyLabel.text.floatValue).stringValue;
//    self.theBill.balance = a.floatValue;
//    if ([self.PassValueDelegeta respondsToSelector:@selector(PassValuesWithBill:)]) {
//        [self.PassValueDelegeta PassValuesWithBill:self.theBill];
    
//    }

    
//    [self.navigationController popViewControllerAnimated:YES];

}
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (![self.budgetText isExclusiveTouch]) {
        [self.budgetText resignFirstResponder];
    }
}
-(void)read
{
    //获取NSUserDefaults对象
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    //读取保存的数据
    NSString *budget=[defaults objectForKey:@"budget"];
    self.budgetLabel.text = budget;


    //打印数据
    
    NSLog(@"budget=%@",budget);
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
