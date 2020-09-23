
#import <React/RCTConvert.h>
#import "RNBbcWallet.h"
#import <Bip39/Bbc.objc.h>
#import "StringUtils.h"
#import "RNWalletOptions.h"
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

RCT_EXPORT_METHOD(importMnemonicWithOptions:(NSString*)mnemonic
                  path:(NSString*)path
                  password:(NSString*)password
                  options:(NSDictionary*)options
                  symbols:(NSArray*)symbols
                  resolve:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject) {
    NSError * __autoreleasing error;
    RNWalletOptions *walletOptions = [[RNWalletOptions alloc]init];
    if ([options objectForKey:@"beta"]) {
        [walletOptions setBeta:[RCTConvert BOOL:(options[@"beta"])]];
    }
    
    if ([options objectForKey:@"shareAccountWithParentChain"]) {
        [walletOptions setShareAccountWithParentChain:[RCTConvert BOOL:options[@"shareAccountWithParentChain"]]];
    }
    
    if ([options objectForKey:@"BBCUseStandardBip44ID"]) {
        [walletOptions setBBCUseStandardBip44ID:[RCTConvert BOOL:options[@"BBCUseStandardBip44ID"]]];
    }
    
    if ([options objectForKey:@"MKFUseBBCBip44ID"]) {
        [walletOptions setMKFUseBBCBip44ID:[RCTConvert BOOL:options[@"MKFUseBBCBip44ID"]]];
    }
    
    
    WalletWallet* wallet = [self getWalletInstance:mnemonic path:path password:password options:walletOptions error:&error];
    NSMutableDictionary *keys = [NSMutableDictionary dictionaryWithCapacity:2];
    for (NSString *symbol in symbols) {
        NSMutableDictionary *keyInfo = [NSMutableDictionary dictionaryWithCapacity:3];
        keyInfo[@"privateKey"] = [wallet derivePrivateKey:symbol error:&error];
        if(error) {
            reject([NSString stringWithFormat:@"%ld",error.code],error.localizedDescription,error);
            return;
        }
        keyInfo[@"publicKey"] = [wallet derivePublicKey:symbol error:&error];
        
        if (error) {
          reject([NSString stringWithFormat:@"%ld",error.code],error.localizedDescription,error);
            return;
        }
        keyInfo[@"address"] = [wallet deriveAddress:symbol error:&error];
        if (error) {
        reject([NSString stringWithFormat:@"%ld",error.code],error.localizedDescription,error);
            return;
        }

        keys[@"symbol"] = symbol;
        keys[@"keyInfo"] = keyInfo;
    }
    resolve(keys);
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
        BbcKeyInfo* keyInfo = BbcDeriveKeySimple(seed, &error);;

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
    NSString* dataUUID = [RCTConvert NSString:map[@"dataUUID"]];
        
    BbcTxBuilder *txBuilder = BbcNewTxBuilder();
    [txBuilder setAnchor:(anchor)];
    [txBuilder setTimestamp:([timestamp longLongValue])];
    [txBuilder setVersion:(version)];
    [txBuilder setLockUntil:(lockUntil)];
    [txBuilder setAddress:(address)];
    [txBuilder setAmount:(amount)];
    [txBuilder setFee:(fee)];
    if (data) {
        if (dataUUID) {
            [txBuilder setDataWithUUID:(dataUUID) timestamp:([timestamp longLongValue]) data:(data)];
        } else {
            [txBuilder setStringData:(data)];
        }
    }
    for (int i = 0; i < utxos.count; i++) {
        NSDictionary* utxo = utxos[i];
        NSString* txid = [RCTConvert NSString:utxo[@"txid"]];
        int vout = [RCTConvert int:utxo[@"vout"]];
        [txBuilder addInput:(txid) vout:(vout)];
    }
    
    NSString* hex = [txBuilder build:(&error)];
    
    if (error) {
        reject([NSString stringWithFormat:@"%ld",error.code],error.localizedDescription,error);
    } else {
        resolve(hex);
    }
    
}

RCT_EXPORT_METHOD(addressToPublicKey:(NSString*) address
                                   resolve:(RCTPromiseResolveBlock)resolve
                                   reject:(RCTPromiseRejectBlock)reject) {
    NSError * __autoreleasing error;
    

    NSString* publicKey = BbcAddress2pubk(address, &error);

    if (error) {
        reject([NSString stringWithFormat:@"%ld",error.code],error.localizedDescription,error);
    } else {
        resolve(publicKey);
    }
}

RCT_EXPORT_METHOD(convertHexStrToBase64:(NSString*) hex1
                                   hex2:(NSString*) hex2
                                resolve:(RCTPromiseResolveBlock)resolve
                                 reject:(RCTPromiseRejectBlock)reject) {
    NSError * __autoreleasing error;
    
    NSMutableData *hexData =  [[NSMutableData alloc] initWithCapacity:8];
    
    if (hex1) {
        NSData *hexData1 = hexString2Data(hex1);
        NSData *newData = reverseData(hexData1);
        [hexData appendData:newData];
    }
    
    if (hex2) {
        NSData *hexData2 = hexString2Data(hex2);
        NSData *newData = reverseData(hexData2);
        [hexData appendData:newData];
    }
    
    NSString *base64String = [hexData base64EncodedStringWithOptions: 0];
    
    if (error) {
        reject([NSString stringWithFormat:@"%ld",error.code],error.localizedDescription,error);
    } else {
        resolve(base64String);
    }
}

- (WalletWallet*) getWalletInstance:(NSString*)mnemonic path:(NSString*)path password:(NSString*)password options:(RNWalletOptions*)walletOptions error:(NSError * _Nullable __autoreleasing * _Nullable)error {
    WalletWalletOptions* options = [WalletWalletOptions new];
    id<WalletWalletOption> pathOption = WalletWithPathFormat(path);
    id<WalletWalletOption> passwordOption = WalletWithPassword(password);
        id<WalletWalletOption> shareAccountWithParentChainOption = WalletWithShareAccountWithParentChain(walletOptions.shareAccountWithParentChain);
    [options add:pathOption];
    [options add:passwordOption];
    [options add:shareAccountWithParentChainOption];
    
    NSLog(@"shareAccountWithParentChain：%d", walletOptions.shareAccountWithParentChain);
    NSLog(@"beta：%d", walletOptions.BBCUseStandardBip44ID);
    NSLog(@"BBCUseStandardBip44ID：%d", walletOptions.BBCUseStandardBip44ID);
    NSLog(@"MKFUseBBCBip44ID：%d", walletOptions.MKFUseBBCBip44ID);
    
    if(walletOptions.BBCUseStandardBip44ID) {
        [options add:WalletWithFlag(WalletFlagBBCUseStandardBip44ID)];
    }
    if(walletOptions.MKFUseBBCBip44ID) {
        [options add:WalletWithFlag(WalletFlagMKFUseBBCBip44ID)];
    }

    WalletWallet* wallet = WalletBuildWalletFromMnemonic(mnemonic, walletOptions.beta, options, error);
    return wallet;
}

@end

