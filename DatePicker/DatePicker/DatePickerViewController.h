//
//  DatePickerViewController.h
//  ZSJDatePicker
//
//  Created by 刘康 on 15/9/23.
//  Copyright © 2015年 zugesiji. All rights reserved.
//

#import "TDSemiModal.h"
#import "DatePicker.h"

@interface DatePickerViewController : TDSemiModalViewController
@property (nonatomic, weak) id<DatePickerDelegate> delegate;
@end
