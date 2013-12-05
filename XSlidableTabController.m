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

@property (strong, nonatomic) NSArray      *viewCtrllerArr;

@end

@implementation XSlidableTabController

- (id)init
{
    if (self = [super init]) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _tabHeight = 29;
    
    [self setup];
    if (_viewCtrllerArr)
        [self updateViews];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    CGFloat baseY = 0.f, width = self.view.frame.size.width;
    CGRect rtTabMenu = CGRectMake(0, baseY, width, _tabHeight);
    [_tabView setFrame:rtTabMenu];
    baseY += rtTabMenu.size.height;
    CGRect rtContent = CGRectMake(0, baseY, width, self.view.frame.size.height - baseY);
    [_scrollView setFrame:rtContent];
    CGSize szScrollContent = _scrollView.contentSize;
    szScrollContent.height = rtContent.size.height;
    [_scrollView setContentSize:szScrollContent];
}

- (NSArray *)viewControllers
{
    return _viewCtrllerArr;
}

- (void)setViewControllers:(NSArray *)viewControllerArr
{
    _viewCtrllerArr = viewControllerArr;
    [self updateViews];
}

- (void)setup
{
    self.view.backgroundColor = [UIColor whiteColor];
    // header tab menu bar.
    CGFloat baseY = 0.f, width = self.view.frame.size.width;
    CGRect rtTabMenu = CGRectMake(0, baseY, width, _tabHeight);
    _tabView = [[XSlidableTab alloc] initWithFrame:rtTabMenu];
    _tabView.delegate = self;
    [self.view addSubview:_tabView];
    
    baseY += rtTabMenu.size.height;
    
    // content place view.
    CGRect rtContent = CGRectMake(0, baseY, width, self.view.frame.size.height - baseY);
    _scrollView = [[UIScrollView alloc] initWithFrame:rtContent];
    _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleHeight;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.pagingEnabled = YES;
    _scrollView.directionalLockEnabled = YES;
    _scrollView.delegate = self;
    _scrollView.alwaysBounceVertical = NO;
    _scrollView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:_scrollView];
}

- (void)updateViews
{
    NSMutableArray *titleArray = [[NSMutableArray alloc] initWithCapacity:_viewCtrllerArr.count];
    for (int i = 0; i < _viewCtrllerArr.count; ++i) {
        titleArray[i] = [_viewCtrllerArr[i] title];
    }
    [_tabView updateWithTitles:titleArray];
    
    [self loadPages];
}

- (void)loadPages
{
    for (UIView *subView in _scrollView.subviews)
        [subView removeFromSuperview];
        
    int numOfPages = [_viewCtrllerArr count];
    CGFloat nextXPos = 0.f;
    CGFloat pageWidth = _scrollView.frame.size.width;
    CGFloat pageHeight = _scrollView.frame.size.height;
    for (int i = 0; i < numOfPages; ++i) {
        UIViewController *viewCtrl = _viewCtrllerArr[i];
        UIView *contentView = viewCtrl.view;
        contentView.frame = CGRectMake(nextXPos, 0, pageWidth, pageHeight);
        nextXPos += pageWidth;
        
        [_scrollView addSubview:contentView];
        [self addChildViewController:viewCtrl];
        [viewCtrl didMoveToParentViewController:self];
    }
    
    _scrollView.contentSize = CGSizeMake(nextXPos, pageHeight);
    
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
        CGFloat pageRate = _scrollView.contentOffset.x / _scrollView.frame.size.width;
        [_tabView updateTabMenuWithPageOffsetRate:pageRate];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat page = _scrollView.contentOffset.x / _scrollView.frame.size.width;
    [_tabView updateTabMenuSelectedIndex:page];
    
    if (_delegate && [_delegate respondsToSelector:@selector(didSwitchToTabAtIndex:)])
        [_delegate didSwitchToTabAtIndex:page];
}

#pragma mark - XSlidableTabDelegate
- (void)segmentedController:(XSlidableTab *)segmentCtrller tappedAtIndex:(NSInteger)index
{
    CGFloat offset = _scrollView.contentOffset.x;
    int page = offset / self.view.frame.size.width;
    if (index != page && page < [_scrollView.subviews count]){
        [_scrollView setContentOffset:CGPointMake([self getPosXOfPage:index], 0) animated:YES];
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(didSwitchToTabAtIndex:)])
        [_delegate didSwitchToTabAtIndex:index];
}

- (CGFloat)getPosXOfPage:(NSInteger)page
{
    return page * _scrollView.frame.size.width;
}
         
@end
