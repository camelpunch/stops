#import <UIKit/UIKit.h>
#import "DirectionRecipient.h"
#import "PredictionRecipient.h"

@class NextBusRouteFetcher;
@class StopsFetcher;
@protocol ActivityDelegate;
@protocol Predictor;

@interface NextArrivalViewController : UIViewController<UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource,RouteRecipient,PredictionRecipient>

@property (strong, nonatomic) UIButton *findButton;
@property (strong, nonatomic) UITextField *routeField;
@property (strong, nonatomic) UILabel *nextArrivalTimeLabel;
@property (weak, nonatomic) id<ActivityDelegate> activityDelegate;

- (id)initWithRouteFetcher:(NextBusRouteFetcher *)aRouteFetcher
                 predictor:(id<Predictor>)aPredictor
 directionButtonDimensions:(CGRect)directionButtonDimensions
   directionButtonYPadding:(CGFloat)directionButtonYPadding;

@end
