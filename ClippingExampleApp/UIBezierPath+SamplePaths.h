//
//  UIBezierPath+SamplePaths.h
//  ClippingExampleApp
//
//  Created by Adam Wulf on 5/8/20.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIBezierPath (SamplePaths)

+ (UIBezierPath *)splitterPath;
+ (UIBezierPath *)splittingPath;

+ (UIBezierPath *)simpleBox1;
+ (UIBezierPath *)simpleBox2;

@end

NS_ASSUME_NONNULL_END
