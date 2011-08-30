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
    NSString* _dataImageBase64;
    NSMutableArray* _dataSketch;
}

@property (nonatomic, retain) NSString* ElementId;
@property (nonatomic, retain) NSString* DataSetName;
@property (nonatomic, retain) NSString* DataText;
@property (nonatomic, retain) NSString* DataImageBase64;
@property (nonatomic, retain) NSMutableArray* DataSketch;

@end
