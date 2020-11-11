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

- (void)testUnionInvalidGlue2
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
}

@end
