#import "MCPEJoystickView.h"

@interface MCPEJoystickView ()

@property (nonatomic, strong) UIView *knobView;
@property (nonatomic) CGPoint startPoint;

@end

@implementation MCPEJoystickView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
        self.layer.cornerRadius = frame.size.width / 2;
        
        _knobView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width * 0.4, frame.size.height * 0.4)];
        _knobView.center = CGPointMake(frame.size.width / 2, frame.size.height / 2);
        _knobView.backgroundColor = [UIColor whiteColor];
        _knobView.layer.cornerRadius = _knobView.frame.size.width / 2;
        [self addSubview:_knobView];
        
        _startPoint = _knobView.center;
        
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
        [self addGestureRecognizer:pan];
    }
    return self;
}

- (void)handlePan:(UIPanGestureRecognizer *)gesture {
    CGPoint translation = [gesture translationInView:self];
    CGFloat maxDistance = self.frame.size.width / 2;

    CGPoint offset = CGPointMake(translation.x, translation.y);
    CGFloat distance = hypot(offset.x, offset.y);
    
    if (distance > maxDistance) {
        CGFloat scale = maxDistance / distance;
        offset.x *= scale;
        offset.y *= scale;
    }
    
    CGPoint knobCenter = CGPointMake(self.startPoint.x + offset.x, self.startPoint.y + offset.y);
    self.knobView.center = knobCenter;

    CGFloat dx = offset.x / maxDistance;
    CGFloat dy = offset.y / maxDistance;
    
    if (self.onDirectionChanged) {
        self.onDirectionChanged(dx, dy);
    }

    if (gesture.state == UIGestureRecognizerStateEnded || gesture.state == UIGestureRecognizerStateCancelled) {
        [UIView animateWithDuration:0.2 animations:^{
            self.knobView.center = self.startPoint;
        }];
        
        if (self.onDirectionChanged) {
            self.onDirectionChanged(0, 0); // reset
        }
    }
}

@end
