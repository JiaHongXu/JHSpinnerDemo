//
//  JHSpinner.h
//  JHSpinnerDemo
//
//  Created by 307A on 2016/12/22.
//  Copyright © 2016年 徐嘉宏. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JHSpinner;

@protocol JHSpinnerDelegate <NSObject>

@required
- (void)spinner:(JHSpinner *)spinner didSelectedOption:(NSString *)option AtIndex:(NSIndexPath *)indexPath;

@optional
- (CGFloat)spinner:(JHSpinner *)spinner heightForRowAtIndexPath:(NSIndexPath *)indexPath;

@optional
- (UITableViewCell *)spinner:(JHSpinner *)spinner cellForRowAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface JHSpinner : UIView
@property (nonatomic, weak) id<JHSpinnerDelegate> delegate;

//spinner view
@property (nonatomic, strong) UITableView *optionsView;

- (instancetype)initOptions:(NSArray<NSString *> *)options onView:(UIView *)contentView;
- (instancetype)initWithFrame:(CGRect)frame andOptions:(NSArray<NSString *> *)options onView:(UIView *)contentView;
;

- (NSInteger)selectedIndex;
- (NSString *)selectedString;

@end
