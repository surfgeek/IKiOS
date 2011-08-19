//
//  GDataXMLElement-Extras.h
//  iRest
//
//  Created by Bryan Coon on 8/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//



#import <Foundation/Foundation.h>
#import "GDataXMLNode.h"

@interface GDataXMLElement (Extras)

- (GDataXMLElement *)elementForChild:(NSString *)childName;
- (NSString *)valueForChild:(NSString *)childName;

@end
