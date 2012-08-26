#import "Kiwi.h"
#import "DirectionsFetcher.h"
#import "Direction.h"
#import "FakeDirectionRecipient.h"

SPEC_BEGIN(DirectionsFetcherSpec)

describe(@"retrieving directions for a named route", ^{    
    pending_(@"sends Direction values back to the delegate", ^{
        FakeDirectionRecipient *recipient = [[FakeDirectionRecipient alloc] init];
        DirectionsFetcher *fetcher = [[DirectionsFetcher alloc] init];
        fetcher.delegate = recipient;
        
        Direction *expectedOutbound = [[Direction alloc] initWithName:@"Outbound to the Crocker-Amazon District"];
        Direction *expectedInbound = [[Direction alloc] initWithName:@"Inbound to the Marina District"];
        
        [recipient expectDirection:expectedInbound];
        [recipient expectDirection:expectedOutbound];
        
        [fetcher fetchDirectionsForRouteName:@"43"];
        
        [[expectFutureValue(recipient.receivedDirections) shouldEventually] contain:expectedInbound];
        [[expectFutureValue(recipient.receivedDirections) shouldEventually] contain:expectedOutbound];
    });
});

SPEC_END
