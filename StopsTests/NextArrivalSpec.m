#import "Kiwi.h"
#import "NextArrivalViewController.h"
#import "DirectionsFetcher.h"
#import "Direction.h"

SPEC_BEGIN(NextArrivalSpec)

describe(@"getting the next arrival for a stop in a chosen direction", ^{
    __block id fetcher;
    __block NextArrivalViewController *controller;
    
    beforeEach(^{
        fetcher = [DirectionsFetcher mock];
        controller = [[NextArrivalViewController alloc] initWithFetcher:fetcher];
    });
    
    describe(@"clicking the find button", ^{
        it(@"retrieves directions for the given route number", ^{
            [controller view];
            
            controller.routeField.text = @"22";
            
            [[fetcher should] receive:@selector(fetchDirectionsForRoute:)
                        withArguments:@"22"];
            [controller findButtonClicked];
        });
        
        it(@"shows the loading spinner", ^{
            [controller view];
            
            controller.routeField.text = @"22";
            [fetcher stub:@selector(fetchDirectionsForRoute:)];
            
            [[theValue(controller.spinner.isAnimating) should] beFalse];
            [controller findButtonClicked];
            [[theValue(controller.spinner.isAnimating) should] beTrue];
        });
    });
    
    describe(@"receiving a direction", ^{
        it(@"displays the direction as a button", ^{
            [controller view];
            Direction *outboundToPotrero = [[Direction alloc] initWithName:@"Outbound to Potrero Hill"];
            
            NSUInteger subviewsCount = controller.view.subviews.count;
            
            [controller addDirection:outboundToPotrero];
            [[[controller.view should] have:subviewsCount + 1] subviews];
            
            [[[controller.view.subviews lastObject] should] beKindOfClass:[UIButton class]];
            UIButton *newButton = [controller.view.subviews lastObject];
            [[newButton.titleLabel.text should] equal:@"Outbound to Potrero Hill"];
        });
    });
});

SPEC_END
