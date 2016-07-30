//
//  ViewController.m
//  takingNote
//
//  Created by 刘鑫 on 16/5/3.
//  Copyright © 2016年 LinXin. All rights reserved.
//

#import "ViewController.h"
#import <LocalAuthentication/LocalAuthentication.h>
#import "PAPasscodeViewController.h"
#import "SqliteManager.h"
#import "Bill.h"
#import "BillTableViewControler.h"

@interface ViewController ()<PAPasscodeViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UISwitch *theSwitch;     ///<是否开启密码保护
@property (weak, nonatomic) IBOutlet UILabel *fingerLabel;
@property (weak, nonatomic) IBOutlet UISwitch *fingerSwitch;            ///<是否开启指纹
@property (weak, nonatomic) IBOutlet UIButton *modifyPasswordButton;    ///<修改密码
@property (weak, nonatomic) IBOutlet UILabel *passWordLabel;
@property (assign, nonatomic) NSInteger openPassWordIndex;              ///<记住是否开启密码
@property (assign, nonatomic) NSInteger openFingerPassWordIndex;        ///<记住是否开启指纹解锁
@property (strong, nonatomic) SqliteManager * sqlManager;               ///<数据库管理类
@property (strong, nonatomic) Bill * theBill;
@property (weak, nonatomic) IBOutlet UIButton *setPasswordButton;       ///<设置密码
@property (strong, nonatomic) BillTableViewControler * VDL;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.theBill = [Bill new];
    self.sqlManager=[[SqliteManager alloc]init];
    self.passWordLabel.text=[self.sqlManager queryPassWord];
    [self allIndex];
    [self openPassWord:@[]];
//    [self openFingerPassWord];
    [self isOpenPassWordSwitch];
//    [self isOpenFingerPassWordSwitch];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSArray *)allIndex{
    NSArray * array = [[NSMutableArray alloc]init];
    array=[self.sqlManager selectAllBill];
    NSString *thePassWordIndex= array.firstObject;
    NSString *theFingerPassWordIndex= array.lastObject;
    self.openPassWordIndex = thePassWordIndex.integerValue;
    self.openFingerPassWordIndex = theFingerPassWordIndex.integerValue;
    [self openPassWord:array];
    return array;
}

#pragma mark - 是否开启密码保护函数
- (IBAction)switchIsChange:(UISwitch *)sender {
    if([self.theSwitch isOn]){
        self.passWordLabel.text=[[SqliteManager sharedManager]queryPassWord];
//        self.fingerLabel.hidden=NO;
//        self.fingerSwitch.hidden=NO;
        self.setPasswordButton.hidden=NO;
        self.modifyPasswordButton.hidden=NO;
        if(self.passWordLabel.text==nil){
            [self setPassword:self.setPasswordButton];
        }
    }else{
        self.fingerLabel.hidden=YES;
        self.fingerSwitch.hidden=YES;
        self.setPasswordButton.hidden=YES;
        self.modifyPasswordButton.hidden=YES;
    }
    [self isOpenPassWordSwitch];
    [self openPassWord:@[]];
}

#pragma mark - 是否开启ToucID函数
- (IBAction)fingerSwitchIsChange:(UISwitch *)sender {
    if([self.fingerSwitch isOn]){
//        [self authenticateUser];
    }else{
//        [self popWindow];
    }
    [self isOpenFingerPassWordSwitch];
    [self openFingerPassWord];
}

- (void)isOpenPassWordSwitch{
    if(self.theSwitch.on==YES){
        self.openPassWordIndex=1;
        [self.sqlManager savePassWordIndex:self.openPassWordIndex];
    }
    if (self.theSwitch.on==NO){
        self.fingerSwitch.on=NO;
        self.openPassWordIndex=2;
        self.openFingerPassWordIndex=2;
        [self.sqlManager savePassWordIndex:self.openPassWordIndex];
        [self.sqlManager saveFingerPassWordIndex:self.openFingerPassWordIndex];
    }
}

- (void)isOpenFingerPassWordSwitch{
    if(self.fingerSwitch.on==YES){
        self.openFingerPassWordIndex=1;
        [self.sqlManager saveFingerPassWordIndex:self.openFingerPassWordIndex];
    }
    if (self.fingerSwitch.on==NO){
        self.openFingerPassWordIndex=2;
        [self.sqlManager saveFingerPassWordIndex:self.openFingerPassWordIndex];
    }
}



- (void)openPassWord:(NSArray *)array{
    self.openPassWordIndex = [[SqliteManager sharedManager] selectPassWordIndex];
    if(self.openPassWordIndex==1){
        self.theSwitch.on=YES;
        NSLog(@"密码保护已开启");
//        self.fingerLabel.hidden=NO;
//        self.fingerSwitch.hidden=NO;
        self.setPasswordButton.hidden=NO;
        self.modifyPasswordButton.hidden=NO;
    }
    if(self.openPassWordIndex==2){
        self.theSwitch.on=NO;
        NSLog(@"密码保护已关闭");
    }
}

