#import <UIKit/UIKit.h>
#import "DirectionRecipient.h"

@class DirectionsFetcher;

@interface NextArrivalViewController : UIViewController<UITextFieldDelegate,DirectionRecipient>

@property (strong, nonatomic) UIButton *findButton;
@property (strong, nonatomic) UITextField *routeField;
@property (strong, nonatomic) UIActivityIndicatorView *spinner;

- (id)initWithFetcher:(DirectionsFetcher *)fetcher
directionButtonDimensions:(CGRect)directionButtonDimensions;
- (void)findButtonClicked;

@end
