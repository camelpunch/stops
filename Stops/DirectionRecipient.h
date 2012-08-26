#import <Foundation/Foundation.h>

@class Direction;

@protocol DirectionRecipient <NSObject>

- (void)addDirection:(Direction *)direction;

@end
