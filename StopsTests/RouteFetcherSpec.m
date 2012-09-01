#import "Kiwi.h"
#import "RouteFetcher.h"
#import "Direction.h"
#import "Stop.h"
#import "FakeRouteRecipient.h"

SPEC_BEGIN(RouteFetcherSpec)

describe(@"fetching a named route", ^{
    __block FakeRouteRecipient *recipient;
    __block RouteFetcher *fetcher;
    __block Direction *outbound;
    __block Direction *inbound;
    
    beforeEach(^{
        recipient = [[FakeRouteRecipient alloc] init];
        fetcher = [[RouteFetcher alloc] init];
        fetcher.delegate = recipient;
        outbound = [[Direction alloc] initWithName:@"Outbound to the Crocker-Amazon District"];
        inbound = [[Direction alloc] initWithName:@"Inbound to the Marina District"];
    });
    
    pending_(@"sends Direction values back to the delegate", ^{
        [recipient expectDirection:inbound];
        [recipient expectDirection:outbound];
        [fetcher fetchRoute:@"43"];
        [[expectFutureValue(recipient.receivedDirections) shouldEventually] contain:inbound];
        [[expectFutureValue(recipient.receivedDirections) shouldEventually] contain:outbound];
    });
    
    pending_(@"sends Stop values back to the delegate", ^{
        Stop *chestnutAndFillmore = [[Stop alloc] initWithName:@"Chestnut St & Fillmore St"
                                                     direction:outbound];
        Stop *masonicAndGeary = [[Stop alloc] initWithName:@"Masonic Ave & Geary Blvd"
                                                 direction:outbound];
        Stop *southHillAndRolph = [[Stop alloc] initWithName:@"South Hill Blvd & Rolph St"
                                                   direction:inbound];
        
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
