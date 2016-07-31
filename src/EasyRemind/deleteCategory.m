//
//  deleteCategory.m
//  takingNote
//
//  Created by 刘鑫 on 16/6/15.
//  Copyright © 2016年 LinXin. All rights reserved.
//

#import "deleteCategory.h"
#import "HJBcategory.h"
#import "SqliteManager.h"
#import "JZMTBtnView.h"

@interface deleteCategory ()
@property (strong, nonatomic) NSMutableArray * categoryList;
@property (strong, nonatomic) HJBCategory * theCategory;
@property (strong, nonatomic) UIImageView * categoryImage;
@property (strong, nonatomic) UILabel * categoryName;
@property (strong, nonatomic) UILabel * wishCategory;
@property (nonatomic, strong) NSUserDefaults *defaults;
@property (strong, nonatomic) SqliteManager * sqlManager;
@property (weak, nonatomic) IBOutlet UISegmentedControl *incomeAndSpendingSg;
@property (strong, nonatomic) NSMutableArray *categoryIDArray;
@property (strong, nonatomic) IBOutlet UITableView *theTableView;

@end

@implementation deleteCategory

- (void)viewDidLoad {
    [super viewDidLoad];
    self.theCategory=[[HJBCategory alloc]init];
    self.categoryList=[[NSMutableArray alloc]init];
    self.sqlManager=[[SqliteManager alloc]init];
    self.categoryImage.image=[UIImage imageWithData:self.theCategory.categoryImageName];
    self.incomeAndSpendingSg.selectedSegmentIndex=0;
    [self.incomeAndSpendingSg addTarget:self action:@selector(segmentedAction:) forControlEvents:UIControlEventValueChanged];
    self.categoryList=[[SqliteManager sharedManager]allCategoryID:self.theCategory.isExpenditure];
    self.theTableView.separatorStyle  = NO;
}

#pragma mark - segmented函数
- (void) segmentedAction:(id)sender {
    switch (self.incomeAndSpendingSg.selectedSegmentIndex) {
        case 0:
            self.theCategory.isExpenditure=[[SqliteManager sharedManager]isExpenditure];
            self.categoryList=[[SqliteManager sharedManager]allCategoryID:self.theCategory.isExpenditure];
            [self.theTableView reloadData];
            break;
        case 1:
            self.theCategory.isExpenditure=[[SqliteManager sharedManager]isExpenditure1];
            self.categoryList=[[SqliteManager sharedManager]allCategoryID:self.theCategory.isExpenditure];
            [self.theTableView reloadData];
            break;
            
        default:
            break;
    }
}

#pragma mark - 保存按钮
- (IBAction)saveButton:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.categoryList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"categoryCell" forIndexPath:indexPath];
    self.theCategory = self.categoryList[indexPath.row];
    self.categoryImage = (UIImageView *)[cell viewWithTag:100];
    self.categoryImage.layer.cornerRadius = self.categoryImage.frame.size.height/2;
    self.categoryImage.layer.masksToBounds = YES;
    self.categoryImage.image=[UIImage imageWithData:self.theCategory.categoryImageName];
    
    self.categoryName=(UILabel *)[cell viewWithTag:101];
    self.categoryName.text=self.theCategory.categoryName;
    
    self.wishCategory=(UILabel *)[cell viewWithTag:102];
    self.wishCategory.text=@"重名为";
    UITapGestureRecognizer * tapRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapRename:)];
    [self.wishCategory addGestureRecognizer:tapRecognizer];
    return cell;
}

#pragma mark - tableViewCell删除
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        HJBCategory *category = self.categoryList[indexPath.row];
        [[SqliteManager sharedManager]deleteCategory:category];
        [self.categoryList removeObjectAtIndex:indexPath.row];
        [self.theTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self.theTableView reloadData];
        
    }
}

#pragma mark - 查找view的父控件
/** 查找View的父控件(UITableViewCell) */
- (UITableViewCell *)findCategoryCell:(UIView *)view{
    if(![view isKindOfClass:[UIView class]]){
        return nil;
    }
    UIView * superView=view.superview;
    while (superView) {
        if ([superView isKindOfClass:[UITableViewCell class]]) {
            return (UITableViewCell *)superView;
        }else{
            superView=superView.superview;
        }
    }
    return nil;
}

#pragma mark - 弹出文本输入框
- (void)tapRename:(UITapGestureRecognizer *)gesture {
    UITableViewCell *cell =    [self findCategoryCell:[gesture view]];
    NSIndexPath *indexPath2 =  [self.tableView indexPathForCell:cell];
    HJBCategory * category= [[HJBCategory alloc]init];
    category = self.categoryList[indexPath2.row];
    NSLog(@"category = %@",category.categoryName);
    NSString * title=[[NSString alloc]initWithFormat:@"修改%@名称",category.categoryName];
    // 通过点击位置确定点击的cell位置
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:[gesture locationInView:self.tableView]];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:@"请输入新类别名称" preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请输入名称";
    }];
    
    UIAlertAction *actionOK = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        // 修改数组中存放的类别名称
        NSString * name = alert.textFields[0].text;
        category.categoryName=name;
        [self.tableView reloadData];
        // 刷新tableView
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        [[SqliteManager sharedManager]updateCategory:category];
    }];
    UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:actionCancel];
    [alert addAction:actionOK];
    [self presentViewController:alert animated:YES completion:nil];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    // 将detele改为删除
    return @" 删除 ";
}
@end
