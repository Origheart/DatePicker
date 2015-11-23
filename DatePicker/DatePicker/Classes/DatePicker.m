//
//  DatePicker.m
//  ZSJDatePicker
//
//  Created by 刘康 on 15/9/23.
//  Copyright © 2015年 zugesiji. All rights reserved.
//

#import "DatePicker.h"

@interface DatePicker () <UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, strong) UIPickerView* picker;

@property (nonatomic, strong) UIView* titleContainer;

@property (nonatomic, strong) UIButton* cancelButton;

@property (nonatomic, strong) UIButton* confirmButton;

@property (nonatomic, strong) UILabel* titleLabel;

@property (nonatomic, strong) NSMutableArray* dates;

@property (nonatomic, strong) NSMutableArray* hours;

@property (nonatomic, strong) NSMutableArray* minutes;

@property (nonatomic, strong) NSDate* pickedDate;

@end

@implementation DatePicker

#pragma mark - Private Methods

- (void)checkSelectedDateIsValid
{
    NSString* selectedDate = self.dates[[self.picker selectedRowInComponent:0]];
    NSString* dateStr = [NSString stringWithFormat:@"%@ %@:%@:00",
                         selectedDate,
                         self.hours[[self.picker selectedRowInComponent:1]],
                         self.minutes[[self.picker selectedRowInComponent:2]]];
    NSDate* date = [[self timeFormatter] dateFromString:dateStr];
    NSLog(@"selected dateStr: %@\nselected date:%@",date, dateStr);
    
    NSDate* minDate = [[NSDate date] dateByAddingTimeInterval:[self.delegate minimumDurationInDatePicker:self]];
    NSDate* maxDate = [[NSDate date] dateByAddingTimeInterval:[self.delegate numberOfHoursInDatePicker:self] * 60 * 60];
    
    if ([date compare:minDate] == NSOrderedAscending) {
        [self updateSelectedDateToDefault];
    }
    
    if ([date compare:maxDate] == NSOrderedDescending) {
        [self adjustSelectedDate:[[NSDate date] dateByAddingTimeInterval:[self.delegate numberOfHoursInDatePicker:self] * 60 * 60]];
    }
}

- (void)adjustSelectedDate:(NSDate*)theDate
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSInteger year;
    NSInteger month;
    NSInteger day;
    NSInteger hour;
    NSInteger minute;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated"
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        [calendar getEra:NULL year:&year month:&month day:&day fromDate:theDate];
        [calendar getHour:&hour minute:&minute second:NULL nanosecond:NULL fromDate:theDate];
    } else {
        NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit;
        NSDateComponents* dateComponents = [calendar components:unitFlags fromDate:theDate];
        year    = [dateComponents year];
        month   = [dateComponents month];
        day     = [dateComponents day];
        hour    = [dateComponents hour];
        minute  = [dateComponents minute];
    }
#pragma clang diagnostic pop
    minute = minute + (5 - minute%5);
    
    if (minute > 55) {
        minute = 0;
        if (hour < 23) {
            hour++;
        } else if (hour == 23) {
            hour = 0;
            day++;
        }
    } else {
        if (hour == 0) {
           
        }
    }
    
    NSString* dateStr = [NSString stringWithFormat:@"%04d-%02d-%02d", (int)year, (int)month, (int)day];
    NSString* hourStr = [NSString stringWithFormat:@"%02d", (int)hour];
    NSString* minuteStr = [NSString stringWithFormat:@"%02d", (int)minute];
    [self.picker selectRow:[self.dates indexOfObject:dateStr] inComponent:0 animated:YES];
    [self.picker selectRow:[self.hours indexOfObject:hourStr] inComponent:1 animated:YES];
    [self.picker selectRow:[self.minutes indexOfObject:minuteStr] inComponent:2 animated:YES];
}

- (void)updateSelectedDateToDefault
{
    [self adjustSelectedDate:[[NSDate date] dateByAddingTimeInterval:[self.delegate minimumDurationInDatePicker:self]]];
}

- (NSDateFormatter*)timeFormatter
{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"YYYY-MM-dd HH:mm:ss";
    return formatter;
}

- (NSDateFormatter*)dateFormatter
{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"YYYY-MM-dd";
    return formatter;
}

#pragma mark - UIPickerViewDelegate & UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0) {
        return self.dates.count;
    } else if (component == 1) {
        return self.hours.count;
    } else {
        return self.minutes.count;
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    [self checkSelectedDateIsValid];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    if (component == 0) {
        return self.frame.size.width / 2;
    } {
        return self.frame.size.width / 4;
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 44;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    if (!view) {
        view = [[UIView alloc] init];
    }
    CGFloat width = component == 0 ? self.frame.size.width / 2 : self.frame.size.width / 4;
    UILabel* text = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, 44)];
    text.textAlignment = NSTextAlignmentCenter;
    if (component == 0) {
        switch (row) {
            case 0:
                text.text = [NSString stringWithFormat:@"今天 %@", self.dates[row]];
                break;
            case 1:
                text.text = [NSString stringWithFormat:@"明天 %@", self.dates[row]];
                break;
            case 2:
                text.text = [NSString stringWithFormat:@"后天 %@", self.dates[row]];
                break;
                
            default:
                text.text = self.dates[row];
                break;
        }
    } else if (component == 1) {
        text.text = self.hours[row];
    } else {
        text.text = self.minutes[row];
    }
    [view addSubview:text];
    return view;
}

