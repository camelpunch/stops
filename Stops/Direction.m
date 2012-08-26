#import "Direction.h"

@implementation Direction
{
    NSString *_name;
}

- (id)initWithName:(NSString *)name
{
    self = [super init];
    if (self) {
        _name = name;
    }
    return self;
}

- (NSString *)name
{
    return _name;
}

- (BOOL)isEqual:(Direction *)other
{
    return [_name isEqual:other.name];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"Direction: %@", _name];
}

@end
