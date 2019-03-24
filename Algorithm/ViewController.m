//
//  ViewController.m
//  Algorithm
//
//  Created by Jayehuang on 2019/3/23.
//  Copyright © 2019 Jayehuang. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //假装都是整型
    NSMutableArray *array=[NSMutableArray arrayWithArray:@[@(5),@(8),@(3),@(10),@(22),@(4),@(7),@(9)]];
//    [self bubbleSort:array.mutableCopy];
//    [self selectSort:array.mutableCopy];
//    [self quickSort:array.mutableCopy];
//    [self insertSort:array.mutableCopy];
//    [self mergeSort:array];
    [self shellSort:array];
}
-(void)shellSort:(NSMutableArray *)array
{
    //5,8,3,7,22,4,10
    int increment=array.count/2.0;//增量
    while (increment>=1) {
        for (int i=increment; i<array.count; i++) {//分组进行插入排序
            NSInteger temp=[array[i]integerValue];
            int j=i;
            while (j>=increment&&temp<[array[j-increment]integerValue]) {//小的左移increment个位置
                [array replaceObjectAtIndex:j withObject:array[j-increment]];
                j-=increment;
            }
            [array replaceObjectAtIndex:j withObject:@(temp)];
        }
        increment=increment/2.0;
    }
    NSLog(@"66--%@",array);
}
//MARK: - 归并排序
-(void)mergeSort:(NSMutableArray *)array
{
    NSMutableArray *tempArray=[NSMutableArray array];
    for (int i=0; i<array.count; i++) {//初始化
        NSMutableArray *subArray=[NSMutableArray array];
        [subArray addObject:array[i]];
        [tempArray addObject:subArray];
    }
    while (tempArray.count!=1) {
        NSInteger i=0;
        while (i<tempArray.count-1) {//递归排序合并相邻数组
            tempArray[i]=[self mergeWithfirstArray:tempArray[i] secondArray:tempArray[i+1]];
            [tempArray removeObjectAtIndex:i+1];
            i++;
        }
    }
    NSLog(@"55--%@",tempArray.firstObject);
}
-(NSMutableArray *)mergeWithfirstArray:(NSMutableArray *)firstArray secondArray:(NSMutableArray *)secondArray
{
    NSMutableArray *mergeArray=[NSMutableArray array];
    NSInteger first = 0,second = 0;
    while (first<firstArray.count&&second<secondArray.count) {
        if ([firstArray[first]integerValue]< [secondArray[second]integerValue]) {
            [mergeArray addObject:firstArray[first]];
            first++;
        }else
        {
            [mergeArray addObject:secondArray[second]];
            second++;
        }
    }
    while (first<firstArray.count) {
        [mergeArray addObject:firstArray[first]];
        first++;
    }
    while (second<secondArray.count) {
        [mergeArray addObject:secondArray[second]];
        second++;
    }
    return mergeArray;
}

//MARK: - 插入排序  平均时间复杂度：O(n^2)  平均空间复杂度：O(1)
-(void)insertSort:(NSMutableArray *)array
{
    for (int i=1; i<array.count; i++) {//假设第一个已经排好序
        NSInteger num=[array[i]integerValue];
        int j=i-1;
        while (j>=0&&num<[array[j]integerValue]) {//反向遍历数组左边的，比num大的都右移一个
            [array replaceObjectAtIndex:j+1 withObject:array[j]];
            j--;
        }
        [array replaceObjectAtIndex:j+1 withObject:@(num)];//将num插到正确的位置
    }
    NSLog(@"44--%@",array);
}

//MARK: - 快速排序   平均时间复杂度：O(n^2)    平均空间复杂度：O(nlogn)    O(nlogn)~O(n^2)
-(void)quickSort:(NSMutableArray *)array
{
    [self quickSort:array left:0 right:array.count-1];
}
-(void)quickSort:(NSMutableArray *)array left:(NSInteger)left right:(NSInteger)right
{
    if (!array||array.count==0||left>=right) {
        return;
    }
    NSInteger i = left;
    NSInteger j = right;
    NSInteger key=[array[i]integerValue];//基准
    while (i<j) {
        //从右边right开始查找比基准数小的值
        while (i<j&&[array[j]integerValue]>=key) {//如果比基准数大，继续查找
            j--;
        }
        //如果比基准数小，交换位置
        [array exchangeObjectAtIndex:i withObjectAtIndex:j];
        //从左边left开始查找比基准数大的值
        while (i<j&&[array[i]integerValue]<=key) {//如果比基准数小，继续查找
            i++;
        }
        //如果比基准数大，交换位置
        [array exchangeObjectAtIndex:i withObjectAtIndex:j];
    }
    //递归排序左边
    [self quickSort:array left:left right:i-1];
    //递归排序右边
    [self quickSort:array left:i+1 right:right];
}
//MARK: - 选择排序   平均时间复杂度：O(n^2)    平均空间复杂度：O(1)
-(void)selectSort:(NSMutableArray *)array
{
    for (int i=0; i<array.count; i++) {
        for (int j=i+1; j<array.count; j++) {
            if ([array[i] integerValue]>[array[j] integerValue]) {//依次与后面的比较，小的往前放，每一遍循环会把（j-array.count）中最小的放i的位置
                [array exchangeObjectAtIndex:i withObjectAtIndex:j];
            }
        }
    }
    NSLog(@"22--%@",array);
}
//MARK: - 冒泡排序  空间复杂度 O(n)。   最差时间复杂度 O(n^2)  平均时间复杂度 O(n^2)
-(void)bubbleSort:(NSMutableArray *)array
{
    for (int i=0; i<array.count; i++) {
        for (int j=0; j<array.count-1-i; j++) {
            if ([array[j] integerValue]>[array[j+1] integerValue]) {//相邻两个比较，左边>右边交换位置
                [array exchangeObjectAtIndex:j withObjectAtIndex:j+1];
            }
        }
    }
    NSLog(@"11--%@",array);
}


@end
