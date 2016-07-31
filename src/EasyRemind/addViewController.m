//
//  addViewController.m
//  takingNote
//
//  Created by 刘鑫 on 16/5/27.
//  Copyright © 2016年 LinXin. All rights reserved.
//

#import "addViewController.h"
#import "JZMTBtnView.h"
#import "SqliteManager.h"
#import "Bill.h"
#import <QuartzCore/QuartzCore.h>
#import "HJBcategory.h"

#define  PIC_WIDTH 80
#define  PIC_HEIGHT 80
#define  INSETS 10

#define kTheScreenWidth [UIScreen mainScreen].bounds.size.width
#define mainHeight     [[UIScreen mainScreen] bounds].size.height
#define mainWidth      [[UIScreen mainScreen] bounds].size.width

@interface addViewController ()<UIScrollViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIButton *photoButton;         ///<选择相册按钮
@property (weak, nonatomic) IBOutlet UISegmentedControl *incomeAndSpendingSg;   ///<收入和支出选择按钮
@property (weak, nonatomic) IBOutlet UITextField *categoryNameField;    ///<类别输入框
@property (weak, nonatomic) IBOutlet UIImageView *categoryImage;
@property (retain, nonatomic) UIScrollView * scrollView;
@property (retain, nonatomic) UIPageControl * pageControl;
@property (retain, nonatomic) NSMutableArray * imageArray;
@property (strong, nonatomic) SqliteManager * sqlManager;

@end

@implementation addViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.sqlManager = [[SqliteManager alloc]init];
    self.categoryImage.layer.cornerRadius=self.categoryImage.frame.size.height/2.0;
    self.categoryImage.layer.masksToBounds=YES;
    _imageArray=[[NSMutableArray alloc]init];
    NSString * plistPath=[[NSBundle mainBundle]pathForResource:@"expend" ofType:@"plist"];
    _imageArray=[[NSMutableArray alloc]initWithContentsOfFile:plistPath];
    [self setUpPage:_imageArray];
    self.categoryNameField.delegate=self;
}

#pragma mark - 保存按钮
- (IBAction)saveButton:(UIBarButtonItem *)sender {
    NSInteger index=self.incomeAndSpendingSg.selectedSegmentIndex;
    HJBCategory * theCategory=[[HJBCategory alloc]init];
    switch (index) {
        case 0:
            theCategory.categoryImageName=UIImageJPEGRepresentation(self.categoryImage.image, 0.8);
            theCategory.categoryName=self.categoryNameField.text;
            theCategory.isExpenditure=0;
            [self.sqlManager saveCategory:theCategory];
            break;
        case 1:
            theCategory.categoryImageName=UIImageJPEGRepresentation(self.categoryImage.image, 0.8);
            theCategory.categoryName=self.categoryNameField.text;
            theCategory.isExpenditure=1;
            
            [self.sqlManager saveCategory:theCategory];
            break;
            
        default:
            break;
    }
    NSLog(@"保存成功");
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 点击任意空白处键盘消失
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.categoryNameField resignFirstResponder];
}

