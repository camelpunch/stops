#import "Kiwi.h"
#import "Stop.h"
#import "Direction.h"

SPEC_BEGIN(StopSpec)

static NSString * const UNUSED_NAME = nil;
static Direction * const UNUSED_DIRECTION = nil;
static NSString * const UNUSED_TAG = nil;

describe(@"a Stop value", ^{
    it(@"has a name", ^{
        Stop *stop = [[Stop alloc] initWithName:@"Chestnut St & Fillmore St"
                                      direction:UNUSED_DIRECTION
                                            tag:UNUSED_TAG];
        [[stop.name should] equal:@"Chestnut St & Fillmore St"];
    });
    
    it(@"has a direction", ^{
        Direction *outbound = [Direction directionNamed:@"Outbound"];
        Stop *stop = [[Stop alloc] initWithName:UNUSED_NAME
                                      direction:outbound
                                            tag:UNUSED_TAG];
        [[stop.direction should] equal:outbound];
    });
    
    it(@"has a tag", ^{
        Stop *stop = [[Stop alloc] initWithName:UNUSED_NAME
                                      direction:UNUSED_DIRECTION
                                            tag:@"5171"];
        [[stop.tag should] equal:@"5171"];
    });
    
    it(@"is equal to other Stops with the same values", ^{
        Direction *north = [Direction directionNamed:@"North"];
        Direction *south = [Direction directionNamed:@"South"];
        
        Stop *stop = [[Stop alloc] initWithName:@"Chestnut St & Fillmore St"
                                      direction:north
                                            tag:@"1234"];
        Stop *equivalentStop = [[Stop alloc] initWithName:@"Chestnut St & Fillmore St"
                                                direction:north
                                                      tag:@"1234"];
        Stop *differentName = [[Stop alloc] initWithName:@"Presidio Blvd & Letterman Dr"
                                               direction:north
                                                         tag:@"1234"];
        Stop *differentDirection = [[Stop alloc] initWithName:@"Chestnut St & Fillmore St"
                                                        direction:south
                                                              tag:@"1234"];
        Stop *differentTag = [[Stop alloc] initWithName:@"Chestnut St & Fillmore St"
                                              direction:north
                                                    tag:@"2345"];

        [[stop should] equal:equivalentStop];
        [[stop shouldNot] equal:differentName];
        [[stop shouldNot] equal:differentDirection];
        [[stop shouldNot] equal:differentTag];
    });
    
    it(@"has a useful description", ^{
        Direction *direction = [Direction directionNamed:@"Outbound"];
        Stop *stop = [[Stop alloc] initWithName:@"Presidio Blvd & Letterman Dr"
                                      direction:direction
                                            tag:UNUSED_TAG];
        [[[stop description] should] equal:@"Stop: <Presidio Blvd & Letterman Dr> Direction: <Outbound>"];
    });
});

SPEC_END
