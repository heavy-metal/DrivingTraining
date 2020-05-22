//
//  StartView.m
//  mxmovies
//
//  Created by mac1 on 16/7/17.
//  Copyright © 2016年 mac1. All rights reserved.
//

#import "StartView.h"
#import "UIViewExt.h"
@interface StartView ()
@property (nonatomic, assign) CGFloat yellowWidth;

@end
@implementation StartView
- (void)awakeFromNib {
    [super awakeFromNib];
    
//    [self creatStartView];
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self != nil) {
        [self creatStartView];
    }
    return self;
}

-(UIImage *)yellowImage {
    if (!_yellowImage) {
        _yellowImage = [UIImage imageNamed:@"yellow" ];
    }
    return _yellowImage;
}
-(UIView *)yellowView {
    if (!_yellowView) {
        
        _yellowView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.yellowImage.size.width*5, self.yellowImage.size.height)];
        _yellowView.backgroundColor = [UIColor colorWithPatternImage:self.yellowImage];
        _yellowWidth = _yellowView.width;
    }
    return _yellowView;
}


-(UIView *)grayView {
    if (!_grayView) {
        
        UIImage *grayImage = [UIImage imageNamed:@"gray"];
        _grayView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.yellowImage.size.width*5, self.yellowImage.size.height)];
        _grayView.backgroundColor = [UIColor colorWithPatternImage:grayImage];
    }
    return _grayView;
}
-(void)creatStartView{
    
    [self addSubview:self.grayView];
    [self addSubview:self.yellowView];
    //拿到2个view的比例
    CGFloat scale = self.frame.size.height/ self.yellowImage.size.height;
    
    self.yellowView.transform = CGAffineTransformMakeScale(scale, scale);
    self.grayView.transform = CGAffineTransformMakeScale(scale, scale);
    
    self.grayView.origin = CGPointMake(0, 0);
    self.yellowView.origin = CGPointMake(0, 0);
    
    
}
-(void)setRating:(CGFloat)rating{
    _rating = rating;
    
    _yellowWidth = _yellowWidth * 0.2 * self.rating;
    
    
}

@end
