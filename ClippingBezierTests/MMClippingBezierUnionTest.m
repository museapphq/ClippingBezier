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

- (void)testUnionToHole2
{
    UIBezierPath *path1 = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, 100, 100)];
    UIBezierPath *path2 = [UIBezierPath bezierPathWithRect:CGRectMake(25, 25, 50, 50)];

    NSArray<UIBezierPath *> *combined1 = [path1 unionWithPath:path2];
    NSArray<UIBezierPath *> *combined2 = [path1 unionWithPath:[path2 bezierPathByReversingPath]];
    NSArray<UIBezierPath *> *combined3 = [path2 unionWithPath:path1];

    XCTAssertEqual([combined1 count], 1);
    XCTAssertEqual([combined2 count], 1);
    XCTAssertEqual([combined3 count], 1);
    XCTAssert([path1 isEqualToBezierPath:[combined1 firstObject] withAccuracy:0.00001]);
    XCTAssert([path1 isEqualToBezierPath:[combined2 firstObject] withAccuracy:0.00001]);
    XCTAssert([path1 isEqualToBezierPath:[combined3 firstObject] withAccuracy:0.00001]);
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
    [unionPath moveToPoint:CGPointMake(80.00000000000001, 80)];
    [unionPath addLineToPoint:CGPointMake(100, 80)];
    [unionPath addLineToPoint:CGPointMake(100, 100)];
    [unionPath addLineToPoint:CGPointMake(0, 100)];
    [unionPath addLineToPoint:CGPointMake(0, 0)];
    [unionPath addLineToPoint:CGPointMake(100, 0)];
    [unionPath addLineToPoint:CGPointMake(100, 20)];
    [unionPath addLineToPoint:CGPointMake(100, 20)];
    [unionPath addLineToPoint:CGPointMake(80, 20)];
    [unionPath addLineToPoint:CGPointMake(80, 80)];
    [unionPath closePath];
    [unionPath moveToPoint:CGPointMake(70, 80)];
    [unionPath addLineToPoint:CGPointMake(70, 20)];
    [unionPath addLineToPoint:CGPointMake(50, 20)];
    [unionPath addLineToPoint:CGPointMake(50, 80)];
    [unionPath addLineToPoint:CGPointMake(70, 80)];
    [unionPath closePath];

    XCTAssert([unionPath isEqualToBezierPath:[finalShapes firstObject] withAccuracy:0.00001]);
}

- (void)testUnionPaths1
{
    UIBezierPath *path1 = [UIBezierPath bezierPath];
    [path1 moveToPoint:CGPointMake(301.378178, 494.217308)];
    [path1 addCurveToPoint:CGPointMake(291.404879, 501.361164) controlPoint1:CGPointMake(297.498984, 495.740229) controlPoint2:CGPointMake(294.072618, 498.20994)];
    [path1 addCurveToPoint:CGPointMake(285.562701, 515.730504) controlPoint1:CGPointMake(288.0951, 505.270788) controlPoint2:CGPointMake(285.953045, 510.229435)];
    [path1 addLineToPoint:CGPointMake(285.562701, 515.730504)];
    [path1 addLineToPoint:CGPointMake(285.492788, 516.715785)];
    [path1 addCurveToPoint:CGPointMake(289.992167, 532.884229) controlPoint1:CGPointMake(285.068291, 522.698162) controlPoint2:CGPointMake(286.785267, 528.338002)];
    [path1 addCurveToPoint:CGPointMake(308.66059, 543.42258) controlPoint1:CGPointMake(294.168117, 538.804221) controlPoint2:CGPointMake(300.870477, 542.869811)];
    [path1 addCurveToPoint:CGPointMake(324.829034, 538.9232019999999) controlPoint1:CGPointMake(314.642967, 543.847077) controlPoint2:CGPointMake(320.282807, 542.130101)];
    [path1 addCurveToPoint:CGPointMake(335.367386, 520.254778) controlPoint1:CGPointMake(330.749026, 534.747252) controlPoint2:CGPointMake(334.814616, 528.044891)];
    [path1 addLineToPoint:CGPointMake(335.437299, 519.269496)];
    [path1 addCurveToPoint:CGPointMake(312.269496, 492.562701) controlPoint1:CGPointMake(336.414565, 505.497006) controlPoint2:CGPointMake(326.041986, 493.539967)];
    [path1 addCurveToPoint:CGPointMake(301.378178, 494.217308) controlPoint1:CGPointMake(308.432032, 492.290403) controlPoint2:CGPointMake(304.735512, 492.899263)];
    [path1 closePath];

    UIBezierPath *path2 = [UIBezierPath bezierPath];
    [path2 moveToPoint:CGPointMake(332.461371, 533.261389)];
    [path2 addLineToPoint:CGPointMake(347.246111, 525.011606)];
    [path2 addLineToPoint:CGPointMake(369.077413, 512.829889)];
    [path2 addLineToPoint:CGPointMake(344.71398, 469.167284)];
    [path2 addLineToPoint:CGPointMake(322.882677, 481.349)];
    [path2 addLineToPoint:CGPointMake(308.097937, 489.598784)];
    [path2 addLineToPoint:CGPointMake(286.266634, 501.780501)];
    [path2 addLineToPoint:CGPointMake(310.630068, 545.4431059999999)];
    [path2 addLineToPoint:CGPointMake(332.461371, 533.261389)];
    [path2 closePath];

    NSArray<UIBezierPath *> *finalShapes = [path1 unionWithPath:path2];

    XCTAssertEqual([finalShapes count], 1);
    XCTAssertTrue(finalShapes[0].isClosed);
}

