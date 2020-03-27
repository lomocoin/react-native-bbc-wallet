package com.bigbang.wallet;

import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.Callback;
import com.facebook.react.bridge.Promise;

import bbc.Bbc;
import bbc.KeyInfo;
import bip39.Bip39;

public class RNBbcWalletModule extends ReactContextBaseJavaModule {

  private final ReactApplicationContext reactContext;
  private final BBC bbcWallet;
  private final Bip39 bip39;

  public RNBbcWalletModule(final ReactApplicationContext reactContext) {
    super(reactContext);
    this.reactContext = reactContext;
    bbcWallet = new BBC();
    bip39 = new Bip39();
  }

  @Override
  public String getName() {
    return "RNBBCWallet";
  }

  @ReactMethod
  public void generateMnemonic(final Promise promise) {
    try {
      final byte[] entropy = bip39.NewEntropy(128);
      bip39.SetWordListLang(bip39.LangEnglish);
      final String mnemonic = bip39.NewMnemonic(entropy);
      promise.resolve(mnemonic);
    } catch (final Exception e) {
      promise.reject("error", e);
    }
  }

  @ReactMethod
  public void importMnemonic(final String mnemonic, final String salt, final Promise promise) {
    try {
      if (!bip39.isMnemonicValid(mnemonic)) {
        promise.reject("error", "Invalid mnemonic");
      } else {
        final byte[] seed = bip39.NewSeed(mnemonic, salt);
        final KeyInfo keyPair = bbc.DeriveKey(seed, 0, 0, 0);

        promise.resolve(keyPair);
      }
    } catch (final Exception e) {
      promise.reject("error", e);
    }
  }

  @ReactMethod
  public void importPrivateKey(final String privateKey, final Promise promise) {
    try {
      final KeyInfo keyPair = bbc.ParsePrivateKey(privateKey);

      promise.resolve(keyPair);
    } catch (final Exception e) {
      promise.reject("error", e);
    }
  }

  @ReactMethod
  public void signTransaction(final String txString, final String privateKey, final Promise promise) {
    try {
      final String signedTX = bbc.SignWithPrivateKey(txString, privateKey);

      promise.resolve(signedTX);
    } catch (final Exception e) {
      promise.reject("error", e);
    }
  }
}
