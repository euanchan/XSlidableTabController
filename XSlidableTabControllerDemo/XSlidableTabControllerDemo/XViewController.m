//
//  XViewController.m
//  XSlidableTabControllerSample
//
//  Created by Euan Chan on 12/5/13.
//  Copyright (c) 2013 Euan Chan. All rights reserved.
//

#import "XSlidableTab.h"
#import "XViewController.h"

@interface XViewController () <XSlidableTabControllerDelegate>

@end

@implementation XViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1)
        self.edgesForExtendedLayout = UIRectEdgeLeft | UIRectEdgeRight;
#endif
   
    self.title = @"SlidableTab Demo";
    [self setupViews];
    [self setupColumns];
    self.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupViews
{
    self.tabHeight = 29;
    self.tabView.btnHeight = self.tabHeight;
    self.tabView.titleColorNormal = [UIColor whiteColor];
    self.tabView.titleColorSelected = [UIColor orangeColor];
    self.tabView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"tab_bg"]];
    self.tabView.selectedImage = [[UIImage imageNamed:@"tab_btn_selected"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 15, 0, 15)];
}

- (void)setupColumns
{
    UIViewController *vc1 = [[UIViewController alloc] init];
    vc1.view.backgroundColor = [UIColor blueColor];
    vc1.title = @"BLUE";
    UIViewController *vc2 = [[UIViewController alloc] init];
    vc2.view.backgroundColor = [UIColor purpleColor];
    vc2.title = @"PURPLE";
    UIViewController *vc3 = [[UIViewController alloc] init];
    vc3.view.backgroundColor = [UIColor redColor];
    vc3.title = @"RED";
    UIViewController *vc4 = [[UIViewController alloc] init];
    vc4.view.backgroundColor = [UIColor yellowColor];
    vc4.title = @"YELLOW";
    UIViewController *vc5 = [[UIViewController alloc] init];
    vc5.view.backgroundColor = [UIColor greenColor];
    vc5.title = @"GREEN";
    
    NSArray *columns = @[vc1, vc2, vc3, vc4, vc5];
    [self setViewControllers:columns];
}

- (void)didSwitchToTabAtIndex:(NSInteger)index
{
    if (index < 0 || index >= [[self viewControllers] count])
        return;
    
    // Do something.
}

@end