- (void)testUnionPaths2
{
    UIBezierPath *path1 = [UIBezierPath bezierPath];
    [path1 moveToPoint:CGPointMake(301.3781783143294, 494.2173077800095)];
    [path1 addCurveToPoint:CGPointMake(291.4048786452396, 501.3611643534879) controlPoint1:CGPointMake(297.4989840540441, 495.7402286767368) controlPoint2:CGPointMake(294.0726175254794, 498.2099400369437)];
    [path1 addCurveToPoint:CGPointMake(285.562700977999, 515.7305036063025) controlPoint1:CGPointMake(288.0951001606109, 505.2707877879222) controlPoint2:CGPointMake(285.9530448172198, 510.2294350114649)];
    [path1 addLineToPoint:CGPointMake(285.562700977999, 515.7305036063025)];
    [path1 addLineToPoint:CGPointMake(285.4927875580855, 516.7157849915839)];
    [path1 addCurveToPoint:CGPointMake(289.9921668684398, 532.8842294722783) controlPoint1:CGPointMake(285.0682911191082, 522.6981620511009) controlPoint2:CGPointMake(286.7852673935041, 528.3380024849246)];
    [path1 addCurveToPoint:CGPointMake(308.660590186389, 543.4225804072823) controlPoint1:CGPointMake(294.1681171128794, 538.8042209929039) controlPoint2:CGPointMake(300.8704772940846, 542.8698109731399)];
    [path1 addCurveToPoint:CGPointMake(324.8290337056694, 538.9232017751076) controlPoint1:CGPointMake(314.6429668241981, 543.8470768163363) controlPoint2:CGPointMake(320.2828068846058, 542.1301008139289)];
    [path1 addCurveToPoint:CGPointMake(335.3673856020876, 520.2547777789789) controlPoint1:CGPointMake(330.7490257475378, 534.7472515781362) controlPoint2:CGPointMake(334.8146161380217, 528.0448910929913)];
    [path1 addLineToPoint:CGPointMake(335.437299022001, 519.2694963936975)];
    [path1 addCurveToPoint:CGPointMake(312.2694963936975, 492.562700977999) controlPoint1:CGPointMake(336.4145648951207, 505.497006441876) controlPoint2:CGPointMake(326.041986345519, 493.5399668511187)];
    [path1 addCurveToPoint:CGPointMake(301.3781783143294, 494.2173077800095) controlPoint1:CGPointMake(308.4320317626604, 492.2904028506207) controlPoint2:CGPointMake(304.735511660335, 492.8992626482518)];
    [path1 closePath];

    UIBezierPath *path2 = [UIBezierPath bezierPath];
    [path2 moveToPoint:CGPointMake(332.461370621175, 533.2613891604791)];
    [path2 addLineToPoint:CGPointMake(347.2461108809152, 525.0116056106955)];
    [path2 addLineToPoint:CGPointMake(369.0774134613077, 512.8298886691741)];
    [path2 addLineToPoint:CGPointMake(344.7139795782651, 469.1672835083892)];
    [path2 addLineToPoint:CGPointMake(322.8826769978726, 481.3490004499105)];
    [path2 addLineToPoint:CGPointMake(308.0979367381324, 489.598783999694)];
    [path2 addLineToPoint:CGPointMake(286.2666341577399, 501.7805009412153)];
    [path2 addLineToPoint:CGPointMake(310.6300680407825, 545.4431061020005)];
    [path2 addLineToPoint:CGPointMake(332.461370621175, 533.2613891604791)];
    [path2 closePath];

    NSArray<UIBezierPath *> *finalShapes = [path1 unionWithPath:path2];

    XCTAssertEqual([finalShapes count], 1);
    XCTAssertTrue(finalShapes[0].isClosed);
}

- (void)testUnionPaths3Rounded
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
    XCTAssertTrue(finalShapes[0].isClosed);
}

- (void)testUnionPaths3
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
    XCTAssertTrue(finalShapes[0].isClosed);
}

