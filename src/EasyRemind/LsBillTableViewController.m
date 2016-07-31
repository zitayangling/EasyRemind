//
//  LsBillTableViewController.m
//  HJB
//
//  Created by zitayangling on 16/5/20.
//  Copyright © 2016年 yangling. All rights reserved.
//

#import "LsBillTableViewController.h"
#import "HeaderView.h"
#import "Bill.h"
#import "SqliteManager.h"

#define KIncome [UIColor colorWithRed:0 green:0.8 blue:0.5 alpha:1];
#define KMoney  [UIColor colorWithRed:0.7 green:0 blue:0.3 alpha:1];

@interface LsBillTableViewController ()
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIImageView *topImage;
@property (retain, nonatomic) IBOutlet UILabel *year;
@property (strong, nonatomic) SqliteManager *db;
@property (strong, nonatomic) NSMutableArray * monthArray;
@property (strong, nonatomic) NSMutableArray * BillOfMonthArray;
@property (strong, nonatomic) NSMutableArray * headerViewArray;
@property (assign, nonatomic) NSInteger  selectindex;
@property (nonatomic, strong) HeaderView *selectedHeaderView;

@property (copy, nonatomic) NSString * chooseYearText;
@property (assign, nonatomic) CGFloat red;
@property (assign, nonatomic) CGFloat blue;
@property (assign, nonatomic) CGFloat green;
@property (nonatomic, strong) NSMutableArray *bools;
@property (weak, nonatomic) IBOutlet UIButton *downYear;
@property (weak, nonatomic) IBOutlet UIButton *upYear;

@end

@implementation LsBillTableViewController

