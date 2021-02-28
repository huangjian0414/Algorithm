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
    NSMutableArray *array=[NSMutableArray array];
    for (int i=0; i<100; i++) {
        [array addObject:@(arc4random()%100)];
    }
//    array = @[@2,@4,@3,@1].mutableCopy;
    //array = @[@4,@1,@2,@3].mutableCopy;
//    [self bubbleSort:array.mutableCopy];
//    [self selectSort:array.mutableCopy];
//    array = @[@2,@4,@3,@1,@7,@9,@5].mutableCopy;
//    [self quickSort:array];
//    NSLog(@"%@",array);
//    [self insertSort:array.mutableCopy];
//    [self mergeSort:array];
//    [self shellSort:array.mutableCopy];
//    [self radixSort:array.mutableCopy];
    [self heapSort:array.mutableCopy];
}
//MARK: - 堆排序
/*
 生成堆 父节点的数都大于字节点 即大根堆
 固定一个最大值，将剩余的数重新构造成一个大根堆，重复这样的过程
 */
-(void)heapSort:(NSMutableArray *)array
{
    array=@[@3,@6,@8,@5,@7].mutableCopy;
    NSInteger endIndex=array.count-1;
    array=[self createHeap:array];//arr初始化大根堆
    while (endIndex >= 0) {
//        NSNumber *temp = array[0];//最大值
//        array[0] = array[endIndex];//第一父节点=最后的节点
//        array[endIndex] = temp;// 最后的节点
        [array exchangeObjectAtIndex:0 withObjectAtIndex:endIndex];
        endIndex -= 1; // 去掉一个index
        array = [self heapAdjast:array withStartIndex:0 withEndIndex:endIndex + 1];//重新构造大根堆
    }
    NSLog(@"88--%@", array);
}
-(NSMutableArray *)createHeap:(NSMutableArray *)array
{
    //@3,@6,@8,@5,@7
    NSInteger i = array.count;
    while (i > 0) {
        array = [self heapAdjast:array withStartIndex:i - 1 withEndIndex:array.count];
        i -= 1;
    }
    return array;
}
-(NSMutableArray *)heapAdjast:(NSMutableArray *)items withStartIndex:(NSInteger)startIndex withEndIndex:(NSInteger)endIndex
{
    NSNumber *temp = items[startIndex];
    NSInteger fatherIndex = startIndex + 1;
    NSInteger maxChildIndex = 2 * fatherIndex;
    while (maxChildIndex <= endIndex) {
        if (maxChildIndex < endIndex && [items[maxChildIndex - 1] floatValue] < [items[maxChildIndex] floatValue]) {
            maxChildIndex++;
        }
        if ([temp floatValue] < [items[maxChildIndex - 1] floatValue]) {
            items[fatherIndex - 1] = items[maxChildIndex - 1];
        } else {
            break;
        }
        fatherIndex = maxChildIndex;
        maxChildIndex = fatherIndex * 2;
    }
    items[fatherIndex - 1] = temp;
    return items;
}

//MARK: - 基数排序
/*
 比如 (556，3，49，26，34)。最大位数3位556 maxDigit=3 创建10个桶 提取位上的数
 从个位开始 ((3)(34),(556,26)(49))  --> (3,34,556,26,49)
 看十位 ((3),(26)(34)(49)(556)) ---> (3,26,34,49,556)
 看百位 ((3),(26),(34),(49),(556)) --->(3,26,34,49,556)
 */
