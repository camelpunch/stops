#import <UIKit/UIKit.h>

@class DirectionsFetcher;

@interface NextArrivalViewController : UIViewController<UITextFieldDelegate>

@property (strong, nonatomic) UIButton *findButton;
@property (strong, nonatomic) UITextField *routeField;
@property (strong, nonatomic) UIActivityIndicatorView *spinner;

- (id)initWithFetcher:(DirectionsFetcher *)fetcher;
- (void)findButtonClicked;

@end
