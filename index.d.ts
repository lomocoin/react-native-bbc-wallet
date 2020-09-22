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
  utxos: IUTXO[];
  address: string;
  anchor: string;
  amount: number;
  fee: number;
  data?: string;
  dataUUID?: string;
  version: number;
  lockUntil: number;
  timestamp: string;
}

export interface WalletOptions {
  bate?: boolean; // default false
  shareAccountWithParentChain?: boolean; // default false
  BBCUseStandardBip44ID?: boolean; // default false
  MKFUseBBCBip44ID?: boolean; // default false
}

export type Symbol = 'BTC' | 'ETH' | 'BBC' | 'USDT(Omni)';

export interface Keys {
  symbol: string;
  keyInfo: KeyInfo;
}

declare module RNBbcWallet {
  function generateMnemonic(): Promise<string>;
  function importMnemonic(
    mnemonic: string,
    salt: string,
  ): Promise<KeyInfo>;
  function importMnemonicWithOptions(
    mnemonic: string,
    path: string,
    password: string,
    options: WalletOptions,
    symbols: Symbol[],
  ): Promise<Keys>;
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
