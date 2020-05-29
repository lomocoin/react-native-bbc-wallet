export interface KeyInfo {
  privateKey: string;
  publicKey: string;
  address: string;
}

export interface IUTXO {
  txid: string;
  vout: number;
}

export interface ITransactionData {
  utxos: IUTXO[],
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
}

export default RNBbcWallet;
