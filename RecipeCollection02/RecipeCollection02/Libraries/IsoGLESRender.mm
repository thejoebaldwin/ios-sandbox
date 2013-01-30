/*
 * Copyright (c) 2006-2007 Erin Catto http://www.gphysics.com
 *
 * iPhone port by Simon Oliver - http://www.simonoliver.com - http://www.handcircus.com
 *
 * This software is provided 'as-is', without any express or implied
 * warranty.  In no event will the authors be held liable for any damages
 * arising from the use of this software.
 * Permission is granted to anyone to use this software for any purpose,
 * including commercial applications, and to alter it and redistribute it
 * freely, subject to the following restrictions:
 * 1. The origin of this software must not be misrepresented; you must not
 * claim that you wrote the original software. If you use this software
 * in a product, an acknowledgment in the product documentation would be
 * appreciated but is not required.
 * 2. Altered source versions must be plainly marked as such, and must not be
 * misrepresented as being the original software.
 * 3. This notice may not be removed or altered from any source distribution.
 */

//
// File modified for cocos2d integration
// http://www.cocos2d-iphone.org
//

#include "IsoGLESRender.h"

#include <cstdio>
#include <cstdarg>
#include <cstring>

IsoGLESDebugDraw::IsoGLESDebugDraw()
: mRatio( 1.0f )
{
}

IsoGLESDebugDraw::IsoGLESDebugDraw( float32 ratio, float32 pr, CGPoint gs ): mRatio( ratio ) 
{
	gameAreaSize = gs;
	perspectiveRatio = pr;
}


/*
IsoGLESDebugDraw::IsoGLESDebugDraw( float32 ratio, CGPoint fs )
{
	mRatio = ratio;
	gameAreaSize = fs;
}
*/

float IsoGLESDebugDraw::convertPositionX(CGPoint areaSize, float x){
	return x - (areaSize.x/2);
}
float IsoGLESDebugDraw::convertPositionY(CGPoint areaSize, float y){
	return y - (areaSize.y/2);
}

void IsoGLESDebugDraw::DrawPolygon(const b2Vec2* old_vertices, int32 vertexCount, const b2Color& color)
{
	b2Vec2 *vertices = new b2Vec2[vertexCount];
	for( int i=0;i<vertexCount;i++) {
		b2Vec2 oldFixedVertices = b2Vec2( convertPositionX(gameAreaSize, old_vertices[i].x*mRatio)/mRatio, convertPositionY(gameAreaSize, old_vertices[i].y*mRatio*perspectiveRatio)/mRatio );
		vertices[i] = oldFixedVertices;
		vertices[i] *= mRatio;
	}
	
	glColor4f(color.r, color.g, color.b,1);
	glVertexPointer(2, GL_FLOAT, 0, vertices);
	glDrawArrays(GL_LINE_LOOP, 0, vertexCount);	
	
	delete [] vertices;
}

void IsoGLESDebugDraw::DrawSolidPolygon(const b2Vec2* old_vertices, int32 vertexCount, const b2Color& color)
{
	b2Vec2 *vertices = new b2Vec2[vertexCount];
	
	for( int i=0;i<vertexCount;i++) {
		b2Vec2 oldFixedVertices = b2Vec2( convertPositionX(gameAreaSize, old_vertices[i].x*mRatio)/mRatio, convertPositionY(gameAreaSize, old_vertices[i].y*mRatio*perspectiveRatio)/mRatio );
		vertices[i] = oldFixedVertices;
		vertices[i] *= mRatio;
	}
	
	glVertexPointer(2, GL_FLOAT, 0, vertices);
	
	glColor4f(color.r, color.g, color.b,0.5f);
	glDrawArrays(GL_TRIANGLE_FAN, 0, vertexCount);
	
	glColor4f(color.r, color.g, color.b,1);
	glDrawArrays(GL_LINE_LOOP, 0, vertexCount);
	
	delete [] vertices;
}

void IsoGLESDebugDraw::DrawCircle(const b2Vec2& center, float32 radius, const b2Color& color)
{
	b2Vec2 fixedCenter = b2Vec2( convertPositionX(gameAreaSize, center.x*mRatio)/mRatio, convertPositionY(gameAreaSize, center.y*mRatio*perspectiveRatio)/mRatio );
	
	const float32 k_segments = 16.0f;
	int vertexCount=16;
	const float32 k_increment = 2.0f * b2_pi / k_segments;
	float32 theta = 0.0f;
	
	GLfloat				glVertices[vertexCount*2];
	for (int32 i = 0; i < k_segments; ++i)
	{
		b2Vec2 v = fixedCenter + radius * b2Vec2(cosf(theta), sinf(theta));
		glVertices[i*2]=v.x * mRatio;
		glVertices[i*2+1]=v.y * mRatio;
		theta += k_increment;
	}
	
	glColor4f(color.r, color.g, color.b,1);
	glVertexPointer(2, GL_FLOAT, 0, glVertices);
	
	glDrawArrays(GL_TRIANGLE_FAN, 0, vertexCount);
}

