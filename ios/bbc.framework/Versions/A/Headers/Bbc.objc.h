// Objective-C API for talking to github.com/dabankio/wallet-core/core/bbc Go package.
//   gobind -lang=objc github.com/dabankio/wallet-core/core/bbc
//
// File is generated by gobind. Do not edit.

#ifndef __Bbc_H__
#define __Bbc_H__

@import Foundation;
#include "ref.h"
#include "Universe.objc.h"

#include "Bip44.objc.h"

@class BbcKeyInfo;

/**
 * KeyInfo 私钥，公钥，地址
 */
@interface BbcKeyInfo : NSObject <goSeqRefInterface> {
}
@property(strong, readonly) _Nonnull id _ref;

- (nonnull instancetype)initWithRef:(_Nonnull id)ref;
- (nonnull instancetype)init;
@property (nonatomic) NSString* _Nonnull privateKey;
@property (nonatomic) NSString* _Nonnull publicKey;
@property (nonatomic) NSString* _Nonnull address;
@end

/**
 * DecodeTX 解析原始交易（使用JSON RPC createtransaction 创建的交易）,
 */
FOUNDATION_EXPORT NSString* _Nonnull BbcDecodeTX(NSString* _Nullable rawTX, NSError* _Nullable* _Nullable error);

/**
 * DeriveKey 由seed推导 私钥、公钥、地址, 入参参考 NewBip44Deriver
 */
FOUNDATION_EXPORT BbcKeyInfo* _Nullable BbcDeriveKey(NSData* _Nullable seed, long accountIndex, long changeType, long index, NSError* _Nullable* _Nullable error);

/**
 * NewBip44Deriver 根据种子获取bip44推导
accountIndex 账户索引，以0开始
changeType 0:外部使用， 1:找零， 通常使用0,BBC通常找零到发送地址
index 地址索引，以0开始
 */
FOUNDATION_EXPORT id<Bip44Deriver> _Nullable BbcNewBip44Deriver(NSData* _Nullable seed, long accountIndex, long changeType, long index, NSError* _Nullable* _Nullable error);

/**
 * NewSimpleBip44Deriver 根据种子获取bip44推导,仅推导1个
 */
FOUNDATION_EXPORT id<Bip44Deriver> _Nullable BbcNewSimpleBip44Deriver(NSData* _Nullable seed, NSError* _Nullable* _Nullable error);

/**
 * ParsePrivateKey 解析私钥，返回 privateKey,publicKey,address
 */
FOUNDATION_EXPORT BbcKeyInfo* _Nullable BbcParsePrivateKey(NSString* _Nullable privateKey, NSError* _Nullable* _Nullable error);

/**
 * SignWithPrivateKey 使用私钥对原始交易进行签名
 */
FOUNDATION_EXPORT NSString* _Nonnull BbcSignWithPrivateKey(NSString* _Nullable rawTX, NSString* _Nullable privateKey, NSError* _Nullable* _Nullable error);

#endif