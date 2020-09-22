//
//  RNWalletOptions.h
//  RNBbcWallet
//
//  Created by wuye on 2020/9/22.
//
#import <Foundation/Foundation.h>
#ifndef RNWalletOptions_h
#define RNWalletOptions_h
@interface RNWalletOptions : NSObject{
    BOOL _bate;
    BOOL _shareAccountWithParentChain;
    BOOL _BBCUseStandardBip44ID;
    BOOL _MKFUseBBCBip44ID;
}

@property BOOL bate;
@property BOOL shareAccountWithParentChain;
@property BOOL BBCUseStandardBip44ID;
@property BOOL MKFUseBBCBip44ID;

@end

#endif /* RNWalletOptions_h */

