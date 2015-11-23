//
//  DatePickerViewController.m
//  ZSJDatePicker
//
//  Created by 刘康 on 15/9/23.
//  Copyright © 2015年 zugesiji. All rights reserved.
//

#import "DatePickerViewController.h"

@interface DatePickerViewController ()
@property (nonatomic, strong) DatePicker* datePicker;
@end

@implementation DatePickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.datePicker];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.datePicker updateSelectedDateToDefault];
}

- (DatePicker *)datePicker
{
    if (_datePicker == nil) {
        _datePicker = [[DatePicker alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 225, self.view.frame.size.width, 225)];
        _datePicker.delegate = self.delegate;
    }
    return _datePicker;
}

@end