- (void)testUnionPaths4
{
    UIBezierPath *path1 = [UIBezierPath bezierPath];
    [path1 moveToPoint:CGPointMake(586.5546859618685, 501.0049007443614)];
    [path1 addLineToPoint:CGPointMake(603.6917332760196, 498.9105365402114)];
    [path1 addLineToPoint:CGPointMake(600.6589812284618, 474.0951700303644)];
    [path1 addLineToPoint:CGPointMake(597.2776662249053, 446.4277017432444)];
    [path1 addLineToPoint:CGPointMake(598.6817287764064, 446.3777826175018)];
    [path1 addLineToPoint:CGPointMake(598.2557548774608, 434.4046929783055)];
    [path1 addLineToPoint:CGPointMake(598.255757752456, 434.4046973894274)];
    [path1 addLineToPoint:CGPointMake(600.0765864530991, 424.5704110987463)];
    [path1 addLineToPoint:CGPointMake(597.8914788349319, 424.1658360693491)];
    [path1 addLineToPoint:CGPointMake(597.845785036679, 422.8814384662383)];
    [path1 addLineToPoint:CGPointMake(598.4195530453338, 416.0176084236699)];
    [path1 addLineToPoint:CGPointMake(598.9005854980256, 415.9746631257495)];
    [path1 addLineToPoint:CGPointMake(598.6540658843851, 413.2122180647474)];
    [path1 addLineToPoint:CGPointMake(598.6540643192939, 413.2122202066951)];
    [path1 addLineToPoint:CGPointMake(599.8043308699894, 399.4519255598385)];
    [path1 addLineToPoint:CGPointMake(597.4082024416637, 399.2516256060214)];
    [path1 addLineToPoint:CGPointMake(596.7378154843714, 391.7391337328909)];
    [path1 addLineToPoint:CGPointMake(596.7378163445783, 391.7391349101218)];
    [path1 addLineToPoint:CGPointMake(595.8726960374154, 367.4227084530307)];
    [path1 addLineToPoint:CGPointMake(594.5719601426955, 367.4689855258055)];
    [path1 addLineToPoint:CGPointMake(591.7315838278868, 335.6403793918167)];
    [path1 addLineToPoint:CGPointMake(594.340144997684, 319.6927788984932)];
    [path1 addLineToPoint:CGPointMake(594.3401508858758, 319.6927659222111)];
    [path1 addLineToPoint:CGPointMake(594.8105322706595, 319.7604657759737)];
    [path1 addLineToPoint:CGPointMake(596.198510838496, 310.1167332639626)];
    [path1 addLineToPoint:CGPointMake(596.1984856617421, 310.1167349879589)];
    [path1 addLineToPoint:CGPointMake(596.6099435393584, 310.1689451693507)];
    [path1 addLineToPoint:CGPointMake(599.0729543075099, 290.758455563808)];
    [path1 addLineToPoint:CGPointMake(599.5399161687859, 287.9036558711749)];
    [path1 addLineToPoint:CGPointMake(599.5399170553948, 287.9036565639494)];
    [path1 addLineToPoint:CGPointMake(604.7594798171671, 287.3125082593189)];
    [path1 addLineToPoint:CGPointMake(602.4348079328421, 266.7867439025244)];
    [path1 addLineToPoint:CGPointMake(603.2623056028136, 261.037195002068)];
    [path1 addLineToPoint:CGPointMake(603.2369377416157, 261.0335439211602)];
    [path1 addLineToPoint:CGPointMake(608.0044915928995, 245.58415456029)];
    [path1 addLineToPoint:CGPointMake(604.9257197436657, 244.6340652475577)];
    [path1 addLineToPoint:CGPointMake(605.0530360784416, 243.6306408762261)];
    [path1 addLineToPoint:CGPointMake(599.7358391613545, 242.9559379949846)];
    [path1 addLineToPoint:CGPointMake(598.7720320688427, 234.4461478884606)];
    [path1 addLineToPoint:CGPointMake(579.123046312684, 236.6715190828699)];
    [path1 addLineToPoint:CGPointMake(579.1230465124466, 236.6715252227085)];
    [path1 addLineToPoint:CGPointMake(560.2276610537965, 230.8405300521222)];
    [path1 addLineToPoint:CGPointMake(558.1185556991254, 237.6751024507487)];
    [path1 addLineToPoint:CGPointMake(555.4507707463559, 237.3365743111688)];
    [path1 addLineToPoint:CGPointMake(555.1912323490045, 239.3819439170066)];
    [path1 addLineToPoint:CGPointMake(549.0896543819672, 240.0729895761789)];
    [path1 addLineToPoint:CGPointMake(551.0116322985548, 257.0431547340426)];
    [path1 addLineToPoint:CGPointMake(551.011636516994, 257.0431482456252)];
    [path1 addLineToPoint:CGPointMake(549.6201483204835, 265.2142588238856)];
    [path1 addLineToPoint:CGPointMake(548.0606438198089, 270.2678450297012)];
    [path1 addLineToPoint:CGPointMake(548.0606695021762, 270.2678459523191)];
    [path1 addLineToPoint:CGPointMake(546.6636356420688, 270.15395759191)];
    [path1 addLineToPoint:CGPointMake(546.149475906873, 276.460998601125)];
    [path1 addLineToPoint:CGPointMake(545.8454593673839, 277.4461671103816)];
    [path1 addLineToPoint:CGPointMake(543.5082986132772, 277.2213752412169)];
    [path1 addLineToPoint:CGPointMake(542.7849887483235, 284.7417312371214)];
    [path1 addLineToPoint:CGPointMake(542.7849731422747, 284.7417285498717)];
    [path1 addLineToPoint:CGPointMake(540.4524971109955, 284.746164750551)];
    [path1 addLineToPoint:CGPointMake(540.4822257978358, 300.3769836672548)];
    [path1 addLineToPoint:CGPointMake(540.482238083743, 300.376975957792)];
    [path1 addLineToPoint:CGPointMake(538.4025530301129, 300.5625663114799)];
    [path1 addLineToPoint:CGPointMake(539.7794026362358, 315.991242910503)];
    [path1 addLineToPoint:CGPointMake(538.2213752412169, 332.1902728152941)];
    [path1 addLineToPoint:CGPointMake(540.5431511220083, 332.413581844774)];
    [path1 addLineToPoint:CGPointMake(540.5490951094906, 335.5382079644401)];
    [path1 addLineToPoint:CGPointMake(540.5490725877183, 335.5382195806076)];
    [path1 addLineToPoint:CGPointMake(540.2847076854124, 335.5455774014496)];
    [path1 addLineToPoint:CGPointMake(540.400733400935, 339.7143561210604)];
    [path1 addLineToPoint:CGPointMake(538.304094602082, 352.532259934987)];
    [path1 addLineToPoint:CGPointMake(536.4839471107854, 352.3747340803717)];
    [path1 addLineToPoint:CGPointMake(534.4103242346051, 376.3370653418847)];
    [path1 addLineToPoint:CGPointMake(532.08269466801, 390.5671678860072)];
    [path1 addLineToPoint:CGPointMake(531.3767599924134, 390.5589736627654)];
    [path1 addLineToPoint:CGPointMake(531.3226810528386, 395.2135618744243)];
    [path1 addLineToPoint:CGPointMake(531.3226806383684, 395.213560010806)];
    [path1 addLineToPoint:CGPointMake(530.5277369387828, 400.0734968032313)];
    [path1 addLineToPoint:CGPointMake(531.2648311175388, 400.1940638802182)];
    [path1 addLineToPoint:CGPointMake(531.0971728827068, 414.6231079672491)];
    [path1 addLineToPoint:CGPointMake(531.0971735298806, 414.6231083914153)];
    [path1 addLineToPoint:CGPointMake(529.0223531279906, 438.5992779974396)];
    [path1 addLineToPoint:CGPointMake(530.8168344491056, 438.7545666243153)];
    [path1 addLineToPoint:CGPointMake(530.7986791012288, 440.3145443645926)];
    [path1 addLineToPoint:CGPointMake(529.3056863369346, 440.389267719632)];
    [path1 addLineToPoint:CGPointMake(530.5166544297606, 464.588531902876)];
    [path1 addLineToPoint:CGPointMake(530.5086629830465, 465.2763061057693)];
    [path1 addLineToPoint:CGPointMake(529.2599543707523, 465.40573629755)];
    [path1 addLineToPoint:CGPointMake(530.3814502442603, 476.2255574393188)];
    [path1 addLineToPoint:CGPointMake(530.3814500583437, 476.225555191424)];
    [path1 addLineToPoint:CGPointMake(530.3005015933313, 483.1928103551022)];
    [path1 addLineToPoint:CGPointMake(527.8635975051948, 483.8027439991368)];
    [path1 addLineToPoint:CGPointMake(532.3814630535373, 501.8537919533474)];
    [path1 addLineToPoint:CGPointMake(532.3814648151263, 501.8537905289799)];
    [path1 addLineToPoint:CGPointMake(532.6860631971596, 507.940702942514)];
    [path1 addLineToPoint:CGPointMake(528.3736515593538, 523.3324118485659)];
    [path1 addLineToPoint:CGPointMake(535.470280591173, 525.3207229272685)];
    [path1 addLineToPoint:CGPointMake(535.470263184915, 525.320741061855)];
    [path1 addLineToPoint:CGPointMake(535.8961042629181, 529.4291148933168)];
    [path1 addLineToPoint:CGPointMake(539.1974497501886, 529.0869239002784)];
    [path1 addLineToPoint:CGPointMake(541.0092375056303, 536.3259046593075)];
    [path1 addLineToPoint:CGPointMake(558.830206058348, 531.8656240115217)];
    [path1 addLineToPoint:CGPointMake(576.5196412857953, 536.8218029861007)];
    [path1 addLineToPoint:CGPointMake(578.2640696672908, 530.5956338374954)];
    [path1 addLineToPoint:CGPointMake(580.4229453721656, 530.9916302933049)];
    [path1 addLineToPoint:CGPointMake(581.2939078414248, 526.2433514901967)];
    [path1 addLineToPoint:CGPointMake(581.2938857256669, 526.2433529547152)];
    [path1 addLineToPoint:CGPointMake(589.5131340965369, 524.1862170398242)];
    [path1 addLineToPoint:CGPointMake(585.0528574893568, 506.3652646312719)];
    [path1 addLineToPoint:CGPointMake(586.5547026701971, 501.0049175803932)];
    [path1 closePath];

    UIBezierPath *path2 = [UIBezierPath bezierPath];
    [path2 moveToPoint:CGPointMake(551.1573612550987, 481.0761989090267)];
    [path2 addLineToPoint:CGPointMake(556.0032487009861, 511.3746837575115)];
    [path2 addLineToPoint:CGPointMake(559.9515255320906, 536.0609372210276)];
    [path2 addLineToPoint:CGPointMake(609.3240324591228, 528.1643835588185)];
    [path2 addLineToPoint:CGPointMake(605.3757556280183, 503.4781300953024)];
    [path2 addLineToPoint:CGPointMake(600.5298681821309, 473.1796452468175)];
    [path2 addLineToPoint:CGPointMake(596.5815913510264, 448.4933917833014)];
    [path2 addLineToPoint:CGPointMake(547.2090844239942, 456.3899454455105)];
    [path2 addLineToPoint:CGPointMake(551.1573612550987, 481.0761989090267)];
    [path2 closePath];

    NSArray<UIBezierPath *> *finalShapes = [path1 unionWithPath:path2];

    XCTAssertEqual([finalShapes count], 1);
    XCTAssertTrue(finalShapes[0].isClosed);
}

