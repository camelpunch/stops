#import <Foundation/Foundation.h>
#import "DirectionRecipient.h"
#import "Direction.h"

@interface FakeDirectionRecipient : NSObject<DirectionRecipient>
- (void)expectDirection:(Direction *)direction;
- (NSSet *)receivedDirections;
@end