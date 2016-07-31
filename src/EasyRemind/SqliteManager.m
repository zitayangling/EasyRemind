//
//  SqliteManager.m
//  HJB
//
//  Created by zitayangling on 16/5/17.
//  Copyright © 2016年 yangling. All rights reserved.
//

#import "SqliteManager.h"
#import "FMDB.h"

#define KDataBaseFile @"HJB.db"
#define kBillTable @"Bill"
#define KCategoryTable @"Category"
#define KPassWord @"PassWord"

@interface SqliteManager()

@property (strong,nonatomic) FMDatabase * db;

@end


@implementation SqliteManager


+ (SqliteManager *)sharedManager{
    static SqliteManager *theManager=nil;
    @synchronized (self){
        
        if (theManager==nil)
        {
            theManager=[[SqliteManager alloc]init];
        }
    }
    return theManager;
}

//寻找文件    沙盒文件
-(NSString *)DBfilepath{
  return  [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",KDataBaseFile]];
}

//创建数据库和表
-(instancetype)init{
    self=[super init];
    if (self) {
        
        //创建数据库
        NSString *path=[self DBfilepath];
        NSLog(@"%@",path);
        self.db=[FMDatabase databaseWithPath:path];
        if (![self.db open]) {
            NSLog(@"打开数据库／创建数据库失败");
            return nil;
        }
        // 创建表
        NSString *sqlStr=[NSString stringWithFormat:@"create table if not exists %@ (billID integer primary key,imageName data,categoryImage data,AccountingTime text,categoryID integer,categoryName text,remarks text,money float,income float,budget float,month text)",kBillTable];
        if (![self.db executeUpdate:sqlStr])
        {
            NSLog(@"打开／创建 %@失败 创建表语句 : %@",kBillTable,sqlStr);
            return nil;
        }
        
        sqlStr=[NSString stringWithFormat:@"create table if not exists %@ (CategoryID integer primary key ,CategoryName text,isExpenditure text ,CategoryImageName data)",KCategoryTable];
        if (![self.db executeUpdate:sqlStr])
        {
            NSLog(@"打开／创建 %@失败，创建表语句：%@",KCategoryTable,sqlStr);
            return nil;
        }
        sqlStr = [NSString stringWithFormat:@"create table if not exists %@ (passWord text primary key,passWordIndex text,fingerPassWordIndex text)",KPassWord];
        if (![self.db executeUpdate:sqlStr])
        {
            NSLog(@"打开／创建 %@失败，创建表语句：%@",KPassWord,sqlStr);
            return nil;
        }
    }
    return self;
}
#pragma mark ------------------账单----------------------------
-(float)oneDayOfmoney:(NSString * )year :(NSString *)month//某月总支出
{
    float money = 0.0;
    NSString * sqlStr = [NSString stringWithFormat:@"select sum(money) as Money from %@ where AccountingTime like '%@-%@-%@' order by strftime('%%d',AccountingTime) desc",kBillTable,year,month,@"%"];
//    return [self.db doubleForQuery:sqlStr];
    
    FMResultSet *str = [self.db executeQuery:sqlStr];
    while ([str next])
    {
        money = [str doubleForColumn:@"Money"];
    }
    
    
    return money;
}

-(float)oneDayOfIncome:(NSString * )year :(NSString *)month//某月总收入
{
    float income = 0.0;
    NSString * sqlStr = [NSString stringWithFormat:@"select sum(income) as Income from %@ where AccountingTime like '%@-%@-%@' order by strftime('%%d',AccountingTime) desc",kBillTable,year,month,@"%"];
    
    FMResultSet *str = [self.db executeQuery:sqlStr];
    while ([str next])
    {
        income = [str doubleForColumn:@"Income"];
    }
    return income;
}


-(float)monthOfSurplus:(NSString *)year :(NSString *)month
{
    float my = 0.0;
    NSString * sqlStr = [NSString stringWithFormat:@"select sum(income) - sum(money) as surplus from %@ where AccountingTime like '%@-%@-%@'",kBillTable,year,month,@"%"];
    FMResultSet *money = [self.db executeQuery:sqlStr];
    while ([money next])
    {
        my = [money doubleForColumn:@"surplus"];
    }
    return my;
}
-(float)monthOfMoney:(NSString *)year :(NSString *)month
{
    float my = 0.0;
    NSString * sqlStr = [NSString stringWithFormat:@"select sum(money) - sum(income) as Confluence from %@ where AccountingTime like '%@-%@-%@'",kBillTable,year,month,@"%"];
    FMResultSet *money = [self.db executeQuery:sqlStr];
    while ([money next])
    {
        my = [money doubleForColumn:@"Confluence"];
    }
    return my;
}

-(NSMutableArray *)allBill:(NSString *)year :(NSString *)month//每月账单
{
    NSMutableArray *array = [NSMutableArray array];
    NSString * sqlStr = [NSString stringWithFormat:@"select * from %@ where AccountingTime like '%@-%@-%@' order by strftime('%%d',AccountingTime) desc",kBillTable,year,month,@"%"];
    
    FMResultSet *result=[self.db executeQuery:sqlStr];
    
    while ([result next]) {
        Bill *bill=[[Bill alloc]init];
        bill.billID=@([result intForColumn:@"billID"]).stringValue;
        bill.imageName=[result dataForColumn:@"imageName"];
        bill.categoryID =  @([result intForColumn:@"categoryID"]).stringValue;
        bill.categoryName = [result stringForColumn:@"categoryName"];
        bill.remarks = [result stringForColumn:@"remarks"];
        bill.money = [result doubleForColumn:@"money"];
        bill.income = [result doubleForColumn:@"income"];
        bill.categoryImage = [result dataForColumn:@"categoryImage"];
        bill.budget = [result doubleForColumn:@"budget"];
        bill.AccountingTime = [result stringForColumn:@"AccountingTime"];
        [array addObject:bill];
    }
    return array;
    
}
-(NSMutableArray *)readMonth:(NSString *)year
{
    self.arry=[NSMutableArray array];
    NSString * sqlStr = [NSString stringWithFormat:@"select distinct strftime('%%m',AccountingTime) as time from %@ where AccountingTime like '%@-%@-%@' order by strftime('%%m',AccountingTime) asc",kBillTable,year,@"%",@"%"];
    
    FMResultSet *result=[self.db executeQuery:sqlStr];
    while ([result next])
    {
        NSString * timeStr = [result stringForColumn:@"time"];
        [self.arry addObject:timeStr];
    }
    return self.arry;
}
//根据日期读取账单

-(NSMutableArray *)readBillList:(NSString *)time{
    if (!time) {
        return nil;
    }
    self.arry=[NSMutableArray array];
    
    NSString *sqlStr=[NSString stringWithFormat:@"select * from %@ where AccountingTime= '%@'",kBillTable,time];
    FMResultSet *result=[self.db executeQuery:sqlStr];
    
    while ([result next]) {
        Bill *bill=[[Bill alloc]init];
        bill.billID=@([result intForColumn:@"billID"]).stringValue;
        bill.imageName=[result dataForColumn:@"imageName"];
        bill.categoryID =  @([result intForColumn:@"categoryID"]).stringValue;
        bill.categoryName = [result stringForColumn:@"categoryName"];
        bill.remarks = [result stringForColumn:@"remarks"];
        bill.money = [result doubleForColumn:@"money"];
        bill.income = [result doubleForColumn:@"income"];
        bill.categoryImage = [result dataForColumn:@"categoryImage"];
        bill.budget = [result doubleForColumn:@"budget"];
        bill.AccountingTime = [result stringForColumn:@"AccountingTime"];
        
        [self.arry addObject:bill];
    }
    return self.arry;
}

-(BOOL)saveBill:(Bill *)theBill{
    if (!theBill) {
        return NO;
    }
        NSString *sqlStr=[NSString stringWithFormat:@"delete from %@ where billID = %@",kBillTable,theBill.billID];
        if (![self.db executeUpdate:sqlStr]) {
            NSLog(@"清空表%@出错%@",kBillTable,self.db.lastErrorMessage);
        }
        NSString *sqlStr1=[NSString stringWithFormat:@"insert into %@ (billID,categoryID,categoryName,imageName,categoryImage,AccountingTime,remarks,money,income,budget,month) values (?,?,?,?,?,?,?,?,?,?,?)",kBillTable];
        if (![self.db executeUpdate:sqlStr1,theBill.billID,theBill.categoryID,theBill.categoryName,theBill.imageName,theBill.categoryImage,theBill.AccountingTime,theBill.remarks,@(theBill.money),@(theBill.income),@(theBill.budget),theBill.month])
        {
            NSLog(@"保存错误，错误代码是: %@",sqlStr1);
            return NO;
        }
    
    return YES;
}
-(BOOL)updateBill:(Bill *)theBill{
    if (!theBill) {
        return NO;
    }
    NSString *sqlStr=[NSString stringWithFormat:@"update %@ set categoryID=?,categoryName=?,imageName=?,categoryImage=?,AccountingTime=?,remarks=?,money=?,income=?,budget=? where billID=?",kBillTable];
    if (![self.db executeUpdate:sqlStr,theBill.categoryID,theBill.categoryName,theBill.imageName,theBill.categoryImage,theBill.AccountingTime,theBill.remarks,@(theBill.money),@(theBill.income),@(theBill.budget),theBill.billID]) {
        NSLog(@"修改数据出错，SQL语句是：%@ , 修改的账单日期为：%@",sqlStr,theBill.AccountingTime);
        return NO;
    }else
    {
        NSLog(@"修改数据成功，SQL语句是：%@ , 修改的账单日期为：%@",sqlStr,theBill.AccountingTime);
    }
    return YES;
}
-(BOOL)deleteBill:(Bill *)theBill
{
    NSString *sqlStr=[NSString stringWithFormat:@"delete from %@ where billID=%@",kBillTable,theBill.billID];
    if (![self.db executeUpdate:sqlStr])
    {
        NSLog(@"清空表%@出错%@",kBillTable,self.db.lastErrorMessage);
        return NO;
    }
    return YES;
}
-(BOOL)deleteAllBill
{
    NSString *sqlStr=[NSString stringWithFormat:@"delete from %@ ",KPassWord];
    if (![self.db executeUpdate:sqlStr])
    {
        NSLog(@"清空表%@出错%@",KPassWord,self.db.lastErrorMessage);
        return NO;
    }
    return YES;
}


#pragma mark ------------------类别---------------------

- (NSMutableArray *)readCategoryID {
    NSMutableArray *categoryArray = [NSMutableArray array];
    NSString * sqlStr=[NSString stringWithFormat:@"select * from Category "];
    FMResultSet *result=[self.db executeQuery:sqlStr];
    while ([result next]) {
        HJBCategory *category = [[HJBCategory alloc] init];
        
        category.categoryID=@([result intForColumn:@"CategoryID"]).stringValue;
        category.categoryImageName=[result dataForColumn:@"CategoryImageName"];
        category.categoryName = [result stringForColumn:@"CategoryName"];
        category.isExpenditure = [result intForColumn:@"isExpenditure"];
        
        [categoryArray addObject:category];
    }
    
    return categoryArray;
}

-(BOOL)saveCategory:(HJBCategory *)theCategory{
    if(!theCategory){
        return NO;
    }
    NSString *sqlStr=[NSString stringWithFormat:@"delete from %@ where CategoryID=%@",KCategoryTable,theCategory.categoryID];
    if (![self.db executeUpdate:sqlStr]) {
        NSLog(@"清空表%@出错%@",KCategoryTable,self.db.lastErrorMessage);
    }
    
    sqlStr=[NSString stringWithFormat:@"insert into %@ (CategoryID,CategoryImageName,CategoryName,IsExpenditure) values(%@,?,?,?)",KCategoryTable,theCategory.categoryID];
    
    if (![self.db executeUpdate:sqlStr,theCategory.categoryImageName,theCategory.categoryName,@(theCategory.isExpenditure)]) {
        NSLog(@"插入数据出错，SQL语句是：%@, 插入类别名称为： %@",sqlStr,theCategory.categoryName);
        return NO;
    }
    return YES;
}

-(BOOL)updateCategory:(HJBCategory *)theCategory{
    if (!theCategory) {
        return NO;
    }
    NSString *sqlStr=[NSString stringWithFormat:@"update %@ set CategoryName = ? where CategoryID = %@",KCategoryTable,theCategory.categoryID];
    if (![self.db executeUpdate:sqlStr,theCategory.categoryName,theCategory.categoryID]) {
        NSLog(@"修改数据出错，SQL语句是：%@ , 修改的类别名称为：%@",sqlStr,theCategory.categoryName);
        return NO;
    }else
    {
        NSLog(@"修改数据成功，SQL语句是：%@ , 修改的类别名称为：%@",sqlStr,theCategory.categoryName);
    }
    return YES;
}
-(BOOL)deleteCategory:(HJBCategory *)theCategory
{
    NSString *sqlStr=[NSString stringWithFormat:@"delete from %@ where CategoryID=%@",KCategoryTable,theCategory.categoryID];
    if (![self.db executeUpdate:sqlStr])
    {
        NSLog(@"清空表%@出错%@",KCategoryTable,self.db.lastErrorMessage);
        return NO;
    }
    return YES;
}

- (double)queryAllExpend{
    NSString *sqlStr = [NSString stringWithFormat:@"SELECT SUM(money) AS OrderTotal FROM %@ ",kBillTable];
    return [self.db doubleForQuery:sqlStr];
    
}
- (double)queryAllIncome{
    NSString *sqlStr = [NSString stringWithFormat:@"SELECT SUM(income)  AS OrderTotal FROM %@ ",kBillTable];
    return [self.db doubleForQuery:sqlStr];
}



#pragma mark ------------------设置---------------------
- (NSString *)queryPassWord {
    /** passWord 字段名 from 后面是 数据库表名称 */
    NSString *sqlStr = [NSString stringWithFormat:@"select passWord from %@",KPassWord];
    FMResultSet *reslust =  [self.db executeQuery:sqlStr];
    NSString * passWord;
    while ([reslust next]) {
        passWord = [reslust stringForColumn:@"passWord"];
    }
    return passWord;
}

- (NSMutableArray *)allCategoryID:(NSInteger)index {
    NSMutableArray *categoryArray = [NSMutableArray array];
    NSString * sqlStr=[NSString stringWithFormat:@"select * from Category where isExpenditure = %ld",index];
    FMResultSet *result=[self.db executeQuery:sqlStr];
    while ([result next]) {
        HJBCategory *category = [[HJBCategory alloc] init];
        
        category.categoryID=@([result intForColumn:@"CategoryID"]).stringValue;
        category.categoryImageName=[result dataForColumn:@"CategoryImageName"];
        category.categoryName = [result stringForColumn:@"CategoryName"];
        category.isExpenditure = [result intForColumn:@"isExpenditure"];
        
        [categoryArray addObject:category];
    }
    
    return categoryArray;
}

- (NSInteger)isExpenditure{
    NSString *sqlStr = [NSString stringWithFormat:@"select isExpenditure from %@ where isExpenditure=0",KCategoryTable];
    FMResultSet *reslust =  [self.db executeQuery:sqlStr];
    NSInteger index = 0;
    while ([reslust next]) {
        index = [reslust intForColumn:@"isExpenditure"];
    }
    return index;
}
- (NSInteger)isExpenditure1{
    NSString *sqlStr = [NSString stringWithFormat:@"select isExpenditure from %@ where isExpenditure=1",KCategoryTable];
    FMResultSet *reslust =  [self.db executeQuery:sqlStr];
    NSInteger index = 0;
    while ([reslust next]) {
        index = [reslust intForColumn:@"isExpenditure"];
    }
    return index;
}
- (NSInteger )selectPassWordIndex
{
    NSString *sqlStr = [NSString stringWithFormat:@"select passWordIndex from %@",KPassWord];
    FMResultSet *reslust = [self.db executeQuery:sqlStr];
    NSInteger index = 0;
    while ([reslust next]) {
        index = [reslust intForColumn:@"passWordIndex"];
    }
    return index;
}

- (NSInteger )selectFingerPassWordIndex
{
    NSString *sqlStr = [NSString stringWithFormat:@"select fingerPassWordIndex from %@",KPassWord];
    FMResultSet *reslust = [self.db executeQuery:sqlStr];
    NSInteger index = 0;
    while ([reslust next]) {
        index = [reslust intForColumn:@"fingerPassWordIndex"];
    }
    return index;
}

- (NSMutableArray *)selectAllBill {
    /** passWord 字段名 from 后面是 数据库表名称 */
    NSString *sqlStr = [NSString stringWithFormat:@"select passWordIndex,fingerPassWordIndex from %@",KPassWord];
    FMResultSet *reslust =  [self.db executeQuery:sqlStr];
    NSMutableArray * allIndex=[[NSMutableArray alloc]init];
    while ([reslust next]) {
        NSInteger passWordIndex = [reslust intForColumn:@"passWordIndex"];
        NSInteger fingerPassWordIndex = [reslust intForColumn:@"fingerPassWordIndex"];
        [allIndex addObjectsFromArray:@[@(passWordIndex),@(fingerPassWordIndex)]];
    }
    return allIndex;
}
-(BOOL)savePassWordIndex:(NSInteger)index{
    if (!index) {
        NSLog(@"密码开启状态保存失败");
        return NO;
    }
    Bill * theBill=[[Bill alloc]init];
    theBill.passWordIndex=index;
    /** UPDATE 表名称 SET 列名称 = 新值 WHERE 列名称 = 某值 */
    NSString *sqlStr1=[NSString stringWithFormat:@"update %@ set passWordIndex= '%ld'",KPassWord,theBill.passWordIndex];
    if (![self.db executeUpdate:sqlStr1,@(theBill.passWordIndex)])
    {
        NSLog(@"保存错误，错误代码是: %@",sqlStr1);
        return NO;
    }
    return YES;
}

- (BOOL)saveFingerPassWordIndex:(NSInteger)index{
    if (!index) {
        NSLog(@"指纹开启状态保存失败");
        return NO;
    }
    Bill * theBill=[[Bill alloc]init];
    theBill.fingerPassWordIndex=index;
    NSString *sqlStr1=[NSString stringWithFormat:@"update %@ set fingerPassWordIndex= '%ld'",KPassWord,theBill.fingerPassWordIndex];
    if (![self.db executeUpdate:sqlStr1,@(theBill.fingerPassWordIndex)])
    {
        NSLog(@"保存错误，错误代码是: %@",sqlStr1);
        return NO;
    }
    return YES;
}
-(BOOL)savePassWord:(NSString *)index:(NSInteger)passWordIndex:(NSInteger)fingerPassWordIndex{
    if (!index) {
        NSLog(@"保存失败");
        return NO;
    }
    Bill * theBill=[[Bill alloc]init];
    theBill.passWord=index;
    theBill.passWordIndex=passWordIndex;
    theBill.fingerPassWordIndex=fingerPassWordIndex;
    NSString *sqlStr1=[NSString stringWithFormat:@"insert into %@ (passWord,passWordIndex,fingerPassWordIndex) values (?,?,?)",KPassWord];
    if (![self.db executeUpdate:sqlStr1,theBill.passWord,@(theBill.passWordIndex),@(theBill.fingerPassWordIndex)])
    {
        NSLog(@"保存错误，错误代码是: %@",sqlStr1);
        return NO;
    }
    return YES;
}
-(BOOL)updatePassWord:(NSString *)passWord{
    NSString *sqlStr=[NSString stringWithFormat:@"update %@ set passWord= '%@'",KPassWord,passWord];
    if (![self.db executeUpdate:sqlStr]) {
        NSLog(@"修改数据出错，SQL语句是：%@ ",sqlStr);
        return NO;
    }else
    {
        NSLog(@"修改数据成功，SQL语句是：%@ ",sqlStr);
    }
    return YES;
}
#pragma mark -------------------- 饼图总收支 --------------------

/** 支出金额和计算出相同类别的支出金额 */
-(NSMutableArray *) queryCategory
{
    self.categoryArray = [NSMutableArray array];
    NSString *sqlStr = [NSString stringWithFormat:@"SELECT CategoryName,SUM(money) FROM %@ GROUP BY CategoryName",kBillTable];
    FMResultSet *result = [self.db executeQuery:sqlStr];
    while ([result next]){
        Bill *theBill = [[Bill alloc]init];
        theBill.SUM_money = [result stringForColumn:@"SUM(money)"];
        if(theBill.SUM_money == nil){
            
        }else{
            [self.categoryArray addObject:theBill.SUM_money];
        }
    }
    return self.categoryArray;
}
/** 支出类别名 */

-(NSMutableArray *) queryCategoryName
{
    self.categoryMoneyName = [NSMutableArray array];
    NSString *sqlStr = [NSString stringWithFormat:@"SELECT CategoryName,SUM(money) FROM %@ GROUP BY CategoryName",kBillTable];
    FMResultSet *result = [self.db executeQuery:sqlStr];
    while ([result next]){
        Bill *theBill = [[Bill alloc]init];
        theBill.categoryName = [result stringForColumn:@"categoryName"];
        if(theBill.categoryName == nil){
            
        }else{
            [self.categoryMoneyName addObject:theBill.categoryName];
        }
        
        
    }
    return self.categoryMoneyName;
}
/** 支出类别图片 */
-(NSMutableArray *) queryCategoryMoneyImage
{
    self.colorAtPixel = [[colorAtPixel alloc]init];
    self.categoryMoneyImage = [NSMutableArray array];
    NSString *sqlStr = [NSString stringWithFormat:@"SELECT CategoryName,categoryImage,SUM(money) FROM %@ GROUP BY CategoryName,categoryImage",kBillTable];
    FMResultSet *result = [self.db executeQuery:sqlStr];
    while ([result next]){
        Bill *theBill = [[Bill alloc]init];
        theBill.categoryImage = [result dataForColumn:@"categoryImage"];
        UIImage *image = [UIImage imageWithData:theBill.categoryImage];
        self.colorAtPixel = [[colorAtPixel alloc]initWithImage:image point:CGPointMake(30, 8)];
        UIColor *color = self.colorAtPixel.imageColor;
        if(theBill.categoryImage == nil){
            
        }else{
            [self.categoryMoneyImage addObject:color];
        }
        
    }
    return self.categoryMoneyImage;
}
/** 收入金额和计算出相同类别的收入金额 */
-(NSMutableArray *) queryCategoryIncome
{
    self.arry = [NSMutableArray array];
    NSString *sqlStr = [NSString stringWithFormat:@"SELECT CategoryName,SUM(income) FROM %@ GROUP BY CategoryName",kBillTable];
    FMResultSet *result = [self.db executeQuery:sqlStr];
    while ([result next]){
        Bill *theBill = [[Bill alloc]init];
        theBill.SUM_income = [result stringForColumn:@"SUM(income)"];
        if(theBill.SUM_income == nil){
            
        }else{
            [self.arry addObject:theBill.SUM_income];
        }
    }
    return self.arry;
}

/** 收入类别名 */
-(NSMutableArray *) queryCategoryIncomeName
{
    self.categoryName = [NSMutableArray array];
    NSString *sqlStr = [NSString stringWithFormat:@"SELECT CategoryName,SUM(income) FROM %@ GROUP BY CategoryName",kBillTable];
    FMResultSet *result = [self.db executeQuery:sqlStr];
    while ([result next]){
        Bill *theBill = [[Bill alloc]init];
        theBill.categoryName = [result stringForColumn:@"categoryName"];
        if(theBill.categoryName == nil){
            
        }else{
            [self.categoryName addObject:theBill.categoryName];
        }
        
        
    }
    return self.categoryName;
}
/** 收入类别图片 */
-(NSMutableArray *) queryCategoryIncomeImage
{
    self.colorAtPixel = [[colorAtPixel alloc]init];
    self.categoryIncomeImage = [NSMutableArray array];
    NSString *sqlStr = [NSString stringWithFormat:@"SELECT CategoryName,categoryImage,SUM(income) FROM %@ GROUP BY CategoryName,categoryImage",kBillTable];
    FMResultSet *result = [self.db executeQuery:sqlStr];
    while ([result next]){
        Bill *theBill = [[Bill alloc]init];
        theBill.categoryImage = [result dataForColumn:@"categoryImage"];
        
        UIImage *image = [UIImage imageWithData:theBill.categoryImage];
        self.colorAtPixel = [[colorAtPixel alloc]initWithImage:image point:CGPointMake(30, 8)];
        UIColor *color = self.colorAtPixel.imageColor;
        if(theBill.categoryImage == nil){
            
        }else{
            [self.categoryIncomeImage addObject:color];
        }
        
    }
    return self.categoryIncomeImage;
}
#pragma mark -------------------- 饼图月收支 --------------------
/** 月收入账单 */
-(NSMutableArray *)monthIncomeOfSurplus :(NSString *)month{
    self.monthArray = [NSMutableArray array];
    NSString * sqlStr = [NSString stringWithFormat:@"SELECT CategoryName,SUM(INCOME) FROM %@ WHERE month = '%@' GROUP BY CategoryName",kBillTable,month];
    FMResultSet *money = [self.db executeQuery:sqlStr];
    while ([money next])
    {
        Bill * bill = [Bill new];
        bill.month_income  = [money stringForColumn:@"SUM(income)"];
        if(bill.month_income == nil){
            
        }else{
            [self.monthArray addObject:bill.month_income];
        }
    }
    return self.monthArray;
}
-(NSMutableArray *)monthIncomeNameOfSurplus :(NSString *)month{
    self.monthName = [NSMutableArray array];
    NSString *sqlStr = [NSString stringWithFormat:@"SELECT CategoryName,SUM(INCOME) FROM %@ WHERE month = '%@' GROUP BY CategoryName",kBillTable,month];
    FMResultSet *money = [self.db executeQuery:sqlStr];
    while ([money next]) {
        Bill *bill = [Bill new];
        bill.categoryName = [money stringForColumn:@"CategoryName"];
        if(bill.categoryName == nil){
            
        }else{
            [self.monthName addObject:bill.categoryName];
        }
        
    }
    return self.monthName;
}
-(NSMutableArray *)monthIncomeImageOfSurplus :(NSString *)month{
    self.monthImage = [NSMutableArray array];
    NSString *sqlStr = [NSString stringWithFormat:@"SELECT CategoryName,CategoryImage,SUM(INCOME) FROM %@ WHERE month = '%@' GROUP BY CategoryName,CategoryImage",kBillTable,month];
    FMResultSet *money = [self.db executeQuery:sqlStr];
    while ([money next]) {
        Bill *bill = [Bill new];
        bill.categoryImage = [money dataForColumn:@"CategoryImage"];
        
        UIImage *image = [UIImage imageWithData:bill.categoryImage];
        self.colorAtPixel = [[colorAtPixel alloc]initWithImage:image point:CGPointMake(30, 8)];
        UIColor *color = self.colorAtPixel.imageColor;
        
        if(bill.categoryImage == nil){
            
        }else{
            [self.monthImage addObject:color];
        }
        
    }
    return self.monthImage;
}
/** 月支出账单 */
-(NSMutableArray *)monthMoneyOfSurplus :(NSString *)month{
    self.monthArray = [NSMutableArray array];
    NSString * sqlStr = [NSString stringWithFormat:@"SELECT CategoryName,SUM(MONEY) FROM %@ WHERE month = '%@' GROUP BY CategoryName",kBillTable,month];
    FMResultSet *money = [self.db executeQuery:sqlStr];
    while ([money next])
    {
        Bill * bill = [Bill new];
        bill.month_money  = [money stringForColumn:@"SUM(money)"];
        if(bill.month_money == nil){
            
        }else{
            [self.monthArray addObject:bill.month_money];
        }
    }
    return self.monthArray;
}
-(NSMutableArray *)monthMoneyNameOfSurplus :(NSString *)month{
    self.monthName = [NSMutableArray array];
    NSString *sqlStr = [NSString stringWithFormat:@"SELECT CategoryName,SUM(MONEY) FROM %@ WHERE month = '%@' GROUP BY CategoryName",kBillTable,month];
    FMResultSet *money = [self.db executeQuery:sqlStr];
    while ([money next]) {
        Bill *bill = [Bill new];
        bill.categoryName = [money stringForColumn:@"CategoryName"];
        if(bill.categoryName == nil){
            
        }else{
            [self.monthName addObject:bill.categoryName];
        }
    }
    return self.monthName;
}
-(NSMutableArray *)monthMoneyImageOfSurplus :(NSString *)month{
    self.monthImage = [NSMutableArray array];
    NSString *sqlStr = [NSString stringWithFormat:@"SELECT CategoryName,CategoryImage,SUM(MONEY) FROM %@ WHERE month = '%@' GROUP BY CategoryName,CategoryImage",kBillTable,month];
    FMResultSet *money = [self.db executeQuery:sqlStr];
    while ([money next]) {
        Bill *bill = [Bill new];
        bill.categoryImage = [money dataForColumn:@"CategoryImage"];
        
        
        UIImage *image = [UIImage imageWithData:bill.categoryImage];
        self.colorAtPixel = [[colorAtPixel alloc]initWithImage:image point:CGPointMake(30, 8)];
        UIColor *color = self.colorAtPixel.imageColor;
        if(bill.categoryImage == nil){
            
        }else{
            [self.monthImage addObject:color];
        }
    }
    return self.monthImage;
}
#pragma mark -------------------- 计算总收支金额 --------------------
/** 计算总收入 */
- (NSString *) calculateAllIncome
{
    self.allIncome = [[NSString alloc]init];
    NSString *sqlStr = [NSString stringWithFormat:@"SELECT SUM(INCOME) FROM %@",kBillTable];
    FMResultSet *result = [self.db executeQuery:sqlStr];
    while ([result next]){
        Bill *theBill = [[Bill alloc]init];
        theBill.allIncome = [result stringForColumn:@"SUM(INCOME)"];
        
        self.allIncome = theBill.allIncome;
    }
    return self.allIncome;
}
/** 总支出 */
- (NSString *) calculateAllMoney
{
    self.allMoney = [[NSString alloc]init];
    NSString *sqlStr = [NSString stringWithFormat:@"SELECT SUM(MONEY) FROM %@",kBillTable];
    FMResultSet *result = [self.db executeQuery:sqlStr];
    while ([result next]){
        Bill *theBill = [[Bill alloc]init];
        theBill.allMoney = [result stringForColumn:@"SUM(MONEY)"];
        
        self.allMoney = theBill.allMoney;
    }
    return self.allMoney;
}
#pragma mark -------------------- 计算月收支金额 --------------------
/** 月总收入 */
- (NSString *)calculateMonthIncome :(NSString *)month
{
    self.monthIncome = [[NSString alloc]init];
    NSString *sqlStr = [NSString stringWithFormat:@"SELECT SUM(INCOME) FROM %@  WHERE MONTH = '%@'",kBillTable,month];
    FMResultSet *result = [self.db executeQuery:sqlStr];
    while ([result next]){
        Bill *theBill = [[Bill alloc]init];
        theBill.allMonthIncome = [result stringForColumn:@"SUM(INCOME)"];
        
        self.monthIncome = theBill.allMonthIncome;
    }
    return self.monthIncome;
}
/** 月总支出 */
- (NSString *)calculateMonthMoney :(NSString *)month
{
    self.monthMoney = [[NSString alloc]init];
    NSString *sqlStr = [NSString stringWithFormat:@"SELECT SUM(MONEY) FROM %@  WHERE MONTH = '%@'",kBillTable,month];
    FMResultSet *result = [self.db executeQuery:sqlStr];
    while ([result next]){
        Bill *theBill = [[Bill alloc]init];
        theBill.allMonthIncome = [result stringForColumn:@"SUM(MONEY)"];
        
        self.monthMoney = theBill.allMonthIncome;
    }
    return self.monthMoney;
}
#pragma mark - 计算时间
-(NSMutableArray *)calculateTime
{
    self.timeArray = [NSMutableArray array];
    NSString *sqlStr = [NSString stringWithFormat:@"SELECT month,SUM(money) FROM %@ GROUP BY month",kBillTable];
    FMResultSet *result = [self.db executeQuery:sqlStr];
    while ([result next]){
        Bill *theBill = [[Bill alloc]init];
        theBill.month = [result stringForColumn:@"month"];
        
        NSLog(@"%@",theBill.month);
        
        [self.timeArray addObject:theBill.month];
    }
    return self.timeArray;
}


@end
