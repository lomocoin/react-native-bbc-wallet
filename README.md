
# react-native-bbc-wallet

## Getting started

`$ npm install react-native-bbc-wallet --save`

### Mostly automatic installation

`$ react-native link react-native-bbc-wallet`

### Manual installation


#### iOS

1. In XCode, in the project navigator, right click `Libraries` ➜ `Add Files to [your project's name]`
2. Go to `node_modules` ➜ `react-native-bbc-wallet` and add `RNBbcWallet.xcodeproj`
3. In XCode, in the project navigator, select your project. Add `libRNBbcWallet.a` to your project's `Build Phases` ➜ `Link Binary With Libraries`
4. Run your project (`Cmd+R`)<

#### Android

1. Open up `android/app/src/main/java/[...]/MainActivity.java`
  - Add `import com.bigbang.wallet.RNBbcWalletPackage;` to the imports at the top of the file
  - Add `new RNBbcWalletPackage()` to the list returned by the `getPackages()` method
2. Append the following lines to `android/settings.gradle`:
  	```
  	include ':react-native-bbc-wallet'
  	project(':react-native-bbc-wallet').projectDir = new File(rootProject.projectDir, 	'../node_modules/react-native-bbc-wallet/android')
  	```
3. Insert the following lines inside the dependencies block in `android/app/build.gradle`:
  	```
      compile project(':react-native-bbc-wallet')
  	```


## Usage
```javascript
import RNBbcWallet from 'react-native-bbc-wallet';

// TODO: What to do with the module?
RNBbcWallet;
```
  