- (void)testUnionPaths5
{
    UIBezierPath *path1 = [UIBezierPath bezierPath];
    [path1 moveToPoint:CGPointMake(548.0606695021762, 270.2678459523191)];
    [path1 addLineToPoint:CGPointMake(546.6636356420688, 270.15395759191)];
    [path1 addLineToPoint:CGPointMake(546.149475906873, 276.460998601125)];
    [path1 addLineToPoint:CGPointMake(545.8454593673839, 277.4461671103816)];
    [path1 addLineToPoint:CGPointMake(543.5082986132772, 277.2213752412169)];
    [path1 addLineToPoint:CGPointMake(542.7849887483235, 284.7417312371214)];
    [path1 addLineToPoint:CGPointMake(542.7849731422747, 284.7417285498717)];
    [path1 addLineToPoint:CGPointMake(540.4524971109955, 284.746164750551)];
    [path1 addLineToPoint:CGPointMake(540.4822257978358, 300.3769836672548)];
    [path1 addLineToPoint:CGPointMake(540.482238083743, 300.376975957792)];
    [path1 addLineToPoint:CGPointMake(538.4025530301129, 300.5625663114799)];
    [path1 addLineToPoint:CGPointMake(539.7794026362358, 315.991242910503)];
    [path1 addLineToPoint:CGPointMake(538.2213752412169, 332.1902728152941)];
    [path1 addLineToPoint:CGPointMake(540.5431511220083, 332.413581844774)];
    [path1 addLineToPoint:CGPointMake(540.55524247373, 338.7697448622874)];
    [path1 addLineToPoint:CGPointMake(538.304094602082, 352.532259934987)];
    [path1 addLineToPoint:CGPointMake(536.4839471107854, 352.3747340803717)];
    [path1 addLineToPoint:CGPointMake(534.4103242346051, 376.3370653418847)];
    [path1 addLineToPoint:CGPointMake(532.08269466801, 390.5671678860072)];
    [path1 addLineToPoint:CGPointMake(531.3767599924134, 390.5589736627654)];
    [path1 addLineToPoint:CGPointMake(531.3226810528386, 395.2135618744243)];
    [path1 addLineToPoint:CGPointMake(531.3226806383684, 395.213560010806)];
    [path1 addLineToPoint:CGPointMake(530.5277369387828, 400.0734968032313)];
    [path1 addLineToPoint:CGPointMake(531.2648311175388, 400.1940638802182)];
    [path1 addLineToPoint:CGPointMake(531.0971728827068, 414.6231079672491)];
    [path1 addLineToPoint:CGPointMake(531.0971735298806, 414.6231083914153)];
    [path1 addLineToPoint:CGPointMake(529.0223531279906, 438.5992779974396)];
    [path1 addLineToPoint:CGPointMake(530.8168344491056, 438.7545666243153)];
    [path1 addLineToPoint:CGPointMake(530.7986791012288, 440.3145443645926)];
    [path1 addLineToPoint:CGPointMake(529.3056863369346, 440.389267719632)];
    [path1 addLineToPoint:CGPointMake(530.5166544297606, 464.588531902876)];
    [path1 addLineToPoint:CGPointMake(530.5086629830465, 465.2763061057693)];
    [path1 addLineToPoint:CGPointMake(529.2599543707523, 465.40573629755)];
    [path1 addLineToPoint:CGPointMake(530.3814502442603, 476.2255574393188)];
    [path1 addLineToPoint:CGPointMake(530.3814500583437, 476.225555191424)];
    [path1 addLineToPoint:CGPointMake(530.3005015933313, 483.1928103551022)];
    [path1 addLineToPoint:CGPointMake(527.8635975051948, 483.8027439991368)];
    [path1 addLineToPoint:CGPointMake(532.3814630535373, 501.8537919533474)];
    [path1 addLineToPoint:CGPointMake(532.3814648151263, 501.8537905289799)];
    [path1 addLineToPoint:CGPointMake(532.6860631971596, 507.940702942514)];
    [path1 addLineToPoint:CGPointMake(528.3736515593538, 523.3324118485659)];
    [path1 addLineToPoint:CGPointMake(535.470280591173, 525.3207229272685)];
    [path1 addLineToPoint:CGPointMake(535.470263184915, 525.320741061855)];
    [path1 addLineToPoint:CGPointMake(535.8961042629181, 529.4291148933168)];
    [path1 addLineToPoint:CGPointMake(539.1974497501886, 529.0869239002784)];
    [path1 addLineToPoint:CGPointMake(541.0092375056303, 536.3259046593075)];
    [path1 addLineToPoint:CGPointMake(558.830206058348, 531.8656240115217)];
    [path1 addLineToPoint:CGPointMake(576.5196412857953, 536.8218029861007)];
    [path1 addLineToPoint:CGPointMake(578.2640696672908, 530.5956338374954)];
    [path1 addLineToPoint:CGPointMake(580.4229453721656, 530.9916302933049)];
    [path1 addLineToPoint:CGPointMake(581.2939078414248, 526.2433514901967)];
    [path1 addLineToPoint:CGPointMake(581.2938857256669, 526.2433529547152)];
    [path1 addLineToPoint:CGPointMake(589.5131340965369, 524.1862170398242)];
    [path1 addLineToPoint:CGPointMake(585.0528574893568, 506.3652646312719)];
    [path1 addLineToPoint:CGPointMake(591.1613051506029, 484.5631509219969)];
    [path1 addLineToPoint:CGPointMake(589.0769704830165, 483.9791686266416)];
    [path1 addLineToPoint:CGPointMake(591.4062260347368, 471.3989823792022)];
    [path1 addLineToPoint:CGPointMake(593.7735073405944, 471.5968633375218)];
    [path1 addLineToPoint:CGPointMake(595.7521944070655, 447.9264218801845)];
    [path1 addLineToPoint:CGPointMake(596.0214079014386, 446.4724092508916)];
    [path1 addLineToPoint:CGPointMake(598.6817287764064, 446.3777826175018)];
    [path1 addLineToPoint:CGPointMake(598.2557548774608, 434.4046929783055)];
    [path1 addLineToPoint:CGPointMake(598.255757752456, 434.4046973894274)];
    [path1 addLineToPoint:CGPointMake(600.0765864530991, 424.5704110987463)];
    [path1 addLineToPoint:CGPointMake(597.8914788349319, 424.1658360693491)];
    [path1 addLineToPoint:CGPointMake(597.845785036679, 422.8814384662383)];
    [path1 addLineToPoint:CGPointMake(598.4195530453338, 416.0176084236699)];
    [path1 addLineToPoint:CGPointMake(598.9005854980256, 415.9746631257495)];
    [path1 addLineToPoint:CGPointMake(598.6540658843851, 413.2122180647474)];
    [path1 addLineToPoint:CGPointMake(598.6540643192939, 413.2122202066951)];
    [path1 addLineToPoint:CGPointMake(599.8043308699894, 399.4519255598385)];
    [path1 addLineToPoint:CGPointMake(597.4082024416637, 399.2516256060214)];
    [path1 addLineToPoint:CGPointMake(596.7378154843714, 391.7391337328909)];
    [path1 addLineToPoint:CGPointMake(596.7378163445783, 391.7391349101218)];
    [path1 addLineToPoint:CGPointMake(595.8726960374154, 367.4227084530307)];
    [path1 addLineToPoint:CGPointMake(594.5719601426955, 367.4689855258055)];
    [path1 addLineToPoint:CGPointMake(591.7315838278868, 335.6403793918167)];
    [path1 addLineToPoint:CGPointMake(594.340144997684, 319.6927788984932)];
    [path1 addLineToPoint:CGPointMake(594.3401508858758, 319.6927659222111)];
    [path1 addLineToPoint:CGPointMake(594.8105322706595, 319.7604657759737)];
    [path1 addLineToPoint:CGPointMake(596.198510838496, 310.1167332639626)];
    [path1 addLineToPoint:CGPointMake(596.1984856617421, 310.1167349879589)];
    [path1 addLineToPoint:CGPointMake(596.6099435393584, 310.1689451693507)];
    [path1 addLineToPoint:CGPointMake(599.0729543075099, 290.758455563808)];
    [path1 addLineToPoint:CGPointMake(599.5399161687859, 287.9036558711749)];
    [path1 addLineToPoint:CGPointMake(599.5399170553948, 287.9036565639494)];
    [path1 addLineToPoint:CGPointMake(604.7594798171671, 287.3125082593189)];
    [path1 addLineToPoint:CGPointMake(602.4348079328421, 266.7867439025244)];
    [path1 addLineToPoint:CGPointMake(603.2623056028136, 261.037195002068)];
    [path1 addLineToPoint:CGPointMake(603.2369377416157, 261.0335439211602)];
    [path1 addLineToPoint:CGPointMake(608.0044915928995, 245.58415456029)];
    [path1 addLineToPoint:CGPointMake(604.9257197436657, 244.6340652475577)];
    [path1 addLineToPoint:CGPointMake(605.0530360784416, 243.6306408762261)];
    [path1 addLineToPoint:CGPointMake(599.7358391613545, 242.9559379949846)];
    [path1 addLineToPoint:CGPointMake(598.7720320688427, 234.4461478884606)];
    [path1 addLineToPoint:CGPointMake(579.123046312684, 236.6715190828699)];
    [path1 addLineToPoint:CGPointMake(579.1230465124466, 236.6715252227085)];
    [path1 addLineToPoint:CGPointMake(560.2276610537965, 230.8405300521222)];
    [path1 addLineToPoint:CGPointMake(558.1185556991254, 237.6751024507487)];
    [path1 addLineToPoint:CGPointMake(555.4507707463559, 237.3365743111688)];
    [path1 addLineToPoint:CGPointMake(555.1912323490045, 239.3819439170066)];
    [path1 addLineToPoint:CGPointMake(549.0896543819672, 240.0729895761789)];
    [path1 addLineToPoint:CGPointMake(551.0116322985548, 257.0431547340426)];
    [path1 addLineToPoint:CGPointMake(551.011636516994, 257.0431482456252)];
    [path1 addLineToPoint:CGPointMake(549.6201483204835, 265.2142588238856)];
    [path1 addLineToPoint:CGPointMake(548.0606438198089, 270.2678450297012)];
    [path1 closePath];

    UIBezierPath *path2 = [UIBezierPath bezierPath];
    [path2 moveToPoint:CGPointMake(541.321122179749, 336.3647211534527)];
    [path2 addLineToPoint:CGPointMake(540.973394907022, 359.4640718028032)];
    [path2 addLineToPoint:CGPointMake(540.5970987444573, 384.4612396663441)];
    [path2 addLineToPoint:CGPointMake(590.5914344715391, 385.2138319914735)];
    [path2 addLineToPoint:CGPointMake(590.9677306341038, 360.2166641279326)];
    [path2 addLineToPoint:CGPointMake(591.3154579068307, 337.1173134785821)];
    [path2 addLineToPoint:CGPointMake(591.6917540693954, 312.1201456150413)];
    [path2 addLineToPoint:CGPointMake(541.6974183423137, 311.3675532899119)];
    [path2 addLineToPoint:CGPointMake(541.321122179749, 336.3647211534527)];
    [path2 closePath];

    NSArray<UIBezierPath *> *finalShapes = [path1 unionWithPath:path2];

    XCTAssertEqual([finalShapes count], 1);
    XCTAssertTrue(finalShapes[0].isClosed);
}

