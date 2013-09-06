//
//  ViewController.m
//  LK_EasySignal
//
//  Created by hesh on 13-9-4.
//  Copyright (c) 2013年 ilikeido. All rights reserved.
//

#import "ViewController.h"
#import "LK_EasySignal.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _textView.placeHolder = @"测试测试测试测试测试测试测试测试";
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

ON_LKSIGNAL3(UIButton, UPINSIDE, signal){
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Test2" message:@"click now" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alertView showInView:self.view cancelSignalObject:nil sumbitSignalObject:nil];
}

ON_LKSIGNAL2(UIAlertView, signal){
    UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:@"Test3" delegate:nil cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Sure" otherButtonTitles:nil, nil];
    sheet.tagString = @"TEST3";
    [sheet showInView:self.view];
}

ON_LKSIGNAL5(UIActionSheet, CLICKED, TEST3, signal){
    NSLog(@"Test3 is finished");
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Test2" message:@"click now" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    alertView.tag = 2;
    [alertView showInView:self.view cancelSignalObject:nil sumbitSignalObject:nil];
}

ON_LKSIGNAL6(UITextView, RETURN, 6, signal){
    NSLog(@"111111232323");
}

ON_LKSIGNAL3(UITextField, BEGIN_EDITING, signal){
    UITextField *textField = (UITextField *)signal.sender;
    textField.maxLength = 11;
    NSLog(@"%@",textField.text);
}

ON_LKSIGNAL3(UITextField, TEXTCHANGED, signal){
    UITextField *textField = (UITextField *)signal.sender;
    NSLog(@"%@",textField.text);
}

ON_LKSIGNAL3(UITextField, RETURN, signal){
    UITextField *textField = (UITextField *)signal.sender;
    NSLog(@"%@",textField.text);
    [textField resignFirstResponder];
}

ON_LKSIGNAL3(UITextView, RETURN, signal){
    UITextView *textView = (UITextView *)signal.sender;
    NSLog(@"%@",textView.text);
    [textView resignFirstResponder];
}

ON_LKSIGNAL4(UIAlertView, 2, signal){
    NSLog(@"Test4 is finished");
}


- (void)viewDidUnload {
    [self setTextView:nil];
    [super viewDidUnload];
}
@end
