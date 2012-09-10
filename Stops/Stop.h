#import <Foundation/Foundation.h>

@class Direction;

@interface Stop : NSObject

- (id)initWithName:(NSString *)aName
         direction:(Direction *)aDirection
               tag:(NSString *)aTag;

@property (strong, nonatomic, readonly) NSString *name;
@property (strong, nonatomic, readonly) Direction *direction;
@property (strong, nonatomic, readonly) NSString *tag;

@end
