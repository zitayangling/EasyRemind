//
//  AddBillViewController.m
//  HJB
//
//  Created by zitayangling on 16/5/19.
//  Copyright © 2016年 yangling. All rights reserved.
//

#import "AddBillViewController.h"
#import "SqliteManager.h"
#import "JZMTBtnView.h"
#import "SZCalendarPicker.h"
#import "WLDecimalKeyboard.h"
#import "HJBCategory.h"





@interface AddBillViewController ()<UIScrollViewDelegate,UITextFieldDelegate,UICollectionViewDelegate,UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *CollectionView;
@property (weak, nonatomic) IBOutlet UILabel *selectCategory;//选择类别
@property (strong, nonatomic) NSMutableArray *CategoryArr;//类别数组
@property (weak, nonatomic) IBOutlet UITextField *AddMoney;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControl;
@property (weak, nonatomic) IBOutlet UIButton *ImageButton;
@property (weak, nonatomic) IBOutlet UIImageView *categoryImage;//类别图片
@property (strong, nonatomic) JZMTBtnView *theCategory;
@property (strong, nonatomic) NSString *dateString;
@property (weak, nonatomic) IBOutlet UIButton *selectDate;
@property (assign, nonatomic) NSInteger index;
@property (strong, nonatomic) HJBCategory *HJBManager;
@property (copy, nonatomic) NSString *monthString;///<月份字符串
@property (strong, nonatomic) Bill *aBill;
@end

@implementation AddBillViewController

- (void)viewDidLoad {
    [super viewDidLoad];

//    [self AddKeyBoard];
    self.CollectionView.delegate =self;
    self.CollectionView.dataSource =self;
    self.categoryImage.layer.cornerRadius = self.categoryImage.frame.size.height/2;
    self.categoryImage.layer.masksToBounds = YES;
    
    self.HJBManager = [[HJBCategory alloc]init];
    //获取本月月份
    [self gainMonth];
//    [self initWithTypeButton:_CategoryArr];
    
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateStr = [dateFormatter stringFromDate:date];
    [self.selectDate setTitle:dateStr forState:UIControlStateNormal];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"back"]];
    
    WLDecimalKeyboard *inputView = [[WLDecimalKeyboard alloc]init];
    self.AddMoney.delegate = self;
    self.AddMoney.inputView = inputView;
    [self.AddMoney reloadInputViews];

    
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSLog(@"%@", [textField.text stringByReplacingCharactersInRange:range withString:string]);
    
    return YES;
}
-(void)viewWillAppear:(BOOL)animated
{
    [self.CollectionView reloadData];
    self.aBill = [[Bill alloc]init];
    self.navigationController.navigationBarHidden = NO;
//    self.aBill.month = self.monthString;

}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
# pragma mark    -----获取时间
-(void)readTime
{
    SZCalendarPicker *calendarPicker = [SZCalendarPicker showOnView:self.view];
    calendarPicker.layer.cornerRadius = 10;
    calendarPicker.layer.masksToBounds = YES;
    calendarPicker.today = [NSDate date];
    calendarPicker.date = calendarPicker.today;
    calendarPicker.frame = CGRectMake(25, 100, self.view.frame.size.width-50, 352);
    calendarPicker.calendarBlock =  ^(NSInteger day, NSInteger month, NSInteger year)
    {
        if (month < 10&& day<10)
        {
            self.dateString = [[NSString alloc]initWithFormat:@"%ld-0%ld-0%ld",year,month,(long)day];
            self.monthString = [[NSString alloc]initWithFormat:@"0%ld",month];
            [self.selectDate setTitle:self.dateString forState:UIControlStateNormal];
        }
        else if(month>10&&day<10) {
            self.dateString = [[NSString alloc]initWithFormat:@"%ld-%ld-0%ld",year,month,(long)day];
            self.monthString = [[NSString alloc]initWithFormat:@"%ld",month];
            [self.selectDate setTitle:self.dateString forState:UIControlStateNormal];
        }
        else if (month<10&&day>10)
        {
            self.dateString = [[NSString alloc]initWithFormat:@"%ld-0%ld-%ld",year,month,(long)day];
            self.monthString = [[NSString alloc]initWithFormat:@"0%ld",month];
            [self.selectDate setTitle:self.dateString forState:UIControlStateNormal];
        }
        else if (month>10&&day>10)
        {
            self.dateString = [[NSString alloc]initWithFormat:@"%ld-%ld-%ld",year,month,(long)day];
            self.monthString = [[NSString alloc]initWithFormat:@"%ld",month];
            [self.selectDate setTitle:self.dateString forState:UIControlStateNormal];
        }
        _theBill.month = self.monthString;
    };
}
-(NSString *)gainMonth
{
    NSDate *monthDate = [NSDate date];
    NSDateFormatter *monthFormatter = [NSDateFormatter new];
    [monthFormatter setDateFormat:@"MM"];
    self.monthString = [monthFormatter stringFromDate:monthDate];
    
    return self.monthString;
}
- (IBAction)selectTime:(UIButton *)sender {
    [self readTime];
}
# pragma mark  -------传值并保持数据库
- (IBAction)save:(UIBarButtonItem *)sender
{
    NSInteger index = self.segmentControl.selectedSegmentIndex;
    if (index == 0) {
        _theBill = [[Bill alloc]init];
        _theBill.categoryImage = UIImageJPEGRepresentation(self.categoryImage.image, 0.8);
        _theBill.imageName = UIImageJPEGRepresentation(self.ImageButton.imageView.image, 0.8);
        _theBill.money = self.AddMoney.text.floatValue;
        _theBill.categoryName = self.selectCategory.text;
        _theBill.month = self.monthString;
        _theBill.AccountingTime = [self.selectDate titleForState:UIControlStateNormal];
        if ([self.passValueDelegeta respondsToSelector:@selector(passValuesWithBill:)]) {
            [self.passValueDelegeta passValuesWithBill:_theBill];
        }
    }else if (index == 1)
    {
        _theBill = [[Bill alloc]init];
        _theBill.categoryImage = UIImageJPEGRepresentation(self.categoryImage.image, 0.8);
        _theBill.imageName = UIImageJPEGRepresentation(self.ImageButton.imageView.image, 0.8);
        _theBill.income = self.AddMoney.text.floatValue;
        _theBill.categoryName = self.selectCategory.text;
        _theBill.month = self.monthString;
        _theBill.AccountingTime = [self.selectDate titleForState:UIControlStateNormal];
        if ([self.passValueDelegeta respondsToSelector:@selector(passValuesWithBill:)]) {
            [self.passValueDelegeta passValuesWithBill:_theBill];
        }
    }
    [self.navigationController popViewControllerAnimated:YES];

}

