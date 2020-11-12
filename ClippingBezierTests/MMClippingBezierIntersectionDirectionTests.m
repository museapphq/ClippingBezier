//
//  MMClippingBezierIntersectionDirectionTests.m
//  ClippingBezierTests
//
//  Created by Adam Wulf on 11/11/20.
//

#import <XCTest/XCTest.h>
#import "MMClippingBezierAbstractTest.h"

@interface MMClippingBezierIntersectionDirectionTests : MMClippingBezierAbstractTest

@end

@implementation MMClippingBezierIntersectionDirectionTests

- (CGFloat)angleBetween:(CGVector)v1 and:(CGVector)v2
{
    if ((v1.dx == 0 && v1.dy == 0) || (v2.dx == 0 && v2.dy == 0)) {
        XCTFail("must be non-zero vector");
    }
    // angle with +ve x-axis, in the range (−π, π]
    float thetaA = atan2(v2.dx, v2.dy);
    float thetaB = atan2(v1.dx, v1.dy);

    float thetaAB = thetaB - thetaA;

    // get in range (−π, π]
    while (thetaAB <= -M_PI)
        thetaAB += 2 * M_PI;

    while (thetaAB > M_PI)
        thetaAB -= 2 * M_PI;

    return thetaAB;
}

/// Vector v is pointing to the right of x
- (void)testIntersectionDirection1
{
    CGVector v = CGVectorMake(2, 1);
    CGVector x = CGVectorMake(1, 1);
    CGFloat dp = v.dx * x.dx + v.dy * x.dy;
    CGFloat vv = v.dx * v.dx + v.dy * v.dy;
    CGFloat c = dp / vv;
    CGVector n = CGVectorMake(x.dx - c * v.dx, x.dy - c * v.dy);
    CGFloat theta = [self angleBetween:x and:n];

    XCTAssertGreaterThan(theta, 0);
}

/// Vector v is pointing to the left of x
- (void)testIntersectionDirection2
{
    CGVector v = CGVectorMake(1, 2);
    CGVector x = CGVectorMake(1, 1);
    CGFloat dp = v.dx * x.dx + v.dy * x.dy;
    CGFloat vv = v.dx * v.dx + v.dy * v.dy;
    CGFloat c = dp / vv;
    CGVector n = CGVectorMake(x.dx - c * v.dx, x.dy - c * v.dy);
    CGFloat theta = [self angleBetween:x and:n];

    XCTAssertLessThan(theta, 0);
}

/// Vector v and x are pointing in the same direction
- (void)testIntersectionDirection3
{
    CGVector v = CGVectorMake(1, 1);
    CGVector x = CGVectorMake(1, 1);
    CGFloat dp = v.dx * x.dx + v.dy * x.dy;
    CGFloat vv = v.dx * v.dx + v.dy * v.dy;
    CGFloat c = dp / vv;
    CGVector n = CGVectorMake(x.dx - c * v.dx, x.dy - c * v.dy);

    XCTAssertEqual(n.dx, 0);
    XCTAssertEqual(n.dy, 0);

    CGFloat theta = [self angleBetween:x and:v];

    XCTAssertEqual(theta, 0);
}

/// Vector v and x are pointing in opposite directions
- (void)testIntersectionDirection4
{
    CGVector v = CGVectorMake(-1, -1);
    CGVector x = CGVectorMake(1, 1);
    CGFloat dp = v.dx * x.dx + v.dy * x.dy;
    CGFloat vv = v.dx * v.dx + v.dy * v.dy;
    CGFloat c = dp / vv;
    CGVector n = CGVectorMake(x.dx - c * v.dx, x.dy - c * v.dy);

    XCTAssertEqual(n.dx, 0);
    XCTAssertEqual(n.dy, 0);

    CGFloat theta = [self angleBetween:x and:v];

    XCTAssertEqualWithAccuracy(theta, -M_PI, 0.000001);
}

@end
