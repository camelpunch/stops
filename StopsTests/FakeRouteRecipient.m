#import "FakeRouteRecipient.h"

@implementation FakeRouteRecipient
{
    NSMutableSet *theExpectedAndReceivedDirections;
    NSMutableSet *theExpectedDirections;
    NSMutableSet *theExpectedAndReceivedStops;
    NSMutableSet *theExpectedStops;
    NSMutableSet *theRejectedStops;
}
- (id)init
{
    self = [super init];
    if (self) {
        theExpectedAndReceivedDirections = [[NSMutableSet alloc] init];
        theExpectedDirections = [[NSMutableSet alloc] init];
        theExpectedAndReceivedStops = [[NSMutableSet alloc] init];
        theExpectedStops = [[NSMutableSet alloc] init];
        theRejectedStops = [[NSMutableSet alloc] init];
    }
    return self;
}

- (void)addDirection:(Direction *)direction
{
    for (Direction *expectedDirection in theExpectedDirections) {
        if ([expectedDirection isEqual:direction]) {
            [theExpectedAndReceivedDirections addObject:expectedDirection];
        }
    }
}

- (void)addStops:(NSArray *)someStops
{
    for (Stop *rejectedStop in theRejectedStops) {
        for (Stop *receivedStop in someStops) {
            if ([rejectedStop isEqual:receivedStop]) {
                @throw [@"Unexpected stop received: " stringByAppendingString:receivedStop.description];
            }
        }
    }
    for (Stop *expectedStop in theExpectedStops) {
        for (Stop *receivedStop in someStops) {
            if ([expectedStop isEqual:receivedStop]) {
                [theExpectedAndReceivedStops addObject:expectedStop];
            }
        }
    }
}

- (void)expectDirection:(Direction *)aDirection
{
    [theExpectedDirections addObject:aDirection];
}

- (void)expectStop:(Stop *)aStop
{
    [theExpectedStops addObject:aStop];
}

- (void)rejectStop:(Stop *)aStop
{
    [theRejectedStops addObject:aStop];
}

- (NSSet *)receivedDirections
{
    return [NSSet setWithSet:theExpectedAndReceivedDirections];
}

- (NSSet *)receivedStops
{
    return [NSSet setWithSet:theExpectedAndReceivedStops];
}

@end
