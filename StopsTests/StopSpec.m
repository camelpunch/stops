#import "Kiwi.h"
#import "Stop.h"
#import "Direction.h"

SPEC_BEGIN(StopSpec)

describe(@"a Stop value", ^{
    it(@"has a name", ^{
        Stop *stop = [[Stop alloc] initWithName:@"Chestnut St & Fillmore St"
                                      direction:nil];
        [[stop.name should] equal:@"Chestnut St & Fillmore St"];
    });
    
    it(@"has a direction", ^{
        Direction *outbound = [Direction directionNamed:@"Outbound"];
        Stop *stop = [[Stop alloc] initWithName:nil
                                      direction:outbound];
        [[stop.direction should] equal:outbound];
    });
    
    it(@"is equal to other Stops with the same values", ^{
        Direction *north = [Direction directionNamed:@"North"];
        Direction *south = [Direction directionNamed:@"South"];
        
        Stop *stop = [[Stop alloc] initWithName:@"Chestnut St & Fillmore St"
                                      direction:north];
        Stop *equivalentStop = [[Stop alloc] initWithName:@"Chestnut St & Fillmore St"
                                                direction:north];
        Stop *differentStopName = [[Stop alloc] initWithName:@"Presidio Blvd & Letterman Dr"
                                               direction:north];
        Stop *differentStopDirection = [[Stop alloc] initWithName:@"Chestnut St & Fillmore St"
                                                        direction:south];

        [[stop should] equal:equivalentStop];
        [[stop shouldNot] equal:differentStopName];
        [[stop shouldNot] equal:differentStopDirection];
    });
    
    it(@"has a useful description", ^{
        Direction *direction = [Direction directionNamed:@"Outbound"];
        Stop *stop = [[Stop alloc] initWithName:@"Presidio Blvd & Letterman Dr"
                                      direction:direction];
        [[[stop description] should] equal:@"Stop: <Presidio Blvd & Letterman Dr> Direction: <Outbound>"];
    });
});

SPEC_END
