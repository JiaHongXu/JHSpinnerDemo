//
//  JHSpinner.m
//  JHSpinnerDemo
//
//  Created by 307A on 2016/12/22.
//  Copyright © 2016年 徐嘉宏. All rights reserved.
//

#import "JHSpinner.h"

static NSString * const cellId = @"JHSpinnerCellId";

@interface JHSpinner() <UITableViewDelegate, UITableViewDataSource>
//a reference of the view it base on
@property (nonatomic, strong) UIView *parentView;

//option array
@property (nonatomic, strong) NSArray<NSString *> *options;

//current option label
@property (nonatomic, strong) UILabel *currentOptionLbl;

//arrow view
@property (nonatomic, strong) UIView *arrowView;

//a boolean value represented the spinner state
@property (nonatomic, assign) BOOL isOpen;

//spinner open/close duration
@property (nonatomic, assign) NSInteger duration;

@property (nonatomic, assign) NSInteger currentIndex;
@end

@implementation JHSpinner

#pragma mark - Init Methods
- (instancetype)initOptions:(NSArray<NSString *> *)options onView:(UIView *)contentView;
 {
    self = [super init];
    if (self) {
        [self setupWithOptions:options onView:contentView];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame andOptions:(NSArray<NSString *> *)options onView:(UIView *)contentView;
 {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupWithOptions:options onView:(UIView *)contentView];
    }
    
    return self;
}

- (void)setupWithOptions:(NSArray<NSString *> * )options onView:(UIView *)contentView {
    self.options = options;
    self.parentView = contentView;
    _isOpen = NO;
    _currentIndex = 0;
    
    //init self as a button
    [self.layer setBorderColor:[UIColor blackColor].CGColor];
    self.userInteractionEnabled = YES;
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onSpinnerClicked)]];
    
    //init current option label
    CGRect lableFrame = CGRectMake(0, 0, CGRectGetWidth(self.frame)-44, CGRectGetHeight(self.frame));
    self.currentOptionLbl = [[UILabel alloc] initWithFrame:lableFrame];
    [self addSubview:_currentOptionLbl];
    if (_options&&_options.count>0) {
        _currentOptionLbl.text = _options[0];
    }
    
    //init table
    self.optionsView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [_parentView insertSubview:_optionsView aboveSubview:self];
    _optionsView.layer.borderColor = [[UIColor blackColor] CGColor];
    _optionsView.layer.borderWidth = 1;
    _optionsView.hidden = YES;
    _optionsView.delegate = self;
    _optionsView.dataSource = self;
    _optionsView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
}

#pragma mark - Overwrite Methods
- (BOOL)endEditing:(BOOL)force {
    [self closeSpinner];
    
    return YES;
}

#pragma mark - On Spinner Clicked
- (void)onSpinnerClicked {
    [_parentView endEditing:YES];   //close another spinner or make other input view end editting
    if (_isOpen) {
        [self closeSpinner];
    } else {
        [self openSpinner];
    }
}

#pragma mark - Open or Close Spinner
- (void)openSpinner {
    //make it unclickable
    self.userInteractionEnabled = NO;
    
    _optionsView.hidden = NO;
    [_optionsView reloadData];
    
    CGPoint newOrigin = self.frame.origin;
    newOrigin.y += CGRectGetHeight(self.frame);
    newOrigin.y --;
    
    CGRect oldFrame = self.frame;
    oldFrame.origin = newOrigin;
    [_optionsView setFrame:oldFrame];
    
    CGRect newFrame = self.frame;
    newFrame.size = CGSizeMake(CGRectGetWidth(newFrame), [self generateHeightWithNumberOfRow:_options.count]);
    newFrame.origin = newOrigin;
    [UIView animateWithDuration:0.3 animations:^{
        [_optionsView setFrame:newFrame];
    } completion:^(BOOL finished) {
        //make it able to click again
        self.userInteractionEnabled = YES;
        _isOpen = YES;
    }];

}

- (void)closeSpinner {
    //make it unclickable
    self.userInteractionEnabled = NO;
    
    CGRect newFrame = self.frame;
    CGPoint newOrigin = newFrame.origin;
    newOrigin.y += CGRectGetHeight(newFrame);
    newOrigin.y --;
    newFrame.origin = newOrigin;
    [UIView animateWithDuration:0.3 animations:^{
        [_optionsView setFrame:newFrame];
    } completion:^(BOOL finished) {
        _optionsView.hidden = YES;
        _isOpen = NO;
        
        //make it able to click again
        self.userInteractionEnabled = YES;
    }];

}

#pragma mark - Public Methods
- (NSString *)selectedString {
    return !_options||_options.count == 0?nil:_options[_currentIndex];
}

- (NSInteger)selectedIndex {
    return !_options||_options.count == 0?0:_currentIndex;
}

#pragma mark - Other Methods
- (CGFloat)generateHeightWithNumberOfRow:(NSInteger)count {
    if (count<=5) {
        return self.frame.size.height * count;
    } else {
        return self.frame.size.height * 5;
    }
}

- (CGFloat)generateBorderWidth {
    CGFloat scale = [[UIScreen mainScreen] scale];
    CGFloat width = scale > 0.0 ? 1.0 / scale : 1.0;
    return width;
}

#pragma mark - Setter
- (void)setOptions:(NSArray *)options {
    if (!options) {
        options = [[NSArray alloc] init];
        return;
    }
    _options = options;
    
}

#pragma mark - Table View Delegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([_delegate respondsToSelector:@selector(spinner:cellForRowAtIndexPath:)]) {
        return [_delegate spinner:self cellForRowAtIndexPath:indexPath];
    } else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        }
        
        [cell.textLabel setText:_options[indexPath.row]];
        cell.backgroundColor = [UIColor whiteColor];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([_delegate respondsToSelector:@selector(spinner:heightForRowAtIndexPath:)]) {
        return [_delegate spinner:self heightForRowAtIndexPath:indexPath];
    } else {
        return 44;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _options.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    _currentIndex = indexPath.row;
    _currentOptionLbl.text = _options[_currentIndex];
    [_delegate spinner:self didSelectedOption:_options[indexPath.row] AtIndex:indexPath];
    [self closeSpinner];
}

@end
