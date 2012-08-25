#import "Kiwi.h"
#import "NextArrivalViewController.h"
#import "DirectionsFetcher.h"

SPEC_BEGIN(NextArrivalSpec)

describe(@"clicking the find button", ^{
    it(@"retrieves directions for the given route number", ^{
        id fetcher = [DirectionsFetcher mock];
        NextArrivalViewController *controller = [[NextArrivalViewController alloc] initWithFetcher:fetcher];
        [controller view];
        
        controller.routeField.text = @"22";
        
        [[fetcher should] receive:@selector(fetchDirectionsForRoute:)
                    withArguments:@"22"];
        [controller findButtonClicked];
    });
    
    it(@"shows the loading spinner", ^{
        id fetcher = [DirectionsFetcher mock];
        [fetcher stub:@selector(fetchDirectionsForRoute:)];
        
        NextArrivalViewController *controller = [[NextArrivalViewController alloc] initWithFetcher:fetcher];
        [controller view];
        
        controller.routeField.text = @"22";
        
        [[theValue(controller.spinner.isAnimating) should] beFalse];
        [controller findButtonClicked];
        [[theValue(controller.spinner.isAnimating) should] beTrue];
    });
});

SPEC_END
