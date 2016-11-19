//
//  CalendarVC.m
//  CalendarDemo
//
//  Created by 马海平 on 16/9/18.
//  Copyright © 2016年 马海平. All rights reserved.
//

#import "CalendarVC.h"
#import "CollectionViewCell.h"
#import "UIColor+ZXLazy.h"

#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define SCREEN_WIDTH  [UIScreen mainScreen].bounds.size.width


@interface CalendarVC ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *collectionViewLayout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leading;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *trailing;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomLayoutContain;

@property (nonatomic , strong) NSArray *weekDayArray;
@property (nonatomic , strong) NSDate *date;
@property (nonatomic , strong) NSDate *today;

@end

@implementation CalendarVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self getFirstDayDate];
    
    
    _collectionView.backgroundColor = [UIColor yellowColor];
    
    NSInteger a = SCREEN_WIDTH /7;
    CGFloat b = (SCREEN_WIDTH - a * 7)/2;
    
    self.leading.constant = self.trailing.constant = b;
    
    _weekDayArray = @[@"日",@"一",@"二",@"三",@"四",@"五",@"六"];
    _date = [NSDate date];
    _today = _date;
    _date = [NSDate dateWithTimeInterval:30 * 24*60*60 sinceDate:_date];
    
    // Do any additional setup after loading the view.
    _collectionViewLayout.itemSize = CGSizeMake((SCREEN_WIDTH- b * 2)/7, (SCREEN_WIDTH- b * 2)/7);//宽高
    // 设置列的最小间距，cell之间的距离
    _collectionViewLayout.minimumInteritemSpacing = 0;
    // 设置最小行间距
    _collectionViewLayout.minimumLineSpacing = 0;
    // 设置布局的内边距
    _collectionViewLayout.sectionInset = UIEdgeInsetsMake(15, 15, 15, 15);
    _collectionViewLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    // 滚动方向
    _collectionViewLayout.scrollDirection = UICollectionViewScrollDirectionVertical;//纵向滑动
    
    
//    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    //如果在SB中设置了identifier这里就可以不写这句，但是如果两处都不写的话就会导致崩溃
    
}

#pragma -mark collectionView delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 2;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 0) {
        return _weekDayArray.count;
    } else {
        NSInteger rows = [self firstWeekdayInThisMonth:_date] + [self totaldaysInMonth:_date] + 7;
        CALayer * layer = [[CALayer alloc]init];
        layer.backgroundColor = [UIColor redColor].CGColor;
        if (rows%7 == 0) {
            layer.frame = CGRectMake(0,  (rows/7) * _collectionViewLayout.itemSize.height, SCREEN_WIDTH, 0.5);
        }else{
            layer.frame = CGRectMake(0,  (rows/7 + 1) * _collectionViewLayout.itemSize.height, SCREEN_WIDTH, 0.5);
        }
        [_collectionView.layer addSublayer:layer];
        _bottomLayoutContain.constant = SCREEN_HEIGHT - 64 - 1 - layer.frame.origin.y;
        return rows;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"cell";
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
    cell.label.font = [UIFont systemFontOfSize:15 - indexPath.section];
    if (indexPath.section == 0) {
        [cell.label setText:_weekDayArray[indexPath.row]];
        [cell.label setTextColor:[UIColor redColor]];
    } else {
        NSInteger daysInThisMonth = [self totaldaysInMonth:_date];
        NSInteger firstWeekday = [self firstWeekdayInThisMonth:_date];
        
        NSInteger day = 0;
        NSInteger i = indexPath.row;
        
        if (i < firstWeekday) {
            [cell.label setText:@""];
            
        }else if (i > firstWeekday + daysInThisMonth - 1){
            [cell.label setText:@""];
        }else{
            day = i - firstWeekday + 1;
            [cell.label setText:[NSString stringWithFormat:@"%li",(long)day]];
            [cell.label setTextColor:[UIColor colorWithHexString:@"#6f6f6f"]];
            
//            //this month
//            if ([_today isEqualToDate:_date]) {
//                
//            } else if ([_today compare:_date] == NSOrderedAscending) {
//                [cell.label setTextColor:[UIColor colorWithHexString:@"#cbcbcb"]];
//            }
//            [calendar setFirstWeekday:1];//1.Sun. 2.Mon. 3.Thes. 4.Wed. 5.Thur. 6.Fri. 7.Sat.
            
            BOOL m = [self getweekDayWithDate:[self getDateWithNumber:(i- firstWeekday)]];//周末
            if (m) {
                [cell.label setTextColor:[UIColor redColor]];
            }else{
                cell.label.textColor = day > [self day:_date] ? [UIColor colorWithHexString:@"#cbcbcb"] : [UIColor colorWithHexString:@"#4898eb"];
            }
            if (day == [self day:_date]) {
                cell.label.textColor = [UIColor whiteColor];
                cell.label.backgroundColor = [UIColor redColor];
                cell.label.layer.cornerRadius = 10.5;
                cell.label.layer.masksToBounds = YES;
            }
        }
    }
    CALayer * layer = [[CALayer alloc]init];
//    layer.frame = CGRectMake(0,  SCREEN_WIDTH/7-1, SCREEN_WIDTH/7, 1);
    layer.frame = CGRectMake(0,  0, SCREEN_WIDTH/7, 0.5);
    layer.backgroundColor = [UIColor blackColor].CGColor;
    [cell.contentView.layer addSublayer:layer];
    return cell;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        NSInteger daysInThisMonth = [self totaldaysInMonth:_date];
        NSInteger firstWeekday = [self firstWeekdayInThisMonth:_date];
        
        NSInteger day = 0;
        NSInteger i = indexPath.row;
        
        if (i >= firstWeekday && i <= firstWeekday + daysInThisMonth - 1) {
            day = i - firstWeekday + 1;
            
            //this month
            if ([_today isEqualToDate:_date]) {
                if (day <= [self day:_date]) {
                    return YES;
                }
            } else if ([_today compare:_date] == NSOrderedDescending) {
                return YES;
            }
        }
    }
    return NO;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section) {
        NSInteger daysInThisMonth = [self totaldaysInMonth:_date];
        NSInteger firstWeekday = [self firstWeekdayInThisMonth:_date];
        
        NSInteger day = 0;
        NSInteger i = indexPath.row;
        
        if ( i > firstWeekday && i < firstWeekday + daysInThisMonth - 1) {
            
            day = i - firstWeekday + 1;
            NSLog(@"hahha %ld",(long)day);
        }
    }
}