#pragma mark - SrollView函数
- (void)setUpPage:(NSMutableArray *)menuArray{
    _scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 100, kTheScreenWidth, 160)];
    _scrollView.backgroundColor = [UIColor clearColor];
    _scrollView.contentSize = CGSizeMake(3*kTheScreenWidth, 160);
    _scrollView.pagingEnabled = YES;
    _scrollView.delegate = self;
    _scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_scrollView];
    
    UIView * page1=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kTheScreenWidth, 180)];
    page1.backgroundColor=[UIColor clearColor];
    [self.scrollView addSubview:page1];
    
    UIView * page2=[[UIView alloc]initWithFrame:CGRectMake(kTheScreenWidth, 0, kTheScreenWidth, 180)];
    page2.backgroundColor=[UIColor clearColor];
    [self.scrollView addSubview:page2];
    
    UIView * page3=[[UIView alloc]initWithFrame:CGRectMake(2*kTheScreenWidth, 0, kTheScreenWidth, 180)];
    page3.backgroundColor=[UIColor clearColor];
    [self.scrollView addSubview:page3];
    
    for(int i=0;i<=30;i++){
    if(i<5){
        CGRect frame=CGRectMake(i*kTheScreenWidth/5, 0, kTheScreenWidth/5, 80);
        NSString * title=[menuArray[i]objectForKey:@"name"];
        NSString * image=[menuArray[i]objectForKey:@"icon"];
        JZMTBtnView * theView=[[JZMTBtnView alloc]initWithFrame:frame title:title imageStr:image];
        theView.tag=10+i;
        [page1 addSubview:theView];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(OnTapBtnView:)];
        [theView addGestureRecognizer:tap];
        
    }else if(i<10){
        CGRect frame = CGRectMake((i-5)*kTheScreenWidth/5, 80, kTheScreenWidth/5, 60);
        NSString *title = [menuArray[i] objectForKey:@"name"];
        NSString *imageStr = [menuArray[i] objectForKey:@"icon"];
        JZMTBtnView *btnView = [[JZMTBtnView alloc] initWithFrame:frame title:title imageStr:imageStr];
        btnView.tag = 10+i;
        [page1 addSubview:btnView];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(OnTapBtnView:)];
        [btnView addGestureRecognizer:tap];

    }else if(i < 15){
        CGRect frame = CGRectMake((i-15)*kTheScreenWidth/5+kTheScreenWidth, 0, kTheScreenWidth/5, 80);
        NSString *title = [menuArray[i] objectForKey:@"name"];
        NSString *imageStr = [menuArray[i] objectForKey:@"icon"];
        JZMTBtnView *btnView = [[JZMTBtnView alloc] initWithFrame:frame title:title imageStr:imageStr];
        btnView.tag = 10+i;
        [page2 addSubview:btnView];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(OnTapBtnView:)];
        [btnView addGestureRecognizer:tap];

    }else if(i<20){
        CGRect frame = CGRectMake((i-20)*kTheScreenWidth/5+kTheScreenWidth, 80, kTheScreenWidth/5, 80);
        NSString *title = [menuArray[i] objectForKey:@"name"];
        NSString *imageStr = [menuArray[i] objectForKey:@"icon"];
        JZMTBtnView *btnView = [[JZMTBtnView alloc] initWithFrame:frame title:title imageStr:imageStr];
        btnView.tag = 10+i;
        [page2 addSubview:btnView];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(OnTapBtnView:)];
        [btnView addGestureRecognizer:tap];
        
    }else if(i < 25){
        CGRect frame = CGRectMake((i-25)*kTheScreenWidth/5+kTheScreenWidth, 0, kTheScreenWidth/5, 80);
        NSString *title = [menuArray[i] objectForKey:@"name"];
        NSString *imageStr = [menuArray[i] objectForKey:@"icon"];
        JZMTBtnView *btnView = [[JZMTBtnView alloc] initWithFrame:frame title:title imageStr:imageStr];
        btnView.tag = 10+i;
        [page3 addSubview:btnView];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(OnTapBtnView:)];
        [btnView addGestureRecognizer:tap];
        
    }else if(i < 29){
        CGRect frame = CGRectMake((i-30)*kTheScreenWidth/5+kTheScreenWidth, 80, kTheScreenWidth/5, 80);
        NSString *title = [menuArray[i] objectForKey:@"name"];
        NSString *imageStr = [menuArray[i] objectForKey:@"icon"];
        JZMTBtnView *btnView = [[JZMTBtnView alloc] initWithFrame:frame title:title imageStr:imageStr];
        btnView.tag = 10+i;
        [page3 addSubview:btnView];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(OnTapBtnView:)];
        [btnView addGestureRecognizer:tap];
    }
    }
}

- (void)refreshScrollView{
    CGFloat width=100*(self.imageArray.count)<300?320:100+self.imageArray.count*90;
    
    CGSize contentSize=CGSizeMake(width, 100);
    [_scrollView setContentSize:contentSize];
    [_scrollView setContentOffset:CGPointMake(width<320?0:width-320, 0) animated:YES];
    
}

- (void)OnTapBtnView:(UITapGestureRecognizer *)sender{
    NSString *title = [self.imageArray[sender.view.tag-10] objectForKey:@"name"];
    NSString *imageStr = [self.imageArray[sender.view.tag-10] objectForKey:@"icon"];
    self.categoryNameField.text = title;
    self.categoryImage.image = [UIImage imageNamed:imageStr];
}

#pragma mark -
- (IBAction)choosePicture:(UIButton *)sender {
    UIAlertController * alertController=[UIAlertController alertControllerWithTitle:@"" message:@"请选择" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction * cancelAction=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction * replaceAction=[UIAlertAction actionWithTitle:@"替换" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]){
            UIImagePickerController * picker=[[UIImagePickerController alloc]init];
            picker.delegate=self;
            picker.allowsEditing=YES;
            picker.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:picker animated:YES completion:^{
            }];
        }
    }];
    UIAlertAction * archiveAction=[UIAlertAction actionWithTitle:@"保存" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImageWriteToSavedPhotosAlbum(self.categoryImage.image, nil, nil,nil);
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:replaceAction];
//    [alertController addAction:archiveAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    [self dismissViewControllerAnimated:YES completion:^{
    }];
    self.categoryImage.image=info[UIImagePickerControllerEditedImage];
}

- (IBAction)incomeAndSpending:(UISegmentedControl *)sender {
}

@end

