#import <Foundation/Foundation.h>

@class Direction;

@interface Stop : NSObject

- (id)initWithName:(NSString *)aName
         direction:(Direction *)aDirection;

- (NSString *)name;
- (Direction *)direction;

@end
