#import <UIKit/UIKit.h>
#import "DirectionRecipient.h"
#import "PredictionRecipient.h"

@class RouteFetcher;
@class StopsFetcher;
@protocol ActivityDelegate;
@protocol Predictor;

@interface NextArrivalViewController : UIViewController<UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource,RouteRecipient,PredictionRecipient>

@property (strong, nonatomic) UIButton *findButton;
@property (strong, nonatomic) UITextField *routeField;
@property (strong, nonatomic) UILabel *nextArrivalTimeLabel;
@property (weak, nonatomic) id<ActivityDelegate> activityDelegate;

- (id)initWithRouteFetcher:(RouteFetcher *)aRouteFetcher
                 predictor:(id<Predictor>)aPredictor
 directionButtonDimensions:(CGRect)directionButtonDimensions
   directionButtonYPadding:(CGFloat)directionButtonYPadding;

@end
