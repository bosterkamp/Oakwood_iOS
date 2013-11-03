//
//  ColorConverter.m
//  Oakwood
//
//  Created by The Osterkamps on 4/14/13.
//  Copyright (c) 2013 Oakwood Baptist Church. All rights reserved.
//

#import "ColorConverter.h"

@implementation ColorConverter


//This is a helper method to convert our silver hex to a UIColor
+ (UIColor *)colorFromHexString:(NSString *)hexString {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}

@end
