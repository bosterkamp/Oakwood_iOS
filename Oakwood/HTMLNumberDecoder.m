//
//  HTMLNumberDecoder.m
//  Oakwood
//
//  Created by The Osterkamps on 8/11/13.
//  Copyright (c) 2013 Oakwood Baptist Church. All rights reserved.
//

#import "HTMLNumberDecoder.h"

@implementation HTMLNumberDecoder

//This is a helper method to convert HTML numbers (&#xxx;) to a proper value, or if we don't know what it is, then replace with blank.
+ (NSString *)decodeString:(NSString *)stringToBeDecoded {
    //unsigned rgbValue = 0;
    NSMutableString *decodedString = [NSMutableString string];
    //NSScanner *scanner = [NSScanner scannerWithString:stringToBeDecoded];

    //[decodedString  appendString:stringToBeDecoded];
    
    
    NSArray *parsedLines = [stringToBeDecoded componentsSeparatedByString:@"&"];
    
    //[decodedString appendString: [parsedLines objectAtIndex:0]];
    //startDate = [[parsedLineElement componentsSeparatedByString:@":"] objectAtIndex:1];
    
    for (NSMutableString *parsedLineElement in parsedLines)
    {
        //[decodedString appendString:parsedLineElement];
        
        NSString *param = [NSMutableString string];
        NSRange start = [parsedLineElement rangeOfString:@"#"];
        
        if (start.location != NSNotFound)
        {
            param = [parsedLineElement substringFromIndex:start.location + start.length];
            //NSLog(@"parsed element amp: %@", parsedLineElement);
            //NSLog(@"param: %@", parsedLineElement);
            
            NSRange end = [param rangeOfString:@";"];
            if (end.location != NSNotFound)
            {
                param = [param substringToIndex:end.location];
                
            }
            
            NSRange range = NSMakeRange(0,6);
            
            //Simple check for values...
            if ([param isEqual: @"8211"] || [param isEqual:@"8212"])
            {
                param = [parsedLineElement stringByReplacingCharactersInRange:range withString:@"-"];
            }
            else if ([param isEqual: @"8216" ] || [param isEqual:@"8217"])
            {
                param = [parsedLineElement stringByReplacingCharactersInRange:range withString:@"'"];
            }
            else if ([param isEqual: @"8220" ] || [param isEqual:@"8221"])
            {
                param = [parsedLineElement stringByReplacingCharactersInRange:range withString:@"\""];
            }
            //Just pull the character out, since we don't know what it is.
            else
            {
                param = [parsedLineElement stringByReplacingCharactersInRange:range withString:@""];
            }
            
            [decodedString appendString:param];

            
        }
        else
        {
            [decodedString appendString:parsedLineElement];
        }
        
    }


     
     /*
     
     
     
    while(![scanner isAtEnd])
  {
    //[scanner scanUpToString:@"&#" intoString:&stringToBeDecoded];
    //[scanner setScanLocation:1]; // bypass '#' character
    //[scanner scanHexInt:&rgbValue];
      [scanner scanString:@"{" intoString:nil];
      foundString = @""; // scanUpToString doesn't modify foundString if no characters are scanned
      [scanner scanUpToString:@"}" intoString:&foundString];
      [formattedResponse appendString:[data objectForKey:foundString];
       [scanner scanString:@"}"];
      [decodedString  appendString:stringToBeDecoded];
  }
    
    NSString *foundString;
    
    while(![scanner isAtEnd]) {
        if([scanner scanUpToString:@"&#" intoString:&foundString]) {
            [decodedString appendString:foundString];
        }
        if(![scanner isAtEnd]) {
            [scanner scanString:@"&#" intoString:nil];
            //foundString = @""; // scanUpToString doesn't modify foundString if no characters are scanned
            [scanner scanUpToString:@";" intoString:&foundString];
            [decodedString appendString:foundString];
             //[scanner scanString:@"}"];
             }
    }
      */
    return decodedString;
}

@end