#pragma mark - date

- (NSInteger)day:(NSDate *)date{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    return [components day];
}


- (NSInteger)month:(NSDate *)date{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    return [components month];
}

- (NSInteger)year:(NSDate *)date{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    return [components year];
}

static NSDate *firstDayOfMonthDate;
- (NSInteger)firstWeekdayInThisMonth:(NSDate *)date{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    [calendar setFirstWeekday:1];//1.Sun. 2.Mon. 3.Thes. 4.Wed. 5.Thur. 6.Fri. 7.Sat.
    NSDateComponents *comp = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    [comp setDay:1];
    firstDayOfMonthDate = [calendar dateFromComponents:comp];
    
    NSUInteger firstWeekday = [calendar ordinalityOfUnit:NSCalendarUnitWeekday inUnit:NSCalendarUnitWeekOfMonth forDate:firstDayOfMonthDate];
    return firstWeekday - 1;
}

- (NSInteger)totaldaysInThisMonth:(NSDate *)date{
    NSRange totaldaysInMonth = [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
    return totaldaysInMonth.length;
}

- (NSInteger)totaldaysInMonth:(NSDate *)date{
    NSRange daysInLastMonth = [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
    return daysInLastMonth.length;
}

- (NSDate *)lastMonth:(NSDate *)date{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.month = -1;
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:date options:0];
    return newDate;
}

- (NSDate*)nextMonth:(NSDate *)date{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.month = +1;
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:date options:0];
    return newDate;
}

/**
 获取传入日期是否是不是周末

 @param date 传入的日期

 @return 是否是周末
 */
- (BOOL) getweekDayWithDate:(NSDate *) date
{
    NSCalendar * calendar = [[NSCalendar currentCalendar] initWithCalendarIdentifier:NSCalendarIdentifierGregorian]; // 指定日历的算法
    NSDateComponents *comps = [calendar components:NSCalendarUnitWeekday fromDate:date];
    
    
    if ([comps weekday] == 1|| [comps weekday] == 7) {
        return YES;
    }else{
        return NO;
    }
    // 1 是周日，2是周一 3.以此类推
    return @([comps weekday] );
    
}

/**
 获取当前月第number天的NSDate
 @param number 当前月第多少天
 @return 返回当前月第number天的NSDate
 */
- (NSDate *)getDateWithNumber:(NSInteger)number {
    NSDate * date = [NSDate dateWithTimeInterval:3600 * 24 * (number)sinceDate:firstDayOfMonthDate];
    return date;
}


/**
获取当前月的第一天的NSDate
 @return 当前月的第一天的NSDate
 */
//- (NSDate *)getFirstDayDate{
//    NSCalendar *calendar = [NSCalendar currentCalendar];
//    NSDateComponents *comp = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:[NSDate date]];
//    [comp setDay:1];
//    firstDayOfMonthDate = [calendar dateFromComponents:comp];
//    firstDayOfMonthDate = [NSDate dateWithTimeInterval:3600 * 8 sinceDate:firstDayOfMonthDate];
//    return firstDayOfMonthDate;
//}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
