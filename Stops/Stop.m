#import "Stop.h"
#import "Direction.h"

@implementation Stop
@synthesize name, direction, tag;

- (id)initWithName:(NSString *)aName
         direction:(Direction *)aDirection
               tag:(NSString *)aTag
{
    self = [super init];
    if (self) {
        name = aName;
        direction = aDirection;
        tag = aTag;
    }
    return self;
}

- (BOOL)isEqual:(Stop *)other
{
    return [self.name isEqual:other.name] &&
    [self.direction isEqual:other.direction] &&
    [self.tag isEqualToString:other.tag];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"Stop: <%@> Direction: <%@>", self.name, self.direction.name];
}

@end
