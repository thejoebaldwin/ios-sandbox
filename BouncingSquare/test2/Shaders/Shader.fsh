//
//  Shader.fsh
//  test2
//
//  Created by Joseph on 6/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

varying lowp vec4 colorVarying;

void main()
{
    gl_FragColor = colorVarying;
}
