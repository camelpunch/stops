#import "Kiwi.h"
#import "ActivityIndicator.h"

SPEC_BEGIN(ActivityIndicatorSpec)

describe(@"activity indicator", ^{
    __block UIView *view;
    __block UIActivityIndicatorView *spinner;
    __block ActivityIndicator *indicator;
    
    beforeEach(^{
        view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
        spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        indicator = [[ActivityIndicator alloc] initWithIndicatorView:spinner];
    });
    
    describe(@"when activity starts", ^{
        beforeEach(^{
            [indicator activityStartedOnView:view];
        });
        
        it(@"starts the spinner", ^{
            [[theValue(spinner.isAnimating) should] beTrue];
        });
        
        it(@"adds the spinner as a subview of the provided view", ^{
            [[spinner.superview should] equal:view];
        });
        
        it(@"centers the spinner horizontally inside the provided view", ^{
            [[theValue(spinner.center.x) should] equal:theValue(view.center.x)];
        });
    });
    
    it(@"stops the spinner when activity ends", ^{
        [indicator activityStartedOnView:view];
        [indicator activityStoppedOnView:view];
        [[theValue(spinner.isAnimating) should] beFalse];
    });
});

SPEC_END
