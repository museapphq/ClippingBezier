//
//  DKUIBezierPathIntersectionPoint.m
//  ClippingBezier
//
//  Created by Adam Wulf on 9/11/13.
//  Copyright (c) 2013 Milestone Made LLC. All rights reserved.
//

#import "DKUIBezierPathIntersectionPoint.h"
#import "DKVector.h"
#import "DKUIBezierPathIntersectionPoint+Private.h"
#import <PerformanceBezier/PerformanceBezier.h>

@implementation DKUIBezierPathIntersectionPoint {
    DKUIBezierPathIntersectionPoint *_flipped;

    NSInteger elementIndex1;
    CGFloat tValue1;
    CGFloat tValue1Rounded;
    NSInteger elementIndex2;
    CGFloat tValue2;
    CGFloat tValue2Rounded;
    CGPoint bez1[4];
    CGPoint bez2[4];
    BOOL mayCrossBoundary;
    NSInteger elementCount1;
    NSInteger elementCount2;
    CGFloat lenAtInter1;
    CGFloat lenAtInter2;
}

@synthesize elementIndex1;
@synthesize elementCount1;
@synthesize tValue1;
@synthesize elementIndex2;
@synthesize elementCount2;
@synthesize tValue2;
@synthesize mayCrossBoundary;
@synthesize lenAtInter1;
@synthesize lenAtInter2;

+ (id)intersectionAtElementIndex:(NSInteger)index1
                       andTValue:(CGFloat)_tValue1
                withElementIndex:(NSInteger)index2
                       andTValue:(CGFloat)_tValue2
                andElementCount1:(NSInteger)_elementCount1
                andElementCount2:(NSInteger)_elementCount2
          andLengthUntilPath1Loc:(CGFloat)_lenAtInter1
          andLengthUntilPath2Loc:(CGFloat)_lenAtInter2
                  andPathLength1:(CGFloat)pathlen1
                  andPathLength2:(CGFloat)pathlen2
                  andClosedPath1:(BOOL)closed1
                  andClosedPath2:(BOOL)closed2
{
    return [[DKUIBezierPathIntersectionPoint alloc] initWithElementIndex:index1
                                                               andTValue:_tValue1
                                                        withElementIndex:index2
                                                               andTValue:_tValue2
                                                        andElementCount1:_elementCount1
                                                        andElementCount2:_elementCount2
                                                  andLengthUntilPath1Loc:_lenAtInter1
                                                  andLengthUntilPath2Loc:_lenAtInter2
                                                          andPathLength1:pathlen1
                                                          andPathLength2:pathlen2
                                                          andClosedPath1:closed1
                                                          andClosedPath2:closed2];
}

- (id)initWithElementIndex:(NSInteger)index1
                 andTValue:(CGFloat)_tValue1
          withElementIndex:(NSInteger)index2
                 andTValue:(CGFloat)_tValue2
          andElementCount1:(NSInteger)_elementCount1
          andElementCount2:(NSInteger)_elementCount2
    andLengthUntilPath1Loc:(CGFloat)_lenAtInter1
    andLengthUntilPath2Loc:(CGFloat)_lenAtInter2
            andPathLength1:(CGFloat)pathlen1
            andPathLength2:(CGFloat)pathlen2
            andClosedPath1:(BOOL)closed1
            andClosedPath2:(BOOL)closed2
{
    if (self = [super init]) {
        _flipped = nil;
        elementIndex1 = index1;
        tValue1 = _tValue1;
        tValue1Rounded = [self roundedTValue:_tValue1];
        elementIndex2 = index2;
        tValue2 = _tValue2;
        tValue2Rounded = [self roundedTValue:_tValue2];
        bez1[0] = CGPointZero;
        bez1[1] = bez1[0];
        bez1[2] = bez1[0];
        bez1[3] = bez1[0];
        bez2[0] = bez1[0];
        bez2[1] = bez1[0];
        bez2[2] = bez1[0];
        bez2[3] = bez1[0];
        elementCount1 = _elementCount1;
        elementCount2 = _elementCount2;
        lenAtInter1 = _lenAtInter1;
        lenAtInter2 = _lenAtInter2;
        _pathClosed1 = closed1;
        _pathClosed2 = closed2;
        _pathLength1 = pathlen1;
        _pathLength2 = pathlen2;
        _matchedIntersections = [[NSMutableSet alloc] init];
    }
    return self;
}

- (CGPoint *)bez1
{
    return bez1;
}

- (CGPoint *)bez2
{
    return bez2;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"[Intersection (%d %f) (%d %f) b:%d d:%d]", (int)elementIndex1, tValue1, (int)elementIndex2, tValue2, mayCrossBoundary, _direction];
}

- (void)setMayCrossBoundary:(BOOL)_mayCrossBoundary
{
    mayCrossBoundary = _mayCrossBoundary;
}

