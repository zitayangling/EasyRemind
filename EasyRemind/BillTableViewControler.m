//
//  BillTableViewControler.m
//  HJB
//
//  Created by zitayangling on 16/5/18.
//  Copyright © 2016年 yangling. All rights reserved.
//

#import "BillTableViewControler.h"
#import "HJBCategory.h"
#import "SqliteManager.h"
#import "Bill.h"
#import "budgetViewController.h"
#import "ViewController.h"
#import "PAPasscodeViewController.h"
#define KIncome [UIColor colorWithRed:0 green:0.8 blue:0.5 alpha:1];
#define KMoney  [UIColor colorWithRed:0.7 green:0 blue:0.3 alpha:1];

@interface BillTableViewControler ()
<
PAPasscodeViewControllerDelegate
>


@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property (weak, nonatomic) IBOutlet UILabel *expenditure;//支出
@property (weak, nonatomic) IBOutlet UILabel *income;//收入
@property (strong, nonatomic) NSArray *incomeMax;
@property (strong,nonatomic) SqliteManager * db;
@property (strong,nonatomic) NSMutableArray *list;
@property (strong,nonatomic) Bill *theBill;
@property (strong, nonatomic) IBOutlet UITableView *TableView;

@property (strong, nonatomic) NSString *date;
@property (assign, nonatomic) NSInteger PassIndex;
@property (assign, nonatomic) NSInteger fingerPassWordIndex;
@property (strong, nonatomic) ViewController *PassView;
@property (strong, nonatomic) NSString *passWord;
@property (strong, nonatomic) NSString *month;
@property (strong, nonatomic) NSString *year;
@end

@implementation BillTableViewControler

- (void)viewDidLoad {
    [super viewDidLoad];
    [self saveCategory];
    self.addButton.layer.cornerRadius = (100-15)/2;
    self.year = [self nowYear];
    self.month = [self nowMonth];
    self.db = [SqliteManager sharedManager];
//    self.tableView.separatorStyle  = NO;
    self.income.textColor = KIncome;
    self.expenditure.textColor = KMoney;
    self.PassView = [[ViewController alloc]init];
    self.passWord = [[SqliteManager sharedManager]queryPassWord ];
    self.fingerPassWordIndex=[[SqliteManager sharedManager]selectFingerPassWordIndex];
    [self judgePassWordIndex];
    NSLog(@"%ld %ld",self.PassIndex,self.fingerPassWordIndex);
//    [self.PassView authenticateUser];
    
}
-(void)judgePassWordIndex
{
    self.PassIndex = [[SqliteManager sharedManager]selectPassWordIndex ];
    if (self.PassIndex == 1)
    {
        [self EnterPass];
    }
}
-(void)EnterPass{
//    if(self.fingerPassWordIndex==1){
//        [self.PassView authenticateUser];
//    }
//    else{
        PAPasscodeViewController *passcodeViewController = [[PAPasscodeViewController alloc] initForAction:PasscodeActionEnter];
        passcodeViewController.delegate = self;
        passcodeViewController.passcode = self.passWord;
        [self presentViewController:passcodeViewController animated:YES completion:nil];
//    }
   
}
#pragma mark - PAPasscodeViewControllerDelegate
- (void)PAPasscodeViewControllerDidCancel:(PAPasscodeViewController *)controller {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)PAPasscodeViewControllerDidChangePasscode:(PAPasscodeViewController *)controller {
    [self dismissViewControllerAnimated:YES completion:^() {
        self.passWord = controller.passcode;
    }];
}

#pragma mark - ..

- (void)passValuesWithBill:(Bill *)bill {

    [self.db saveBill:bill];
    
}


