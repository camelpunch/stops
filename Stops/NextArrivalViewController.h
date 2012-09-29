#import <UIKit/UIKit.h>
#import "DirectionRecipient.h"
#import "PredictionRecipient.h"

@class NextBusRouteFetcher;
@class StopsFetcher;
@protocol ActivityDelegate;
@protocol Predictor;

@interface NextArrivalViewController : UIViewController<UISearchBarDelegate,UIPickerViewDelegate,UIPickerViewDataSource,RouteRecipient,PredictionRecipient>

@property (strong, nonatomic) UISearchBar *routeField;
@property (strong, nonatomic) UILabel *nextArrivalTimeLabel;
@property (weak, nonatomic) id<ActivityDelegate> activityDelegate;

- (id)initWithRouteFetcher:(NextBusRouteFetcher *)aRouteFetcher
                 predictor:(id<Predictor>)aPredictor;

@end
