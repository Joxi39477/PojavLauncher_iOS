#import <UIKit/UIKit.h>

@interface MCPEJoystickView : UIView

@property (nonatomic, copy) void (^onDirectionChanged)(CGFloat dx, CGFloat dy);

@end
