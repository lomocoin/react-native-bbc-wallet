
#import <React/RCTConvert.h>
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

    if (!Bip39IsMnemonicValid(mnemonic)) {
        reject(@"error", @"Invalid Mnemonic", nil);
    } else {
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

    NSString* signedTransaction = BbcSignWithPrivateKey(txString, NULL, privateKey, &error);

    if (error) {
        reject([NSString stringWithFormat:@"%ld",error.code],error.localizedDescription,error);
    } else {
        resolve(signedTransaction);
    }
}

RCT_EXPORT_METHOD(signTransactionWithTemplate:(NSString*) txString
                                   templateData:(NSString*) templateData
                                   privateKey:(NSString*) privateKey
                                   resolve:(RCTPromiseResolveBlock)resolve
                                   reject:(RCTPromiseRejectBlock)reject) {
    NSError * __autoreleasing error;
    
    NSLog(@"txString:%@",txString);
    NSLog(@"templateData:%@",templateData);
    NSLog(@"privateKey:%@",privateKey);

    NSString* signTransactionWithTemplate = BbcSignWithPrivateKey(txString, templateData, privateKey, &error);

    if (error) {
        reject([NSString stringWithFormat:@"%ld",error.code],error.localizedDescription,error);
    } else {
        resolve(signTransactionWithTemplate);
    }
}

RCT_EXPORT_METHOD(buildTransaction:(NSDictionary *) map
                  resolve:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject){
    NSError * __autoreleasing error;
    NSArray* utxos = [RCTConvert NSArray:map[@"utxos"]];
    NSString* address = [RCTConvert NSString:map[@"address"]];
    NSString* anchor = [RCTConvert NSString:map[@"anchor"]];
    double amount = [RCTConvert double:map[@"amount"]];
    double fee = [RCTConvert double:map[@"fee"]];
    int version = [RCTConvert int:map[@"version"]];
    int lockUntil = [RCTConvert int:map[@"lockUntil"]];
    NSString* timestamp = [RCTConvert NSString:map[@"timestamp"]];
    NSString* data = [RCTConvert NSString:map[@"data"]];
        
    BbcTxBuilder *txBuilder = BbcNewTxBuilder();
    [txBuilder setAnchor:(anchor)];
    [txBuilder setTimestamp:([timestamp longLongValue])];
    [txBuilder setVersion:(version)];
    [txBuilder setLockUntil:(lockUntil)];
    [txBuilder setAddress:(address)];
    [txBuilder setAmount:(amount)];
    [txBuilder setFee:(fee)];
    if (data) {
        [txBuilder setStringData:(data)];
    }
    for (int i = 0; i < utxos.count; i++) {
        NSDictionary* utxo = utxos[i];
        NSString* txid = [RCTConvert NSString:utxo[@"txid"]];
        int vout = [RCTConvert int:map[@"vout"]];
        [txBuilder addInput:(txid) vout:(vout)];
    }
    
    NSString* hex = [txBuilder build:(&error)];
    
    if (error) {
        reject([NSString stringWithFormat:@"%ld",error.code],error.localizedDescription,error);
    } else {
        resolve(hex);
    }
    
}

@end