//获取时间
-(NSString *)nowDate
{
    NSDate *date1 = [NSDate date];
    NSDateFormatter *dateFormatter1 = [NSDateFormatter new];
    [dateFormatter1 setDateFormat:@"yyyy-MM-dd"];
    NSString *dateStr2 = [dateFormatter1 stringFromDate:date1];
    return dateStr2;
}
//获取当前年份
-(NSString *)nowYear
{
    NSDate *date1 = [NSDate date];
    NSDateFormatter *dateFormatter2 = [NSDateFormatter new];
    [dateFormatter2 setDateFormat:@"yyyy"];
    NSString *dateStr1 = [dateFormatter2 stringFromDate:date1];
    return dateStr1;
}
//获取当前月份
-(NSString *)nowMonth
{
    NSDate *date1 = [NSDate date];
    NSDateFormatter *dateFormatter2 = [NSDateFormatter new];
    [dateFormatter2 setDateFormat:@"MM"];
    NSString *dateStr1 = [dateFormatter2 stringFromDate:date1];
    return dateStr1;
}

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;
    [super viewWillAppear:animated];
    //每月总支出
    self.income.text = [NSString stringWithFormat:@"%.2f",[[SqliteManager sharedManager ] oneDayOfIncome:self.year :self.month]];
    //每月总支出
    self.expenditure.text = [NSString stringWithFormat:@"%.2f",[[SqliteManager sharedManager] oneDayOfmoney:self.year :self.month]];

    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of rows
    NSMutableArray *cellList = [[NSMutableArray alloc]init];
    cellList = [self.db allBill:self.year :self.month];
    return cellList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"theBill" forIndexPath:indexPath];
    NSMutableArray *cellList = [[NSMutableArray alloc]init];
    cellList = [[SqliteManager sharedManager] allBill:self.year :self.month];
    NSLog(@"%ld",indexPath.row);
    Bill *abill = cellList[(indexPath.row)];
    UILabel *categorLabel = (UILabel *)[cell viewWithTag:1];
    categorLabel.text = abill.categoryName;
    if (abill.money == 0) {
        UILabel *income = (UILabel *)[cell viewWithTag:5];
        income.text = @(abill.income).stringValue;
        income.textColor = KIncome;
        UILabel *MoneyLabel = (UILabel *)[cell viewWithTag:2];
        MoneyLabel.text = nil;
        UILabel *money = (UILabel *)[cell viewWithTag:11];
        money.hidden = YES;

    }
    else if (abill.income == 0)
    {
       
        UILabel *MoneyLabel = (UILabel *)[cell viewWithTag:2];
        MoneyLabel.text = @(abill.money).stringValue;
        MoneyLabel.textColor  = KMoney;
        UILabel *income = (UILabel *)[cell viewWithTag:5];
        income.text =nil;//如果不写。修改返回时不刷新数据
        UILabel *Income = (UILabel *)[cell viewWithTag:12];
        Income.hidden = YES;
    }
    UILabel *time = (UILabel *)[cell viewWithTag:50];
    time.text = abill.AccountingTime;
    UIImageView *category = (UIImageView *)[cell viewWithTag:6];
    category.image = [UIImage imageWithData:abill.categoryImage];
    category.layer.cornerRadius = category.frame.size.height/2;
    category.layer.masksToBounds = YES;
    

    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    self.list = [self.db allBill:self.year :self.month];
    Bill *aBill = self.list[indexPath.row];
    [self.db deleteBill:aBill];
    //每月总支出
    self.income.text = [NSString stringWithFormat:@"%.2f",[[SqliteManager sharedManager ] oneDayOfIncome:self.year :self.month]];
    //每月总支出
    self.expenditure.text = [NSString stringWithFormat:@"%.2f",[[SqliteManager sharedManager] oneDayOfmoney:self.year :self.month]];

    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
        [self.tableView reloadData];
}
-(void)saveCategory
{
    NSMutableArray * categoryArray1 =[NSMutableArray array];
    categoryArray1 = [[SqliteManager sharedManager] readCategoryID];
    if (categoryArray1.count == 0) {
        NSString * path = [[NSBundle mainBundle]pathForResource:@"expend" ofType:@"plist"];
        NSMutableArray * categoryArray = [[NSMutableArray alloc]initWithContentsOfFile:path];
        for (int i=0; i<categoryArray.count; i++) {
            NSString * imageStr = [categoryArray[i]objectForKey:@"icon"];
            NSString * name = [categoryArray[i]objectForKey:@"name"];
            HJBCategory * cate = [[HJBCategory alloc]init];
            cate.categoryImageName = UIImageJPEGRepresentation([UIImage imageNamed:imageStr], 0.8);
            cate.categoryName = name;
            [[SqliteManager sharedManager] saveCategory:cate];
            
            
        }
    }
    
}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here, for example:
    // Create the next view controller.
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
    
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    UIViewController *destination=segue.destinationViewController;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
//    [destination setValue:self.db forKey:@"SQLmanager"];
    if ([segue.identifier isEqualToString:@"home2write"]) {
        [segue.destinationViewController setValue:self forKey:@"passValueDelegeta"];
    }else
    {

        self.list = [self.db allBill:self.year :self.month];
        Bill *aBill = self.list[indexPath.row];
        
        [destination setValue:aBill forKey:@"theBill"];
        [destination setValue:@(indexPath.row) forKey:@"index"];
    }
    
    if ([segue.identifier isEqualToString:@"home2bugdet"]) {
        [segue.destinationViewController setValue:self forKey:@"PassValueDelegeta"];
    }
    
    
}


@end
