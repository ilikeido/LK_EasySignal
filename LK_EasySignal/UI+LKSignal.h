//
//  UILKSignal.h
//  LK_EasySignal
//
//  Created by hesh on 13-9-4.
//  Copyright (c) 2013年 ilikeido. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UIButton (LK_EasySignal)

+(NSString *)UPINSIDE;

@end

@interface UIView (LK_EasySignal)

@property(nonatomic,assign) BOOL tapable;
+(NSString *)TAPED;

@end

@interface UISlider(LK_EasySignal)

+(NSString *)VALUECHANGE;

@end

@interface UISwitch (LK_EasySignal)

+(NSString *)VALUECHANGE;

@end

@interface UIAlertView (LK_EasySignal)

-(void)showInView:(UIView *)view cancelSignalObject:(NSObject *)cancelSignalObject sumbitSignalObject:(NSObject *)sumbitSignalObject;

+(NSString *)CANCEL;

+(NSString *)SUMBIT;

@end

@interface UIActionSheet (LK_EasySignal)

+(NSString *)CLICKED;

-(void)setSignalObject:(NSObject *)object index:(int)index;

-(void)addButtonWithTitle:(NSString *)title signalObject:(NSObject *)object;

@end
