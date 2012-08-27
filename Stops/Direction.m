#import "Direction.h"

@implementation Direction
{
    NSString *theName;
}

- (id)initWithName:(NSString *)name
{
    self = [super init];
    if (self) {
        theName = name;
    }
    return self;
}

- (NSString *)name
{
    return theName;
}

- (BOOL)isEqual:(Direction *)other
{
    return [theName isEqual:other.name];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"Direction: %@", theName];
}

@end