-(void)radixSort:(NSMutableArray *)array
{
    array = @[@556,@3,@49,@26,@34].mutableCopy;
    NSMutableArray *buckets=[self createBucket];
    NSInteger maxDigit=[self getMaxDigit:array];
    for (int i=1; i<=maxDigit; i++) {
        for (int j=0; j<array.count; j++) {
            NSInteger baseNum=[self fetchBaseNumber:array[j] digit:i];
            [buckets[baseNum] addObject:array[j]];//位上的数相同的放一起
        }
        NSInteger k=0;
        /// 重新生成数组
        for (int i=0; i<buckets.count; i++) {
            NSMutableArray *bucket=buckets[i];
            while (bucket.count != 0) {
                NSNumber *number = [bucket objectAtIndex:0]; //取出桶里的第一个
                array[k] = number;
                [bucket removeObjectAtIndex:0];//删除第一个 继续while
                k++;
            }
        }
    }
    NSLog(@"77-- %@",array);
}
//提取每个原素的基数   digit 比如个位1 十位2
-(NSInteger)fetchBaseNumber:(NSNumber *)number digit:(NSInteger)digit
{
    NSString *numString=[NSString stringWithFormat:@"%@",number];
    if (digit>0&&digit<=numString.length) {
        NSString *str=[numString substringWithRange:NSMakeRange(numString.length-digit, 1)];
        return [str integerValue];
    }
    return 0;
}
//获取最大数的位数  即最大的是几位数
-(NSInteger)getMaxDigit:(NSMutableArray *)array
{
    NSInteger maxNum=[array.firstObject integerValue];
    for (int i=0; i<array.count; i++) {
        if (maxNum<[array[i]integerValue]) {
            maxNum=[array[i]integerValue];
        }
    }
    NSString *numString=[NSString stringWithFormat:@"%ld",maxNum];
    return numString.length;
}
//创10个桶桶 存放位上的数是0-9
-(NSMutableArray *)createBucket
{
    NSMutableArray *buckets=[NSMutableArray array];
    for (int i=0; i<10; i++) {
        NSMutableArray *array=[NSMutableArray array];
        [buckets addObject:array];
    }
    return buckets;
}
//MARK: - 希尔排序
-(void)shellSort:(NSMutableArray *)array
{
    //如 5,8,3,7,22,4,2    增量7/2=3  即每搁3个数合起来为一组
    //相当于（5,7,2）(8,22)(3,4)  ---> (2,8,3,5,22,4,7) 增量3/2=1
    //(5,8,3,7,22,4,10) -->(3,4,5,7,8,10,22)
    
    //array = @[@5,@8,@3,@7,@22,@4,@2].mutableCopy;
    int increment=array.count/2.0;//增量
    while (increment>=1) {
        for (int i=increment; i<array.count; i++) {//按增量分组进行插入排序
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
    //每个数都用一个数组装着  即分
    for (int i=0; i<array.count; i++) {//初始化
        NSMutableArray *subArray=[NSMutableArray array];
        [subArray addObject:array[i]];
        [tempArray addObject:subArray];
    }
    while (tempArray.count!=1) {
        NSInteger i=0;
        while (i<tempArray.count-1) {//递归排序合并相邻数组
            tempArray[i]=[self mergeWithfirstArray:tempArray[i] secondArray:tempArray[i+1]];//将相邻的2个数排序并合并到一个数组赋值给前面。 即治
            [tempArray removeObjectAtIndex:i+1];//删除后面无用的数组
            i++;
        }
    }
    NSLog(@"55--%@",tempArray.firstObject);
}
-(NSMutableArray *)mergeWithfirstArray:(NSMutableArray *)firstArray secondArray:(NSMutableArray *)secondArray
{
    // 用一个新的数组来存放排序的元素
    NSMutableArray *mergeArray=[NSMutableArray array];
    NSInteger first = 0,second = 0;
    // 比如 （3，4，1，7）
    // 第一步 ((3)(4)(1)(7))
    // 3<4 mergearray=(3) first = 1 第一个while不满足了 第二个也不满足了 第3个满足 mergearray=(3,4)都不满足了return(3,4)  同理1，7返回（1，7）
    //((3,4)(1,7))
    //3>1 第一个while走else merge=(1) second=1 继续3<7 merge=(1,3) first=1 继续4<7 merge=(1,3,4) first=2 第一个while不满足了 第二个也不满足了 第3个满足，merge=(1,3,4,7) 都不满足了 return(1,3,4,7) 完成
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
/*
 arr=(2,4,3,1)  假设2已经排好序 遍历将2右边的数插入正确的位置
 i=1 num=arr[i]=4 j=0  4不小于arr[j] 不进while 把4放到j+1的位置 arr=(2,4,3,1)
 i=2 num=arr[i]=3 j=1  3<4 (2,4,4,1)  j=0   继续不满足while条件(3不小于arr[j=0]=2)  将num(3)插到(1)正确的位置(2,3,4,1)
 i=3 num=arr[i]=1 j=2  (2,3,4,4) j=1 继续1<3 (2,3,3,4) j=0 继续1<2 (2,2,3,4) j=-1不满足while条件 将num(1)插到(0)正确的位置(1,2,3,4)
 */
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
/// 将比基准数小的全放左边 ，大的全放右边  分成左右2个区间之后 ，分别继续这个操作
/*
 arr = 2,4,3,1,7,9,5
 i=0 j=6 key=arr[0]=2 left=0 right=6
 0<6进while  右边(4,3,1,7,9,5)里找比2小的j=j-3=3 arr=(1,4,3,2,7,9,5) 2右边的数都比它大   左边(1,4,3)找比2大的i=i+1=1 arr=(1,2,3,4,7,9,5) 2左边的都比它小，4右边的都比它大，但是2和4之间的数不清楚，所以往下继续这种操作 找2-4之间的数
 这时候i=1 j=3 继续 key=2 右边(2,3,4)里找比2小的 没有j=j-2=1 i=1=j 结束 arr还是=(1,2,3,4,7,9,5) i=j=1 第一波外层while完毕，2左边的都比它小，右边的都比它大
 
 递归左边 i=0 j=0 结束
 递归右边 i=2 j=6 key=arr[2]=3 left=2 right=6 右边(4,7,9,5)找比3小的j=2 arr没变化 左边i=j=2结束
 
 递归左边 i=2 j=1 结束
 递归右边 i=3 j=6 key=arr[3]=4 left=3 right=6 右边(7,9,5)找比4小的j=3 arr没变化 左边i=j=3结束
 
 递归左边 i=3 j=2 结束
 递归右边 i=4 j=6 key=arr[4]=7 left=4 right=6 右边(9,5)找比7小的j=6 arr=(1,2,3,4,5,9,7) 左边(5,9)找比7大的i=5 arr=(1,2,3,4,5,7,9)
 i=5 j=6 继续外层while 右边(9)找比7小的 j=5=i 结束
 
 递归左边 i=4 j=4 结束
 递归右边 i=6 j=6 结束
 */
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
//从第一个位置数开始分别与后面的数比较，如果大于那个数就交换位置，再以第一个位置的数继续和后面的数比较，大于继续交换位置，即把小的往左边移
/*
 将最小的数移到左边，和数组里每个数都比较，最多比较count-1=3次即可
 arr = 2,4,3,1  第一层for遍历总共3次，从2开始遍历比较  第二层for遍历j=4-i-1次 从4开始遍历比较
 i=0  j进行4-0-1=3次遍历 2<4不动，2<3不动 ,2>1交换 arr=1,4,3,2  即将最小的1移到最左边
 i=1  j进行4-1-1=2次遍历 4>3交换arr=1,3,4,2 ,3>2交换arr=1,2,4,3
 i=2  j进行4-2-1=1次遍历 4>3交换arr=1,2,3,4 排序完成
 */
-(void)selectSort:(NSMutableArray *)array
{
    for (int i=0; i<array.count-1; i++) {
        for (int j=i+1; j<array.count; j++) {
            if ([array[i] integerValue]>[array[j] integerValue]) {//依次与后面的比较，小的往前放，每一遍循环会把（j-array.count）中最小的放i的位置
                [array exchangeObjectAtIndex:i withObjectAtIndex:j];
            }
        }
    }
    NSLog(@"22--%@",array);
}
//MARK: - 冒泡排序  空间复杂度 O(n)。   最差时间复杂度 O(n^2)  平均时间复杂度 O(n^2)  优化设置标识符，如果第二遍历完没有发生交换即提前排序完就不要再遍历了
/*
 第一遍将最大的数移到右边，相邻的2个数依次比较，最多比较count-1=3次即可
arr = 2,4,3,1  第一层for遍历总共3次，从4开始遍历比较  第二层for遍历j=4-i次 从2开始遍历比较
i=1  j进行4-1=3次遍历 2<4不动，4>3交换arr=2,3,4,1 ,4>1交换 arr=2,3,1,4  即将最大的4移到最右边
i=2  j进行4-2=2次遍历 2<3不动 3>1交换arr=2,1,3,4 最大的4已经移动过到右边了所以不用再遍历比较它，因此将第二大的3已到倒数第二
i=3  j进行4-3=1次遍历 2>1交换arr=1,2,3,4 将第3大的移到倒数第3，剩下的1就是最小的了，排序完成
 */
-(void)bubbleSort:(NSMutableArray *)array
{
    int a = 0;
    for (int i=1; i<array.count; i++) {
        BOOL isChange = NO;
        for (int j=0; j<array.count-i; j++) {
            if ([array[j] integerValue]>[array[j+1] integerValue]) {//相邻两个比较，左边>右边交换位置
                [array exchangeObjectAtIndex:j withObjectAtIndex:j+1];
                isChange = YES;
            }
            a++;
        }
        if (!isChange) {
            break;
        }
    }
    NSLog(@"11--%@",array);
    NSLog(@"次数--%d",a);
}


@end