- (void)testUnionPaths6
{
    UIBezierPath *path1 = [UIBezierPath bezierPath];
    [path1 moveToPoint:CGPointMake(620.8655482851358, 335.9684147785148)];
    [path1 addLineToPoint:CGPointMake(622.9875061968842, 296.6951167729743)];
    [path1 addLineToPoint:CGPointMake(624.3363026235381, 271.7315283250078)];
    [path1 addLineToPoint:CGPointMake(574.4091257276052, 269.0339354716999)];
    [path1 addLineToPoint:CGPointMake(573.0603293009513, 293.9975239196664)];
    [path1 addLineToPoint:CGPointMake(572.1602689738288, 310.6558832840694)];
    [path1 addLineToPoint:CGPointMake(570.6088626418198, 310.6714746350677)];
    [path1 addLineToPoint:CGPointMake(570.6202306904594, 311.8029480841565)];
    [path1 addLineToPoint:CGPointMake(541.6974183423137, 311.3675532899119)];
    [path1 addLineToPoint:CGPointMake(541.3338926009072, 335.5163883955379)];
    [path1 addLineToPoint:CGPointMake(542.8796385873932, 335.4733551188858)];
    [path1 addLineToPoint:CGPointMake(541.3338620077711, 335.5163772713557)];
    [path1 addLineToPoint:CGPointMake(540.5490725877183, 335.5382195806076)];
    [path1 addLineToPoint:CGPointMake(540.2847076854124, 335.5455774014496)];
    [path1 addLineToPoint:CGPointMake(540.400733400935, 339.7143561210604)];
    [path1 addLineToPoint:CGPointMake(540.9653264397846, 360.0000611907789)];
    [path1 addLineToPoint:CGPointMake(540.9488110781331, 361.0971682635864)];
    [path1 addLineToPoint:CGPointMake(539.7621196643465, 361.1906105536563)];
    [path1 addLineToPoint:CGPointMake(540.7571511930203, 373.8290702513436)];
    [path1 addLineToPoint:CGPointMake(540.5970987444573, 384.4612396663441)];
    [path1 addLineToPoint:CGPointMake(541.5953977943913, 384.4762676128553)];
    [path1 addLineToPoint:CGPointMake(541.5954088784055, 384.4762564637616)];
    [path1 addLineToPoint:CGPointMake(541.6745141138086, 385.4810169167816)];
    [path1 addLineToPoint:CGPointMake(542.3523955832679, 409.8371537864492)];
    [path1 addLineToPoint:CGPointMake(543.5893552536579, 409.8027266459165)];
    [path1 addLineToPoint:CGPointMake(543.7675196162107, 412.0656736292227)];
    [path1 addLineToPoint:CGPointMake(543.7675163025195, 412.065667385881)];
    [path1 addLineToPoint:CGPointMake(542.7217948625087, 412.193467788793)];
    [path1 addLineToPoint:CGPointMake(545.6892690622128, 436.4747010447309)];
    [path1 addLineToPoint:CGPointMake(547.256607668511, 456.3823534867533)];
    [path1 addLineToPoint:CGPointMake(547.2090844239942, 456.3899454455105)];
    [path1 addLineToPoint:CGPointMake(547.3038580843761, 456.9825094175761)];
    [path1 addLineToPoint:CGPointMake(547.6092252722709, 460.861148733922)];
    [path1 addLineToPoint:CGPointMake(547.9202872018868, 460.836658690456)];
    [path1 addLineToPoint:CGPointMake(547.9202859278228, 460.8366702670407)];
    [path1 addLineToPoint:CGPointMake(551.0843385438143, 480.6196308322495)];
    [path1 addLineToPoint:CGPointMake(552.0013655807721, 488.1231661580025)];
    [path1 addLineToPoint:CGPointMake(550.9149313889463, 488.3613883024607)];
    [path1 addLineToPoint:CGPointMake(553.4350065814868, 499.8538798573999)];
    [path1 addLineToPoint:CGPointMake(553.5562383675456, 500.8458526592783)];
    [path1 addLineToPoint:CGPointMake(553.5562167332262, 500.8458661326099)];
    [path1 addLineToPoint:CGPointMake(551.4737863047027, 501.5162431495522)];
    [path1 addLineToPoint:CGPointMake(557.3419757943045, 519.7449354296439)];
    [path1 addLineToPoint:CGPointMake(557.6876419908559, 521.9061857788848)];
    [path1 addLineToPoint:CGPointMake(557.6876304032364, 521.9061989967712)];
    [path1 addLineToPoint:CGPointMake(551.7361215956352, 526.8497639642151)];
    [path1 addLineToPoint:CGPointMake(559.608991631909, 536.3278340756736)];
    [path1 addLineToPoint:CGPointMake(556.6849026489824, 541.2354474548087)];
    [path1 addLineToPoint:CGPointMake(563.3845007933223, 545.2272686133632)];
    [path1 addLineToPoint:CGPointMake(563.3980516029808, 545.2890668199545)];
    [path1 addLineToPoint:CGPointMake(562.8125648293126, 547.7397520982714)];
    [path1 addLineToPoint:CGPointMake(564.4086952067518, 548.1210778424395)];
    [path1 addLineToPoint:CGPointMake(564.6698715820489, 558.2419728406546)];
    [path1 addLineToPoint:CGPointMake(569.6932379205355, 558.1123285477497)];
    [path1 addLineToPoint:CGPointMake(570.8046630629718, 561.5648500589339)];
    [path1 addLineToPoint:CGPointMake(578.5111645923483, 559.083969336312)];
    [path1 addLineToPoint:CGPointMake(585.7596124490634, 567.8103069757932)];
    [path1 addLineToPoint:CGPointMake(592.245064125681, 562.4232273724448)];
    [path1 addLineToPoint:CGPointMake(592.2450412897059, 562.4232427178869)];
    [path1 addLineToPoint:CGPointMake(599.6383695327306, 566.8284090393294)];
    [path1 addLineToPoint:CGPointMake(605.005848754226, 557.8200009960352)];
    [path1 addLineToPoint:CGPointMake(605.00586109355, 557.8200001308174)];
    [path1 addLineToPoint:CGPointMake(611.4439728774923, 559.3581061663584)];
    [path1 addLineToPoint:CGPointMake(612.0024677196927, 557.0203920284805)];
    [path1 addLineToPoint:CGPointMake(616.5947866934684, 556.9018816647043)];
    [path1 addLineToPoint:CGPointMake(616.3889028562965, 548.9244388161709)];
    [path1 addLineToPoint:CGPointMake(617.6134317218899, 549.0197381941508)];
    [path1 addLineToPoint:CGPointMake(617.8148593397586, 546.431272777373)];
    [path1 addLineToPoint:CGPointMake(618.3992656433492, 546.2431724348635)];
    [path1 addLineToPoint:CGPointMake(617.9404139268344, 544.8178151321787)];
    [path1 addLineToPoint:CGPointMake(617.9404148839437, 544.8178089065933)];
    [path1 addLineToPoint:CGPointMake(618.2514088395587, 540.8213504891512)];
    [path1 addLineToPoint:CGPointMake(624.2215623870485, 535.862249022798)];
    [path1 addLineToPoint:CGPointMake(620.6505188961908, 531.5631052008537)];
    [path1 addLineToPoint:CGPointMake(627.2106601215804, 520.5529724586113)];
    [path1 addLineToPoint:CGPointMake(621.5242165383243, 517.1648191211241)];
    [path1 addLineToPoint:CGPointMake(624.7532360364884, 503.6489924904732)];
    [path1 addLineToPoint:CGPointMake(621.5496811169817, 502.8836427540537)];
    [path1 addLineToPoint:CGPointMake(621.5496552988566, 502.8836361371166)];
    [path1 addLineToPoint:CGPointMake(621.6149533764311, 497.5977786189702)];
    [path1 addLineToPoint:CGPointMake(623.4911667655792, 473.4873258538677)];
    [path1 addLineToPoint:CGPointMake(622.2462154236187, 473.3904469921498)];
    [path1 addLineToPoint:CGPointMake(622.2462430542701, 473.390441620871)];
    [path1 addLineToPoint:CGPointMake(622.0972223383477, 458.5582581236094)];
    [path1 addLineToPoint:CGPointMake(622.402573974387, 433.8401549064158)];
    [path1 addLineToPoint:CGPointMake(621.8488159037889, 433.8333141360531)];
    [path1 addLineToPoint:CGPointMake(620.8655476263901, 335.968414225503)];
    [path1 closePath];

    UIBezierPath *path2 = [UIBezierPath bezierPath];
    [path2 moveToPoint:CGPointMake(622.8006134346539, 298.6802895867939)];
    [path2 addLineToPoint:CGPointMake(626.3079727420134, 272.6150298465341)];
    [path2 addLineToPoint:CGPointMake(629.641941982487, 247.838334160798)];
    [path2 addLineToPoint:CGPointMake(580.0885506110146, 241.1703956798509)];
    [path2 addLineToPoint:CGPointMake(576.754581370541, 265.947091365587)];
    [path2 addLineToPoint:CGPointMake(573.2472220631815, 292.0123511058468)];
    [path2 addLineToPoint:CGPointMake(569.9132528227079, 316.7890467915829)];
    [path2 addLineToPoint:CGPointMake(619.4666441941803, 323.45698527253)];
    [path2 addLineToPoint:CGPointMake(622.8006134346539, 298.6802895867939)];
    [path2 closePath];

    NSArray<UIBezierPath *> *finalShapes = [path1 unionWithPath:path2];

    XCTAssertEqual([finalShapes count], 1);
    XCTAssertTrue(finalShapes[0].isClosed);
}

