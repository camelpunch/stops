#import "Direction.h"

@implementation Direction
{
    NSString *theName;
}

+ (id)directionNamed:(NSString *)aName
{
    if (!aName || [aName isEqualToString:@""]) {
        @throw [NSException exceptionWithName:@"InvalidDirection"
                                       reason:@"must provide a name"
                                     userInfo:nil];
    }
    return [[Direction alloc] initWithName:aName];
}

- (id)initWithName:(NSString *)aName
{
    self = [super init];
    if (self) {
        theName = aName;
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
