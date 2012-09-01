#import "Kiwi.h"
#import "NextArrivalViewController.h"
#import "RouteFetcher.h"
#import "Direction.h"
#import "Stop.h"

SPEC_BEGIN(NextArrivalSpec)

describe(@"getting the next arrival for a stop in a chosen direction", ^{
    __block id routeFetcher;
    __block NextArrivalViewController *controller;
    __block Direction *inbound;
    __block Direction *outbound;
    __block CGRect directionButtonDimensions;
    __block CGFloat verticalPadding;
    
    beforeEach(^{
        routeFetcher = [RouteFetcher mock];
        directionButtonDimensions = CGRectMake(10, 20, 30, 40);
        verticalPadding = 10;
        controller = [[NextArrivalViewController alloc] initWithRouteFetcher:routeFetcher
                                                   directionButtonDimensions:directionButtonDimensions
                                                     directionButtonYPadding:verticalPadding];
        inbound = [[Direction alloc] initWithName:@"Inbound to Hell"];
        outbound = [[Direction alloc] initWithName:@"Outbound to Heaven"];
    });
    
    describe(@"clicking the find button", ^{
        it(@"retrieves directions for the given route number", ^{
            [controller view];
            
            controller.routeField.text = @"22";
            
            [[routeFetcher should] receive:@selector(fetchRoute:)
                             withArguments:@"22"];

            [controller.findButton sendActionsForControlEvents:UIControlEventTouchUpInside];
        });
        
        it(@"shows the loading spinner", ^{
            [controller view];
            
            controller.routeField.text = @"22";
            [routeFetcher stub:@selector(fetchRoute:)];
            
            [[theValue(controller.spinner.isAnimating) should] beFalse];
            [controller.findButton sendActionsForControlEvents:UIControlEventTouchUpInside];
            [[theValue(controller.spinner.isAnimating) should] beTrue];
        });
        
        it(@"removes any previous direction buttons", ^{
            [controller view];
            
            controller.routeField.text = @"43";
            [routeFetcher stub:@selector(fetchRoute:)];

            [controller addDirection:inbound];
            
            UIButton *directionButton = [controller.view.subviews lastObject];
            
            UIView *anotherView = [[UIView alloc] init];
            [controller.view addSubview:anotherView];
            
            NSUInteger buttonCountBefore = controller.view.subviews.count;
            [controller.findButton sendActionsForControlEvents:UIControlEventTouchUpInside];
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
    
        it(@"displays subsequent direction buttons beneath the previous button, with provided padding", ^{
            [controller addDirection:outbound];
            [controller addDirection:inbound];
            secondButton = [controller.view.subviews lastObject];
            [[theValue(secondButton.frame.origin.y) should]
             equal:theValue(firstButton.frame.origin.y + firstButton.frame.size.height + verticalPadding)];
        });
        
        it(@"resets the position of new buttons if find has been pressed", ^{
            [routeFetcher stub:@selector(fetchRoute:)];

            [controller addDirection:outbound];
            [controller addDirection:inbound];
            [controller.findButton sendActionsForControlEvents:UIControlEventTouchUpInside];
            [controller addDirection:outbound];
            
            firstButton = [controller.view.subviews lastObject];
            [[theValue(firstButton.frame.origin.y) should] equal:theValue(directionButtonDimensions.origin.y)];
        });
    });

    describe(@"clicking a direction button", ^{
        __block UIButton *button;
        
        beforeEach(^{
            [controller addDirection:inbound];
            button = [controller.view.subviews lastObject];
        });
        
        it(@"shows the loading spinner", ^{
            [[theValue(controller.spinner.isAnimating) should] beFalse];
            [routeFetcher stub:@selector(fetchStopsForDirection:)];
            [button sendActionsForControlEvents:UIControlEventTouchUpInside];
            [[theValue(controller.spinner.isAnimating) should] beTrue];
        });
        
        it(@"requests stops from the fetcher", ^{
            KWCaptureSpy *spy = [routeFetcher captureArgument:@selector(fetchStopsForDirection:) atIndex:0];
            [button sendActionsForControlEvents:UIControlEventTouchUpInside];
            [[spy.argument should] equal:inbound];
        });
        
        describe(@"when stops are added", ^{
            __block UIPickerView *picker;
            __block Stop *inboundStop1;
            __block Stop *inboundStop2;
            __block Stop *outboundStop1;
            __block NSArray *stops;
            
            beforeEach(^{
                inboundStop1 = [[Stop alloc] initWithName:@"Fillmore St & Bay St"
                                                direction:inbound];
                inboundStop2 = [[Stop alloc] initWithName:@"Some Other Stop"
                                                direction:inbound];
                outboundStop1 = [[Stop alloc] initWithName:@"Some Outbound Stop"
                                                 direction:outbound];
                stops = [NSArray arrayWithObjects:inboundStop1, inboundStop2, outboundStop1, nil];
                
                [routeFetcher stub:@selector(fetchStopsForDirection:)];
                [button sendActionsForControlEvents:UIControlEventTouchUpInside];
            });
            
            it(@"stops the spinner", ^{
                [controller.spinner startAnimating];
                [controller addStops:stops];
                [[theValue(controller.spinner.isAnimating) should] beFalse];
            });
            
            it(@"prompts the user with a stop picker", ^{
                [controller addStops:stops];
                picker = controller.view.subviews.lastObject;
                
                [[picker should] beKindOfClass:[UIPickerView class]];
                [[(NSObject *)picker.delegate should] equal:controller];
                
                NSUInteger componentCount = [controller numberOfComponentsInPickerView:picker];
                [[theValue(componentCount) should] equal:theValue(1)];
            });
            
            it(@"populates the picker with stops from the chosen direction", ^{
                [controller addStops:stops];
                
                NSUInteger rowCount = [controller pickerView:picker numberOfRowsInComponent:0];
                [[theValue(rowCount) should] equal:theValue(2)];
                
                [[[controller pickerView:picker titleForRow:0 forComponent:0] should] equal:inboundStop1.name];
                [[[controller pickerView:picker titleForRow:1 forComponent:0] should] equal:inboundStop2.name];
            });
        });
    });
//    pending_(@"shows the next arrival time when a stop is selected", ^{
//        [controller pickerView:picker didSelectRow:0 inComponent:0];
//        UILabel *nextArrivalTime = controller.nextArrivalTimeLabel;
//        [[nextArrivalTime.text should] equal:@""];
//    });
});
SPEC_END