- (void)setDirection:(DKIntersectionDirection)direction
{
    _direction = direction;
}

- (DKUIBezierPathIntersectionPoint *)flipped
{
    if (!_flipped) {
        DKUIBezierPathIntersectionPoint *ret = [DKUIBezierPathIntersectionPoint intersectionAtElementIndex:self.elementIndex2
                                                                                                 andTValue:self.tValue2
                                                                                          withElementIndex:self.elementIndex1
                                                                                                 andTValue:self.tValue1
                                                                                          andElementCount1:elementCount2
                                                                                          andElementCount2:elementCount1
                                                                                    andLengthUntilPath1Loc:lenAtInter2
                                                                                    andLengthUntilPath2Loc:lenAtInter1
                                                                                            andPathLength1:self.pathLength2
                                                                                            andPathLength2:self.pathLength1
                                                                                            andClosedPath1:self.pathClosed2
                                                                                            andClosedPath2:self.pathClosed1];
        ret.bez1[0] = self.bez2[0];
        ret.bez1[1] = self.bez2[1];
        ret.bez1[2] = self.bez2[2];
        ret.bez1[3] = self.bez2[3];
        ret.bez2[0] = self.bez1[0];
        ret.bez2[1] = self.bez1[1];
        ret.bez2[2] = self.bez1[2];
        ret.bez2[3] = self.bez1[3];
        ret.mayCrossBoundary = self.mayCrossBoundary;
        ret.direction = self.direction;

        _flipped = ret;
    }

    return _flipped;
}

/**
 * returns YES if the two intersections are close.
 * this is the case if the two locations are within
 * precision distance, and if both the length along
 * each path is within the precision.
 */
- (BOOL)isCloseToIntersection:(DKUIBezierPathIntersectionPoint *)other withPrecision:(CGFloat)precision
{
    CGFloat myDistFromEnd1 = [self pathClosed1] ? MIN(self.lenAtInter1, ABS(self.pathLength1 - self.lenAtInter1)) : self.lenAtInter1;
    CGFloat otherDistFromEnd1 = [other pathClosed1] ? MIN(other.lenAtInter1, ABS(other.pathLength1 - other.lenAtInter1)) : other.lenAtInter1;
    CGFloat myDistFromEnd2 = [self pathClosed2] ? MIN(self.lenAtInter2, ABS(self.pathLength2 - self.lenAtInter2)) : self.lenAtInter2;
    CGFloat otherDistFromEnd2 = [other pathClosed2] ? MIN(other.lenAtInter2, ABS(other.pathLength2 - other.lenAtInter2)) : other.lenAtInter2;

    // account for the closed path. when these are true, it means we've found
    // the shortest length by looping backward around the path
    if (myDistFromEnd1 < lenAtInter1) {
        myDistFromEnd1 = -myDistFromEnd1;
    }
    if (otherDistFromEnd1 < other.lenAtInter1) {
        otherDistFromEnd1 = -otherDistFromEnd1;
    }
    if (myDistFromEnd2 < lenAtInter2) {
        myDistFromEnd2 = -myDistFromEnd2;
    }
    if (otherDistFromEnd2 < other.lenAtInter2) {
        otherDistFromEnd2 = -otherDistFromEnd2;
    }

    CGFloat compare1 = ABS(myDistFromEnd1 - otherDistFromEnd1);
    CGFloat compare2 = ABS(myDistFromEnd2 - otherDistFromEnd2);

    return compare1 < precision && compare2 < precision;
}


// this method checks if two intersections share
// the same element endpoint - ie, if one marks
// element 4, tvalue 0, and the other element 3
// tvalue 1
- (BOOL)matchesElementEndpointWithIntersection:(DKUIBezierPathIntersectionPoint *)obj
{
    BOOL ret = NO;
    if (self.elementIndex1 == elementCount1 - 1 && [obj elementIndex1] == 1 &&
        self.tValue1 == 1 && [obj tValue1] == 0) {
        ret = YES;
    }
    if (self.elementIndex2 == elementCount2 - 1 && [obj elementIndex2] == 1 &&
        self.tValue2 == 1 && [obj tValue2] == 0) {
        ret = YES;
    }
    if (obj.elementIndex1 == elementCount1 - 1 && [self elementIndex1] == 1 &&
        obj.tValue1 == 1 && [self tValue1] == 0) {
        ret = YES;
    }
    if (obj.elementIndex2 == elementCount2 - 1 && [self elementIndex2] == 1 &&
        obj.tValue2 == 1 && [self tValue2] == 0) {
        ret = YES;
    }
    if (self.elementIndex1 == [obj elementIndex1] - 1 &&
        self.tValue1 == 1 && [obj tValue1] == 0) {
        ret = YES;
    }
    if (self.elementIndex2 == [obj elementIndex2] - 1 &&
        self.tValue2 == 1 && [obj tValue2] == 0) {
        ret = YES;
    }
    if (self.elementIndex1 == [obj elementIndex1] + 1 &&
        self.tValue1 == 0 && [obj tValue1] == 1) {
        ret = YES;
    }
    if (self.elementIndex2 == [obj elementIndex2] + 1 &&
        self.tValue2 == 0 && [obj tValue2] == 1) {
        ret = YES;
    }
    if (self.elementIndex1 == [obj elementIndex1] &&
        self.tValue1 == [obj tValue1]) {
        ret = YES;
    }
    if (self.elementIndex2 == [obj elementIndex2] &&
        self.tValue2 == [obj tValue2]) {
        ret = YES;
    }

    return ret;
}

