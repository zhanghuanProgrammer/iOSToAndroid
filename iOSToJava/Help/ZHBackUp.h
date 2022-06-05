#import <Cocoa/Cocoa.h>

@interface ZHBackUp : NSObject
+ (void)backUpProject:(NSString *)project
           asyncBlock:(NSString * (^)(void))asyncBlock;
@end
