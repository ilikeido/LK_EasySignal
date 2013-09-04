//
//  UIResponder+EasySignal.m
//  LK_EasySignal
//
//  Created by hesh on 13-9-3.
//  Copyright (c) 2013年 ilikeido. All rights reserved.
//

#import "UIResponder+LKSignal.h"
#import "LKSignal.h"
#import <objc/runtime.h>
#import "UI+LKSignal.h"

#define SIGNAL_DEFAULT @"SIGNAL_DEFAULT"

#pragma mark -

@implementation UIResponder(LK_EasySignal)

@dynamic tagString;

-(void)setTagString:(NSString *)tagString{
    if (self.tagString) {
        objc_removeAssociatedObjects(self.tagString);
    }
    objc_setAssociatedObject( self, "tagString", tagString, OBJC_ASSOCIATION_RETAIN_NONATOMIC );
}

-(NSString *)tagString{
    NSObject * obj = objc_getAssociatedObject( self, "tagString" );
	if ( obj && [obj isKindOfClass:[NSString class]] )
		return (NSString *)obj;
	return nil;
}


#pragma clang diagnostic push 
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
-(void)sendSignal:(LKSignal *)signal;{
    if (self == signal.sender) {
        if (self != signal.firstRouter) {
            [signal.firstRouter sendSignal:signal];
            return;
        }
    }
    NSString *handleSelector1 = [NSString stringWithFormat:@"handleLKSignal_%@:",signal.preName?signal.preName:signal.sender.className];
    NSString *handleSelector2 = [NSString stringWithFormat:@"handleLKSignal_%@_%@:",signal.preName?signal.preName:signal.sender.className,signal.signalName];
    SEL sel1 = NSSelectorFromString(handleSelector1);
    SEL sel2 = NSSelectorFromString(handleSelector2);
    if (signal.tagString) {
        NSString *handleSelector3 = [NSString stringWithFormat:@"handleLKSignal_%@_%@:",signal.preName?signal.preName:signal.sender.className,signal.tagString];
        SEL sel3 = NSSelectorFromString(handleSelector3);
        if ([self respondsToSelector:sel3]) {
            [self performSelector:sel3 withObject:signal];
            return;
        }
    }
    if ([self respondsToSelector:sel1]) {
        [self performSelector:sel1 withObject:signal];
    }else if ([self respondsToSelector:sel2]) {
        [self performSelector:sel2 withObject:signal];
    }
    else if ([self respondsToSelector:@selector(handleLKSignal:)]) {
        [self performSelector:@selector(handleLKSignal:) withObject:signal];
    }
}

#pragma clang diagnostic pop
-(void)handleLKSignal:(LKSignal *)signal;{
#if defined(__LKLOG__) && __LKLOG__
    NSLog(@"%@_%@:->%@",signal.firstRouter.className,signal.signalName,signal.currentRouter.className);
#endif
    if (self.nextResponder) {
        signal.currentRouter = self.nextResponder;
        [self.nextResponder sendSignal:signal];
    }
}

-(NSString *)signalName{
    return SIGNAL_DEFAULT;
}

-(LKSignal *)instanceSignal:(NSString *)signalName object:(NSObject *)object tag:(int)tag{
    LKSignal *signal = [[LKSignal alloc]initWithSender:self firstRouter:self object:object signalName:signalName tag:tag tagString:self.tagString];
    return signal;
}

-(void)sendSignal;{
    [self sendSignalName:self.signalName object:nil tag:0];
}

-(void)sendSignalName:(NSString *)signalName;{
    [self sendSignalName:signalName object:nil tag:0];
}

-(void)sendSignalObject:(NSString *)object;{
    [self sendSignalName:self.signalName object:object tag:0];
}

-(void)sendSignalTag:(int)tag;{
    [self sendSignalName:self.signalName object:nil tag:tag];
}

-(void)sendSignalName:(NSString *)signalName object:(NSObject *)object;{
    [self sendSignalName:signalName object:object tag:0];
}

-(void)sendSignalObject:(NSObject *)object tag:(int)tag;{
    [self sendSignalName:self.signalName object:object tag:tag];
}

-(void)sendSignalName:(NSString *)signalName object:(NSObject *)object tag:(int)tag{
    LKSignal *signal = [self instanceSignal:signalName object:object tag:tag];
    [self sendSignal:signal];
}

-(NSString *)className;{
   const char *name =  class_getName([self class]);
   return [NSString stringWithUTF8String:name];
}

@end