- (NSMutableArray *)monthArray {
    if (!_monthArray) {
        _monthArray = [NSMutableArray array];
        _monthArray = [[SqliteManager sharedManager] readMonth:self.chooseYearText];
    }
    return _monthArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.topImage.image = [UIImage imageNamed:@"hahaha.jpg"];
    self.db = [SqliteManager sharedManager];
    self.BillOfMonthArray = [[NSMutableArray alloc]init];
    
    self.chooseYearText = [self dateOfTitle];
    self.year.text = self.chooseYearText;//显示年份
    [self chooseYear];
    self.tableView.separatorStyle = NO;
    
    NSInteger thisYear = ([self dateOfTitle]).integerValue;
    NSInteger year = self.year.text.integerValue;
    if(year>=thisYear)
    {
        self.downYear.hidden = YES;
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;
    [self setHeaderView];
    [self.tableView reloadData];

}
#pragma mark - 滑动切换年份账单
-(void)chooseYear
{
    UISwipeGestureRecognizer *swipeGestureToRight=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeImage:)];
    //swipeGestureToRight.direction=UISwipeGestureRecognizerDirectionRight;//默认为向右轻扫
    [self.topView addGestureRecognizer:swipeGestureToRight];
    
    UISwipeGestureRecognizer *swipeGestureToLeft=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeImage:)];
    swipeGestureToLeft.direction=UISwipeGestureRecognizerDirectionLeft;
    [self.topView addGestureRecognizer:swipeGestureToLeft];
}
//注意虽然轻扫手势是连续手势，但是只有在识别结束才会触发，不用判断状态
-(void)swipeImage:(UISwipeGestureRecognizer *)gesture
{
    //direction记录的轻扫的方向
    NSInteger year = self.year.text.integerValue;
    if (gesture.direction==UISwipeGestureRecognizerDirectionRight) {//向左
        year--;
        self.downYear.hidden = NO;
        self.chooseYearText = @(year).stringValue;
        self.year.text = self.chooseYearText;
    }else if(gesture.direction==UISwipeGestureRecognizerDirectionLeft){//向右
        NSInteger thisYear = ([self dateOfTitle]).integerValue;
        if(year >= thisYear)
        {
            return;
        }else
        {
            year++;
            self.chooseYearText = @(year).stringValue;
            self.year.text = self.chooseYearText;
            if(year >= thisYear)
            {
                self.downYear.hidden = YES;
            }
        }
    }
    [self setHeaderView];
    [self.tableView reloadData];
    
  
}
#pragma mark - HeaderView
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
//    self.headerViewArray release];
    HeaderView * headerView = [[HeaderView alloc]init];
    headerView = self.headerViewArray[section];
    if(!self.headerViewArray)
    {
        return nil;
    }
    return headerView;
    
}
-(void)setHeaderView{

    self.bools = [NSMutableArray array];
    self.headerViewArray = [[NSMutableArray alloc]init];
    self.monthArray = [[SqliteManager sharedManager] readMonth:self.chooseYearText];
    if(self.monthArray)
    {
        for (int i=0; i<self.monthArray.count; i++)
        {
            HeaderView * headerView = (HeaderView *)[[[NSBundle mainBundle]loadNibNamed:@"HeaderView" owner:self options:nil]objectAtIndex:0];

            NSString * month = self.monthArray[i];
            NSString * year = self.chooseYearText;
            headerView.month.text = [[NSString alloc]initWithFormat:@"%@月",month] ;
            //月结余
//            float monthSurplus = [[SqliteManager sharedManager]monthOfSurplus:year :month];
            NSString *Surplus =@([[SqliteManager sharedManager]monthOfSurplus:year :month]).stringValue;
            
            
            headerView.image.image = [UIImage imageNamed:@"UpAccessory.png"];
            headerView.Surplus.text =[NSString stringWithFormat:@"结余：%@",Surplus];

            headerView.theMonth = month;
            headerView.theYear = year;
            headerView.sectionIndex = i;
  
            //创建手势对象
            UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchs:)];
            //设置手势属性
            tapGesture.numberOfTapsRequired=1;//设置点按次数，默认为1，注意在iOS中很少用双击操作
            tapGesture.numberOfTouchesRequired=1;//点按的手指数
            //添加手势到对象(注意，这里添加到了控制器视图中，而不是图片上，否则点击空白无法隐藏导航栏)
            [headerView addGestureRecognizer:tapGesture];
            self.red = 0.7;
            self.blue = 0.7;
            self.green = 0.9;
            headerView.backgroundColor = [UIColor colorWithRed:self.red green:self.green blue:self.blue alpha:1];
            [self.headerViewArray addObject:headerView];
            [self.bools addObject:@NO];
        }
    }
}
-(void)touchs:(UITapGestureRecognizer *)sender{
   HeaderView *tapView = (HeaderView *)[sender view];
    self.selectedHeaderView = tapView;
    self.selectindex = self.selectedHeaderView.sectionIndex;
   
    if([self.bools[self.selectindex] isEqual:@NO])
    {
        self.bools[self.selectindex] = @YES;
    }
    else
    {
        self.bools[self.selectindex] = @NO;
    }

//    self.red+=0.3;
//    self.blue+=0.1;
//    self.green+=0.4;
//    if(self.red>1&&self.blue>1&&self.green>1)
//    {
//        self.red = 0.1;
//        self.green = 0.1;
//        self.blue = 0.1;
//    }
//    self.selectedHeaderView.backgroundColor = [UIColor colorWithRed:self.red green:self.green blue:self.blue alpha:1];
    [self.tableView reloadData];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;//headerView高度
   
}


#pragma mark - date 日期
-(NSString *)dateOfTitle//年份
{
    NSDate * now = [NSDate date];
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy"];
    NSString * date1 = [dateFormatter stringFromDate:now];
    return date1;
}