- (void)testUnionPaths7
{
    UIBezierPath *path1 = [UIBezierPath bezierPath];
    [path1 moveToPoint:CGPointMake(600.4383961256497, 407.3983834412122)];
    [path1 addLineToPoint:CGPointMake(599.6018663984008, 405.0719462890968)];
    [path1 addLineToPoint:CGPointMake(593.7861948066816, 407.1631191221845)];
    [path1 addLineToPoint:CGPointMake(592.7698518857133, 404.9390888035055)];
    [path1 addLineToPoint:CGPointMake(582.4851658523235, 409.6390629037863)];
    [path1 addLineToPoint:CGPointMake(582.1848615743246, 408.9405879264772)];
    [path1 addLineToPoint:CGPointMake(577.92455473932, 410.7722643242638)];
    [path1 addLineToPoint:CGPointMake(577.90825651048, 410.7398423978149)];
    [path1 addLineToPoint:CGPointMake(577.362363036066, 411.0139717008453)];
    [path1 addLineToPoint:CGPointMake(571.8371523434469, 413.3894822205745)];
    [path1 addLineToPoint:CGPointMake(571.8371401490955, 413.3895094802881)];
    [path1 addLineToPoint:CGPointMake(568.5874713256284, 409.0852787756284)];
    [path1 addLineToPoint:CGPointMake(556.505307402506, 418.2072413550235)];
    [path1 addLineToPoint:CGPointMake(556.5053111309837, 418.2072492318206)];
    [path1 addLineToPoint:CGPointMake(550.1740127599218, 419.7649406765397)];
    [path1 addLineToPoint:CGPointMake(550.2039211397246, 419.8865044669607)];
    [path1 addLineToPoint:CGPointMake(539.9154774678462, 421.8143488245427)];
    [path1 addLineToPoint:CGPointMake(540.8344656009308, 426.7187818396026)];
    [path1 addLineToPoint:CGPointMake(530.8573359733522, 431.0083452127848)];
    [path1 addLineToPoint:CGPointMake(531.0792271031848, 431.52444308804)];
    [path1 addLineToPoint:CGPointMake(526.927972248705, 433.123840927393)];
    [path1 addLineToPoint:CGPointMake(529.1408002562009, 438.8672820768995)];
    [path1 addLineToPoint:CGPointMake(524.2286198400815, 442.575950305231)];
    [path1 addLineToPoint:CGPointMake(537.1776704322293, 459.7271445292165)];
    [path1 addLineToPoint:CGPointMake(537.177669614459, 459.7271437692976)];
    [path1 addLineToPoint:CGPointMake(544.9039007418461, 479.7807374680918)];
    [path1 addLineToPoint:CGPointMake(550.6473418913527, 477.567909460596)];
    [path1 addLineToPoint:CGPointMake(554.3560101196841, 482.4800898767154)];
    [path1 addLineToPoint:CGPointMake(570.0302176039944, 470.6461555712947)];
    [path1 addLineToPoint:CGPointMake(570.0302144286278, 470.6461527167251)];
    [path1 addLineToPoint:CGPointMake(574.701898727402, 468.3001903251144)];
    [path1 addLineToPoint:CGPointMake(579.8563225744359, 466.3142988039456)];
    [path1 addLineToPoint:CGPointMake(582.6664929154342, 466.464409843924)];
    [path1 addCurveToPoint:CGPointMake(598.7973503134953, 461.651305825648) controlPoint1:CGPointMake(588.6747306683986, 466.7853478376288) controlPoint2:CGPointMake(594.3006072562862, 464.9573004528888)];
    [path1 addLineToPoint:CGPointMake(602.7484629618413, 460.9109624547542)];
    [path1 addLineToPoint:CGPointMake(602.3024776399483, 458.5308390797298)];
    [path1 addCurveToPoint:CGPointMake(602.4222767059863, 458.4013225750541) controlPoint1:CGPointMake(602.3425596337614, 458.4878098450634) controlPoint2:CGPointMake(602.3824929470718, 458.4446374150812)];
    [path1 addLineToPoint:CGPointMake(614.7843612635157, 455.3598762179916)];
    [path1 addLineToPoint:CGPointMake(614.1937218297007, 452.9591989221919)];
    [path1 addLineToPoint:CGPointMake(616.5201557616844, 452.1226793866821)];
    [path1 addLineToPoint:CGPointMake(608.5010354006486, 429.8210457118649)];
    [path1 addLineToPoint:CGPointMake(602.8390632297104, 406.8077407872656)];
    [path1 addLineToPoint:CGPointMake(600.4384147096662, 407.3983731413718)];
    [path1 closePath];

    UIBezierPath *path2 = [UIBezierPath bezierPath];
    [path2 moveToPoint:CGPointMake(566.3714093416369, 417.0628529001687)];
    [path2 addLineToPoint:CGPointMake(563.5668439119494, 417.8964405466531)];
    [path2 addLineToPoint:CGPointMake(539.6029634136805, 425.01911079486)];
    [path2 addLineToPoint:CGPointMake(553.8483039100943, 472.9468717913975)];
    [path2 addLineToPoint:CGPointMake(577.8121844083631, 465.8242015431907)];
    [path2 addLineToPoint:CGPointMake(580.6167498380506, 464.9906138967063)];
    [path2 addLineToPoint:CGPointMake(604.5806303363195, 457.8679436484994)];
    [path2 addLineToPoint:CGPointMake(590.3352898399057, 409.9401826519618)];
    [path2 addLineToPoint:CGPointMake(566.3714093416369, 417.0628529001687)];
    [path2 closePath];

    NSArray<UIBezierPath *> *finalShapes = [path1 unionWithPath:path2];

    XCTAssertEqual([finalShapes count], 1);
    XCTAssertTrue(finalShapes[0].isClosed);
}

@end
