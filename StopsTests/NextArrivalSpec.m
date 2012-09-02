#import "Kiwi.h"
#import <OCMock.h>
#import "NextArrivalViewController.h"
#import "RouteFetcher.h"
#import "Direction.h"
#import "Stop.h"
#import "ActivityDelegate.h"

SPEC_BEGIN(NextArrivalSpec)

describe(@"getting the next arrival for a stop in a chosen direction", ^{
    __block id routeFetcher;
    __block NextArrivalViewController *controller;
    __block Direction *inbound;
    __block Direction *outbound;
    __block CGRect directionButtonDimensions;
    __block CGFloat verticalPadding;
    __weak __block id activityDelegate;
    
    beforeEach(^{
        routeFetcher = [OCMockObject mockForClass:[RouteFetcher class]];
        activityDelegate = [OCMockObject mockForProtocol:@protocol(ActivityDelegate)];
        directionButtonDimensions = CGRectMake(10, 20, 30, 40);
        verticalPadding = 10;
        controller = [[NextArrivalViewController alloc] initWithRouteFetcher:routeFetcher
                                                   directionButtonDimensions:directionButtonDimensions
                                                     directionButtonYPadding:verticalPadding];
        inbound = [[Direction alloc] initWithName:@"Inbound to Hell"];
        outbound = [[Direction alloc] initWithName:@"Outbound to Heaven"];
    });
    
    afterEach(^{
        [routeFetcher verify];
        [activityDelegate verify];
    });
    
    describe(@"clicking the find button", ^{      
        it(@"retrieves directions for the given route number", ^{
            [controller view];
            controller.routeField.text = @"22";
            [[routeFetcher expect] fetchRoute:@"22"];
            [controller.findButton sendActionsForControlEvents:UIControlEventTouchUpInside];
        });
        
        it(@"notifies the activity delegate", ^{
            [controller view];
            [[routeFetcher stub] fetchRoute:OCMOCK_ANY];
            controller.activityDelegate = activityDelegate;
            [[activityDelegate expect] activityStartedOnView:controller.view];
            [controller.findButton sendActionsForControlEvents:UIControlEventTouchUpInside];
        });
        
        it(@"removes any previous direction buttons", ^{
            [controller view];
            
            [controller addDirection:inbound];
            
            UIButton *directionButton = [controller.view.subviews lastObject];
            
            UIView *anotherView = [[UIView alloc] init];
            [controller.view addSubview:anotherView];
            
            [[routeFetcher stub] fetchRoute:OCMOCK_ANY];
            
            NSUInteger buttonCountBefore = controller.view.subviews.count;
            [controller.findButton sendActionsForControlEvents:UIControlEventTouchUpInside];
            
            [[theValue(controller.view.subviews.count) should] equal:theValue(buttonCountBefore - 1)];
            [[controller.view.subviews should] contain:anotherView];
            [[controller.view.subviews shouldNot] contain:directionButton];
        });
    });
    
    describe(@"when a direction is received", ^{
        __block NSUInteger initialSubviewsCount;
        __block UIButton *firstButton;
        __block UIButton *secondButton;
        
        beforeEach(^{
            [controller view];
            initialSubviewsCount = controller.view.subviews.count;
        });
        
        it(@"notifies the activity delegate", ^{
            controller.activityDelegate = activityDelegate;
            [[activityDelegate expect] activityStoppedOnView:controller.view];
            [controller addDirection:outbound];
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
        
        it(@"resets the position of new buttons when find has been pressed", ^{
            [[routeFetcher stub] fetchRoute:OCMOCK_ANY];

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
        
        it(@"notifies the activity delegate", ^{
            [[routeFetcher stub] fetchStopsForDirection:OCMOCK_ANY];
            controller.activityDelegate = activityDelegate;
            [[activityDelegate expect] activityStartedOnView:controller.view];
            [button sendActionsForControlEvents:UIControlEventTouchUpInside];
        });
        
        it(@"requests stops from the fetcher", ^{
            [[routeFetcher expect] fetchStopsForDirection:inbound];
            [button sendActionsForControlEvents:UIControlEventTouchUpInside];
        });
    });
        
    describe(@"when stops are received", ^{
        __block UIPickerView *picker;
        __block UIButton *button;
        __block Stop *inboundStop1;
        __block Stop *inboundStop2;
        __block Stop *outboundStop1;
        __block NSArray *stops;
        
        beforeEach(^{
            //// choose a direction
            [controller addDirection:inbound];
            button = [controller.view.subviews lastObject];
            [[routeFetcher stub] fetchStopsForDirection:OCMOCK_ANY];
            [button sendActionsForControlEvents:UIControlEventTouchUpInside];
            ////

            inboundStop1 = [[Stop alloc] initWithName:@"Fillmore St & Bay St" direction:inbound];
            inboundStop2 = [[Stop alloc] initWithName:@"Some Other Stop" direction:inbound];
            outboundStop1 = [[Stop alloc] initWithName:@"Some Outbound Stop" direction:outbound];
            stops = [NSArray arrayWithObjects:inboundStop1, inboundStop2, outboundStop1, nil];
        });
        
        it(@"notifies the activity delegate", ^{
            controller.activityDelegate = activityDelegate;
            [[activityDelegate expect] activityStoppedOnView:controller.view];
            [controller addStops:stops];
        });
        
        it(@"prompts the user with a stop picker", ^{
            [controller addStops:stops];
            picker = controller.view.subviews.lastObject;
            
            [[picker should] beKindOfClass:[UIPickerView class]];
            [[(NSObject *)picker.delegate should] equal:controller];
            [[(NSObject *)picker.dataSource should] equal:controller];
            
            [[theValue([controller numberOfComponentsInPickerView:picker]) should] equal:theValue(1)];
        });
        
        it(@"populates the picker with stops from the chosen direction", ^{
            [controller addStops:stops];
            [[theValue([controller pickerView:picker numberOfRowsInComponent:0]) should] equal:theValue(2)];            
            [[[controller pickerView:picker titleForRow:0 forComponent:0] should] equal:inboundStop1.name];
            [[[controller pickerView:picker titleForRow:1 forComponent:0] should] equal:inboundStop2.name];
        });
    });

//    it(@"shows the next arrival time when a stop is selected", ^{
//        Stop *stop = [[Stop alloc] initWithName:@"Fillmore St & Bay St" direction:inbound];
//
//        [controller addStops:[NSArray arrayWithObject:stop]];
//
//        [controller pickerView:picker didSelectRow:0 inComponent:0];
//        UILabel *nextArrivalTime = controller.nextArrivalTimeLabel;
//        [[nextArrivalTime.text should] equal:@""];
//    });
});
SPEC_END