-(NSString *)nowDate//当前日期
{
    NSDate * nowdate = [NSDate date];
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString * date1 = [dateFormatter stringFromDate:nowdate];
    return date1;
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Incomplete implementation, return the number of sections
    return self.monthArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of rows

    

        HeaderView * selectView = [[HeaderView alloc]init];
        selectView = self.headerViewArray[section];

//    self.bools[section];
//    if(!selectView)
//    {
//         selectView.image.image = [UIImage imageNamed:@"UpAccessory.png"];
//              [self.tableView release];
//    }
        if(selectView.sectionIndex == section)
        {
//            NSLog(@"%ld",section);
            if([self.bools[section]  isEqual: @YES])
            {
                self.BillOfMonthArray = [[SqliteManager sharedManager]allBill:selectView.theYear  :selectView.theMonth];
                    selectView.image.image = [UIImage imageNamed:@"DownAccessory.png"];
                return self.BillOfMonthArray.count;
            }
            else
            {
                selectView.image.image = [UIImage imageNamed:@"UpAccessory.png"];
                return 0;
            }
        }
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.tableView.separatorStyle  = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    HeaderView * selectView = [[HeaderView alloc]init];
    selectView = self.headerViewArray[indexPath.section];
    
    //-----------------------------------------------
//    NSLog(@"year:%@,month:%@",selectView.theYear,selectView.month);
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"theBill" forIndexPath:indexPath];
//    cell.separatorInset
    if(selectView.month == nil)
    {
            UILabel *MoneyLabel = (UILabel *)[cell viewWithTag:1];
        MoneyLabel.text = @"没有数据";
    }
    else{
        
    
    self.BillOfMonthArray = [[NSMutableArray alloc]init];
    self.BillOfMonthArray = [self.db allBill:selectView.theYear  :selectView.theMonth];

    Bill *abill = self.BillOfMonthArray[indexPath.row];
    
    UILabel *income = (UILabel *)[cell viewWithTag:2];
    UILabel *MoneyLabel = (UILabel *)[cell viewWithTag:1];
        income.textColor = KIncome;
        MoneyLabel.textColor = KMoney;
    if (abill.money == 0)
    {
        income.text =[NSString stringWithFormat:@"收入:%@",@(abill.income).stringValue] ;
        MoneyLabel.text = @"";
    }
    else if (abill.income == 0)
    {
        MoneyLabel.text = [NSString stringWithFormat:@"支出:%@",@(abill.money).stringValue];
        income.text = @"";
    }
    UIImageView *category = (UIImageView *)[cell viewWithTag:3];
        category.layer.cornerRadius = category.frame.size.height/2;
        category.layer.masksToBounds = YES;
    category.image = [UIImage imageWithData:abill.categoryImage];
    
    UILabel *categorLabel = (UILabel *)[cell viewWithTag:4];
    categorLabel.text = abill.categoryName;
    
    UILabel *date = (UILabel *)[cell viewWithTag:5];
    date.text = abill.AccountingTime;
    }
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
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        
        HeaderView * selectView = [[HeaderView alloc]init];
        selectView = self.headerViewArray[indexPath.section];
        self.BillOfMonthArray = [[NSMutableArray alloc]init];
        self.BillOfMonthArray = [self.db allBill:selectView.theYear  :selectView.theMonth];
        Bill *abill = self.BillOfMonthArray[indexPath.row];
        
        [self.db deleteBill:abill];


        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self setHeaderView];
        [self.tableView reloadData];
      

        
        
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
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


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    UIViewController *destination=segue.destinationViewController;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    //    [destination setValue:self.db forKey:@"SQLmanager"];
    if ([segue.identifier isEqualToString:@"lsToUpdate"])
    {
    
        HeaderView * selectView = [[HeaderView alloc]init];
        selectView = self.headerViewArray[indexPath.section];
        self.BillOfMonthArray = [[NSMutableArray alloc]init];
        self.BillOfMonthArray = [self.db allBill:selectView.theYear  :selectView.theMonth];
        Bill *aBill = self.BillOfMonthArray[indexPath.row];
        
        [destination setValue:aBill forKey:@"theBill"];
        [destination setValue:@(indexPath.row) forKey:@"index"];
    }

}


- (IBAction)lastYear:(id)sender {
    self.downYear.hidden = NO;
    NSInteger year = self.year.text.integerValue;
    year--;
    self.chooseYearText = @(year).stringValue;
    self.year.text = self.chooseYearText;
    [self setHeaderView];
    [self.tableView reloadData];
    
    
}
- (IBAction)nextYear:(id)sender {
    NSInteger thisYear = ([self dateOfTitle]).integerValue;
    NSInteger year = self.year.text.integerValue;
    year++;
    self.chooseYearText = @(year).stringValue;
    self.year.text = self.chooseYearText;
    [self setHeaderView];
    [self.tableView reloadData];
    if(year >= thisYear)
    {
        self.downYear.hidden = YES;
    }
    
}
@end
