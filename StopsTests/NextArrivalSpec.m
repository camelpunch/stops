#import "Kiwi.h"
#import "NextArrivalViewController.h"
#import "DirectionsFetcher.h"
#import "Direction.h"

SPEC_BEGIN(NextArrivalSpec)

describe(@"getting the next arrival for a stop in a chosen direction", ^{
    __block id fetcher;
    __block NextArrivalViewController *controller;
    __block Direction *inbound;
    __block Direction *outbound;
    __block CGRect directionButtonDimensions;
    
    beforeEach(^{
        fetcher = [DirectionsFetcher mock];
        directionButtonDimensions = CGRectMake(10, 20, 30, 40);
        controller = [[NextArrivalViewController alloc] initWithFetcher:fetcher
                                              directionButtonDimensions:directionButtonDimensions];
        inbound = [[Direction alloc] initWithName:@"Inbound to Hell"];
        outbound = [[Direction alloc] initWithName:@"Outbound to Heaven"];
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
        
        it(@"removes any previous direction buttons", ^{
            [controller view];
            
            controller.routeField.text = @"43";
            [fetcher stub:@selector(fetchDirectionsForRouteName:)];

            [controller addDirection:inbound];
            
            UIButton *directionButton = [controller.view.subviews lastObject];
            
            UIView *anotherView = [[UIView alloc] init];
            [controller.view addSubview:anotherView];
            
            NSUInteger buttonCountBefore = controller.view.subviews.count;
            [controller findButtonClicked];
            [[theValue(controller.view.subviews.count) should] equal:theValue(buttonCountBefore - 1)];
            [[controller.view.subviews should] contain:anotherView];
            [[controller.view.subviews shouldNot] contain:directionButton];
        });
    });
    
    describe(@"receiving a direction", ^{
        __block NSUInteger initialSubviewsCount;
        __block UIButton *firstButton;
        __block UIButton *secondButton;
        
        beforeEach(^{
            [controller view];
            initialSubviewsCount = controller.view.subviews.count;
        });
        
        it(@"stops the spinner", ^{
            [controller.spinner startAnimating];
            [controller addDirection:outbound];
            [[theValue(controller.spinner.isAnimating) should] beFalse];
        });
        
        it(@"displays the first direction as a button with appropriate text", ^{
            [controller addDirection:outbound];
            [[[controller.view should] have:initialSubviewsCount + 1] subviews];
            firstButton = [controller.view.subviews lastObject];
            [[firstButton.titleLabel.text should] equal:@"Outbound to Heaven"];
        });
    
        it(@"displays subsequent direction buttons beneath the previous button", ^{
            [controller addDirection:outbound];
            [controller addDirection:inbound];
            secondButton = [controller.view.subviews lastObject];
            [[theValue(secondButton.frame.origin.y) should]
             beGreaterThan:theValue(firstButton.frame.origin.y + firstButton.frame.size.height)];
        });
        
        it(@"resets the position of new buttons if find has been pressed", ^{
            [fetcher stub:@selector(fetchDirectionsForRouteName:)];

            [controller addDirection:outbound];
            [controller addDirection:inbound];
            [controller findButtonClicked];
            [controller addDirection:outbound];
            
            firstButton = [controller.view.subviews lastObject];
            [[theValue(firstButton.frame.origin.y) should] equal:theValue(directionButtonDimensions.origin.y)];
        });
    });
});

SPEC_END
