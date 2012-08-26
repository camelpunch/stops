#import "XMLFixture.h"

@implementation XMLFixture
{
    NSString *_name;
}

- initWithName:(NSString *)name
{
    self = [super init];
    if (self) {
        _name = name;
    }
    return self;
}

- (NSString *)body
{
    NSString *path = [[NSBundle bundleWithIdentifier:@"Andrew-Bruce.StopsTests"] pathForResource:_name
                                                                                          ofType:@""];
    NSError *error = nil;
    return [[NSString alloc] initWithContentsOfFile:path
                                           encoding:NSUTF8StringEncoding
                                              error:&error];
}

@end
