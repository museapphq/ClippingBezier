//
//  MMClippingBezierUnionTest.m
//  ClippingBezierTests
//
//  Created by Adam Wulf on 5/21/20.
//

#import <XCTest/XCTest.h>
#import "MMClippingBezierAbstractTest.h"
#import <ClippingBezier/ClippingBezier.h>
#import <PerformanceBezier/PerformanceBezier.h>
#import <ClippingBezier/UIBezierPath+Clipping_Private.h>

@interface MMClippingBezierUnionTest : MMClippingBezierAbstractTest

@end

@implementation MMClippingBezierUnionTest

- (void)testSimpleUnionStep1
{
    UIBezierPath *path1 = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, 100, 100)];
    UIBezierPath *path2 = [UIBezierPath bezierPathWithRect:CGRectMake(50, 20, 100, 60)];

    NSArray<DKUIBezierPathShape *> *finalShapes = [path1 allUniqueShapesWithPath:path2];

    XCTAssertEqual([finalShapes count], 3);

    XCTAssert([finalShapes[0] canGlueToShape:finalShapes[1]]);
    XCTAssert([finalShapes[0] canGlueToShape:finalShapes[2]]);

    DKUIBezierPathShape *unionShape = [[finalShapes[0] glueToShape:finalShapes[1]] glueToShape:finalShapes[2]];

    XCTAssertNotNil(unionShape);

    UIBezierPath *unionPath = [UIBezierPath bezierPath];
    [unionPath moveToPoint:CGPointMake(100, 20)];
    [unionPath addLineToPoint:CGPointMake(150, 20)];
    [unionPath addLineToPoint:CGPointMake(150, 80)];
    [unionPath addLineToPoint:CGPointMake(100, 80)];
    [unionPath addLineToPoint:CGPointMake(100, 100)];
    [unionPath addLineToPoint:CGPointMake(0, 100)];
    [unionPath addLineToPoint:CGPointMake(0, 0)];
    [unionPath addLineToPoint:CGPointMake(100, 0)];
    [unionPath addLineToPoint:CGPointMake(100, 20)];
    [unionPath closePath];

    XCTAssert([unionPath isEqualToBezierPath:[unionShape fullPath] withAccuracy:0.00001]);
}

- (void)testSimpleUnionStep2
{
    UIBezierPath *path1 = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, 100, 100)];
    UIBezierPath *path2 = [UIBezierPath bezierPathWithRect:CGRectMake(50, 20, 100, 60)];

    NSArray<DKUIBezierPathShape *> *finalShapes = [path1 uniqueGluedShapesWithPath:path2];

    XCTAssertEqual([finalShapes count], 1);

    DKUIBezierPathShape *unionShape = finalShapes[0];

    UIBezierPath *unionPath = [UIBezierPath bezierPath];
    [unionPath moveToPoint:CGPointMake(100, 20)];
    [unionPath addLineToPoint:CGPointMake(150, 20)];
    [unionPath addLineToPoint:CGPointMake(150, 80)];
    [unionPath addLineToPoint:CGPointMake(100, 80)];
    [unionPath addLineToPoint:CGPointMake(100, 100)];
    [unionPath addLineToPoint:CGPointMake(0, 100)];
    [unionPath addLineToPoint:CGPointMake(0, 0)];
    [unionPath addLineToPoint:CGPointMake(100, 0)];
    [unionPath addLineToPoint:CGPointMake(100, 20)];
    [unionPath closePath];

    XCTAssert([unionPath isEqualToBezierPath:[unionShape fullPath] withAccuracy:0.00001]);
}

- (void)testSimpleUnionStep3
{
    UIBezierPath *path1 = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, 100, 100)];
    UIBezierPath *path2 = [UIBezierPath bezierPathWithRect:CGRectMake(50, 20, 100, 60)];

    NSArray<UIBezierPath *> *finalShapes = [path1 unionWithPath:path2];

    XCTAssertEqual([finalShapes count], 1);

    UIBezierPath *unionShape = finalShapes[0];

    UIBezierPath *unionPath = [UIBezierPath bezierPath];
    [unionPath moveToPoint:CGPointMake(100, 20)];
    [unionPath addLineToPoint:CGPointMake(150, 20)];
    [unionPath addLineToPoint:CGPointMake(150, 80)];
    [unionPath addLineToPoint:CGPointMake(100, 80)];
    [unionPath addLineToPoint:CGPointMake(100, 100)];
    [unionPath addLineToPoint:CGPointMake(0, 100)];
    [unionPath addLineToPoint:CGPointMake(0, 0)];
    [unionPath addLineToPoint:CGPointMake(100, 0)];
    [unionPath addLineToPoint:CGPointMake(100, 20)];
    [unionPath closePath];

    XCTAssert([unionPath isEqualToBezierPath:unionShape withAccuracy:0.00001]);
}

