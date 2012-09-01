#import <UIKit/UIKit.h>
#import "DirectionRecipient.h"

@class RouteFetcher;
@class StopsFetcher;

@interface NextArrivalViewController : UIViewController<UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource,RouteRecipient>

@property (strong, nonatomic) UIButton *findButton;
@property (strong, nonatomic) UITextField *routeField;
@property (strong, nonatomic) UIActivityIndicatorView *spinner;
@property (strong, nonatomic) UILabel *nextArrivalTimeLabel;

- (id)initWithRouteFetcher:(RouteFetcher *)aDirectionsFetcher
 directionButtonDimensions:(CGRect)directionButtonDimensions
   directionButtonYPadding:(CGFloat)directionButtonYPadding;

@end
