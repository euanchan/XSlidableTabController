//
//  XSlidableTabController.m
//  cncn.
//
//  Created by Euan Chan on 13-10-9.
//  Copyright (c) 2013 cncn. All rights reserved.
//

#import "XSlidableTab.h"
#import "XSlidableTabController.h"

@interface XSlidableTabController () <UIScrollViewDelegate, XSlidableTabDelegate>

@property (strong, nonatomic) XSlidableTab     *tabMenuView;
@property (strong, nonatomic) UIScrollView *scrollView;

@end

@implementation XSlidableTabController

- (id)initWithViewControllers:(NSArray *)viewControllerArr
{
    if (self = [super init]) {
        self.viewCtrllerArr = viewControllerArr;
    }
    return self;
}

static const CGFloat kMenuHeight = 29;
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (self.viewCtrllerArr)
        [self setup];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    CGFloat baseY = 0.f, width = self.view.frame.size.width;
    CGRect rtTabMenu = CGRectMake(0, baseY, width, kMenuHeight);
    [self.tabMenuView setFrame:rtTabMenu];
    baseY += rtTabMenu.size.height;
    CGRect rtContent = CGRectMake(0, baseY, width, self.view.frame.size.height - baseY);
    [self.scrollView setFrame:rtContent];
    CGSize szScrollContent = self.scrollView.contentSize;
    szScrollContent.height = rtContent.size.height;
    [self.scrollView setContentSize:szScrollContent];
}

- (void)setViewControllers:(NSArray *)viewControllerArr
{
    self.viewCtrllerArr = viewControllerArr;
    [self setup];
}

- (void)setup
{
    self.view.backgroundColor = [UIColor whiteColor];
    NSMutableArray *titleArray = [[NSMutableArray alloc] initWithCapacity:self.viewCtrllerArr.count];
    for (int i = 0; i < self.viewCtrllerArr.count; ++i) {
        titleArray[i] = [self.viewCtrllerArr[i] title];
    }
    
    // header tab menu bar.
    CGFloat baseY = 0.f, width = self.view.frame.size.width;
    CGRect rtTabMenu = CGRectMake(0, baseY, width, kMenuHeight);
    self.tabMenuView = [[XSlidableTab alloc] initWithFrame:rtTabMenu];
    [self.tabMenuView updateWithTitles:titleArray];
    self.tabMenuView.delegate = self;
    [self.view addSubview:self.tabMenuView];
    
    baseY += rtTabMenu.size.height;
    
    // content place view.
    CGRect rtContent = CGRectMake(0, baseY, width, self.view.frame.size.height - baseY);
    self.scrollView = [[UIScrollView alloc] initWithFrame:rtContent];
    self.scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleHeight;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.directionalLockEnabled = YES;
    self.scrollView.delegate = self;
    self.scrollView.alwaysBounceVertical = NO;
    self.scrollView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:self.scrollView];
    
    [self loadPages];
}

- (void)loadPages
{
    int numOfPages = [self.viewCtrllerArr count];
    CGFloat nextXPos = 0.f;
    CGFloat pageWidth = self.scrollView.frame.size.width;
    CGFloat pageHeight = self.scrollView.frame.size.height;
    for (int i = 0; i < numOfPages; ++i) {
        UIViewController *viewCtrl = self.viewCtrllerArr[i];
        UIView *contentView = viewCtrl.view;
        contentView.frame = CGRectMake(nextXPos, 0, pageWidth, pageHeight);
        nextXPos += pageWidth;
        
        [self.scrollView addSubview:contentView];
        [self addChildViewController:viewCtrl];
        [viewCtrl didMoveToParentViewController:self];
    }
    
    self.scrollView.contentSize = CGSizeMake(nextXPos, pageHeight);
    
    if (_delegate && [_delegate respondsToSelector:@selector(didSwitchToTabAtIndex:)])
        [_delegate didSwitchToTabAtIndex:0];
}

#pragma mark - UIScrollView delegate
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
//    [self setStatusBarReplacedWithPageDots:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.isDragging) {
        CGFloat pageRate = self.scrollView.contentOffset.x / self.scrollView.frame.size.width;
        [self.tabMenuView updateTabMenuWithPageOffsetRate:pageRate];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat page = self.scrollView.contentOffset.x / self.scrollView.frame.size.width;
    [self.tabMenuView updateTabMenuSelectedIndex:page];
    
    if (_delegate && [_delegate respondsToSelector:@selector(didSwitchToTabAtIndex:)])
        [_delegate didSwitchToTabAtIndex:page];
}

#pragma mark - XSlidableTabDelegate
- (void)segmentedController:(XSlidableTab *)segmentCtrller tappedAtIndex:(NSInteger)index
{
    CGFloat offset = self.scrollView.contentOffset.x;
    int page = offset / self.view.frame.size.width;
    if (index != page && page < [self.scrollView.subviews count]){
        [self.scrollView setContentOffset:CGPointMake([self getPosXOfPage:index], 0) animated:YES];
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(didSwitchToTabAtIndex:)])
        [_delegate didSwitchToTabAtIndex:index];
}

- (CGFloat)getPosXOfPage:(NSInteger)page
{
    return page * self.scrollView.frame.size.width;
}
         
@end
