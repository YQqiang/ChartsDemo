//
//  ViewController.m
//  ChartsDemo
//
//  Created by sungrow on 2017/8/30.
//  Copyright © 2017年 yuqiang. All rights reserved.
//

#import "ViewController.h"
#import <Charts/Charts-Swift.h>
#import "UIColor+Util.h"


@interface ViewController ()

/** 折线和柱状图表 */
@property (nonatomic, strong) CombinedChartView *combinedChartView;
/** 图表的x轴坐标 */
@property (nonatomic,strong) NSMutableArray *xVals;
@property (nonatomic, strong) NSDictionary *dataDic;

@end

@implementation ViewController

#pragma mark - <lazy>
- (NSMutableArray *)xVals {
    if (!_xVals) {
        _xVals = [NSMutableArray array];
        NSArray *arr = (NSArray *)self.dataDic[@"result_data"][@"bar_data"];
        for (int i = 1 ; i <= arr.count; i ++) {
            [_xVals addObject:[NSString stringWithFormat:@"%02d",i]];
        }
    }
    return _xVals;
}

- (NSDictionary *)dataDic {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"data.json" ofType:nil];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSJSONSerialization *dic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    if ([dic isKindOfClass:[NSDictionary class]]) {
        return (NSDictionary *)dic;
    }
    return @{};
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.combinedChartView = [[CombinedChartView alloc] init];
    [self setupcombinedChartView];
    [self.view addSubview:self.combinedChartView];
    self.combinedChartView.frame = CGRectMake(0, 44, [UIScreen mainScreen].bounds.size.width , 240);
    [self loadChartData];
}

- (void)loadChartData {
    [_combinedChartView animateWithYAxisDuration:1.4];
    CombinedChartData *data = [[CombinedChartData alloc] initWithXVals:self.xVals];
    data.barData = [self generateBarData];
    data.lineData = [self generateLineData];
    _combinedChartView.data = data;
}

//初始化图表
- (void)setupcombinedChartView {
//    _combinedChartView.delegate = self;
    _combinedChartView.backgroundColor = [UIColor clearColor];
    _combinedChartView.descriptionText = @"";
    _combinedChartView.noDataText = @"";
    _combinedChartView.noDataTextDescription = NSLocalizedString(@"暂无数据", nil);
    _combinedChartView.drawOrder = @[
                                     @(CombinedChartDrawOrderBar),
                                     @(CombinedChartDrawOrderLine)
                                     ];
    
    _combinedChartView.pinchZoomEnabled = NO;
    _combinedChartView.drawBarShadowEnabled = NO;
    _combinedChartView.drawGridBackgroundEnabled = NO;
    _combinedChartView.drawValueAboveBarEnabled = NO;
    
    ChartXAxis *xAxis = _combinedChartView.xAxis;
    xAxis.labelPosition = XAxisLabelPositionBottom;
    xAxis.spaceBetweenLabels = 0.0;
    xAxis.drawGridLinesEnabled = NO;
    
    ChartYAxis *leftAxis = _combinedChartView.leftAxis;
    leftAxis.labelFont = [UIFont systemFontOfSize:10.f];
    leftAxis.drawAxisLineEnabled = YES;
    leftAxis.axisMinValue = 0.0;
    leftAxis.granularityEnabled = NO;
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = kCFNumberFormatterDecimalStyle;
    leftAxis.valueFormatter = formatter;
    
    _combinedChartView.rightAxis.enabled = NO;
    
    _combinedChartView.scaleXEnabled = NO;
    _combinedChartView.scaleYEnabled = NO;
    
    ChartLegend *legend = _combinedChartView.legend;
    legend.enabled = NO;
}

//计划发电生成柱状图
- (BarChartData *)generateBarData {
    BarChartData *d = [[BarChartData alloc] init];
    NSMutableArray *entries = [[NSMutableArray alloc] init];
    NSArray *actualEnergy = self.dataDic[@"result_data"][@"bar_data"];
    for (int index = 0; index < [actualEnergy count]; index++) {
        double  actual_energy=[[actualEnergy objectAtIndex:index] doubleValue];
        actual_energy = actual_energy > 0 ? actual_energy : 0;
        [entries addObject:[[BarChartDataEntry alloc] initWithValue:(actual_energy) xIndex:index]];
    }
    BarChartDataSet *set = [[BarChartDataSet alloc] initWithYVals:entries label:@""];
    set.barSpace = self.xVals.count == 1 ? 1.08 : self.xVals.count < 5 ? 1.2 : 0.5;
    [set setColor:[UIColor barPriorityAColor]];
    set.valueTextColor = [UIColor barPriorityAColor];
    set.valueFont = [UIFont systemFontOfSize:0.f];
    set.axisDependency = AxisDependencyLeft;
    [d addDataSet:set];
    return d;
}

//实际发电生成折线图
- (LineChartData *)generateLineData {
    LineChartData *d = [[LineChartData alloc] init];
    NSMutableArray *entries = [[NSMutableArray alloc] init];
    NSArray *planEnergy = self.dataDic[@"result_data"][@"line_data"];
    for (int index = 0; index < [planEnergy count] ; index++) {
        double plan_energy = [[planEnergy objectAtIndex:index] doubleValue];
        plan_energy = plan_energy > 0 ? plan_energy : 0;
        [entries addObject:[[ChartDataEntry alloc] initWithValue:(plan_energy) xIndex:index]];
    }
    if (planEnergy.count != 0) {
        for (NSUInteger index = planEnergy.count - 1; index > 0; index --) {
            NSString *str = [planEnergy objectAtIndex:index];
            if ([str isEqualToString:@"--"]) {
                [entries removeObjectAtIndex:index];
            } else {
                break;
            }
        }
    }
    
    LineChartDataSet *set = [[LineChartDataSet alloc] initWithYVals:entries label:@""];
    [set setColor:[UIColor linePriorityAColor]];
    set.lineWidth = 1.5;
    [set setCircleColor:[UIColor linePriorityAColor]];
    set.fillColor = [UIColor linePriorityAColor];
    set.drawCubicEnabled = NO;
    set.drawValuesEnabled = YES;
    set.drawCircleHoleEnabled = NO;
    set.circleRadius = 3.0f;
    set.valueFont = [UIFont systemFontOfSize:0.f];
    set.valueTextColor = [UIColor linePriorityAColor];
    set.axisDependency = AxisDependencyLeft;
    
    [d addDataSet:set];
    
    return d;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
