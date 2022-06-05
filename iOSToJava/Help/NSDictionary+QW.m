
#import "NSDictionary+QW.h"

@implementation NSDictionary (SCJson)

- (id)valueForUniqueKeys:(NSArray *)keys{
    if (keys.count > 0) {
        id result = [self valueForUniqueKey:[keys firstObject]];
        if(keys.count == 1) return result;
        if (result && [result isKindOfClass:[NSDictionary class]]) {
            return [result valueForUniqueKeys:[keys subarrayWithRange:NSMakeRange(1, keys.count - 1)]];
        }
    }
    return nil;
}

- (id)valueForUniqueKey:(NSString *)key{
    if(!self || ![self isKindOfClass:[NSDictionary class]]) return nil;
    id value = self[key];
    if (value) return value;
    for (NSString *keyTemp in self) {
        id value = self[keyTemp];
        if ([value isKindOfClass:[NSDictionary class]]) {
            id result = [(NSDictionary *)value valueForUniqueKey:key];
            if (result) return result;
        }
        if ([value isKindOfClass:[NSArray class]]) {
            id result = [self valueForUniqueKey:key inArr:value];
            if (result) return result;
        }
    }
    return nil;
}

- (id)valueForUniqueKey:(NSString *)key inArr:(NSArray *)arr{
    for (id value in arr) {
        if ([value isKindOfClass:[NSDictionary class]]) {
            id result = [(NSDictionary *)value valueForUniqueKey:key];
            if (result) return result;
        }
        if ([value isKindOfClass:[NSArray class]]) {
            id result = [self valueForUniqueKey:key inArr:value];
            if (result) return result;
        }
    }
    return nil;
}

- (NSString *)stringValueForUniqueKey:(NSString *)key{
    id result = [self valueForUniqueKey:key];
    if (result == nil) return nil;
    if ([result isKindOfClass:[NSArray class]] || [result isKindOfClass:[NSDictionary class]]) {
        if ([NSJSONSerialization isValidJSONObject:self]) {
            NSError *error = nil;
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:&error];
            NSString *json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            if (!error) return json;
        }
        return nil;
    }
    return [NSString stringWithFormat:@"%@",result];
}

- (NSDictionary *)dicValueForUniqueKey:(NSString *)key{
    id result = [self dicForUniqueKey:key];
    return result;
}

- (id)dicForUniqueKey:(NSString *)key{
    if(!self || ![self isKindOfClass:[NSDictionary class]]) return nil;
    id value = self[key];
    if (value) return self;
    for (NSString *keyTemp in self) {
        id value = self[keyTemp];
        if ([value isKindOfClass:[NSDictionary class]]) {
            id result = [(NSDictionary *)value dicForUniqueKey:key];
            if (result) return result;
        }
        if ([value isKindOfClass:[NSArray class]]) {
            id result = [self dicForUniqueKey:key inArr:value];
            if (result) return result;
        }
    }
    return nil;
}

- (id)dicForUniqueKey:(NSString *)key inArr:(NSArray *)arr{
    for (id value in arr) {
        if ([value isKindOfClass:[NSDictionary class]]) {
            id result = [(NSDictionary *)value dicForUniqueKey:key];
            if (result) return result;
        }
        if ([value isKindOfClass:[NSArray class]]) {
            id result = [self dicForUniqueKey:key inArr:value];
            if (result) return result;
        }
    }
    return nil;
}

- (NSString *)stringValueForUniqueKeys:(NSArray *)keys{
    id result = [self valueForUniqueKeys:keys];
    if (result == nil) return nil;
    if ([result isKindOfClass:[NSArray class]] || [result isKindOfClass:[NSDictionary class]]) {
        if ([NSJSONSerialization isValidJSONObject:self]) {
            NSError *error = nil;
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:&error];
            NSString *json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            if (!error) return json;
        }
        return nil;
    }
    return [NSString stringWithFormat:@"%@",result];
}

- (id)valueForUniqueKey:(NSString *)key checkClass:(Class)cls{
    id result = [self valueForUniqueKey:key];
    if ([result isKindOfClass:cls]) {
        return result;
    }
    return nil;
}

- (id)valueForUniqueKeys:(NSArray *)keys checkClass:(Class)cls{
    id result = [self valueForUniqueKeys:keys];
    if ([result isKindOfClass:cls]) {
        return result;
    }
    return nil;
}

+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString{
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err)
    {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

@end
