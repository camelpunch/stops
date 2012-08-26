#import "FakeDirectionRecipient.h"

@implementation FakeDirectionRecipient
{
    NSMutableSet *_expectedAndReceivedDirections;
    NSMutableSet *_expectedDirections;
}
- (id)init
{
    self = [super init];
    if (self) {
        _expectedAndReceivedDirections = [[NSMutableSet alloc] init];
        _expectedDirections = [[NSMutableSet alloc] init];
    }
    return self;
}

- (void)addDirection:(Direction *)direction
{
    for (Direction *expectedDirection in _expectedDirections) {
        if ([expectedDirection isEqual:direction]) {
            [_expectedAndReceivedDirections addObject:expectedDirection];
        }
    }
}

- (void)expectDirection:(Direction *)direction
{
    [_expectedDirections addObject:direction];
}

- (NSSet *)receivedDirections
{
    return [NSSet setWithSet:_expectedAndReceivedDirections];
}

@end
