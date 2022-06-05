
#import "iOS2Android.h"
#import "MBProgressHUD.h"
#import "ZHFileManager.h"
#import "ZHNSString.h"
#import "NSDictionary+QW.h"

@interface iOS2Android ()

@property (nonatomic,assign)BOOL danduCeshi;
@property (nonatomic,copy)NSString *ruleTxt;

@end


@implementation iOS2Android

- (NSString *)begin:(NSString *)code{
    if (code.length <= 0) {
        [MBProgressHUD showText:@"内容不能为空"];
        return code;
    }
    NSString *content = [self beginDealText:code isMulu:NO];
    if (content.length > 0) {
        [MBProgressHUD showText:@"代码转换完成!"];
        return content;
    }
    [MBProgressHUD showText:@"代码转换失败!"];
    return code;
}

- (NSString *)beginPath:(NSString *)path{
    NSString *text = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    return [self begin:text];
}

- (void)beginMulu:(NSString *)mulu{
    NSArray *paths = [ZHFileManager subPathFileArrInDirector:mulu hasPathExtension:@[@".h", @".m"]];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        for (NSInteger i=0; i<paths.count; i++) {
            @autoreleasepool {
                NSString *path = paths[i];
                NSLog(@"😄😄😄😄😄😄😄😄%@",path);
                NSLog(@"😄😄😄😄😄😄😄😄 进度:%.2f%%",(i+1)*100.0/paths.count);
                NSString *content = [self beginDeal:path isMulu:YES];
                if (content.length > 0) {
                    [content writeToFile:path atomically:YES encoding:(NSUTF8StringEncoding) error:nil];
                }
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD showText:@"代码转换完成!"];
        });
    });
}

- (NSString *)beginDeal:(NSString *)path isMulu:(BOOL)isMulu{
    NSString *text = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    return [self beginDealText:text isMulu:isMulu];
}

- (NSString *)beginDealText:(NSString *)text isMulu:(BOOL)isMulu{
    //拿到代码
    NSString *content = nil;
    if(isMulu) content = text;
    else content = [NSString stringWithFormat:@" \n%@\n ",text];
    //获取规则
    if(self.ruleTxt.length <= 0)self.ruleTxt = [self getRule];
    NSString *rule = self.ruleTxt;
    NSDictionary *dicRule = [NSDictionary dictionaryWithJsonString:rule];
    if (!dicRule) {
        [MBProgressHUD showText:@"代码转换规则 json不对,请检查!"];
        return @"";
    }
    self.danduCeshi = [dicRule stringValueForUniqueKey:@"单独测试"];
    
    NSArray *tihuan = dicRule[@"替换"];
    NSArray *kua_zi_fu_tihuan = dicRule[@"跨字符替换"];
    
    //开始转换
    content = [self run_kua_zi_fu_tihuan:kua_zi_fu_tihuan content:content isYouxian:YES];
    content = [self run_tihuan:tihuan content:content isYanchi:NO];
    content = [self run_kua_zi_fu_tihuan:kua_zi_fu_tihuan content:content isYouxian:NO];
    content = [self run_tihuan:tihuan content:content isYanchi:YES];
    
    return content;
}

