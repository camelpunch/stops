#import "ActivityIndicator.h"

@implementation ActivityIndicator
{
    UIActivityIndicatorView *theIndicatorView;
}

- (id)initWithIndicatorView:(UIActivityIndicatorView *)anIndicatorView
{
    self = [super init];
    if (self) {
        theIndicatorView = anIndicatorView;
    }
    return self;
}

- (void)activityStartedOnView:(UIView *)aView
{
    theIndicatorView.center = CGPointMake(aView.center.x, 20);
    [aView addSubview:theIndicatorView];
    [theIndicatorView startAnimating];
}

- (void)activityStoppedOnView:(UIView *)aView
{
    [theIndicatorView stopAnimating];
}

@end