- (void)testFullOverlapUnionStep1
{
    UIBezierPath *path1 = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, 100, 100)];
    UIBezierPath *path2 = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, 200, 100)];

    NSArray<DKUIBezierPathShape *> *finalShapes = [path1 allUniqueShapesWithPath:path2];

    XCTAssertEqual([finalShapes count], 2);

    XCTAssert([finalShapes[0] canGlueToShape:finalShapes[1]]);

    DKUIBezierPathShape *unionShape = [finalShapes[0] glueToShape:finalShapes[1]];

    XCTAssertNotNil(unionShape);

    UIBezierPath *unionPath = [UIBezierPath bezierPath];
    [unionPath moveToPoint:CGPointMake(0, 0)];
    [unionPath addLineToPoint:CGPointMake(100, 0)];
    [unionPath addLineToPoint:CGPointMake(200, 0)];
    [unionPath addLineToPoint:CGPointMake(200, 100)];
    [unionPath addLineToPoint:CGPointMake(100, 100)];
    [unionPath addLineToPoint:CGPointMake(0, 100)];
    [unionPath addLineToPoint:CGPointMake(0, 0)];
    [unionPath closePath];

    XCTAssert([unionPath isEqualToBezierPath:[unionShape fullPath] withAccuracy:0.00001]);
}

- (void)testFullOverlapUnion
{
    UIBezierPath *path1 = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, 100, 100)];
    UIBezierPath *path2 = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, 200, 100)];

    NSArray<UIBezierPath *> *finalShapes = [path1 unionWithPath:path2];

    XCTAssertEqual([finalShapes count], 1);

    UIBezierPath *unionPath = [UIBezierPath bezierPath];
    [unionPath moveToPoint:CGPointMake(0, 0)];
    [unionPath addLineToPoint:CGPointMake(100, 0)];
    [unionPath addLineToPoint:CGPointMake(200, 0)];
    [unionPath addLineToPoint:CGPointMake(200, 100)];
    [unionPath addLineToPoint:CGPointMake(100, 100)];
    [unionPath addLineToPoint:CGPointMake(0, 100)];
    [unionPath addLineToPoint:CGPointMake(0, 0)];
    [unionPath closePath];

    XCTAssert([unionPath isEqualToBezierPath:[finalShapes firstObject] withAccuracy:0.00001]);
}

- (void)testUnionToHole
{
    UIBezierPath *path1 = [UIBezierPath bezierPath];
    [path1 moveToPoint:CGPointMake(100, 20)];
    [path1 addLineToPoint:CGPointMake(50, 20)];
    [path1 addLineToPoint:CGPointMake(50, 80)];
    [path1 addLineToPoint:CGPointMake(100, 80)];
    [path1 addLineToPoint:CGPointMake(100, 100)];
    [path1 addLineToPoint:CGPointMake(0, 100)];
    [path1 addLineToPoint:CGPointMake(0, 0)];
    [path1 addLineToPoint:CGPointMake(100, 0)];
    [path1 addLineToPoint:CGPointMake(100, 20)];
    [path1 closePath];

    UIBezierPath *path2 = [UIBezierPath bezierPath];
    [path2 moveToPoint:CGPointMake(70, 10)];
    [path2 addLineToPoint:CGPointMake(80, 10)];
    [path2 addLineToPoint:CGPointMake(80, 90)];
    [path2 addLineToPoint:CGPointMake(70, 90)];
    [path2 addLineToPoint:CGPointMake(70, 10)];
    [path2 closePath];

    NSArray<UIBezierPath *> *finalShapes = [path1 unionWithPath:path2];

    XCTAssertEqual([finalShapes count], 1);

    UIBezierPath *unionPath = [UIBezierPath bezierPath];
    [unionPath moveToPoint:CGPointMake(70.000000, 80.000000)];
    [unionPath addLineToPoint:CGPointMake(70.000000, 20.000000)];
    [unionPath addLineToPoint:CGPointMake(50.000000, 20.000000)];
    [unionPath addLineToPoint:CGPointMake(50.000000, 80.000000)];
    [unionPath addLineToPoint:CGPointMake(70.000000, 80.000000)];
    [unionPath addLineToPoint:CGPointMake(100.000000, 80.000000)];
    [unionPath addLineToPoint:CGPointMake(100.000000, 100.000000)];
    [unionPath addLineToPoint:CGPointMake(0.000000, 100.000000)];
    [unionPath addLineToPoint:CGPointMake(0.000000, 0.000000)];
    [unionPath addLineToPoint:CGPointMake(100.000000, 0.000000)];
    [unionPath addLineToPoint:CGPointMake(100.000000, 20.000000)];
    [unionPath addLineToPoint:CGPointMake(100.000000, 20.000000)];
    [unionPath addLineToPoint:CGPointMake(80.000000, 20.000000)];
    [unionPath addLineToPoint:CGPointMake(80.000000, 80.000000)];

    XCTAssert([unionPath isEqualToBezierPath:[finalShapes firstObject] withAccuracy:0.00001]);
}

