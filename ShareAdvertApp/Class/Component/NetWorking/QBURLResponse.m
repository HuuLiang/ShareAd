//
//  QBURLResponse.m
//  kuaibov
//
//  Created by Sean Yue on 15/9/3.
//  Copyright (c) 2015年 kuaibov. All rights reserved.
//

#import "QBURLResponse.h"
#import <objc/runtime.h>
#import "QBDefines.h"
#import "NSObject+Properties.h"


@implementation QBURLResponse

- (void)parseResponseWithDictionary:(NSDictionary *)dic {
    [self parseDataWithDictionary:dic inInstance:self];
}

- (void)parseDataWithDictionary:(NSDictionary *)dic inInstance:(id)instance {
    if (!dic || !instance) {
        return ;
    }

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    NSArray *properties = [NSObject propertiesOfClass:[instance class]];
    [dic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        NSString *propertyName = key;
        NSString *setPropertyName = propertyName;
        
        if (![properties containsObject:setPropertyName]) {
            return ;
        }
        
        id value = obj;
        
        if ([value isKindOfClass:[NSString class]]
            || [value isKindOfClass:[NSNumber class]]) {
            [instance setValue:value forKey:setPropertyName];
        } else if ([value isKindOfClass:[NSDictionary class]]) {
            id property = [instance valueForKey:setPropertyName];
            Class subclass = [property class];
            if (!subclass) {
                NSString *classPropertyName = [propertyName stringByAppendingString:@"Class"];
                if ([instance respondsToSelector:NSSelectorFromString(classPropertyName)]) {
                    subclass = [instance valueForKey:classPropertyName];
                }
            }
            
            id subinstance = [[subclass alloc] init];
            [instance setValue:subinstance forKey:setPropertyName];
            
            [self parseDataWithDictionary:(NSDictionary *)value inInstance:subinstance];
        } else if ([value isKindOfClass:[NSArray class]]) {
            Class subclass = [instance valueForKey:[propertyName stringByAppendingString:@"ElementClass"]];
            if (!subclass) {
                QBLog(@"JSON Parsing Warning: cannot find element class of property: %@ in class: %@\n", propertyName, [[instance class] description])
                return;
            }
            
            if (subclass == [NSString class] || subclass == [NSNumber class]) {
                [instance setValue:value forKey:setPropertyName];
                return ;
            }
            
            NSMutableArray *arr = [[NSMutableArray alloc] init];
            [instance setValue:arr forKey:setPropertyName];
            
            for (id subobj in (NSArray *)value) {
                if ([subobj isKindOfClass:[NSDictionary class]]) {
                    id subinstance = [[subclass alloc] init];
                    [arr addObject:subinstance];
                    [self parseDataWithDictionary:(NSDictionary *)subobj inInstance:subinstance];
                } else if ([subobj isKindOfClass:[NSString class]]) {
                    [arr addObject:subobj];
                }
            }
        }
    }];
#pragma clang diagnostic pop
}

@end
