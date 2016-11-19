//
//  ViewController.m
//  CalendarDemo
//
//  Created by 马海平 on 16/9/11.
//  Copyright © 2016年 马海平. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSLog(@"%ld",(long)[self getNumberOfDaysInMonth]);
    [self getDateInfo];
    [self strToDate];
    [self getAllDaysWithCalender];
    NSLog(@"%@",[self getweekDayWithDate:[NSDate date]]);
}

//1.获取当月的天数
- (NSInteger)getNumberOfDaysInMonth
{
    NSCalendar * calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian]; // 指定日历的算法
    NSDate * currentDate = [NSDate date];
    // 只要个时间给日历,就会帮你计算出来。这里的时间取当前的时间。
    NSRange range = [calendar rangeOfUnit:NSCalendarUnitDay
                                   inUnit: NSCalendarUnitMonth
                                  forDate:currentDate];
    return range.length;
}
/**
 *    NSCalendarUnitWeekday
 *     获取指定日期的年，月，日，星期，时,分,秒信息
 */
- (void) getDateInfo
{
    NSDate * date  = [NSDate date];
    NSCalendar * calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian]; // 指定日历的算法 NSCalendarIdentifierGregorian,NSGregorianCalendar
    // NSDateComponent 可以获得日期的详细信息，即日期的组成
    NSDateComponents *comps = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond|NSCalendarUnitWeekOfYear|NSCalendarUnitWeekOfMonth fromDate:date];
    
    NSLog(@"年 = year = %ld",comps.year);
    NSLog(@"月 = month = %ld",comps.month);
    NSLog(@"日 = day = %ld",comps.day);
    NSLog(@"时 = hour = %ld",comps.hour);
    NSLog(@"分 = minute = %ld",comps.minute);
    NSLog(@"秒 = second = %ld",comps.second);
    NSLog(@"星期 =weekDay = %ld ",comps.weekday);
    
}

// 日期和字符串之间的转换
- (void) strToDate
{
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"]; // 年-月-日 时:分:秒
    // 这个格式可以随便定义,比如：@"yyyy,MM,dd,HH,mm,ss"
    NSString * dateStr = @"2015-11-27 10:10:10";
    
    NSDate * date = [formatter dateFromString:dateStr];
    NSLog(@"the date = %@",date);
    
}



/**
 *  获取当月中所有天数是周几
 */
- (void) getAllDaysWithCalender
{
    NSUInteger dayCount = [self getNumberOfDaysInMonth]; //一个月的总天数
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    NSDate * currentDate = [NSDate date];
    [formatter setDateFormat:@"yyyy-MM"];
    NSString * str = [formatter stringFromDate:currentDate];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSMutableArray * allDaysArray = [[NSMutableArray alloc] init];
    for (NSInteger i = 1; i <= dayCount; i++) {
        NSString * sr = [NSString stringWithFormat:@"%@-%ld",str,i];
        NSDate *suDate = [formatter dateFromString:sr];
        [allDaysArray addObject:[self getweekDayWithDate:suDate]];
    }
    NSLog(@"allDaysArray %@",allDaysArray);
}

/**
 *  获得某天的数据
 *
 *  获取指定的日期是星期几
 */
- (id) getweekDayWithDate:(NSDate *) date
{
    NSCalendar * calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian]; // 指定日历的算法
    NSDateComponents *comps = [calendar components:NSCalendarUnitWeekday fromDate:date];
    
    // 1 是周日，2是周一 3.以此类推
    return @([comps weekday] -1 );
    
}

























- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