- (void)testUnionSimilarValidGlue
{
    UIBezierPath *path1 = [UIBezierPath bezierPath];
    [path1 moveToPoint:CGPointMake(543.554343, 292.316303)];
    [path1 addLineToPoint:CGPointMake(542.054343, 297.316303)];
    [path1 addCurveToPoint:CGPointMake(558.816303, 328.445657)
             controlPoint1:CGPointMake(538.086896, 310.541124)
             controlPoint2:CGPointMake(545.591482, 324.478211)];
    [path1 addCurveToPoint:CGPointMake(589.945657, 311.683697)
             controlPoint1:CGPointMake(572.041124, 332.413104)
             controlPoint2:CGPointMake(585.978211, 324.908518)];
    [path1 addLineToPoint:CGPointMake(591.445657, 306.683697)];
    [path1 addCurveToPoint:CGPointMake(574.683697, 275.554343)
             controlPoint1:CGPointMake(595.413104, 293.458876)
             controlPoint2:CGPointMake(587.908518, 279.521789)];
    [path1 addCurveToPoint:CGPointMake(543.554343, 292.316303)
             controlPoint1:CGPointMake(561.458876, 271.586896)
             controlPoint2:CGPointMake(547.521789, 279.091482)];
    [path1 closePath];

    UIBezierPath *path2 = [UIBezierPath bezierPath];
    [path2 moveToPoint:CGPointMake(541.114837, 302.106538)];
    [path2 addLineToPoint:CGPointMake(540.614837, 307.305110)];
    [path2 addLineToPoint:CGPointMake(538.221375, 332.190273)];
    [path2 addLineToPoint:CGPointMake(587.991701, 336.977196)];
    [path2 addLineToPoint:CGPointMake(590.385163, 312.092033)];
    [path2 addLineToPoint:CGPointMake(590.885163, 306.893462)];
    [path2 addLineToPoint:CGPointMake(593.278625, 282.008299)];
    [path2 addLineToPoint:CGPointMake(543.508299, 277.221375)];
    [path2 addLineToPoint:CGPointMake(541.114837, 302.106538)];
    [path2 closePath];

    NSArray<UIBezierPath *> *finalShapes = [path1 unionWithPath:path2];

    XCTAssertEqual([finalShapes count], 1);
}

- (void)testUnionInvalidGlue
{
    UIBezierPath *path1 = [UIBezierPath bezierPath];
    [path1 moveToPoint:CGPointMake(543.55434286947127, 292.31630286084135)];
    [path1 addLineToPoint:CGPointMake(542.05434286947127, 297.31630286084135)];
    [path1 addCurveToPoint:CGPointMake(558.81630286084135, 328.44565713052879)
            controlPoint1:CGPointMake(538.0868964921109, 310.54112411870938)
            controlPoint2:CGPointMake(545.59148160297332, 324.47821075316836)];
    [path1 addCurveToPoint:CGPointMake(589.94565713052873, 311.68369713915865)
            controlPoint1:CGPointMake(572.04112411870938, 332.41310350788922)
            controlPoint2:CGPointMake(585.97821075316836, 324.90851839702668)];
    [path1 addLineToPoint:CGPointMake(591.44565713052873, 306.68369713915865)];
    [path1 addCurveToPoint:CGPointMake(574.68369713915865, 275.55434286947121)
            controlPoint1:CGPointMake(595.4131035078891, 293.45887588129062)
            controlPoint2:CGPointMake(587.90851839702668, 279.52178924683164)];
    [path1 addCurveToPoint:CGPointMake(543.55434286947127, 292.31630286084135)
            controlPoint1:CGPointMake(561.45887588129062, 271.58689649211078)
            controlPoint2:CGPointMake(547.52178924683164, 279.09148160297332)];
    [path1 closePath];

    UIBezierPath *path2 = [UIBezierPath bezierPath];
    [path2 moveToPoint:CGPointMake(541.1148369272471, 302.10653831396985)];
    [path2 addLineToPoint:CGPointMake(540.6148369272471, 307.30510974254122)];
    [path2 addLineToPoint:CGPointMake(538.22137524121695, 332.19027281529412)];
    [path2 addLineToPoint:CGPointMake(587.99170138672275, 336.97719618735442)];
    [path2 addLineToPoint:CGPointMake(590.3851630727529, 312.09203311460152)];
    [path2 addLineToPoint:CGPointMake(590.8851630727529, 306.89346168603015)];
    [path2 addLineToPoint:CGPointMake(593.27862475878305, 282.00829861327725)];
    [path2 addLineToPoint:CGPointMake(543.50829861327725, 277.22137524121695)];
    [path2 addLineToPoint:CGPointMake(541.1148369272471, 302.10653831396985)];
    [path2 closePath];

    NSArray<UIBezierPath *> *finalShapes = [path1 unionWithPath:path2];

    XCTAssertEqual([finalShapes count], 1);
}

@end
