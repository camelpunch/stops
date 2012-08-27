#import "XMLFixture.h"

@implementation XMLFixture
{
    NSString *theName;
}

- initWithName:(NSString *)name
{
    self = [super init];
    if (self) {
        theName = name;
    }
    return self;
}

- (NSString *)body
{
    NSString *path = [[NSBundle bundleWithIdentifier:@"Andrew-Bruce.StopsTests"] pathForResource:theName
                                                                                          ofType:@""];
    NSError *error = nil;
    return [[NSString alloc] initWithContentsOfFile:path
                                           encoding:NSUTF8StringEncoding
                                              error:&error];
}

@end
