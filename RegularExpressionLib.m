////
////  RegularExpressionLib.m
////  HongXiaoBao
////
////  Created by hoomsun on 16/7/4.
////  Copyright © 2016年 hongxb. All rights reserved.
////
//
//#import "RegularExpressionLib.h"
//
//@implementation RegularExpressionLib
//
//
///**
// *  常用的第三方正则库:
// 
// 匹配中文字符的正则表达式： [\u4e00-\u9fa5]
// 
// 评注：匹配中文还真是个头疼的事，有了这个表达式就好办了
// 
// 匹配双字节字符(包括汉字在内)：[^\x00-\xff]
// 
// 评注：可以用来计算字符串的长度（一个双字节字符长度计2，ASCII字符计1）
// 
// 匹配空白行的正则表达式：\n\s*\r
// 
// 评注：可以用来删除空白行
// 匹配HTML标记的正则表达式：<(\S ?)[^>] >.*?
// 
// 评注：网上流传的版本太糟糕，上面这个也仅仅能匹配部分，对于复杂的嵌套标记依旧无能为力
// 匹配首尾空白字符的正则表达式：^\s |\s $
// 
// 评注：可以用来删除行首行尾的空白字符(包括空格、制表符、换页符等等)，非常有用的表达式
// 匹配Email地址的正则表达式：\w+([-+.]\w+) @\w+([-.]\w+) .\w+([-.]\w+)*
// 
// 评注：表单验证时很实用
// 匹配网址URL的正则表达式：[a-zA-z]+://[^\s]*
// 
// 评注：网上流传的版本功能很有限，上面这个基本可以满足需求
// 匹配帐号是否合法(字母开头，允许5-16字节，允许字母数字下划线)：^[a-zA-Z][a-zA-Z0-9_]{4,15}$
// 
// 评注：表单验证时很实用
// 匹配国内电话号码：\d{3}-\d{8}|\d{4}-\d{7}
// 
// 评注：匹配形式如 0511-4405222 或 021-87888822
// 匹配腾讯QQ号：[1-9][0-9]{4,}
// 
// 评注：腾讯QQ号从10000开始
// 匹配中国邮政编码：[1-9]\d{5}(?!\d)
// 
// 评注：中国邮政编码为6位数字
// 匹配身份证：\d{15}|\d{18}
// 
// 评注：中国的身份证为15位或18位
// 匹配ip地址：\d+.\d+.\d+.\d+
// 
// 评注：提取ip地址时有用
// */
//
//
///*
// 匹配特定数字：
// ^[1-9]\d*$    //匹配正整数
// ^-[1-9]\d*$   //匹配负整数
// ^-?[1-9]\d*$   //匹配整数
// ^[1-9]\d*|0$  //匹配非负整数（正整数 + 0）
// ^-[1-9]\d*|0$   //匹配非正整数（负整数 + 0）
// ^[1-9]\d*\.\d*|0\.\d*[1-9]\d*$   //匹配正浮点数
// ^-([1-9]\d*\.\d*|0\.\d*[1-9]\d*)$  //匹配负浮点数
// ^-?([1-9]\d*\.\d*|0\.\d*[1-9]\d*|0?\.0+|0)$  //匹配浮点数
// ^[1-9]\d*\.\d*|0\.\d*[1-9]\d*|0?\.0+|0$   //匹配非负浮点数（正浮点数 + 0）
// ^(-([1-9]\d*\.\d*|0\.\d*[1-9]\d*))|0?\.0+|0$  //匹配非正浮点数（负浮点数 + 0）
// 评注：处理大量数据时有用，具体应用时注意修正
// 
// */
//
///*
// 匹配特定字符串：
// ^[A-Za-z]+$  //匹配由26个英文字母组成的字符串
// ^[A-Z]+$  //匹配由26个英文字母的大写组成的字符串
// ^[a-z]+$  //匹配由26个英文字母的小写组成的字符串
// ^[A-Za-z0-9]+$  //匹配由数字和26个英文字母组成的字符串
// ^\w+$  //匹配由数字、26个英文字母或者下划线组成的字符串
// 
// */
//
///*
// 其他一些常用字符
// \\d     // 代表数字
// {2}     // 代表有两个
// {2,4}   // 代表有2到4个
// ?       // 代表0或1个
// +       // 代表至少1个
// *       // 代表0个或多个
// ^       // 代表以...开头
// $       // 代表以...结束
// .       // 代表除换行符以外的任意字符
// 
// */
//
///*
// OC中正则表达式的使用方法
// 
// 创建一个正则表达式对象
// 利用正则表达式来测试对应的字符串
// 
// */
//- (void)test
//{
//    NSString *checkString = @"a34ssd231";
//    // 1.创建正则表达式，[0-9]:表示‘0’到‘9’的字符的集合
//    NSString *pattern = @"[0-9]";
//    // 1.1将正则表达式设置为OC规则
//    NSRegularExpression *regular = [[NSRegularExpression alloc] initWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:nil];
//    // 2.利用规则测试字符串获取匹配结果
//    NSArray *results = [regular matchesInString:checkString options:0 range:NSMakeRange(0, checkString.length)];
//    NSLog(@"%ld",results.count);
//    /*
//     分析结果：
//     从checkingString上分析为数字的字符为 5
//     所以可以得出一个结论，正则表达式的作用就是把多个字符串杂糅到一个表达式中
//     */
//}
//
//检查电话号码
//-(BOOL)checkUSPhoneNumber:(NSString*)phoneNumber
//{
//    YKLog(@"phoneNumber--->%@",phoneNumber);
//    if (phoneNumber == nil || [phoneNumber length]<1)
//    {
//        return NO;
//    }
//    NSError *error = NULL;
//    NSDataDetector *detector = [NSDataDetectordataDetectorWithTypes:NSTextCheckingTypePhoneNumbererror:&error];
//    NSRange inputRange = NSMakeRange(0, [phoneNumber length]);
//    NSArray *matches = [detector matchesInString:phoneNumber options:0 range:inputRange];
//    if ([matches count] == 0)
//    {
//        return NO;
//    }
//    NSTextCheckingResult *result = (NSTextCheckingResult *)[matches objectAtIndex:0];
//    if ([result resultType] == NSTextCheckingTypePhoneNumber && result.range.location == inputRange.location && result.range.length == inputRange.length)
//    {
//        return YES;
//    }
//    else
//    {
//        return NO;
//    }
//}
//
//@end
