
#import "RNBbcWallet.h"
#import <bbc/Bbc.h>
// @import Mobile;

@implementation RNBbcWallet

- (dispatch_queue_t)methodQueue
{
    return dispatch_get_main_queue();
}
RCT_EXPORT_MODULE()

RCT_EXPORT_METHOD(generateMnemonic:(RCTPromiseResolveBlock)resolve
                                    reject:(RCTPromiseRejectBlock)reject) {
    NSError * __autoreleasing error;
    
    NSData* entropy = Bip39NewEntropy(128, &error);
    NSString* mnemonic = Bip39NewMnemonic(entropy, &error);
    if (error) {
        reject([NSString stringWithFormat:@"%ld",error.code],error.localizedDescription,error);
    } else {
        resolve(mnemonic);
    }
}

RCT_EXPORT_METHOD(importMnemonic:(NSString*)mnemonic
                                  salt:(NSString*)salt
                                  resolve:(RCTPromiseResolveBlock)resolve
                                  reject:(RCTPromiseRejectBlock)reject) {
    NSError * __autoreleasing error;
    
    NSData* seed = Bip39NewSeed(mnemonic, salt);
    BbcKeyInfo * keyInfo = BbcDeriveKey(seed, 0, 0, 0, &error);

    NSMutableDictionary *retDict = [NSMutableDictionary dictionaryWithCapacity:3];
        retDict[@"address"] = keyInfo.address;
        retDict[@"privateKey"] = keyInfo.privateKey;
        retDict[@"publicKey"] = keyInfo.publicKey;
    
    if (error) {
        reject([NSString stringWithFormat:@"%ld",error.code],error.localizedDescription,error);
    } else {
        resolve(retDict);
    }
}

RCT_EXPORT_METHOD(importPrivateKey:(NSString*)privateKey
                                    resolve:(RCTPromiseResolveBlock)resolve
                                    reject:(RCTPromiseRejectBlock)reject) {
    NSError * __autoreleasing error;
    
    BbcKeyInfo * keyInfo = BbcParsePrivateKey(privateKey, &error);
    NSMutableDictionary *retDict = [NSMutableDictionary dictionaryWithCapacity:3];
        retDict[@"address"] = keyInfo.address;
        retDict[@"privateKey"] = keyInfo.privateKey;
        retDict[@"publicKey"] = keyInfo.publicKey;
    
    if (error) {
        reject([NSString stringWithFormat:@"%ld",error.code],error.localizedDescription,error);
    } else {
        resolve(retDict);
    }
}

RCT_EXPORT_METHOD(signTransaction:(NSString*) txString
                                   privateKey:(NSString*) privateKey
                                   resolve:(RCTPromiseResolveBlock)resolve
                                   reject:(RCTPromiseRejectBlock)reject) {
    NSError * __autoreleasing error;
    
    NSString* signedTransaction = BbcSignWithPrivateKey(txString, privateKey, &error);
    
    if (error) {
        reject([NSString stringWithFormat:@"%ld",error.code],error.localizedDescription,error);
    } else {
        resolve(signedTransaction);
    }
}
@end