void IsoGLESDebugDraw::DrawSolidCircle(const b2Vec2& center, float32 radius, const b2Vec2& axis, const b2Color& color)
{
	b2Vec2 fixedCenter = b2Vec2( convertPositionX(gameAreaSize, center.x*mRatio)/mRatio, convertPositionY(gameAreaSize, center.y*mRatio*perspectiveRatio)/mRatio );
	
	const float32 k_segments = 16.0f;
	int vertexCount=16;
	const float32 k_increment = 2.0f * b2_pi / k_segments;
	float32 theta = 0.0f;
	
	GLfloat				glVertices[vertexCount*2];
	for (int32 i = 0; i < k_segments; ++i)
	{
		b2Vec2 v = fixedCenter + radius * b2Vec2(cosf(theta), sinf(theta));
		glVertices[i*2]=v.x * mRatio;
		glVertices[i*2+1]=v.y * mRatio;
		theta += k_increment;
	}
	
	//This draws a non solid circle
	glColor4f(0.1f, 0.1f, 0.1f ,0.0f);
	glVertexPointer(2, GL_FLOAT, 0, glVertices);
	glDrawArrays(GL_TRIANGLE_FAN, 0, vertexCount);
	
	// Draw the axis line
	glColor4f(color.r, color.g, color.b,0.5f);
	DrawSegment(center,center+radius*axis,color);
}

void IsoGLESDebugDraw::DrawSegment(const b2Vec2& p1, const b2Vec2& p2, const b2Color& color)
{
	b2Vec2 fixedP1 = b2Vec2( convertPositionX(gameAreaSize, p1.x*mRatio)/mRatio, convertPositionY(gameAreaSize, p1.y*mRatio*perspectiveRatio)/mRatio );
	b2Vec2 fixedP2 = b2Vec2( convertPositionX(gameAreaSize, p2.x*mRatio)/mRatio, convertPositionY(gameAreaSize, p2.y*mRatio*perspectiveRatio)/mRatio );
	
	glColor4f(color.r, color.g, color.b,1);
	GLfloat				glVertices[] = {
		fixedP1.x * mRatio, fixedP1.y * mRatio,
		fixedP2.x * mRatio, fixedP2.y * mRatio
	};
	glVertexPointer(2, GL_FLOAT, 0, glVertices);
	glDrawArrays(GL_LINES, 0, 2);
}

void IsoGLESDebugDraw::DrawTransform(const b2Transform& xf)
{
	b2Vec2 p1 = xf.position, p2;
	const float32 k_axisScale = 0.4f;
	
	p2 = p1 + k_axisScale * xf.R.col1;
	DrawSegment(p1,p2,b2Color(1,0,0));
	
	p2 = p1 + k_axisScale * xf.R.col2;
	DrawSegment(p1,p2,b2Color(0,1,0));
}

void IsoGLESDebugDraw::DrawPoint(const b2Vec2& p, float32 size, const b2Color& color)
{
	b2Vec2 fixedPoint = b2Vec2( convertPositionX(gameAreaSize, p.x*mRatio)/mRatio, convertPositionY(gameAreaSize, p.y*mRatio*perspectiveRatio)/mRatio );
	
	glColor4f(color.r, color.g, color.b,1);
	glPointSize(size);
	GLfloat				glVertices[] = {
		fixedPoint.x * mRatio, fixedPoint.y * mRatio
	};
	glVertexPointer(2, GL_FLOAT, 0, glVertices);
	glDrawArrays(GL_POINTS, 0, 1);
	glPointSize(1.0f);
}

void IsoGLESDebugDraw::DrawString(int x, int y, const char *string, ...)
{
	//	NSLog(@"DrawString: unsupported: %s", string);
	//printf(string);
	/* Unsupported as yet. Could replace with bitmap font renderer at a later date */
}

void IsoGLESDebugDraw::DrawAABB(b2AABB* aabb, const b2Color& c)
{
	glColor4f(c.r, c.g, c.b,1);
	
	GLfloat				glVertices[] = {
		aabb->lowerBound.x * mRatio, aabb->lowerBound.y * mRatio,
		aabb->upperBound.x * mRatio, aabb->lowerBound.y * mRatio,
		aabb->upperBound.x * mRatio, aabb->upperBound.y * mRatio,
		aabb->lowerBound.x * mRatio, aabb->upperBound.y * mRatio
	};
	glVertexPointer(2, GL_FLOAT, 0, glVertices);
	glDrawArrays(GL_LINE_LOOP, 0, 8);
	
}
