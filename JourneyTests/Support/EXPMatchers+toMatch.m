#import "EXPMatchers+toMatch.h"

EXPMatcherImplementationBegin(toMatch, (NSString * regex)) {
  BOOL actualIsString = [actual isKindOfClass:[NSString class]];
  BOOL regexIsString = [regex isKindOfClass:[NSString class]];

  prerequisite(^BOOL{
    return actualIsString && regexIsString;
  });

  match(^BOOL{
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL matchResult = [pred evaluateWithObject:(NSString *)actual];
    return matchResult;
  });

  failureMessageForTo(^NSString *{
    if(!actualIsString) return [NSString stringWithFormat:@"%@ is not an instance of NSString", EXPDescribeObject(actual)];
    if(!regexIsString) return @"the regex is not an instance of NSString";
    return [NSString stringWithFormat:@"expected %@ to match %@", EXPDescribeObject(actual), EXPDescribeObject(regex)];
  });

  failureMessageForNotTo(^NSString *{
    if(!actualIsString) return [NSString stringWithFormat:@"%@ is not an instance of NSString", EXPDescribeObject(actual)];
    if(!regexIsString) return @"tthe regex is not an instance of NSString";
    return [NSString stringWithFormat:@"expected %@ not to match %@", EXPDescribeObject(actual), EXPDescribeObject(regex)];
  });
}
EXPMatcherImplementationEnd
