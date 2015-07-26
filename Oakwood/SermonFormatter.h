//
//  SermonFormatter.h
//  Oakwood
//
//  Created by The Osterkamps on 12/10/14.
//  Copyright (c) 2014 Oakwood Baptist Church. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SermonFormatter : NSObject

//this needs to be an NSArray Probably
+(NSDictionary *)formatSermons:(NSArray *)videoSermons audioSermon:(NSArray *)audioSermons;

@end