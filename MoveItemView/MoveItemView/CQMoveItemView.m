//
//  CQMoveItemView.m
//  MoveItemView
//
//  Created by 陈乾 on 2017/3/11.
//  Copyright © 2017年 Cha1ien. All rights reserved.
//

#import "CQMoveItemView.h"
#import "CQMoveItemCell.h"
#import "CQMoveItemHeader.h"

static NSInteger ColumnNumber = 4;
static CGFloat   verticalNumber = 15;
static CGFloat   horizontalNumber = 15;

#define cellReuseIdentifier @"CQMoveItemCell"
#define headerReuseIdentifier @"CQMoveItemHeader"

@interface CQMoveItemView()<UICollectionViewDelegate,UICollectionViewDataSource>

@end

@implementation CQMoveItemView{
    
    UICollectionView *_collectionView;
    //被拖拽的item
    CQMoveItemCell *_dragingCell;
    //被拖拽的indexPath
    NSIndexPath *_dragingIndexPath;
    //目标indexPath
    NSIndexPath *_targetIndexPath;
    

}


#pragma mark - init
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setUpUI];
    }
    return self;
}

#pragma mark - setUI
-(void)setUpUI{
    
    self.backgroundColor = [UIColor whiteColor];
    
    /*-------------创建colView 的flowlayout的设置----------------*/
    UICollectionViewFlowLayout *flowlayout = [[UICollectionViewFlowLayout alloc] init];
    CGFloat width = (self.bounds.size.width - (ColumnNumber + 1)*horizontalNumber)/ColumnNumber;
    CGFloat height = width/2;
    flowlayout.itemSize = CGSizeMake(width, height);
    flowlayout.minimumLineSpacing = horizontalNumber;
    flowlayout.minimumInteritemSpacing = verticalNumber;
    //设置组头的size
    flowlayout.headerReferenceSize = CGSizeMake(self.bounds.size.width, 40);
    /*-------------创建colView----------------*/
    _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowlayout];
    
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.backgroundColor = [UIColor clearColor];
    
    //准守代理
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    

    //注册cell
    [_collectionView registerClass:[CQMoveItemCell class] forCellWithReuseIdentifier:cellReuseIdentifier];
    //注册头部
    [_collectionView registerClass:[CQMoveItemHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerReuseIdentifier];
    //添加
    [self addSubview:_collectionView];
    /*-------------长按手势----------------*/
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    longPress.minimumPressDuration = 0.3;
    [_collectionView addGestureRecognizer:longPress];
    
    /*-------------创建一个长按显示的按钮（只是暂时把他隐藏起来）----------------*/
    _dragingCell = [[CQMoveItemCell alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    _dragingCell.hidden = YES;
    [_collectionView addSubview:_dragingCell];


}

#pragma mark - longPress长按回调
-(void)longPress:(UILongPressGestureRecognizer *)gesture{
    
    //获取长按的点
    CGPoint point = [gesture locationInView:_collectionView];
    
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:
            [self begenLongPress:point];
            break;
        case UIGestureRecognizerStateChanged:
            [self changeLongPress:point];

            break;
        case UIGestureRecognizerStateEnded:
            [self endLongPress:point];

            break;
        default:
            break;
    }

}

#pragma mark - 长按手势的私有方法

//长按开始的时候
-(void)begenLongPress:(CGPoint)point{
    
    _dragingIndexPath = [self getdragingIndexPathWithPoint:point];
    //非空判断
    if(!_dragingIndexPath){
        return;
    }
    //把正在拖拽的item带到最前面
    [_collectionView bringSubviewToFront:_dragingCell];
    //取出正在拖拽对应item
    CQMoveItemCell *cell = (CQMoveItemCell *)[_collectionView cellForItemAtIndexPath:_dragingIndexPath];
    //标示正在拖拽 这样控件的ui略有改变 --变灰一点
    cell.isMoving = YES;
    //把前面隐藏的正在拖拽的cell展示出来
    _dragingCell.hidden = NO;
    _dragingCell.frame = cell.frame;
    _dragingCell.title = cell.title;
    //稍微放大一点
    [_dragingCell setTransform:CGAffineTransformMakeScale(1.1, 1.1)];

    

}

//长按拖拽中... 持续调用..
-(void)changeLongPress:(CGPoint)point{
    //非空判断
    if(!_dragingIndexPath){
        return;
    }
    //跟随拖拽走动
    _dragingCell.center = point;
    //获取目标位置
    _targetIndexPath = [self getDestinationIndexPathWith:point];
    //如果开始拖拽和目标都有 需要交换item位置
    if(_dragingIndexPath && _targetIndexPath){
        //重新更新数据
        [self reUpDate];
        [_collectionView moveItemAtIndexPath:_dragingIndexPath toIndexPath:_targetIndexPath];
        //交换 indexPath
        _dragingIndexPath = _targetIndexPath;
    }
    
    
    
}
//拖拽结束
-(void)endLongPress:(CGPoint)point{
    
    //非空判断
    if (!_dragingIndexPath) {
        return;
    }
    
    //根据_dragingIndexPath获取最终的位置
    CGRect frame = [_collectionView cellForItemAtIndexPath:_dragingIndexPath].frame;
    //变回原来的大小
    [_dragingCell setTransform:CGAffineTransformMakeScale(1, 1)];
    [UIView animateWithDuration:0.25 animations:^{
        _dragingCell.frame = frame;
    } completion:^(BOOL finished) {
        _dragingCell.hidden = YES;
        CQMoveItemCell *cell = (CQMoveItemCell *)[_collectionView cellForItemAtIndexPath:_dragingIndexPath];
        cell.isMoving = NO;
    }];
    
    
    
}

#pragma mark - reUpDate
-(void)reUpDate{
    
    //其实是交换数组中的obj的位置
    id obj = _useTitleArr[_dragingIndexPath.row];
    [_useTitleArr removeObject:obj];
    [_useTitleArr insertObject:obj atIndex:_targetIndexPath.row];
    

}


#pragma mark - 根据长按手势开始的点 获取 indexPath
-(NSIndexPath *)getdragingIndexPathWithPoint:(CGPoint)point{
    NSIndexPath *dragIndexpath = nil;
    
    if([_collectionView numberOfItemsInSection:0] == 1){
        return dragIndexpath;
    }
    for (NSIndexPath *indexPath in _collectionView.indexPathsForVisibleItems) {
        //第二组不要拖拽功能
        if (indexPath.section > 0) {
            continue;
        }
        //如果对应的indexPath的cell区域包含point这个点 就返回对应的indexPath
        if (CGRectContainsPoint([_collectionView cellForItemAtIndexPath:indexPath].frame, point)) {
            dragIndexpath = indexPath;
            break;
        }
        
    }
    return dragIndexpath;
    
}

#pragma mark - 根据传入的point获取目标IndexPath的方法
-(NSIndexPath *)getDestinationIndexPathWith:(CGPoint)point{
    
    NSIndexPath *destinationIndexPath;
    for (NSIndexPath *indexPath in _collectionView.indexPathsForVisibleItems) {
        //如果是自己相同的indexPath不需要换位置
        if ([indexPath isEqual:_dragingIndexPath]) {
            continue;
        }
        //如果是第二组也不要这个功能
        if (indexPath.section > 0) {
            continue;
        }
        if (CGRectContainsPoint([_collectionView cellForItemAtIndexPath:indexPath].frame, point)) {
            destinationIndexPath = indexPath;
            break;
        }
    }
    return destinationIndexPath;

}



#pragma mark - UICollectionViewDelegate,UICollectionViewDataSource

//返回组
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 2;
}
//返回组里面的行
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return section == 0 ? _useTitleArr.count : _unUseTitleArr.count;
}
//返回cell
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
  
    CQMoveItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellReuseIdentifier forIndexPath:indexPath];
    //TODO:将数据传入
    
    cell.title = indexPath.section == 0 ? _useTitleArr[indexPath.row] : _unUseTitleArr[indexPath.row];

    return cell;
    
}
//返回header
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
      CQMoveItemHeader *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerReuseIdentifier forIndexPath:indexPath];
        
        if (indexPath.section == 0) {
            header.title = @"已选频道";
            header.subTitle = @"拖拽移动item";
        }else{
            header.title = @"频道推荐";
            header.subTitle = @"";
        }
        return header;        
    }else{
        return nil;
    }

}

//代理
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        id obj = [_useTitleArr objectAtIndex:indexPath.row];
        [_useTitleArr removeObject:obj];
        [_unUseTitleArr insertObject:obj atIndex:0];
        //移动到1组的0行的位置
        [collectionView moveItemAtIndexPath:indexPath toIndexPath:[NSIndexPath indexPathForItem:0 inSection:1]];
    }else{
        id obj = [_unUseTitleArr objectAtIndex:indexPath.row];
        [_unUseTitleArr removeObject:obj];
        [_useTitleArr insertObject:obj atIndex:0];
        //移动到0组的0行的位置
        [collectionView moveItemAtIndexPath:indexPath toIndexPath:[NSIndexPath indexPathForItem:_useTitleArr.count-1 inSection:0]];
    
    }

}

#pragma mark - 刷新CollectionView
-(void)reloadData{

    [_collectionView reloadData];
    
}

@end
