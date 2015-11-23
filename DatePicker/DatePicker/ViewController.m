//
//  ViewController.m
//  DatePicker
//
//  Created by 刘康 on 15/11/23.
//  Copyright © 2015年 origheart. All rights reserved.
//

#import "ViewController.h"
#import "DatePickerViewController.h"

@interface ViewController () <DatePickerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (nonatomic, strong) DatePickerViewController* datePicker;

@end

@implementation ViewController

#pragma mark - Target & Actions

- (IBAction)show:(UIButton *)sender {
    [self presentSemiModalViewController:self.datePicker];
}

#pragma mark - DatePickerDelegate

- (NSUInteger)numberOfHoursInDatePicker:(DatePicker *)picker
{
    return 72;
}

- (NSTimeInterval)minimumDurationInDatePicker:(DatePicker *)picker
{
    return 30 * 60;
}

- (void)datePicker:(DatePicker *)picker didPickDate:(NSDate *)date
{
    [self dismissSemiModalViewController:self.datePicker];
    self.textField.text = [NSString stringWithFormat:@"%@", date];
}

- (void)datePickerDidCancelPickDate
{
    [self dismissSemiModalViewController:self.datePicker];
}

#pragma mark - Getters

- (DatePickerViewController *)datePicker
{
    if (_datePicker == nil) {
        _datePicker = [[DatePickerViewController alloc] init];
        _datePicker.delegate = self;
    }
    return _datePicker;
}

@end
