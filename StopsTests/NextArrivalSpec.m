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
            
            [[fetcher should] receive:@selector(fetchDirectionsForRouteName:)
                        withArguments:@"22"];
            [controller findButtonClicked];
        });
        
        it(@"shows the loading spinner", ^{
            [controller view];
            
            controller.routeField.text = @"22";
            [fetcher stub:@selector(fetchDirectionsForRouteName:)];
            
            [[theValue(controller.spinner.isAnimating) should] beFalse];
            [controller findButtonClicked];
            [[theValue(controller.spinner.isAnimating) should] beTrue];
        });
    });
    
    describe(@"receiving a direction", ^{
        __block Direction *inbound;
        __block Direction *outbound;
        __block NSUInteger initialSubviewsCount;
        __block UIButton *firstButton;
        __block UIButton *secondButton;
        
        beforeEach(^{
            inbound = [[Direction alloc] initWithName:@"Inbound to Hell"];
            outbound = [[Direction alloc] initWithName:@"Outbound to Heaven"];
            [controller view];
            initialSubviewsCount = controller.view.subviews.count;
            [controller addDirection:outbound];
            [[[controller.view should] have:initialSubviewsCount + 1] subviews];
            firstButton = [controller.view.subviews lastObject];
        });
        
        it(@"displays the first direction as a button with appropriate text", ^{
            [[firstButton.titleLabel.text should] equal:@"Outbound to Heaven"];
        });
    
        it(@"displays subsequent direction buttons beneath the previous button", ^{
            [controller addDirection:inbound];
            secondButton = [controller.view.subviews lastObject];
            [[theValue(secondButton.frame.origin.y) should]
             beGreaterThan:theValue(firstButton.frame.origin.y + firstButton.frame.size.height)];
        });
    });
});

SPEC_END