- (void)openFingerPassWord{
    if(self.openFingerPassWordIndex==1){
        self.fingerSwitch.on=YES;
        NSLog(@"指纹解锁已开启");
    }else if(self.openFingerPassWordIndex==2){
        self.fingerSwitch.on=NO;
        NSLog(@"指纹解锁已关闭");
    }
}

#pragma mark - UIAlertController
- (void)popWindow{
    UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"提示" message:@"指纹解锁已关闭" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * action=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"点击了确定按钮");
    }];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - TouchID函数
- (void)authenticateUser{
    //初始化上下文对象
    LAContext* context = [[LAContext alloc] init];
    //错误对象
    NSError* error = nil;
    NSString* result = @"Authentication is needed to access your notes.";
    
    //首先使用canEvaluatePolicy 判断设备支持状态
    if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]) {
        //支持指纹验证
        [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:result reply:^(BOOL success, NSError *error) {
            if (success) {
                //验证成功，主线程处理UI
            }
            else{
                
                NSLog(@"%@",error.localizedDescription);
                switch (error.code) {
                    case LAErrorSystemCancel:{
                        NSLog(@"Authentication was cancelled by the system");
                        //切换到其他APP，系统取消验证Touch ID
                        break;
                    }
                    case LAErrorUserCancel:{
                        NSLog(@"Authentication was cancelled by the user");
                        //用户取消验证Touch ID
//                        PAPasscodeViewController *passcodeViewController = [[PAPasscodeViewController alloc] initForAction:PasscodeActionEnter];
//                        passcodeViewController.delegate = self;
////                        passcodeViewController.passcode = self.passWordLabel.text;
//                        [self presentViewController:passcodeViewController animated:YES completion:nil];
                        break;
                    }
                    case LAErrorUserFallback:{
                        NSLog(@"User selected to enter custom password");
                        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                            //用户选择输入密码，切换主线程处理
                            [self enterPassWord:self.setPasswordButton];
                        }];
                        break;
                    }
                    default:{
                        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                            //其他情况，切换主线程处理
                        }];
                        break;
                    }
                }
            }
        }];
    }
    else{
        //不支持指纹识别，LOG出错误详情
        
        switch (error.code) {
            case LAErrorTouchIDNotEnrolled:{
                NSLog(@"TouchID is not enrolled");
                break;
            }
            case LAErrorPasscodeNotSet:{
                NSLog(@"A passcode has not been set");
                break;
            }
            default:{
                NSLog(@"TouchID not available");
                break;
            }
        }
        
        NSLog(@"%@",error.localizedDescription);
    }
}

#pragma mark - 设置密码函数
- (IBAction)setPassword:(UIButton *)sender {
    PAPasscodeViewController *passcodeViewController = [[PAPasscodeViewController alloc] initForAction:PasscodeActionSet];
    passcodeViewController.delegate = self;
    [self presentViewController:passcodeViewController animated:YES completion:nil];
}

- (void)enterPassWord:(UIButton *)sender{
    PAPasscodeViewController *passcodeViewController = [[PAPasscodeViewController alloc] initForAction:PasscodeActionEnter];
    passcodeViewController.delegate = self;
    passcodeViewController.passcode = self.passWordLabel.text;
    [self presentViewController:passcodeViewController animated:YES completion:nil];
}

- (IBAction)changePassWord:(UIButton *)sender {
    PAPasscodeViewController *passcodeViewController = [[PAPasscodeViewController alloc] initForAction:PasscodeActionChange];
    passcodeViewController.delegate = self;
    passcodeViewController.passcode = self.passWordLabel.text;
    [self presentViewController:passcodeViewController animated:YES completion:nil];
}

#pragma mark - PAPasscodeViewControllerDelegate
- (void)PAPasscodeViewControllerDidCancel:(PAPasscodeViewController *)controller {
    [self dismissViewControllerAnimated:YES completion:nil];
    self.theSwitch.on=NO;
}

- (void)PAPasscodeViewControllerDidSetPasscode:(PAPasscodeViewController *)controller {
    [self dismissViewControllerAnimated:YES completion:^() {
        if(self.passWordLabel.text!=nil){
            [self.sqlManager updatePassWord:controller.passcode];
             NSLog(@"更新成功");
        }else{
            NSInteger isOpenPassWord;
            NSInteger isOpenFingerPassWord;
            if(self.theSwitch.on)
            {
                isOpenPassWord = 1;
            }
            else{
                isOpenPassWord = 2;
            }
            if(self.fingerSwitch.on)
            {
                isOpenFingerPassWord = 1;
            }
            else
            {
                isOpenFingerPassWord = 2;
            }
            [self.sqlManager savePassWord:controller.passcode :isOpenPassWord :isOpenFingerPassWord];
             NSLog(@"保存成功");
        }
    }];
}

- (void)PAPasscodeViewControllerDidChangePasscode:(PAPasscodeViewController *)controller {
    [self dismissViewControllerAnimated:YES completion:^() {
        if(self.passWordLabel.text!=nil){
            [self.sqlManager updatePassWord:controller.passcode];
             NSLog(@"更新成功");
        }else{
            [self.sqlManager savePassWord:controller.passcode :self.openPassWordIndex :self.openFingerPassWordIndex];
             NSLog(@"保存成功");
        }
    }];
}

@end
