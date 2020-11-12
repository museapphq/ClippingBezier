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
    NSInteger elementIndex1;
    CGFloat tValue1;
    NSInteger elementIndex2;
    CGFloat tValue2;
    CGPoint *bez1;
    CGPoint *bez2;
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
@synthesize bez1;
@synthesize bez2;
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
        elementIndex1 = index1;
        tValue1 = _tValue1;
        elementIndex2 = index2;
        tValue2 = _tValue2;
        bez1 = (CGPoint *)malloc(sizeof(CGPoint) * 4);
        bez2 = (CGPoint *)malloc(sizeof(CGPoint) * 4);
        if (!bez1 || !bez2) {
            @throw [NSException exceptionWithName:@"Memory Exception" reason:@"can't malloc" userInfo:nil];
        }
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

- (NSString *)description
{
    return [NSString stringWithFormat:@"[Intersection (%d %f) (%d %f) %d]", (int)elementIndex1, tValue1, (int)elementIndex2, tValue2, mayCrossBoundary];
}

- (void)dealloc
{
    free(bez1);
    free(bez2);
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

    NSMutableArray<DKUIBezierPathIntersectionPoint *> *flippedPoints = [NSMutableArray array];
    for (DKUIBezierPathIntersectionPoint *p in self.matchedIntersections) {
        [flippedPoints addObject:[p flipped]];
    }
    [ret.matchedIntersections addObjectsFromArray:flippedPoints];
    return ret;
}

/**
 * returns YES if the two intersections are close.
 * this is the case if the two locations are within
 * precision distance, and if both the length along
 * each path is within the precision.
 */
- (BOOL)isCloseToIntersection:(DKUIBezierPathIntersectionPoint *)otherIntersection withPrecision:(CGFloat)precision
{
    CGFloat dist1 = ABS(self.lenAtInter1 - otherIntersection.lenAtInter1);
    CGFloat dist2 = ABS(self.lenAtInter2 - otherIntersection.lenAtInter2);

    // next, check if we're close to the beginning
    // or end
    CGFloat distFromEnd1 = self.pathLength1 - self.lenAtInter1;
    if (distFromEnd1 < precision) {
        CGFloat dist1other = ABS(distFromEnd1 - otherIntersection.lenAtInter1);
        dist1 = MIN(dist1, dist1other);
    }
    CGFloat distFromEnd2 = self.pathLength2 - self.lenAtInter2;
    if (distFromEnd2 < precision) {
        CGFloat dist2other = ABS(distFromEnd2 - otherIntersection.lenAtInter2);
        dist2 = MIN(dist2, dist2other);
    }

    distFromEnd1 = otherIntersection.pathLength1 - otherIntersection.lenAtInter1;
    if (distFromEnd1 < precision) {
        CGFloat dist1other = ABS(distFromEnd1 - self.lenAtInter1);
        dist1 = MIN(dist1, dist1other);
    }

    distFromEnd2 = otherIntersection.pathLength2 - otherIntersection.lenAtInter2;
    if (distFromEnd2 < precision) {
        CGFloat dist2other = ABS(distFromEnd2 - self.lenAtInter2);
        dist2 = MIN(dist2, dist2other);
    }

    if (MAX(dist1, dist2) < precision) {
        return YES;
    }

    return NO;
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
            [self roundedTValue:self.tValue1] == [self roundedTValue:other.tValue1] &&
            self.elementIndex2 == other.elementIndex2 &&
            [self roundedTValue:self.tValue2] == [self roundedTValue:other.tValue2]) {
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
