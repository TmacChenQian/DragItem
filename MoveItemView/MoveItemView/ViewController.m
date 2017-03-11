//
//  ViewController.m
//  MoveItemView
//
//  Created by 陈乾 on 2017/3/11.
//  Copyright © 2017年 Cha1ien. All rights reserved.
//

#import "ViewController.h"
#import "CQMoveItemView.h"
#import "CQMoveItemControl.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"ChannelControl";
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(showChannel)];
    
}

-(void)showChannel
{
    NSArray *arr1 = @[@"要闻",@"河北",@"财经",@"娱乐",@"体育",@"社会",@"NBA",@"视频",@"汽车",@"图片",@"科技",@"军事",@"国际",@"数码",@"星座",@"电影",@"时尚",@"文化",@"游戏",@"教育",@"动漫",@"政务",@"纪录片",@"房产",@"佛学",@"股票",@"理财"];
    NSArray *arr2 = @[@"有声",@"家居",@"电竞",@"美容",@"电视剧",@"搏击",@"健康",@"摄影",@"生活",@"旅游",@"韩流",@"探索",@"综艺",@"美食",@"育儿"];
    
    [[CQMoveItemControl shareInstance] showMoveItemsWithUseTitleArr:arr1 andUnUseTitleArr:arr2 andFinishedBlock:^(NSArray *arr1, NSArray *arr2) {
        
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
