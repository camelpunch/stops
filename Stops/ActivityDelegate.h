#import <Foundation/Foundation.h>

@protocol ActivityDelegate <NSObject>

- (void)activityStartedOnView:(UIView *)aView;
- (void)activityStoppedOnView:(UIView *)aView;

@end
