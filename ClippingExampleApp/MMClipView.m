//
//  MMClipView.m
//  ClippingBezier
//
//  Created by Adam Wulf on 5/23/15.
//
//

#import "MMClipView.h"
#import "UIBezierPath+SamplePaths.h"
#import <ClippingBezier/ClippingBezier.h>

@interface UIBezierPath (Private)

- (DKUIBezierPathClippingResult *)clipUnclosedPathToClosedPath:(UIBezierPath *)closedPath usingIntersectionPoints:(NSArray *)intersectionPoints andBeginsInside:(BOOL)beginsInside;

@end

@interface MMClipView ()

@property(nonatomic, readwrite) IBOutlet UISegmentedControl *displayTypeControl;

@end

@implementation MMClipView {
    UIBezierPath *shapePath1;
    UIBezierPath *shapePath2;
}

- (void)awakeFromNib
{
    [super awakeFromNib];

    shapePath1 = [UIBezierPath samplePath1];
    shapePath2 = [UIBezierPath samplePath2];
}

- (IBAction)changedPreviewType:(id)sender
{
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    if (_displayTypeControl.selectedSegmentIndex != 1 && _displayTypeControl.selectedSegmentIndex != 4 && _displayTypeControl.selectedSegmentIndex != 5) {
        [[UIColor purpleColor] setStroke];
        [[[UIColor purpleColor] colorWithAlphaComponent:.1] setFill];
        [shapePath1 setLineWidth:3];
        [shapePath1 fill];
        [shapePath1 stroke];

        [[UIColor greenColor] setStroke];
        [[[UIColor greenColor] colorWithAlphaComponent:.1] setFill];
        [shapePath2 setLineWidth:3];
        [shapePath2 fill];
        [shapePath2 stroke];
    }

    if (_displayTypeControl.selectedSegmentIndex == 0) {
        NSArray *intersections = [shapePath1 findIntersectionsWithClosedPath:shapePath2 andBeginsInside:nil];

        for (DKUIBezierPathIntersectionPoint *intersection in intersections) {
            [[UIColor redColor] setFill];
            CGPoint p = intersection.location1;

            NSLog(@"intersection at: %f %f", p.x, p.y);

            [[UIBezierPath bezierPathWithArcCenter:p radius:7 startAngle:0 endAngle:2 * M_PI clockwise:YES] fill];
        }
    } else if (_displayTypeControl.selectedSegmentIndex == 1) {
        NSArray<DKUIBezierPathShape *> *shapes = [shapePath1 uniqueShapesCreatedFromSlicingWithUnclosedPath:shapePath2];

        for (DKUIBezierPathShape *shape in shapes) {
            [[MMClipView randomColor] setFill];

            [[shape fullPath] fill];
        }
    } else if (_displayTypeControl.selectedSegmentIndex == 2) {
        NSArray<UIBezierPath *> *intersection = [shapePath1 intersectionWithPath:shapePath2];

        for (UIBezierPath *path in intersection) {
            [[MMClipView randomColor] setFill];
            [path fill];
        }
    } else if (_displayTypeControl.selectedSegmentIndex == 3) {
        NSArray<UIBezierPath *> *intersection = [shapePath1 differenceWithPath:shapePath2];

        for (UIBezierPath *path in intersection) {
            [[MMClipView randomColor] setFill];
            [path fill];
        }
    } else if (_displayTypeControl.selectedSegmentIndex == 4) {
        [[UIColor purpleColor] setStroke];
        [[[UIColor purpleColor] colorWithAlphaComponent:.5] setFill];
        [shapePath1 setLineWidth:3];
        [shapePath1 fill];
        [shapePath1 stroke];
    } else if (_displayTypeControl.selectedSegmentIndex == 5) {
        [[UIColor greenColor] setStroke];
        [[[UIColor greenColor] colorWithAlphaComponent:.5] setFill];
        [shapePath2 setLineWidth:3];
        [shapePath2 fill];
        [shapePath2 stroke];
    }
}

+ (UIColor *)randomColor
{
    static BOOL generated = NO;

    // ff the randomColor hasn't been generated yet,
    // reset the time to generate another sequence
    if (!generated) {
        generated = YES;
        srandom((int)time(NULL));
    }

    // generate a random number and divide it using the
    // maximum possible number random() can be generated
    CGFloat red = (CGFloat)random() / (CGFloat)RAND_MAX;
    CGFloat green = (CGFloat)random() / (CGFloat)RAND_MAX;
    CGFloat blue = (CGFloat)random() / (CGFloat)RAND_MAX;

    UIColor *color = [UIColor colorWithRed:red green:green blue:blue alpha:1.0f];
    return color;
}


@end
