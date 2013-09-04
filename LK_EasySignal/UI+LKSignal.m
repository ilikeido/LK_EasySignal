//
//  UILKSignal.m
//  LK_EasySignal
//
//  Created by hesh on 13-9-4.
//  Copyright (c) 2013年 ilikeido. All rights reserved.
//

#import "UI+LKSignal.h"
#import "LKSignal.h"
#import <objc/runtime.h>
#import "UIResponder+LKSignal.h"
#import <BILib.h>

#pragma mark -

@implementation UIButton (LK_EasySignal)

+(NSString *)UPINSIDE;{
    return @"UPINSIDE";
}

@end


@implementation UISlider(LK_EasySignal)

+(NSString *)VALUECHANGE;{
    return @"VALUECHANGE";
}

@end

@interface UIAlertView(LK_EasySignal_Private)

@property(nonatomic,strong) LKSignal *cancelSignal;

@property(nonatomic,strong) LKSignal *submitSignal;

@property(nonatomic,weak) UIView *targetView;

-(void)setCancelSignalObject:(NSObject *)object;

-(void)setSumbitSignalObject:(NSObject *)object;

@end

@implementation UIAlertView(LK_EasySignal_Private)

@dynamic cancelSignal;
@dynamic submitSignal;

-(void)setCancelSignal:(LKSignal *)cancelSignal{
    if (self.cancelSignal) {
        objc_removeAssociatedObjects(self.cancelSignal);
    }
    objc_setAssociatedObject( self, "cancelSignal", cancelSignal, OBJC_ASSOCIATION_RETAIN_NONATOMIC );
}

-(LKSignal *)cancelSignal{
    NSObject * obj = objc_getAssociatedObject( self, "cancelSignal" );
	if ( obj && [obj isKindOfClass:[LKSignal class]] )
		return (LKSignal *)obj;
	return nil;
}

-(void)setSubmitSignal:(LKSignal *)submitSignal{
    objc_setAssociatedObject( self, "submitSignal", submitSignal, OBJC_ASSOCIATION_RETAIN_NONATOMIC );
}

-(LKSignal *)submitSignal{
    NSObject * obj = objc_getAssociatedObject( self, "submitSignal" );
	if ( obj && [obj isKindOfClass:[LKSignal class]] )
		return (LKSignal *)obj;
	return nil;
}

-(UIView *)targetView{
    NSObject * obj = objc_getAssociatedObject( self, "targetView" );
	if ( obj && [obj isKindOfClass:[UIView class]] )
		return (UIView *)obj;
	return nil;
}

-(void)setTargetView:(UIView *)targetView{
    objc_setAssociatedObject( self, "targetView", targetView, OBJC_ASSOCIATION_RETAIN_NONATOMIC );
}

-(void)setCancelSignalObject:(NSObject *)object;{
    self.cancelSignal = [[LKSignal alloc]initWithSender:self firstRouter:self.targetView object:object signalName:UIAlertView.CANCEL tag:0  tagString:self.tagString];
}

-(void)setSumbitSignalObject:(NSObject *)object{
    self.submitSignal = [[LKSignal alloc]initWithSender:self firstRouter:self.targetView object:object signalName:UIAlertView.SUMBIT tag:0  tagString:self.tagString];
}

@end

@implementation UIAlertView(LK_EasySignal)

-(void)showInView:(UIView *)view cancelSignalObject:(NSObject *)cancelSignalObject sumbitSignalObject:(NSObject *)sumbitSignalObject;{
    self.targetView = view;
    [self setCancelSignalObject:cancelSignalObject];
    [self setSumbitSignalObject:sumbitSignalObject];
    [self show];
    self.delegate = self;
}

#pragma mark -UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex;{
    if (buttonIndex != alertView.cancelButtonIndex) {
        self.submitSignal.tag = buttonIndex;
        [self.targetView sendSignal:self.submitSignal];
    }else{
        [self.targetView sendSignal:self.cancelSignal];
    }
}


+(NSString *)CANCEL;{
    return @"CANCEL";
}

+(NSString *)SUMBIT;{
    return @"SUMBIT";
}

@end

@interface UIActionSheet (LK_EasySignal_Private)<UIActionSheetDelegate>
-(NSMutableDictionary *)signlaDic;
-(LKSignal *)defaultSignal;
@end

@implementation UIActionSheet (LK_EasySignal_Private)

