//
//  RNWalletOptions.m
//  appcenter-analytics
//
//  Created by wuye on 2020/9/22.
//
#import <RNWalletOptions.h>
@implementation RNWalletOptions
- (void)setBeta:(BOOL)beta{
    _beta = beta;
}
- (BOOL)beta{
    return _beta;
}

- (void)setShareAccountWithParentChain:(BOOL)shareAccountWithParentChain{
    _shareAccountWithParentChain = shareAccountWithParentChain;
}
- (BOOL)shareAccountWithParentChain{
    return _shareAccountWithParentChain;
}

- (void)setMKFUseBBCBip44ID:(BOOL)MKFUseBBCBip44ID{
    _MKFUseBBCBip44ID = MKFUseBBCBip44ID;
}
- (BOOL)MKFUseBBCBip44ID{
    return _MKFUseBBCBip44ID;
}

- (void)setBBCUseStandardBip44ID:(BOOL)BBCUseStandardBip44ID{
    _BBCUseStandardBip44ID = BBCUseStandardBip44ID;
}
- (BOOL)BBCUseStandardBip44ID{
    return _BBCUseStandardBip44ID;
}
@end
