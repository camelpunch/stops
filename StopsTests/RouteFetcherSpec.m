#import "Kiwi.h"
#import "NextBusRouteFetcher.h"
#import "Direction.h"
#import "Stop.h"
#import "FakeRouteRecipient.h"

SPEC_BEGIN(RouteFetcherSpec)

describe(@"fetching a named route", ^{
    __block FakeRouteRecipient *recipient;
    __block NextBusRouteFetcher *fetcher;
    __block Direction *outbound;
    __block Direction *inbound;
    
    beforeEach(^{
        recipient = [[FakeRouteRecipient alloc] init];
        fetcher = [[NextBusRouteFetcher alloc] init];
        fetcher.delegate = recipient;
        outbound = [Direction directionNamed:@"Outbound to the Crocker-Amazon District"];
        inbound = [Direction directionNamed:@"Inbound to the Marina District"];
    });
    
    pending_(@"sends Direction values to the delegate", ^{
        [recipient expectDirection:inbound];
        [recipient expectDirection:outbound];
        [fetcher fetchRoute:@"43"];
        [[expectFutureValue(recipient.receivedDirections) shouldEventually] contain:inbound];
        [[expectFutureValue(recipient.receivedDirections) shouldEventually] contain:outbound];
    });
    
    pending_(@"sends Stop values to the delegate", ^{
        Stop *chestnutAndFillmore = [[Stop alloc] initWithName:@"Chestnut St & Fillmore St"
                                                     direction:outbound
                                                           tag:@"3941"];
        Stop *masonicAndGeary = [[Stop alloc] initWithName:@"Masonic Ave & Geary Blvd"
                                                 direction:outbound
                                                       tag:@"5710"];
        Stop *southHillAndRolph = [[Stop alloc] initWithName:@"South Hill Blvd & Rolph St"
                                                   direction:inbound
                                                         tag:@"345"];
        
        [recipient expectStop:chestnutAndFillmore];
        [recipient expectStop:masonicAndGeary];
        [recipient rejectStop:southHillAndRolph];
        [fetcher fetchRoute:@"43"];
        [fetcher fetchStopsForDirection:outbound];
        [[expectFutureValue(recipient.receivedStops) shouldEventually] contain:chestnutAndFillmore];
        [[expectFutureValue(recipient.receivedStops) shouldEventually] contain:masonicAndGeary];
    });
});

SPEC_END