-(id)init{
    self = [super init];
    if (self) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            [BILib injectToClass:[UIActionSheet class] selector:@selector(showInView:) preprocess:^(UIActionSheet *sheet,UIView *view){
                __weak id<UIActionSheetDelegate> delegate = (id<UIActionSheetDelegate>)sheet;
                if (!sheet.delegate) {
                    sheet.delegate = delegate;
                    NSDictionary *signlaDic = sheet.signlaDic;
                    if (signlaDic.count> 0) {
                        for (LKSignal *signal in signlaDic.allValues) {
                            signal.firstRouter = view;
                        }
                    }else{
                        self.defaultSignal.firstRouter = view;
                    }
                }
            }];
            
            [BILib injectToClass:[UIActionSheet class] selector:@selector(setTagString:) preprocess:^(UIActionSheet *sheet,NSString *tagString){
                NSDictionary *signlaDic = sheet.signlaDic;
                if (signlaDic.count>0) {
                    for (LKSignal *signal in signlaDic.allValues) {
                        signal.tagString = tagString;
                    }
                }else{
                    self.defaultSignal.tagString = tagString;
                }
            }];
        });
        
    }
    return self;
}

-(NSMutableDictionary *)signlaDic{
    NSMutableDictionary *signlaDic = objc_getAssociatedObject(self, @"signlaDic");
    if (!signlaDic) {
        signlaDic = [NSMutableDictionary dictionary];
        objc_setAssociatedObject(self, @"signlaDic", signlaDic, OBJC_ASSOCIATION_RETAIN);
    }
    return signlaDic;
}

-(LKSignal *)defaultSignal{
    LKSignal *defaultSignal = objc_getAssociatedObject(self, @"defaultSignal");
    if (!defaultSignal) {
        defaultSignal =  [[LKSignal alloc]initWithSender:self firstRouter:self object:nil signalName:UIActionSheet.CLICKED tag:0 tagString:self.tagString];
        objc_setAssociatedObject(self, @"defaultSignal", defaultSignal, OBJC_ASSOCIATION_RETAIN);
    }
    return defaultSignal;
}

#pragma mark -UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;{
    LKSignal *signal = [self.signlaDic objectForKey:[NSNumber numberWithInt:buttonIndex]];
    if (!signal) {
         signal = self.defaultSignal;
    }
    [signal.firstRouter sendSignal:signal];
}

@end

@implementation UIActionSheet(LK_EasySignal)

+(NSString *)CLICKED;{
    return @"CLICKED";
}

-(void)setSignalObject:(NSObject *)object index:(int)index{
    LKSignal *signal = [[LKSignal alloc]initWithSender:self firstRouter:self object:object signalName:UIActionSheet.CLICKED tag:index tagString:nil];
    [self.signlaDic setObject:signal forKey:[NSNumber numberWithInt:index]];
}

-(void)addButtonWithTitle:(NSString *)title signalObject:(NSObject *)object;{
    int index = [self addButtonWithTitle:title];
    [self setSignalObject:object index:index];
}

@end

#pragma mark -

@interface UIView (LK_EasySignal_Private)

@property(nonatomic,strong) UIGestureRecognizer *tagRecongizer;

@end

@implementation UIView (LK_EasySignal_Private)

@dynamic tagRecongizer;

-(UIGestureRecognizer *)tagRecongizer{
    NSObject * obj = objc_getAssociatedObject( self, "tagRecongizer" );
	if ( obj && [obj isKindOfClass:[UIGestureRecognizer class]] )
		return (UIGestureRecognizer *)obj;
	return nil;
}

-(void)setTagRecongizer:(UIGestureRecognizer *)tagRecongizer{
    if (self.tagRecongizer) {
        objc_removeAssociatedObjects(self.tagRecongizer);
    }
    objc_setAssociatedObject( self, "tagRecongizer", tagRecongizer, OBJC_ASSOCIATION_ASSIGN );
}

@end

@implementation UIView (LK_EasySignal)

-(void)setTapable:(BOOL)_tapable{
    if (_tapable) {
        UITapGestureRecognizer *_tagRecongizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapSignal)];
        [self addGestureRecognizer:_tagRecongizer];
        self.tagRecongizer = _tagRecongizer;
    }else{
        self.tagRecongizer = nil;
    }
}

-(BOOL)tapable{
    if (self.tagRecongizer) {
        return YES;
    }else{
        return NO;
    }
}

+(NSString *)TAPED;{
    return @"TAPED";
}

-(void)tapSignal{
    [self sendSignalName:[self class].TAPED];
}

@end
