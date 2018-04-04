//
//  SwitchImageAnimationView.m
//  Mark_test
//
//  Created by slb on 2018/4/2.
//  Copyright © 2018年 slb. All rights reserved.
//

#import "SwitchImageAnimationView.h"

@interface SwitchImageAnimationView ()
@property (nonatomic, assign) CGFloat w;
@property (nonatomic, assign) CGFloat h;
@property (nonatomic, strong) NSArray <UIImage *>*imageArray;
@property (nonatomic, strong) UIImageView *upImgView;
@property (nonatomic, strong) UIImageView *downImgView;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, assign) CGFloat animationTime;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) CAShapeLayer *maskLayer;
@property (nonatomic, strong) CABasicAnimation *maskAnimation;
@property (nonatomic, strong) CAShapeLayer *whiteLayer;
@property (nonatomic, strong) CABasicAnimation *whiteAnimation;
// 倾斜角度
@property (nonatomic, assign) CGFloat slopeAngle;
// 白条的宽度
@property (nonatomic, assign) CGFloat lineWidth;
@end

@implementation SwitchImageAnimationView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _lineWidth = 40;
        _currentIndex = 0;
        _animationTime = 3;
        _slopeAngle = M_PI/3;
        _w = self.bounds.size.width;
        _h = self.bounds.size.height;
        
        [self buildUI];
    }
    return self;
}

- (void)buildUI{
    
    if (self.imageArray.count) {
        [self addSubview:self.upImgView];
        self.upImgView.image = [self.imageArray firstObject];
        
        if (self.imageArray.count > 1){
            [self insertSubview:self.downImgView belowSubview:self.upImgView];
            self.downImgView.image = self.imageArray[1];
            
            [self animationAction];
            
            self.timer = [NSTimer scheduledTimerWithTimeInterval:_animationTime target:self selector:@selector(animationAction) userInfo:nil repeats:YES];
            [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
        }
    }
}

- (void)animationAction{
    NSInteger nextIndex = _currentIndex == self.imageArray.count - 1 ? 0 : _currentIndex + 1;
    
    self.downImgView.image = self.upImgView.image;
    self.upImgView.image = self.imageArray[nextIndex];
    self.upImgView.layer.mask = self.maskLayer;
    [self.maskLayer addAnimation:self.maskAnimation forKey:nil];
    [self.whiteLayer addAnimation:self.whiteAnimation forKey:nil];
    
    if (nextIndex) {
        _currentIndex ++;
    }else{
        _currentIndex = 0;
    }
}

- (NSArray<UIImage *> *)imageArray{
    if (!_imageArray) {
        _imageArray = @[
                        [UIImage imageNamed:@"001"],
                        [UIImage imageNamed:@"002"],
                        [UIImage imageNamed:@"003"]];
    }
    return _imageArray;
}

- (UIImageView *)upImgView{
    if (!_upImgView) {
        _upImgView = [[UIImageView alloc] initWithFrame:self.bounds];
    }
    return _upImgView;
}

- (UIImageView *)downImgView{
    if (!_downImgView) {
        _downImgView = [[UIImageView alloc] initWithFrame:self.bounds];
    }
    return _downImgView;
}

- (CAShapeLayer *)maskLayer{
    if (!_maskLayer) {
        
        CGFloat p_w = 2 * _w + _h/tan(_slopeAngle);
        UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, p_w, _h)];
        
        // 白条的四个点的origin.x
        CGFloat a1 = _w + _h/tan(_slopeAngle);
        CGFloat a3 = _w;
        
        UIBezierPath *path_1 = [UIBezierPath bezierPath];
        [path_1 moveToPoint:CGPointMake(a1, 0)];
        [path_1 addLineToPoint:CGPointMake(p_w, 0)];
        [path_1 addLineToPoint:CGPointMake(p_w, _h)];
        [path_1 addLineToPoint:CGPointMake(a3, _h)];
        [path_1 closePath];
        
        [path appendPath:path_1];
        
        _maskLayer = [CAShapeLayer layer];
        _maskLayer.frame = CGRectMake(- (p_w - _w), 0, p_w, _h);
        _maskLayer.path = path.CGPath;
        _maskLayer.fillRule = kCAFillRuleEvenOdd;
        
        [self.layer addSublayer:self.whiteLayer];
    }
    return _maskLayer;
}

- (CAShapeLayer *)whiteLayer{
    if (!_whiteLayer) {
        _whiteLayer = [CAShapeLayer layer];
        _whiteLayer.fillColor = [UIColor whiteColor].CGColor;
        _whiteLayer.frame = CGRectMake(-(_lineWidth + _h/tan(_slopeAngle)), 0, _lineWidth + _h/tan(_slopeAngle), _h);
        
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(0, _h)];
        [path addLineToPoint:CGPointMake(_lineWidth, _h)];
        [path addLineToPoint:CGPointMake(_lineWidth + _h/tan(_slopeAngle), 0)];
        [path addLineToPoint:CGPointMake(_h/tan(_slopeAngle), 0)];
        [path closePath];
        _whiteLayer.path = path.CGPath;
    }
    return _whiteLayer;
}

- (CABasicAnimation *)maskAnimation{
    if (!_maskAnimation) {
        CGFloat x = - (_h/tan(_slopeAngle))/2;
        _maskAnimation = [CABasicAnimation animationWithKeyPath:@"position.x"];
        _maskAnimation.fromValue = [NSValue valueWithCGPoint:CGPointMake(x, 0)];
        _maskAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(_w - x, 0)];
        _maskAnimation.duration = _animationTime;
    }
    return _maskAnimation;
}

- (CABasicAnimation *)whiteAnimation{
    if (!_whiteAnimation) {
        CGFloat x = - (_lineWidth + _h/tan(_slopeAngle))/2;
        _whiteAnimation = [CABasicAnimation animationWithKeyPath:@"position.x"];
        _whiteAnimation.fromValue = [NSValue valueWithCGPoint:CGPointMake(x, 0)];
        _whiteAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(_w - x, 0)];
        _whiteAnimation.duration = _animationTime;
    }
    return _whiteAnimation;
}

- (void)dealloc{
    [self.timer invalidate];
    self.timer = nil;
}

@end
