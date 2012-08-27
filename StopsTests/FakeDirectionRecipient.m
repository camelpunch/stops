#import "FakeDirectionRecipient.h"

@implementation FakeDirectionRecipient
{
    NSMutableSet *theExpectedAndReceivedDirections;
    NSMutableSet *theExpectedDirections;
}
- (id)init
{
    self = [super init];
    if (self) {
        theExpectedAndReceivedDirections = [[NSMutableSet alloc] init];
        theExpectedDirections = [[NSMutableSet alloc] init];
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

- (void)expectDirection:(Direction *)direction
{
    [theExpectedDirections addObject:direction];
}

- (NSSet *)receivedDirections
{
    return [NSSet setWithSet:theExpectedAndReceivedDirections];
}

@end
