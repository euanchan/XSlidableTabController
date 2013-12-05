//
//  XSlidableTabController.h
//  cncn.
//
//  Created by Euan Chan on 13-10-9.
//  Copyright (c) 2013 cncn. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol XSlidableTabControllerDelegate;
@interface XSlidableTabController : UIViewController

@property (strong, nonatomic) NSArray      *viewCtrllerArr;
@property (assign, nonatomic) id<XSlidableTabControllerDelegate> delegate;

- (id)initWithViewControllers:(NSArray *)viewControllerArr;
- (void)setViewControllers:(NSArray *)viewControllerArr;

@end


@protocol XSlidableTabControllerDelegate <NSObject>

- (void)didSwitchToTabAtIndex:(NSInteger)index;

@end