- (CGPoint)location1
{
    return [UIBezierPath pointAtT:self.tValue1 forBezier:self.bez1];
}
- (CGPoint)location2
{
    return [UIBezierPath pointAtT:self.tValue2 forBezier:self.bez2];
}

- (BOOL)crossMatchesIntersection:(DKUIBezierPathIntersectionPoint *)otherInter
{
    BOOL ret = NO;
    if (self.elementIndex1 == elementCount1 - 1 && [otherInter elementIndex2] == 1 &&
        self.tValue1 == 1 && [otherInter tValue2] == 0) {
        ret = YES;
    }
    if (self.elementIndex2 == elementCount2 - 1 && [otherInter elementIndex1] == 1 &&
        self.tValue2 == 1 && [otherInter tValue1] == 0) {
        ret = YES;
    }
    if (otherInter.elementIndex1 == elementCount1 - 1 && [self elementIndex2] == 1 &&
        otherInter.tValue1 == 1 && [self tValue2] == 0) {
        ret = YES;
    }
    if (otherInter.elementIndex2 == elementCount2 - 1 && [self elementIndex1] == 1 &&
        otherInter.tValue2 == 1 && [self tValue1] == 0) {
        ret = YES;
    }
    if (self.elementIndex1 == [otherInter elementIndex2] - 1 &&
        self.tValue1 == 1 && [otherInter tValue2] == 0) {
        ret = YES;
    }
    if (self.elementIndex2 == [otherInter elementIndex1] - 1 &&
        self.tValue2 == 1 && [otherInter tValue1] == 0) {
        ret = YES;
    }
    if (self.elementIndex1 == [otherInter elementIndex2] + 1 &&
        self.tValue1 == 0 && [otherInter tValue2] == 1) {
        ret = YES;
    }
    if (self.elementIndex2 == [otherInter elementIndex1] + 1 &&
        self.tValue2 == 0 && [otherInter tValue1] == 1) {
        ret = YES;
    }
    if (self.elementIndex1 == [otherInter elementIndex2] &&
        self.tValue1 == [otherInter tValue2]) {
        ret = YES;
    }
    if (self.elementIndex2 == [otherInter elementIndex1] &&
        self.tValue2 == [otherInter tValue1]) {
        ret = YES;
    }
    return ret;
}

- (BOOL)isEqualToIntersection:(id)object
{
    if ([object isKindOfClass:[DKUIBezierPathIntersectionPoint class]]) {
        DKUIBezierPathIntersectionPoint *other = (DKUIBezierPathIntersectionPoint *)object;
        if (self.elementIndex1 == other.elementIndex1 &&
            self.elementIndex2 == other.elementIndex2 &&
            tValue1Rounded == other->tValue1Rounded &&
            tValue2Rounded == other->tValue2Rounded) {
            return YES;
        } else if ([_matchedIntersections containsObject:other]) {
            return YES;
        } else if ([[other matchedIntersections] containsObject:self]) {
            return YES;
        }
    }
    return NO;
}

- (BOOL)isEqual:(id)object
{
    if ([object isKindOfClass:[DKUIBezierPathIntersectionPoint class]]) {
        return [self isEqualToIntersection:object];
    }
    return [super isEqual:object];
}

- (NSUInteger)hash
{
    NSUInteger prime = 31;
    NSUInteger result = 1;
    result = prime * result + self.elementIndex1;
    result = prime * result + self.elementCount1;
    result = prime * result + self.tValue1;
    result = prime * result + self.elementIndex2;
    result = prime * result + self.elementCount2;
    result = prime * result + self.tValue2;
    result = prime * result + ((self.mayCrossBoundary) ? 1231 : 1237);
    if (self.direction == kDKIntersectionDirectionLeft) {
        result = prime * result + 1231;
    } else if (self.direction == kDKIntersectionDirectionRight) {
        result = prime * result + 1237;
    } else {
        result = prime * result + 1327;
    }
    return result;
}

- (CGFloat)roundedTValue:(CGFloat)tVal
{
    return (CGFloat)round(tVal * pow(10, 6)) / pow(10, 6);
}


@end
