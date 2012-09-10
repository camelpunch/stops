#import "Kiwi.h"
#import <OCMock.h>
#import "NextArrivalViewController.h"
#import "NextBusRouteFetcher.h"
#import "Direction.h"
#import "Stop.h"
#import "ActivityDelegate.h"
#import "Predictor.h"
#import "Prediction.h"

static id const UNUSED_FETCHER = nil;
static id const UNUSED_PREDICTOR = nil;
static UIPickerView * const UNUSED_PICKER = nil;
static CGRect const UNUSED_DIMENSIONS = {0, 0};
static NSUInteger const UNUSED_PADDING = 0;

SPEC_BEGIN(NextArrivalSpec)

describe(@"getting the next arrival for a stop in a chosen direction", ^{      
    describe(@"tapping find", ^{      
        it(@"retrieves directions for the route entered", ^{
            id routeFetcher = [OCMockObject mockForClass:[NextBusRouteFetcher class]];
            NextArrivalViewController *controller =
            [[NextArrivalViewController alloc] initWithRouteFetcher:routeFetcher
                                                          predictor:UNUSED_PREDICTOR
                                          directionButtonDimensions:UNUSED_DIMENSIONS
                                            directionButtonYPadding:UNUSED_PADDING];
            [controller view];
            controller.routeField.text = @"22";
            [[routeFetcher expect] fetchRoute:@"22"];
            [controller.findButton sendActionsForControlEvents:UIControlEventTouchUpInside];
            [routeFetcher verify];
        });
        
        it(@"notifies the activity delegate", ^{
            NextArrivalViewController *controller =
            [[NextArrivalViewController alloc] initWithRouteFetcher:UNUSED_FETCHER
                                                          predictor:UNUSED_PREDICTOR
                                          directionButtonDimensions:UNUSED_DIMENSIONS
                                            directionButtonYPadding:UNUSED_PADDING];
            [controller view];
            __weak id delegate = [OCMockObject mockForProtocol:@protocol(ActivityDelegate)];
            controller.activityDelegate = delegate;
            
            [[controller.findButton shouldNot] beNil];
            [[delegate expect] activityStartedOnView:controller.view];
            [controller.findButton sendActionsForControlEvents:UIControlEventTouchUpInside];
            [delegate verify];
        });
        
        it(@"removes any previous direction buttons", ^{
            NextArrivalViewController *controller =
            [[NextArrivalViewController alloc] initWithRouteFetcher:UNUSED_FETCHER
                                                          predictor:UNUSED_PREDICTOR
                                          directionButtonDimensions:UNUSED_DIMENSIONS
                                            directionButtonYPadding:UNUSED_PADDING];
            
            UIView *view = controller.view;
            [controller addDirection:[[Direction alloc] init]];
            UIButton *directionButton = [view.subviews lastObject];
            UIView *anotherView = [[UIView alloc] init];
            [view addSubview:anotherView];
                        
            [controller.findButton sendActionsForControlEvents:UIControlEventTouchUpInside];
            [[view.subviews should] contain:anotherView];
            [[view.subviews shouldNot] contain:directionButton];
        });
    });
    
    describe(@"when a direction is received", ^{
        it(@"notifies the activity delegate", ^{
            NextArrivalViewController *controller =
            [[NextArrivalViewController alloc] initWithRouteFetcher:UNUSED_FETCHER
                                                          predictor:UNUSED_PREDICTOR
                                          directionButtonDimensions:UNUSED_DIMENSIONS
                                            directionButtonYPadding:UNUSED_PADDING];
            __weak id delegate = [OCMockObject mockForProtocol:@protocol(ActivityDelegate)];
            controller.activityDelegate = delegate;
            [[delegate expect] activityStoppedOnView:controller.view];
            [controller addDirection:[Direction directionNamed:@"outbound"]];
            [delegate verify];
        });
        
        it(@"displays the first direction as a button with appropriate text", ^{
            NextArrivalViewController *controller =
            [[NextArrivalViewController alloc] initWithRouteFetcher:UNUSED_FETCHER
                                                          predictor:UNUSED_PREDICTOR
                                          directionButtonDimensions:UNUSED_DIMENSIONS
                                            directionButtonYPadding:UNUSED_PADDING];
            [controller addDirection:[Direction directionNamed:@"Outbound to Heaven"]];
            UIButton *button = [controller.view.subviews lastObject];
            [[button.titleLabel.text should] equal:@"Outbound to Heaven"];
        });
    
        it(@"displays subsequent direction buttons beneath the previous button, with provided padding", ^{
            CGFloat padding = 42;
            NextArrivalViewController *controller =
            [[NextArrivalViewController alloc] initWithRouteFetcher:UNUSED_FETCHER
                                                          predictor:UNUSED_PREDICTOR
                                          directionButtonDimensions:UNUSED_DIMENSIONS
                                            directionButtonYPadding:padding];
            [controller addDirection:[Direction directionNamed:@"Outbound to Heaven"]];
            UIButton *firstButton = [controller.view.subviews lastObject];
            [controller addDirection:[Direction directionNamed:@"Inbound to Hell"]];
            UIButton *secondButton = [controller.view.subviews lastObject];
            [[theValue(secondButton.frame.origin.y) should]
             equal:theValue(firstButton.frame.origin.y + firstButton.frame.size.height + padding)];
        });
        
        it(@"resets the vertical position of new buttons when find has been pressed", ^{
            CGFloat verticalPosition = 15;
            NextArrivalViewController *controller =
            [[NextArrivalViewController alloc] initWithRouteFetcher:UNUSED_FETCHER
                                                          predictor:UNUSED_PREDICTOR
                                          directionButtonDimensions:CGRectMake(0, verticalPosition, 0, 0)
                                            directionButtonYPadding:UNUSED_PADDING];
            [controller addDirection:[[Direction alloc] init]];
            [controller addDirection:[[Direction alloc] init]];
            [controller.findButton sendActionsForControlEvents:UIControlEventTouchUpInside];
            [controller addDirection:[[Direction alloc] init]];            
            UIButton *button = [controller.view.subviews lastObject];
            [[theValue(button.frame.origin.y) should] equal:theValue(verticalPosition)];
        });
    });

    describe(@"tapping a direction", ^{
        it(@"notifies the activity delegate", ^{
            NextArrivalViewController *controller =
            [[NextArrivalViewController alloc] initWithRouteFetcher:UNUSED_FETCHER
                                                          predictor:UNUSED_PREDICTOR
                                          directionButtonDimensions:UNUSED_DIMENSIONS
                                            directionButtonYPadding:UNUSED_PADDING];
            UIView *view = controller.view;
            [controller addDirection:[[Direction alloc] init]];
            UIButton *button = [view.subviews lastObject];
            __weak id delegate = [OCMockObject mockForProtocol:@protocol(ActivityDelegate)];
            controller.activityDelegate = delegate;
            
            [[delegate expect] activityStartedOnView:controller.view];
            [button sendActionsForControlEvents:UIControlEventTouchUpInside];
            [delegate verify];
        });
        
        it(@"requests stops from the fetcher", ^{
            id routeFetcher = [OCMockObject mockForClass:[NextBusRouteFetcher class]];
            Direction *inbound = [Direction directionNamed:@"inbound"];
            NextArrivalViewController *controller =
            [[NextArrivalViewController alloc] initWithRouteFetcher:routeFetcher
                                                          predictor:UNUSED_PREDICTOR
                                          directionButtonDimensions:UNUSED_DIMENSIONS
                                            directionButtonYPadding:UNUSED_PADDING];
            UIView *view = controller.view;
            [controller addDirection:inbound];
            UIButton *button = [view.subviews lastObject];

            [[routeFetcher expect] fetchStopsForDirection:inbound];
            [button sendActionsForControlEvents:UIControlEventTouchUpInside];
            [routeFetcher verify];
        });
    });
        
    describe(@"when stops are received", ^{
        it(@"notifies the activity delegate", ^{
            NextArrivalViewController *controller =
            [[NextArrivalViewController alloc] initWithRouteFetcher:UNUSED_FETCHER
                                                          predictor:UNUSED_PREDICTOR
                                          directionButtonDimensions:UNUSED_DIMENSIONS
                                            directionButtonYPadding:UNUSED_PADDING];
            __weak id delegate = [OCMockObject mockForProtocol:@protocol(ActivityDelegate)];
            controller.activityDelegate = delegate;

            [[delegate expect] activityStoppedOnView:controller.view];
            [controller addStops:[NSArray array]];
            [delegate verify];
        });
        
        it(@"prompts the user with a stop picker", ^{
            NextArrivalViewController *controller =
            [[NextArrivalViewController alloc] initWithRouteFetcher:UNUSED_FETCHER
                                                          predictor:UNUSED_PREDICTOR
                                          directionButtonDimensions:UNUSED_DIMENSIONS
                                            directionButtonYPadding:UNUSED_PADDING];
            NSArray *stops = [NSArray arrayWithObject:[[Stop alloc] init]];
            [controller addStops:stops];
            UIPickerView *picker = controller.view.subviews.lastObject;
            
            [[(NSObject *)picker.delegate should] equal:controller];
            [[(NSObject *)picker.dataSource should] equal:controller];
            
            [[theValue([controller numberOfComponentsInPickerView:picker]) should] equal:theValue(stops.count)];
        });
        
        it(@"populates the picker with stop choices from the selected direction", ^{
            NextArrivalViewController *controller =
            [[NextArrivalViewController alloc] initWithRouteFetcher:UNUSED_FETCHER
                                                          predictor:UNUSED_PREDICTOR
                                          directionButtonDimensions:UNUSED_DIMENSIONS
                                            directionButtonYPadding:UNUSED_PADDING];
            Direction *inbound = [Direction directionNamed:@"inbound"];
            Stop *stop1 = [[Stop alloc] initWithName:@"Stop 1"
                                           direction:inbound
                                                 tag:@"123"];
            Stop *stop2 = [[Stop alloc] initWithName:@"Stop 2"
                                           direction:inbound
                                                 tag:@"234"];
            NSArray *stops = [NSArray arrayWithObjects:stop1, stop2, nil];
            
            [controller view];
            [controller addDirection:inbound];
            UIButton *directionButton = controller.view.subviews.lastObject;
            [directionButton sendActionsForControlEvents:UIControlEventTouchUpInside];
            
            [controller addStops:stops];
            [[theValue([controller pickerView:UNUSED_PICKER numberOfRowsInComponent:0]) should] equal:theValue(stops.count)];
            [[[controller pickerView:UNUSED_PICKER titleForRow:0 forComponent:0] should] equal:@"Stop 1"];
            [[[controller pickerView:UNUSED_PICKER titleForRow:1 forComponent:0] should] equal:@"Stop 2"];
        });
    });

    it(@"requests a prediction when a stop is selected", ^{
        id predictor = [OCMockObject mockForProtocol:@protocol(Predictor)];
        NextArrivalViewController *controller =
        [[NextArrivalViewController alloc] initWithRouteFetcher:UNUSED_FETCHER
                                                      predictor:predictor
                                      directionButtonDimensions:UNUSED_DIMENSIONS
                                        directionButtonYPadding:UNUSED_PADDING];
        [controller view];
        Stop *stop = [[Stop alloc] initWithName:@"Fillmore St & Bay St"
                                      direction:[Direction directionNamed:@"inbound"]
                                            tag:@"123"];
        controller.routeField.text = @"43";
        [controller addStops:[NSArray arrayWithObject:stop]];
        
        [[predictor expect] predictArrivalOnRoute:@"43" atStop:stop];
        [controller pickerView:UNUSED_PICKER didSelectRow:0 inComponent:0];
        [predictor verify];
    });

    it(@"shows the predicted arrival time when prediction is received", ^{
        NextArrivalViewController *controller =
        [[NextArrivalViewController alloc] initWithRouteFetcher:UNUSED_FETCHER
                                                      predictor:UNUSED_PREDICTOR
                                      directionButtonDimensions:UNUSED_DIMENSIONS
                                        directionButtonYPadding:UNUSED_PADDING];
        [controller view];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyy-MM-dd HH:mm";
        NSDate *time = [formatter dateFromString:@"2013-04-25 22:35"];
        [controller receivePrediction:[Prediction predictionWithDate:time]];
        [[controller.view.subviews.lastObject should] equal:controller.nextArrivalTimeLabel];
        [[controller.nextArrivalTimeLabel.accessibilityLabel should] equal:@"Arrival Time"];
        [[controller.nextArrivalTimeLabel.text should] equal:@"10:35PM"];
    });

});
SPEC_END
