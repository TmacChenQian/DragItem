//
//  CQMoveItemControl.h
//  MoveItemView
//
//  Created by 陈乾 on 2017/3/11.
//  Copyright © 2017年 Cha1ien. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef void (^FinishedBlock)(NSArray *arr1,NSArray* arr2);
@interface CQMoveItemControl : NSObject



+(instancetype)shareInstance;

-(void)showMoveItemsWithUseTitleArr:(NSArray *)useArr andUnUseTitleArr:(NSArray *)unuseArr andFinishedBlock:(FinishedBlock)finishedBlock;

@end
