export interface KeyInfo {
  privateKey: string;
  publicKey: string;
  address: string;
}

export interface ITransactionData {
  txid: string;
  vout: number;
  address: string;
  anchor: string;
  amount: number;
  fee: number;
  data?: string;
  version: number;
  lockUntil: number;
  timestamp: string;
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
  function buildTransaction(data: ITransactionData): Promise<string>;
  function addressToPublicKey(address: string): Promise<string>;
  function convertHexStrToBase64(hex1: string, hex2: string): Promise<string>;
}

export default RNBbcWallet;
