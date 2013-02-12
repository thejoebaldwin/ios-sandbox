#import "cocos2d.h"


@interface MainLayer : CCLayer {

}




+(id) scene;
-(void) addBackground;

-(CCLayer *) getFluidLayer;
-(void) clearFluidLayer;


@end
