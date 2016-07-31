//
//  UpadateViewController.m
//  HJB
//
//  Created by 周建臣 on 16/5/29.
//  Copyright © 2016年 yangling. All rights reserved.
//

#import "UpadateViewController.h"
#import "JZMTBtnView.h"


#define screen_width [UIScreen mainScreen].bounds.size.width
#define screen_height [UIScreen mainScreen].bounds.size.height

@interface UpadateViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UICollectionViewDataSource,UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *moneyText;//支出
@property (weak, nonatomic) IBOutlet UITextField *categortText;
@property (weak, nonatomic) IBOutlet UIImageView *photoImage;
@property (weak, nonatomic) IBOutlet UIImageView *categoryImage;
@property (strong, nonatomic) JZMTBtnView *theCategory;
//@property (strong, nonatomic) NSMutableArray *categoryArr;
@property (weak, nonatomic) IBOutlet UISegmentedControl *selectSG;
@property (assign, nonatomic) NSInteger Segindex;
@property (weak, nonatomic) IBOutlet UICollectionView *CollectionView;



@end

@implementation UpadateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.CollectionView.delegate = self;
    self.CollectionView.dataSource = self;
    self.SQLmanager = [[SqliteManager alloc]init];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"back"]];
    self.theCategory = [[JZMTBtnView alloc]init];
    self.navigationItem.title = self.theBill.AccountingTime;
    if (self.Segindex ==0) {
         self.moneyText.text = @(self.theBill.money).stringValue;
        if (self.theBill.income ==0) {
            self.moneyText.text = @(self.theBill.money).stringValue;
            self.selectSG.selectedSegmentIndex = 0;
        }else
        {
                   self.moneyText.text = @(self.theBill.income).stringValue;
            self.selectSG.selectedSegmentIndex =1;
        }
    }

        self.navigationItem.title = self.theBill.AccountingTime;

    self.categortText.text = self.theBill.categoryName;
    self.categoryImage.image = [UIImage imageWithData:self.theBill.categoryImage];
    if (self.theBill.imageName == nil) {
    }else
    {
        self.photoImage.image = [UIImage imageWithData:self.theBill.imageName];

    }
    
    //设置圆角
    self.categoryImage.layer.cornerRadius = self.categoryImage.frame.size.height/2;
    self.categoryImage.layer.masksToBounds = YES;
    
    self.photoImage.layer.cornerRadius = self.categoryImage.frame.size.height/2;
    self.photoImage.layer.masksToBounds = YES;
    
    // Do any additional setup after loading the view.
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
}

#pragma mark 添加滑动视图


- (IBAction)addPhoto:(UIButton *)sender {
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
#pragma mark –
#pragma mark Camera View Delegate Methods
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    [self performSelector:@selector(saveImage:)
               withObject:image
               afterDelay:0.5];
    //图片在imageview上显示
    [self dismissViewControllerAnimated:YES completion:nil];
    self.photoImage.image = info[UIImagePickerControllerEditedImage];
    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)ModifyButton:(UIBarButtonItem *)sender {
    Bill *aBill = [Bill new];
    NSInteger index = self.selectSG.selectedSegmentIndex;
    switch (index) {
        case 0:
            aBill.billID = self.theBill.billID;
            if (self.navigationItem.title == nil) {
                NSDate *date = [NSDate date];
                NSDateFormatter *dateFormatter = [NSDateFormatter new];
                [dateFormatter setDateFormat:@"yyyy-MM-dd"];
                NSString *dateStr = [dateFormatter stringFromDate:date];
                aBill.AccountingTime = dateStr;
            }else{
                aBill.AccountingTime = self.navigationItem.title;}
            aBill.categoryName = self.categortText.text;
            aBill.money = self.moneyText.text.floatValue;
            aBill.categoryImage = UIImageJPEGRepresentation(self.categoryImage.image, 0.8);
            aBill.imageName = UIImageJPEGRepresentation(self.photoImage.image, 0.8);
            
            [self.SQLmanager updateBill:aBill];
            break;
          case 1:
            aBill.billID = self.theBill.billID;
            aBill.AccountingTime = self.navigationItem.title;
            aBill.categoryName = self.categortText.text;
            aBill.income = self.moneyText.text.floatValue;
            aBill.categoryImage = UIImageJPEGRepresentation(self.categoryImage.image, 0.8);
            aBill.imageName = UIImageJPEGRepresentation(self.photoImage.image, 0.8);
            
            [self.SQLmanager updateBill:aBill];
            break;
            
        default:
            break;
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
    categoryArray = [[SqliteManager sharedManager] allCategoryID:0];
    return categoryArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    //    NSString * path = [[NSBundle mainBundle]pathForResource:@"expend" ofType:@"plist"];
    //    NSMutableArray * categoryArray = [[NSMutableArray alloc]initWithContentsOfFile:path];
    //
    //    NSString * imageStr = [categoryArray[indexPath.row]objectForKey:@"icon"];
    //    NSString * name = [categoryArray[indexPath.row]objectForKey:@"name"];
    
    NSMutableArray *categoryARR = [NSMutableArray array];
    categoryARR = [[SqliteManager sharedManager] allCategoryID:0];
    HJBCategory *category = categoryARR [(indexPath.row)];
    
    UIImageView *imageView = [cell viewWithTag:100];
    imageView.image = [UIImage imageWithData:category.categoryImageName];
    imageView.layer.cornerRadius = imageView.frame.size.height/2;
    imageView.layer.masksToBounds = YES;
    
    //
    //    self.HJBManager.categoryImageName = UIImageJPEGRepresentation(imageView.image, 0.8);
    //    [[SqliteManager sharedManager] saveCategory:self.HJBManager];
    UILabel *label = [cell viewWithTag:200];
    label.text = category.categoryName;
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray * categoryArray =[NSMutableArray array];
    categoryArray = [[SqliteManager sharedManager] allCategoryID:0];
    HJBCategory *Categ = categoryArray[indexPath.row];
    self.categoryImage.image = [UIImage imageWithData:Categ.categoryImageName];
    self.categortText.text = Categ.categoryName;
    
    
    
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
