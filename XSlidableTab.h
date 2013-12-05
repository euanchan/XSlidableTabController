//
//  XSlidableTab.h
//  cncn.
//
//  Created by Euan Chan on 13-10-9.
//  Copyright (c) 2013 cncn. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol XSlidableTabDelegate;
@interface XSlidableTab : UIView

@property (assign, nonatomic) id<XSlidableTabDelegate> delegate;
@property (assign, nonatomic) NSInteger  btnHeight;
@property (assign, nonatomic) NSInteger  btnGap;
@property (assign, nonatomic) NSInteger  btnFontSize;
@property (strong, nonatomic) UIColor   *titleColorNormal;
@property (strong, nonatomic) UIColor   *titleColorSelected;
@property (strong, nonatomic) UIImage   *selectedImage;

- (id)initWithFrame:(CGRect)frame;
- (void)updateWithTitles:(NSArray *)titles;

// set tabmenu to half postion between page1 and page2, offsetRate shoule be 1.5
- (void)updateTabMenuWithPageOffsetRate:(CGFloat)offsetPagingRate;

// scroll tabmenu to page.
- (void)updateTabMenuSelectedIndex:(NSInteger)page;

@end


@protocol XSlidableTabDelegate <NSObject>

- (void)segmentedController:(XSlidableTab *)segmentCtrller tappedAtIndex:(NSInteger)index;

@end