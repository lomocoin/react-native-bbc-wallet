package com.bigbang.wallet;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReadableArray;
import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.bridge.WritableMap;

import java.util.ArrayList;
import java.util.List;

import bbc.Bbc;
import bbc.KeyInfo;
import bbc.TxBuilder;
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
  public void signTransactionWithTemplate(final String txString, String templatemap, final String privateKey, final Promise promise) {
    try {
      final String signedTX = Bbc.signWithPrivateKey(txString, templatemap, privateKey);

      promise.resolve(signedTX);
    } catch (final Exception e) {
      promise.reject("error", e);
    }
  }

  @ReactMethod
  public void buildTransaction(ReadableMap map, Promise promise) {
    try {
      ReadableArray utxos = map.getArray("utxos");
      String address = map.getString("address");
      long timestamp = Long.parseLong(map.getString("timestamp"));
      String anchor = map.getString("anchor");
      double amount = map.getDouble("amount");
      double fee = map.getDouble("fee");
      int version = map.getInt("version");
      int lockUntil = map.getInt("lockUntil");
      String data = map.getString("data");

      TxBuilder txBuilder = Bbc.newTxBuilder();
      txBuilder
        .setAnchor(anchor)
        .setTimestamp(timestamp)
        .setVersion(version)
        .setLockUntil(lockUntil)
        .setAddress(address)
        .setAmount(amount)
        .setFee(fee);
      if (!"".equals(data) && data != null) {
        txBuilder.setStringData(data);
      }
      for (int i = 0; i < utxos.size(); i++) {
        ReadableMap utxo = utxos.getMap(i);
        txBuilder.addInput(utxo.getString("txid"), (byte)utxo.getInt("vout"));
      }
      String hex = txBuilder.build();
      promise.resolve(hex);
    } catch (Exception ex) {
      promise.reject("error", ex);
    }
  }
}
