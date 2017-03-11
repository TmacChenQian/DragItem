//
//  CQMoveItemControl.m
//  MoveItemView
//
//  Created by 陈乾 on 2017/3/11.
//  Copyright © 2017年 Cha1ien. All rights reserved.
//

#import "CQMoveItemControl.h"
#import <UIKit/UIKit.h>
#import "CQMoveItemView.h"
@implementation CQMoveItemControl{
    FinishedBlock _finishedBlock;
    UINavigationController *_naviVC;
    CQMoveItemView *_itemView;
 

}

+(instancetype)shareInstance{
    static CQMoveItemControl *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

-(instancetype)init{
    if (self = [super init]) {
        [self setUpUI];
    }
    return self;
}

-(void)setUpUI{

   _itemView = [[CQMoveItemView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    UIViewController *vc = [UIViewController new];
    
    [vc.view addSubview:_itemView];
    
    _naviVC = [[UINavigationController alloc] initWithRootViewController:vc];
    _naviVC.topViewController.navigationController.navigationBar.tintColor  = [UIColor redColor];
    
    _naviVC.topViewController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(changeItemViewFrameAnimation)];
  
}

-(void)changeItemViewFrameAnimation{
    
  [UIView animateWithDuration:0.25 animations:^{
     
      CGRect frame = _naviVC.view.frame;
      
      frame.origin.y = -_naviVC.view.frame.size.height;
      
      _naviVC.view.frame =  frame;
      
  } completion:^(BOOL finished) {
      
      [_naviVC.view removeFromSuperview];
  }];
}

-(void)showMoveItemsWithUseTitleArr:(NSArray *)useArr andUnUseTitleArr:(NSArray *)unuseArr andFinishedBlock:(FinishedBlock)finishedBlock{
    //记录block
    _finishedBlock = finishedBlock;
    
    _itemView.useTitleArr = [NSMutableArray arrayWithArray:useArr];
    _itemView.unUseTitleArr = [NSMutableArray arrayWithArray:unuseArr];
    
    [_itemView reloadData];

    //实现从上到下 渐渐出现的效果
    CGRect frame = _naviVC.view.frame;
    
    frame.origin.y = -_naviVC.view.frame.size.height;
    
    _naviVC.view.frame =  frame;
    
    _naviVC.view.alpha = 0;
    
    [[UIApplication sharedApplication].keyWindow addSubview:_naviVC.view];

    [UIView animateWithDuration:0.3 animations:^{
       
        _naviVC.view.alpha = 1;
        _naviVC.view.frame = [UIScreen mainScreen].bounds;
        
    }];
    
}

@end
