/* cocos2d for iPhone
 * http://www.cocos2d-iphone.org
 *
 * Copyright (c) 2007 Scott Lembcke
 * Copyright (c) 2010 Lam Pham
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

#include "stdio.h"
#include "math.h"

#import "../ccMacros.h"		// CC_SWAP
#include "CGPointExtension.h"

#define kCGPointEpsilon FLT_EPSILON

CGFloat
ccpLength(const CGPoint v)
{
	return sqrtf(ccpLengthSQ(v));
}

CGFloat
ccpDistance(const CGPoint v1, const CGPoint v2)
{
	return ccpLength(ccpSub(v1, v2));
}

CGPoint
ccpNormalize(const CGPoint v)
{
	return ccpMult(v, 1.0f/ccpLength(v));
}

CGPoint
ccpForAngle(const CGFloat a)
{
	return ccp(cosf(a), sinf(a));
}

CGFloat
ccpToAngle(const CGPoint v)
{
	return atan2f(v.y, v.x);
}

CGPoint ccpLerp(CGPoint a, CGPoint b, float alpha)
{
	return ccpAdd(ccpMult(a, 1.f - alpha), ccpMult(b, alpha));
}

float clampf(float value, float min_inclusive, float max_inclusive)
{
	if (min_inclusive > max_inclusive) {
		CC_SWAP(min_inclusive,max_inclusive);
	}
	return value < min_inclusive ? min_inclusive : value < max_inclusive? value : max_inclusive;
}

CGPoint ccpClamp(CGPoint p, CGPoint min_inclusive, CGPoint max_inclusive)
{
	return ccp(clampf(p.x,min_inclusive.x,max_inclusive.x), clampf(p.y, min_inclusive.y, max_inclusive.y));
}

CGPoint ccpFromSize(CGSize s)
{
	return ccp(s.width, s.height);
}

CGPoint ccpCompOp(CGPoint p, float (*opFunc)(float))
{
	return ccp(opFunc(p.x), opFunc(p.y));
}

BOOL ccpFuzzyEqual(CGPoint a, CGPoint b, float var)
{
	if(a.x - var <= b.x && b.x <= a.x + var)
		if(a.y - var <= b.y && b.y <= a.y + var)
			return true;
	return false;
}

CGPoint ccpCompMult(CGPoint a, CGPoint b)
{
	return ccp(a.x * b.x, a.y * b.y);
}

float ccpAngleSigned(CGPoint a, CGPoint b)
{
	CGPoint a2 = ccpNormalize(a);
	CGPoint b2 = ccpNormalize(b);
	float angle = atan2f(a2.x * b2.y - a2.y * b2.x, ccpDot(a2, b2));
	if( fabs(angle) < kCGPointEpsilon ) return 0.f;
	return angle;
}

CGPoint ccpRotateByAngle(CGPoint v, CGPoint pivot, float angle)
{
    CGPoint r = ccpSub(v, pivot);
	float cosa = cosf(angle), sina = sinf(angle);
	float t = r.x;
    r.x = t*cosa - r.y*sina + pivot.x;
	r.y = t*sina + r.y*cosa + pivot.y;
	return r;
}

BOOL ccpLineIntersect(CGPoint A, CGPoint B,
					  CGPoint C, CGPoint D,
					  float *S, float *T)
{    
    // FAIL: Line undefined
    if ( (A.x==B.x && A.y==B.y) || (C.x==D.x && C.y==D.y) ) return NO;
    
    //  Translate system to make A the origin
    B.x-=A.x; B.y-=A.y;
    C.x-=A.x; C.y-=A.y;
    D.x-=A.x; D.y-=A.y;
    
    // Cache
    CGPoint C2 = C, D2 = D;
    
    // Length of segment AB
    float distAB = sqrtf(B.x*B.x+B.y*B.y);
    
    // Rotate the system so that point B is on the positive X axis.
    float theCos = B.x/distAB;
    float theSin = B.y/distAB;
    float newX = C.x*theCos+C.y*theSin;
    C.y  = C.y*theCos-C.x*theSin; C.x = newX;
    newX = D.x*theCos+D.y*theSin;
    D.y  = D.y*theCos-D.x*theSin; D.x = newX;
    
    // FAIL: Lines are parallel.
    if (C.y == D.y) return NO;
    
    // Discover position of the intersection in the line AB
    float ABpos = D.x+(C.x-D.x)*D.y/(D.y-C.y);
    
    // Vector CD
    C.x = D2.x-C2.x;
    C.y = D2.y-C2.y;
    
    // Vector between intersection and point C
    A.x = ABpos*theCos-C2.x;
    A.y = ABpos*theSin-C2.y;
    
    newX = sqrtf((A.x*A.x+A.y*A.y)/(C.x*C.x+C.y*C.y));
    if(((A.y<0) != (C.y<0)) || ((A.x<0) != (C.x<0)))
        newX *= -1.0f;
    
    *S = ABpos/distAB;
    *T = newX;
    
    // Success.
    return YES;
}

float ccpAngle(CGPoint a, CGPoint b)
{
	float angle = acosf(ccpDot(ccpNormalize(a), ccpNormalize(b)));
	if( fabs(angle) < kCGPointEpsilon ) return 0.f;
	return angle;
}
