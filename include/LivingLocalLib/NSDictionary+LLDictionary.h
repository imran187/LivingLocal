//
//  NSDictionary+CBDictionary.h
//  Chirping Block
//
//  Created by TechLoverr on 1/17/15.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (LLDictionary)

- (id)objectForKeyWithValidation:(NSString *)aKey;
- (id)objectForKeyWithValidation:(NSString *)aKey ForClass:(Class)className;

@end
