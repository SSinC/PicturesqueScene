//
//  STANSideBar.h
//  GraduationProject
//
//  Created by stan on 3/25/14.
//  Copyright (c) 2014 stan. All rights reserved.
//
//

#import <UIKit/UIKit.h>

@class STANSideBar;

@protocol STANSideBarDelegate <NSObject>
@optional
- (void)sidebar:(STANSideBar *)sidebar willShowOnScreenAnimated:(BOOL)animatedYesOrNo;
- (void)sidebar:(STANSideBar *)sidebar didShowOnScreenAnimated:(BOOL)animatedYesOrNo;
- (void)sidebar:(STANSideBar *)sidebar willDismissFromScreenAnimated:(BOOL)animatedYesOrNo;
- (void)sidebar:(STANSideBar *)sidebar didDismissFromScreenAnimated:(BOOL)animatedYesOrNo;
- (void)sidebar:(STANSideBar *)sidebar didTapItemAtIndex:(NSUInteger)index;
- (void)sidebar:(STANSideBar *)sidebar didEnable:(BOOL)itemEnabled itemAtIndex:(NSUInteger)index;
@end

@interface STANSideBar : UIViewController

+ (instancetype)visibleSidebar;

// The width of the sidebar
// Default 150
@property (nonatomic, assign) CGFloat width;

// Access the view that contains the menu items
@property (nonatomic, strong, readonly) UIScrollView *contentView;

// Toggle displaying the sidebar on the right side of the device
// Default NO
@property (nonatomic, assign) BOOL showFromRight;

// The duration of the show and hide animations
// Default 0.25
@property (nonatomic, assign) CGFloat animationDuration;

// The dimension for each item view, not including padding
// Default {75, 75}
@property (nonatomic, assign) CGSize itemSize;

// The color to tint the blur effect
// Default white: 0.2, alpha: 0.73
@property (nonatomic, strong) UIColor *tintColor;

// The background color for each item view
// NOTE: set using either colorWithWhite:alpha or colorWithRed:green:blue:alpha
// Default white: 1, alpha 0.25
@property (nonatomic, strong) UIColor *itemBackgroundColor;

// The width of the colored border for selected item views
// Default 2
@property (nonatomic, assign) NSUInteger borderWidth;

// If YES, only a single item can be selected at a time, and one item is always selected
// Default NO
@property (nonatomic, assign) BOOL isSingleSelect;

@property (nonatomic, assign) BOOL sideBarShowsOnParentView;

// An optional delegate to respond to interaction events
@property (nonatomic, weak) id <STANSideBarDelegate> delegate;

- (instancetype)initWithImages:(NSArray *)images selectedIndices:(NSIndexSet *)selectedIndices borderColors:(NSArray *)colors;
- (instancetype)initWithImages:(NSArray *)images selectedIndices:(NSIndexSet *)selectedIndices;
- (instancetype)initWithImages:(NSArray *)images;

- (void)show;
- (void)showAnimated:(BOOL)animated;
- (void)showInViewController:(UIViewController *)controller animated:(BOOL)animated;

- (void)dismiss;
- (void)dismissAnimated:(BOOL)animated;
- (void)dismissAnimated:(BOOL)animated completion:(void (^)(BOOL finished))completion;

@end
