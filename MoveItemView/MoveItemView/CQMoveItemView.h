//
//  CQMoveItemView.h
//  MoveItemView
//
//  Created by 陈乾 on 2017/3/11.
//  Copyright © 2017年 Cha1ien. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CQMoveItemView : UIView

@property(nonatomic, strong) NSMutableArray *useTitleArr;
@property(nonatomic, strong) NSMutableArray *unUseTitleArr;

-(void)reloadData;

@end