- (NSString *)run_kua_zi_fu_tihuan:(NSArray *)kua_zi_fu_tihuan content:(NSString *)content isYouxian:(BOOL)isYouxian{
    for (NSDictionary *dic in kua_zi_fu_tihuan) {
        NSString *target = dic[@"目标规则"];
        NSString *replace = dic[@"重组规则"];
        NSString *bian_liang_ming = dic[@"%@是变量"];
        NSString *chang_liang_ming = dic[@"%@是常量"];
        NSString *xiang_tong = dic[@"%@相同"];
        NSString *bu_bao_hang = dic[@"%@不包含"];
        NSString *danduCeshi = dic[@"单独测试"];
        NSString *yihangdaima = dic[@"限制一行代码范围"];
        NSString *youxian = dic[@"优先级"];
        NSString *bian_cheng_bian_liang = dic[@"临时变成变量"];
        //筛选优先级
        if (isYouxian && youxian == nil)continue;
        if (!isYouxian && youxian)continue;
        //筛选单独测试
        if (self.danduCeshi && !danduCeshi) continue;
        
        NSArray *splits = nil;
        if([target containsString:@"%@"])splits = [target componentsSeparatedByString:@"%@"];
        else splits = [ZHNSString componentsSeparatedByStrings:@[@"%1@",@"%2@",@"%3@",@"%4@",@"%5@",@"%6@",@"%7@",@"%8@",@"%9@",@"%10@",
                                                                 @"%11@",@"%12@",@"%13@",@"%14@",@"%15@",@"%16@",@"%17@",@"%18@",@"%19@",@"%20@",
                                                                 @"%21@",@"%22@",@"%23@",@"%24@",@"%25@",@"%26@",@"%27@",@"%28@",@"%29@",@"%30@",
                                                               ] text:target];
        if(splits == nil)break;
        
        NSArray *replace_splits = nil;
        if([target containsString:@"%@"])replace_splits = [replace componentsSeparatedByString:@"%@"];
        
        NSString *contentTmp = content;
        BOOL isFind = YES;
        while (isFind) {
            NSString *targetStr = [ZHNSString getMidTargetStringBetweenLeftRightStrings:splits withText:contentTmp];
            if (targetStr.length > 0) {
                //开始重组
                if (yihangdaima) {
                    if ([targetStr containsString:@"\n"]) {
                        //继续往后找
                        contentTmp = [contentTmp substringFromIndex:[contentTmp rangeOfString:targetStr].location + targetStr.length];
                        continue;
                    }
                }
                NSArray *splitStrs = [ZHNSString getMidsBetweenLeftRightStrings:splits withText:targetStr];
                if(splitStrs.count <= 0)isFind = NO;
                //过滤不包含
                if (bu_bao_hang && bu_bao_hang.length > 0) {
                    BOOL isBuBaoHan = YES;
                    if ([bu_bao_hang containsString:@","]) {
                        NSArray *bu_bao_hangs = [bu_bao_hang componentsSeparatedByString:@","];
                        for (NSString *splitStr in splitStrs) {
                            if ([ZHNSString isBaoHanCode:splitStr arr:bu_bao_hangs]) {
                                isBuBaoHan = NO;
                                break;
                            }
                        }
                    }else{
                        for (NSString *splitStr in splitStrs) {
                            if([splitStr containsString:bu_bao_hang]){
                                isBuBaoHan = NO;
                                break;
                            }
                        }
                    }
                    if (!isBuBaoHan) {
                        //继续往后找
                        contentTmp = [contentTmp substringFromIndex:[contentTmp rangeOfString:targetStr].location + targetStr.length];
                        continue;
                    }
                }
                //判断变量 判断常量
                if(bian_liang_ming && chang_liang_ming){
                    BOOL isBianliang = YES;BOOL isChangliang = YES;
                    for (NSString *splitStr in splitStrs) {
                        if ((![ZHNSString isBianLiangMingCode:splitStr]) && (![ZHNSString isChangLiangMingCode:splitStr])) {
                            isBianliang = NO;isChangliang = NO;
                            break;
                        }
                    }
                    if (!isBianliang && !isChangliang) {
                        //继续往后找
                        contentTmp = [contentTmp substringFromIndex:[contentTmp rangeOfString:targetStr].location + targetStr.length];
                        continue;
                    }
                }
                //判断变量
                else if(bian_liang_ming){
                    BOOL isBianliang = YES;
                    for (NSString *splitStr in splitStrs) {
                        if (![ZHNSString isBianLiangMingCode:splitStr]) {
                            isBianliang = NO;
                            break;
                        }
                    }
                    if (!isBianliang) {
                        //继续往后找
                        contentTmp = [contentTmp substringFromIndex:[contentTmp rangeOfString:targetStr].location + targetStr.length];
                        continue;
                    }
                }
                //判断常量
                else if(chang_liang_ming){
                    BOOL isChangliang = YES;
                    for (NSString *splitStr in splitStrs) {
                        if (![ZHNSString isChangLiangMingCode:splitStr]) {
                            isChangliang = NO;
                            break;
                        }
                    }
                    if (!isChangliang) {
                        //继续往后找
                        contentTmp = [contentTmp substringFromIndex:[contentTmp rangeOfString:targetStr].location + targetStr.length];
                        continue;
                    }
                }
                //判断相同
                if(xiang_tong){
                    BOOL isXiangTong = YES;
                    NSString *xiang_tong_str = @"";
                    for (NSString *splitStr in splitStrs) { 
                        if(xiang_tong_str.length > 0 && ![xiang_tong_str isEqualToString:splitStr]){
                            isXiangTong = NO;
                            break;
                        }
                        xiang_tong_str = splitStr;
                    }
                    if (!isXiangTong) {
                        //继续往后找
                        contentTmp = [contentTmp substringFromIndex:[contentTmp rangeOfString:targetStr].location + targetStr.length];
                        continue;
                    }
                }
                if(!isFind)break;
                //开始组合
                NSMutableString *strM = [NSMutableString string];
                if (replace_splits) {
                    for (NSInteger i=0; i<replace_splits.count; i++) {
                        [strM appendString:replace_splits[i]];
                        if(i<splitStrs.count)[strM appendString:splitStrs[i]];
                    }
                }else{
                    NSString *replace_tmp = replace;
                    for (int i=0; i<splitStrs.count; i++) {
                        replace_tmp = [replace_tmp stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%%%d@",i+1] withString:splitStrs[i]];
                    }
                    [strM appendString:replace_tmp];
                }
                if (strM.length > 0) {
                    if(bian_cheng_bian_liang)[strM setString:[NSString stringWithFormat:@"<#%@#>",strM]];
                    content = [content stringByReplacingOccurrencesOfString:targetStr withString:strM];
                    contentTmp = content;
                }else{
                    isFind = NO;
                }
            }else{
                isFind = NO;
            }
        }
    }
    return content;
}

- (NSString *)run_tihuan:(NSArray *)tihuan content:(NSString *)content isYanchi:(BOOL)isYanchi{
    for (NSDictionary *dic in tihuan) {
        NSString *danduCeshi = dic[@"单独测试"];
        NSString *bian_liang_ming = dic[@"%@是变量"];
        NSString *yanchi = dic[@"延迟执行"];
        //筛选优先级
        if (isYanchi && yanchi == nil)continue;
        if (!isYanchi && yanchi)continue;
        if (self.danduCeshi && !danduCeshi) continue;
        NSString *target = dic[@"目标字符"];
        NSString *replace = dic[@"替换字符"];
        if(bian_liang_ming)content = [ZHNSString changeOldName:target newName:replace inText:content];
        else content = [content stringByReplacingOccurrencesOfString:target withString:replace];
    }
    return content;
}

- (NSString *)getRule {
    NSString *macDesktopPath = [ZHFileManager getMacDesktop];
    macDesktopPath           = [macDesktopPath stringByAppendingPathComponent:@"rule.txt"];/**规则文件路径 我习惯放在桌面上 请将rule文件复制到桌面*/
    NSString *text = [NSString stringWithContentsOfFile:macDesktopPath encoding:NSUTF8StringEncoding error:nil];
    if(text.length <= 0){
        //使用默认规则
        macDesktopPath = [[NSBundle mainBundle] pathForResource:@"rule" ofType:@".txt"];
        text = [NSString stringWithContentsOfFile:macDesktopPath encoding:NSUTF8StringEncoding error:nil];
    }
    return text;
}

@end
