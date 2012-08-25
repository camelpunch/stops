#import "Kiwi.h"
#import "NextArrivalViewController.h"
#import "DirectionsFetcher.h"

SPEC_BEGIN(NextArrivalSpec)

describe(@"clicking the find button", ^{
    it(@"retrieves directions for the given route number", ^{
        id fetcher = [DirectionsFetcher mock];
        NextArrivalViewController *controller = [[NextArrivalViewController alloc] initWithFetcher:fetcher];
        [controller view];
        [[controller.view shouldNot] beNil];
        [[[controller.view should] have:1] subviews];
        [[fetcher should] receive:@selector(fetchDirectionsForRoute:)
                    withArguments:@"22"];
        [controller findButtonClicked];
    });
});

SPEC_END