#pragma mark 添加滑动视图

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
//item个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSMutableArray * categoryArray = [NSMutableArray array];
    categoryArray = [[SqliteManager sharedManager]readCategoryID];
    return categoryArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    NSMutableArray *categoryARR = [NSMutableArray array];
    categoryARR = [[SqliteManager sharedManager] readCategoryID];
    HJBCategory *category = categoryARR [(indexPath.row)];
    
    UIImageView *imageView = [cell viewWithTag:100];
    imageView.image = [UIImage imageWithData:category.categoryImageName];
    imageView.layer.cornerRadius = imageView.frame.size.height/2;
    imageView.layer.masksToBounds = YES;

    UILabel *label = [cell viewWithTag:200];
    label.text = category.categoryName;
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray * categoryArray =[NSMutableArray array];
    categoryArray = [[SqliteManager sharedManager]readCategoryID];
    HJBCategory *Categ = categoryArray[indexPath.row];
    self.categoryImage.image = [UIImage imageWithData:Categ.categoryImageName];
    self.selectCategory.text = Categ.categoryName;
    
    
    
}
- (IBAction)addImage:(UIButton *)sender {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"请选择" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    //拍照替换
    UIAlertAction *photoAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self addPicEvent];
    }];
    [alertController addAction:photoAction];
    
    //读取相册
    UIAlertAction *photoAlbumAction = [UIAlertAction actionWithTitle:@"相册替换" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            UIImagePickerController  *picker = [[UIImagePickerController alloc]init];
            picker.delegate = self;
            picker.allowsEditing = YES;
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:picker animated:YES completion:nil];
        }
    }];
    [alertController addAction:photoAlbumAction];
    //取消
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
    

}
- (void) addPicEvent
{
    //先设定sourceType为相机，然后判断相机是否可用（ipod）没相机，不可用将sourceType设定为相片库
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if (![UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
        sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = sourceType;
    [self presentViewController:picker animated:YES completion:nil];
    //    [picker release];
}
- (void)saveImage:(UIImage *)image {
    NSLog(@"保存");
    UIImageWriteToSavedPhotosAlbum(image, self, nil, nil);
}
#pragma mark Camera View Delegate Methods
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    [self performSelector:@selector(saveImage:)
               withObject:image
               afterDelay:0.5];
    //图片在imageview上显示
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.ImageButton setImage:info[UIImagePickerControllerEditedImage] forState:0];
    
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
