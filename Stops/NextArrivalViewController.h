#import <UIKit/UIKit.h>

@class DirectionsFetcher;

@interface NextArrivalViewController : UIViewController

@property (weak, nonatomic) UIButton *findButton;

- (id)initWithFetcher:(DirectionsFetcher *)fetcher;
- (void)findButtonClicked;

@end
