//
//  ViewController.m
//  Mark_test
//
//  Created by slb on 2018/3/29.
//  Copyright © 2018年 slb. All rights reserved.
//

#import "ViewController.h"
#import "SwitchImageAnimationView.h"
@interface ViewController ()
@property (nonatomic, strong) CALayer *markLayer;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
//    [self test_1];
//    [self test_2];
    [self test_3];
}

- (void)test_3{
    SwitchImageAnimationView *view = [[SwitchImageAnimationView alloc] initWithFrame:CGRectMake(80, 80, 200, 200)];
    [self.view addSubview:view];
}

// 渐变色进度条
- (void)test_2{
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(20, 100, self.view.bounds.size.width - 40, 50)];
    [self.view addSubview:bgView];
    
    CALayer *bgLayer = [CALayer layer];
    bgLayer.backgroundColor = [UIColor grayColor].CGColor;
    bgLayer.frame = CGRectMake(0, 20, bgView.bounds.size.width, 10);
    bgLayer.cornerRadius = 5;
    [bgView.layer addSublayer:bgLayer];
    
    
    CALayer *markLayer = [CALayer layer];
    markLayer.frame = CGRectMake(-50, 0, 50, 10);
    markLayer.borderWidth = 5;
    
//    CAShapeLayer *markLayer = [CAShapeLayer layer];
////    markLayer.frame = CGRectMake(0, 0, 50, 10);
//    markLayer.strokeColor = [UIColor whiteColor].CGColor;
//    markLayer.lineWidth = 10;
//    markLayer.lineDashPattern = @[@5,@2,@3,@5];
//
//    UIBezierPath *path = [UIBezierPath bezierPath];
//    [path moveToPoint:CGPointMake(0, 5)];
//    [path addLineToPoint:CGPointMake(50, 5)];
//    markLayer.path = path.CGPath;
    _markLayer = markLayer;
    
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = bgLayer.frame;
    gradientLayer.cornerRadius = bgLayer.cornerRadius;
    gradientLayer.colors = @[
                             (id)[UIColor colorWithRed:1.00f green:0.39f blue:0.28f alpha:1.00f].CGColor,
                             (id)[UIColor colorWithRed:1.00f green:0.91f blue:0.53f alpha:1.00f].CGColor,
                             (id)[UIColor colorWithRed:0.03f green:0.65f blue:0.93f alpha:1.00f].CGColor,
                             (id)[UIColor colorWithRed:0.54f green:0.04f blue:0.82f alpha:1.00f].CGColor];
    gradientLayer.locations = @[@0.25,@0.5,@0.75,@1];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1, 0);
    gradientLayer.mask = markLayer;
    [bgView.layer addSublayer:gradientLayer];

    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position.x"];
    animation.fromValue = [NSValue valueWithCGPoint:CGPointMake(-markLayer.frame.size.width/2, 0)];
    animation.toValue = [NSValue valueWithCGPoint:CGPointMake(bgView.bounds.size.width + markLayer.frame.size.width/2, 0)];
    animation.duration = 2;
    animation.repeatCount = HUGE_VALF;
    animation.beginTime = CACurrentMediaTime() + 1;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//    animation.autoreverses = YES;
    [markLayer addAnimation:animation forKey:nil];
}

// 镂空的遮盖
- (void)test_1{
    self.view.backgroundColor = [UIColor whiteColor];
    UIView *backView = [[UIView alloc] initWithFrame:self.view.bounds];
    backView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    [self.view addSubview:backView];
    
    UIBezierPath *path_1 = [UIBezierPath bezierPathWithRect:self.view.bounds];
    //    UIBezierPath *path_2 = [UIBezierPath bezierPathWithRect:CGRectMake(self.view.bounds.size.width / 2 - 100, self.view.bounds.size.height / 2 - 100, 200, 200)];
    UIBezierPath *path_2 = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(100, 100, 100, 60) cornerRadius:6];
    //    UIBezierPath *path_2 = [UIBezierPath bezierPathWithArcCenter:CGPointMake(backView.center.x, backView.center.y) radius:50 startAngle:0 endAngle:M_PI clockwise:NO];
    [path_1 appendPath:path_2];
    
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.path = path_1.CGPath;
    layer.fillRule = kCAFillRuleEvenOdd;
    backView.layer.mask = layer;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
