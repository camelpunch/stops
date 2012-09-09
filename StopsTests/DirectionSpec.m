#import "Kiwi.h"
#import "Direction.h"

SPEC_BEGIN(DirectionSpec)

describe(@"a Direction value", ^{
    it(@"cannot be instantiated without a name", ^{
        [[theBlock(^{
            [[Direction directionNamed:@""] name];
        }) should] raiseWithName:@"InvalidDirection" reason:@"must provide a name"];
    });
    
    it(@"has a name", ^{
        Direction *direction = [Direction directionNamed:@"Outbound to Mars"];
        [[direction.name should] equal:@"Outbound to Mars"];
    });
    
    it(@"is equal to other Directions with the same values", ^{
        Direction *direction = [Direction directionNamed:@"Outbound to Mars"];
        Direction *equivalentDirection = [Direction directionNamed:@"Outbound to Mars"];
        Direction *differentDirection = [Direction directionNamed:@"Outbound to Saturn"];
        [[direction should] equal:equivalentDirection];
        [[direction shouldNot] equal:differentDirection];
    });
    
    it(@"has a useful description", ^{
        Direction *direction = [Direction directionNamed:@"Outbound to Mars"];
        [[[direction description] should] equal:@"Direction: Outbound to Mars"];
    });
});

SPEC_END
