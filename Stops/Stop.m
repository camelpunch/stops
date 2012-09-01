#import "Stop.h"
#import "Direction.h"

@implementation Stop
{
    NSString *theName;
    Direction *theDirection;
}

- (id)initWithName:(NSString *)aName
         direction:(Direction *)aDirection
{
    self = [super init];
    if (self) {
        theName = aName;
        theDirection = aDirection;
    }
    return self;
}

- (NSString *)name { return theName; }
- (Direction *)direction { return theDirection; }

- (BOOL)isEqual:(Stop *)other
{
    return [theName isEqual:other.name] && [theDirection isEqual:other.direction];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"Stop: <%@> Direction: <%@>", theName, theDirection.name];
}

@end
