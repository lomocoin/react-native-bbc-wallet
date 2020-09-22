package com.bigbang.wallet;

public class RNWalletOptions {
	private boolean beta;
	private boolean shareAccountWithParentChain;
	private boolean BBCUseStandardBip44ID;
	private boolean MKFUseBBCBip44ID;

	public boolean isBeta() {
		return beta;
	}

	public void setBeta(boolean beta) {
		this.beta = beta;
	}

	public boolean isShareAccountWithParentChain() {
		return shareAccountWithParentChain;
	}

	public void setShareAccountWithParentChain(boolean shareAccountWithParentChain) {
		this.shareAccountWithParentChain = shareAccountWithParentChain;
	}

	public boolean isBBCUseStandardBip44ID() {
		return BBCUseStandardBip44ID;
	}

	public void setBBCUseStandardBip44ID(boolean BBCUseStandardBip44ID) {
		this.BBCUseStandardBip44ID = BBCUseStandardBip44ID;
	}

	public boolean isMKFUseBBCBip44ID() {
		return MKFUseBBCBip44ID;
	}

	public void setMKFUseBBCBip44ID(boolean MKFUseBBCBip44ID) {
		this.MKFUseBBCBip44ID = MKFUseBBCBip44ID;
	}
}
