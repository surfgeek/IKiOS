//
//  DataElement.h
//  iRest
//
//  Created by Bryan Coon on 8/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataElement : NSObject
{
    NSString* _elementId;
    NSString* _dataSetName;
    NSString* _dataText;
}

@property (nonatomic, retain) NSString* ElementId;
@property (nonatomic, retain) NSString* DataSetName;
@property (nonatomic, retain) NSString* DataText;

@end
