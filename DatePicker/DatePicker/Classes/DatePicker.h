//
//  DatePicker.h
//  ZSJDatePicker
//
//  Created by 刘康 on 15/9/23.
//  Copyright © 2015年 zugesiji. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DatePicker;
@protocol DatePickerDelegate <NSObject>

@required

- (void)datePicker:(DatePicker*)picker didPickDate:(NSDate*)date;

- (void)datePickerDidCancelPickDate;

- (NSUInteger)numberOfHoursInDatePicker:(DatePicker*)picker;

- (NSTimeInterval)minimumDurationInDatePicker:(DatePicker*)picker;

@end

@interface DatePicker : UIView

@property (nonatomic, weak) id<DatePickerDelegate> delegate;

- (void)updateSelectedDateToDefault;

@end
