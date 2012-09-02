#import <UIKit/UIKit.h>
#import "DirectionRecipient.h"

@class RouteFetcher;
@class StopsFetcher;
@protocol ActivityDelegate;

@interface NextArrivalViewController : UIViewController<UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource,RouteRecipient>

@property (strong, nonatomic) UIButton *findButton;
@property (strong, nonatomic) UITextField *routeField;
@property (strong, nonatomic) UILabel *nextArrivalTimeLabel;
@property (weak, nonatomic) id<ActivityDelegate> activityDelegate;

- (id)initWithRouteFetcher:(RouteFetcher *)aDirectionsFetcher
 directionButtonDimensions:(CGRect)directionButtonDimensions
   directionButtonYPadding:(CGFloat)directionButtonYPadding;

@end