#pragma mark - LifeCycle

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self initialize];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self initialize];
    }
    return self;
}

- (void)initialize
{
    self.backgroundColor = [UIColor colorWithRed:0.92 green:0.92 blue:0.92 alpha:1.f];
    [self addSubview:self.titleContainer];
    [self addSubview:self.picker];
}

- (void)dealloc
{
    NSLog(@"DatePicker dealloc");
}

#define HeightOfTitle       44

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.titleContainer.frame = CGRectMake(0, 0, self.frame.size.width, HeightOfTitle);
    self.cancelButton.frame = CGRectMake(0, 0, 50, HeightOfTitle);
    self.confirmButton.frame = CGRectMake(self.frame.size.width - 50, 0, 50, HeightOfTitle);
    self.titleLabel.frame = CGRectMake(self.cancelButton.frame.origin.x + self.cancelButton.frame.size.width, 0, self.frame.size.width - 50 * 2, HeightOfTitle);
    self.picker.frame = CGRectMake(0, self.titleContainer.frame.size.height, self.frame.size.width, self.frame.size.height - self.titleContainer.frame.size.height);
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    UIBezierPath* path = [UIBezierPath bezierPath];
    CGFloat startPointY = (self.frame.size.height - HeightOfTitle) / 2 + HeightOfTitle / 2;
    [path moveToPoint:CGPointMake(0, startPointY)];
    [path addLineToPoint:CGPointMake(self.frame.size.width, startPointY)];
    [path addLineToPoint:CGPointMake(self.frame.size.width, startPointY + HeightOfTitle)];
    [path addLineToPoint:CGPointMake(0, startPointY + HeightOfTitle)];
    [path closePath];
    [[UIColor whiteColor] setFill];
    [path fill];
    CGContextRestoreGState(context);
}

#pragma mark - Actions & Target

- (void)cancelButtonTapped:(UIButton*)sender
{
    if ([self.delegate respondsToSelector:@selector(datePickerDidCancelPickDate)]) {
        [self.delegate datePickerDidCancelPickDate];
    }
}

- (void)confirmButtonTapped:(UIButton*)sender
{
    if ([self.delegate respondsToSelector:@selector(datePicker:didPickDate:)]) {
        [self.delegate datePicker:self didPickDate:self.pickedDate];
    }
}

#pragma mark - Getters

- (NSDate *)pickedDate
{
    NSString* selectedDate = self.dates[[self.picker selectedRowInComponent:0]];
    NSString* dateStr = [NSString stringWithFormat:@"%@ %@:%@:00",
                         selectedDate,
                         self.hours[[self.picker selectedRowInComponent:1]],
                         self.minutes[[self.picker selectedRowInComponent:2]]];
    _pickedDate = [[self timeFormatter] dateFromString:dateStr];
    return _pickedDate;
}

- (NSMutableArray *)dates
{
    if (_dates == nil) {
        NSDate* now = [NSDate date];
        NSUInteger dateCount = [self.delegate numberOfHoursInDatePicker:self] / 24;
        _dates = [NSMutableArray array];
        NSString* nowStr = [[self dateFormatter] stringFromDate:now];
        [_dates addObject:nowStr];
        for (int i = 1; i <= dateCount; i++) {
            NSDate* date = [now dateByAddingTimeInterval:i * 24 * 60 * 60];
            NSString* dateStr = [[self dateFormatter] stringFromDate:date];
            [_dates addObject:dateStr];
        }
    }
    return _dates;
}

- (NSMutableArray *)hours
{
    if (_hours == nil) {
        _hours = [NSMutableArray array];
        for (int i = 0; i < 24; i++) {
            [_hours addObject:[NSString stringWithFormat:@"%02d", i]];
        }
    }
    return _hours;
}

- (NSMutableArray *)minutes
{
    if (_minutes == nil) {
        _minutes = [NSMutableArray array];
        for (int i = 0; i < 60; i++) {
            if (i%5 == 0) {
                [_minutes addObject:[NSString stringWithFormat:@"%02d", i]];
            }
        }
    }
    return _minutes;
}

- (UIPickerView *)picker
{
    if (_picker == nil) {
        _picker = [[UIPickerView alloc] init];
        _picker.backgroundColor = [UIColor clearColor];
        _picker.delegate = self;
        _picker.dataSource = self;
        _picker.showsSelectionIndicator = YES;
    }
    return _picker;
}

- (UIView *)titleContainer
{
    if (_titleContainer == nil) {
        _titleContainer = [[UIView alloc] init];
        _titleContainer.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1.f];
        [_titleContainer addSubview:self.cancelButton];
        [_titleContainer addSubview:self.confirmButton];
        [_titleContainer addSubview:self.titleLabel];
    }
    return _titleContainer;
}

- (UIButton *)cancelButton
{
    if (_cancelButton == nil) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [_confirmButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        _cancelButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [_cancelButton addTarget:self action:@selector(cancelButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}

- (UIButton *)confirmButton
{
    if (_confirmButton == nil) {
        _confirmButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_confirmButton setTitle:@"确定" forState:UIControlStateNormal];
        [_confirmButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        _confirmButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [_confirmButton addTarget:self action:@selector(confirmButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmButton;
}

- (UILabel *)titleLabel
{
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.text = @"预约时间";
        _titleLabel.textColor = [UIColor darkGrayColor];
        _titleLabel.font = [UIFont systemFontOfSize:16];
    }
    return _titleLabel;
}

@end
