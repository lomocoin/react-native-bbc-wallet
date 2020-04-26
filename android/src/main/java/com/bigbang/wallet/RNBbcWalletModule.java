package com.bigbang.wallet;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.WritableMap;

import bbc.Bbc;
import bbc.KeyInfo;
import bip39.Bip39;

public class RNBbcWalletModule extends ReactContextBaseJavaModule {

  private final ReactApplicationContext reactContext;

  public RNBbcWalletModule(final ReactApplicationContext reactContext) {
    super(reactContext);
    this.reactContext = reactContext;
  }

  @Override
  public String getName() {
    return "RNBbcWallet";
  }

  @ReactMethod
  public void generateMnemonic(final Promise promise) {
    try {
      final byte[] entropy = Bip39.newEntropy(128);
      Bip39.setWordListLang(Bip39.LangEnglish);
      final String mnemonic = Bip39.newMnemonic(entropy);
      promise.resolve(mnemonic);
    } catch (final Exception e) {
      promise.reject("error", e);
    }
  }

  @ReactMethod
  public void importMnemonic(final String mnemonic, final String salt, final Promise promise) {
    try {
      if (!Bip39.isMnemonicValid(mnemonic)) {
        promise.reject("error", "Invalid mnemonic");
      } else {
        final byte[] seed = Bip39.newSeed(mnemonic, salt);
        final KeyInfo keyPair = Bbc.deriveKey(seed, 0, 0, 0);

        final WritableMap resultMap = Arguments.createMap();

        resultMap.putString("address", keyPair.getAddress());
        resultMap.putString("privateKey", keyPair.getPrivateKey());
        resultMap.putString("publicKey", keyPair.getPublicKey());

        promise.resolve(resultMap);
      }
    } catch (final Exception e) {
      promise.reject("error", e);
    }
  }

  @ReactMethod
  public void importPrivateKey(final String privateKey, final Promise promise) {
    try {
      final KeyInfo keyPair = Bbc.parsePrivateKey(privateKey);

      final WritableMap resultMap = Arguments.createMap();

      resultMap.putString("address", keyPair.getAddress());
      resultMap.putString("privateKey", keyPair.getPrivateKey());
      resultMap.putString("publicKey", keyPair.getPublicKey());

      promise.resolve(resultMap);
    } catch (final Exception e) {
      promise.reject("error", e);
    }
  }

  @ReactMethod
  public void signTransaction(final String txString, final String privateKey, final Promise promise) {
    try {
      final String signedTX = Bbc.signWithPrivateKey(txString, "", privateKey);

      promise.resolve(signedTX);
    } catch (final Exception e) {
      promise.reject("error", e);
    }
  }


  @ReactMethod
  public void signTransactionWithTemplate(final String txString, String templateData, final String privateKey, final Promise promise) {
    try {
      final String signedTX = Bbc.signWithPrivateKey(txString, templateData, privateKey);

      promise.resolve(signedTX);
    } catch (final Exception e) {
      promise.reject("error", e);
    }
  }


}
