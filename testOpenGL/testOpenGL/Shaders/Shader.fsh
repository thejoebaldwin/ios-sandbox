//
//  Shader.fsh
//  testOpenGL
//
//  Created by Joseph on 1/15/13.
//  Copyright (c) 2013 Joe Baldwin. All rights reserved.
//

varying lowp vec4 colorVarying;

void main()
{
    gl_FragColor = colorVarying;
}
