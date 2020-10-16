package com.bigbang.wallet;

import android.util.Base64;

import com.bigbang.utils.StringUtils;
import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReadableArray;
import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.bridge.WritableMap;

import bbc.Bbc;
import bbc.KeyInfo;
import bbc.TxBuilder;
import bip39.Bip39;
import wallet.Wallet;
import wallet.WalletOptions;
import wallet.Wallet_;

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
	public void importMnemonicWithOptions(
			final String mnemonic,
			final String path,
			final String password,
			final ReadableMap options,
			final ReadableArray symbols,
			Promise promise
	) {
		try {
			RNWalletOptions walletOptions = new RNWalletOptions();
			walletOptions.setBeta(options.hasKey("beta") && options.getBoolean("beta"));
			walletOptions.setShareAccountWithParentChain(options.hasKey("shareAccountWithParentChain")
					&& options.getBoolean("shareAccountWithParentChain"));
			walletOptions.setBBCUseStandardBip44ID(options.hasKey("BBCUseStandardBip44ID")
					&& options.getBoolean("BBCUseStandardBip44ID"));
			walletOptions.setMKFUseBBCBip44ID(options.hasKey("MKFUseBBCBip44ID")
					&& options.getBoolean("MKFUseBBCBip44ID"));

			Wallet_ wallet = this.getWalletInstance(mnemonic, path, password, walletOptions);
			WritableMap keys = Arguments.createMap();

			for (int i = 0; i < symbols.size(); i++) {
				String symbol = symbols.getString(i);
				WritableMap keyInfo = Arguments.createMap();
				try {
					keyInfo.putString("publicKey", wallet.derivePublicKey(symbol));
					keyInfo.putString("address", wallet.deriveAddress(symbol));
					keyInfo.putString("privateKey", wallet.derivePrivateKey(symbol));
				} catch (Exception e) {
					e.printStackTrace();
				}
				keys.putString("symbol", symbol);
				keys.putMap("keyInfo", keyInfo);
			}
			promise.resolve(keys);
		} catch (Exception e) {
			e.printStackTrace();
			promise.reject(e);
		}
	}

	@ReactMethod
	public void importMnemonic(final String mnemonic, final String salt, final String symbol, final String path, final Promise promise) {
		try {
			if (!Bip39.isMnemonicValid(mnemonic)) {
				promise.reject("error", "Invalid mnemonic");
			} else {
				final byte[] seed = Bip39.newSeed(mnemonic, salt);
				final bip44.Deriver keyPair = Bbc.newSymbolBip44Deriver(symbol, path, symbol, seed);
				String address = keyPair.deriveAddress();
				String privateKey = keyPair.derivePrivateKey();
				String publicKey = keyPair.derivePublicKey();

				final WritableMap resultMap = Arguments.createMap();
				resultMap.putString("address", address);
				resultMap.putString("privateKey", privateKey);
				resultMap.putString("publicKey", publicKey);
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
	public void symbolSignWithPrivateKey(final String symbol, final String txString, final String privateKey, final Promise promise) {
		try {
			final String signedTX = Bbc.symbolSignWithPrivateKey(symbol, txString, "", privateKey);

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
	public void symbolSignWithPrivateKeyTemplate(final String symbol, final String txString, String templatemap, final String privateKey, final Promise promise) {
		try {
			final String signedTX = Bbc.symbolSignWithPrivateKey(symbol, txString, templatemap, privateKey);

			promise.resolve(signedTX);
		} catch (final Exception e) {
			promise.reject("error", e);
		}
	}

	@ReactMethod
	public void addressToPublicKey(String address, Promise promise) {
		try {
			String publicKey = Bbc.address2pubk(address);
			promise.resolve(publicKey);
		} catch (Exception e) {
			e.printStackTrace();
			promise.reject(e);
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

			TxBuilder txBuilder = Bbc.newTxBuilder();
			txBuilder
					.setAnchor(anchor)
					.setTimestamp(timestamp)
					.setVersion(version)
					.setLockUntil(lockUntil)
					.setAddress(address)
					.setAmount(amount)
					.setFee(fee);

			if (map.hasKey("dataUUID") && map.hasKey("data")) {
				String dataUUID = map.getString("dataUUID");
				String data = map.getString("data");
				if (!"".equals(data) && data != null) {
					txBuilder.setDataWithUUID(dataUUID, timestamp, data);
				}
			}

			if (map.hasKey("data") && !map.hasKey("dataUUID")) {
				String data = map.getString("data");
				if (!"".equals(data) && data != null) {
					txBuilder.setStringData(data);
				}
			}

			for (int i = 0; i < utxos.size(); i++) {
				ReadableMap utxo = utxos.getMap(i);
				txBuilder.addInput(utxo.getString("txid"), (byte) utxo.getInt("vout"));
			}
			String hex = txBuilder.build();
			promise.resolve(hex);
		} catch (Exception ex) {
			promise.reject("error", ex);
		}
	}

	@ReactMethod
	public void convertHexStrToBase64(String hex1, String hex2, Promise promise) {
		byte[] byte1 = StringUtils.hexString2ReverseByte(hex1);
		byte[] byte2 = StringUtils.hexString2ReverseByte(hex2);

		if (byte1 != null && byte2 != null) {
			byte[] hexData = StringUtils.byteMerger(byte1, byte2);
			String base64 = Base64.encodeToString(hexData, Base64.NO_WRAP);
			promise.resolve(base64);
		} else if (byte1 != null && byte2 == null) {
			String base64 = Base64.encodeToString(byte1, Base64.NO_WRAP);
			promise.resolve(base64);
		} else if (byte1 == null && byte2 != null) {
			String base64 = Base64.encodeToString(byte2, Base64.NO_WRAP);
			promise.resolve(base64);
		} else {
			promise.reject(new Exception("no hex"));
		}
	}

	@ReactMethod
	public void calcTxid(final String symbol, final String rawTx, final Promise promise) {
		try {
			final String txid = Bbc.calcTxid(symbol, rawTx);
			promise.resolve(txid);
		} catch (final Exception e) {
			promise.reject("error", e);
		}
	}

	/**
	 * @params password: salt
	 */
	private Wallet_ getWalletInstance(
			String mnemonic,
			String path,
			String password,
			RNWalletOptions walletOptions
	) {
		WalletOptions options = new WalletOptions();
		options.add(Wallet.withPathFormat(path));
		options.add(Wallet.withPassword(password));
		options.add(Wallet.withShareAccountWithParentChain(walletOptions.isShareAccountWithParentChain()));

		if(walletOptions.isBBCUseStandardBip44ID()){
			options.add(Wallet.withFlag(Wallet.FlagBBCUseStandardBip44ID));
		}

		if (walletOptions.isMKFUseBBCBip44ID()) {
			options.add(Wallet.withFlag(Wallet.FlagMKFUseBBCBip44ID));
		}

		Wallet_ wallet = null;
		try {
			wallet = Wallet.buildWalletFromMnemonic(mnemonic, walletOptions.isBeta(), options);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return wallet;
	}
}
