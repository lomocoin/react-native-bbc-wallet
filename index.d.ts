export interface KeyInfo {
  privateKey: string;
  publicKey: string;
  address: string;
}

declare module RNBbcWallet {
  function generateMnemonic(): Promise<string>;
  function importMnemonic(mnemonic: string, salt: string): Promise<KeyInfo>;
  function importPrivateKey(privateKey: string): Promise<KeyInfo>;
  function signTransactionWithTemplate(
    txString: string,
    templateData: string,
    privateKey: string
  ): Promise<string>;
  function signTransaction(
    txString: string,
    privateKey: string
  ): Promise<string>;
}

export default RNBbcWallet;
