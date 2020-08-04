package com.bigbang.utils;

public class StringUtils {
	public static byte[] hexString2ReverseByte(String hex) {

		if ((hex == null) || (hex.equals(""))){
			return null;
		}
		else if (hex.length()%2 != 0){
			return null;
		}
		else{
			hex = hex.toUpperCase();
			int len = hex.length()/2;
			byte[] b = new byte[len];
			char[] hc = hex.toCharArray();
			for (int i=0; i<len; i++){
				int p=2*i;
				b[i] = (byte) (charToByte(hc[p]) << 4 | charToByte(hc[p+1]));
			}
			int size = b.length;
			byte[] newByte = new byte[size];
			for (int i = 0; i < size; i++) {
				newByte[i] = b[size - i - 1];
			}
			return newByte;
		}
	}

	public static byte[] byteMerger(byte[] bt1, byte[] bt2){
		byte[] bt3 = new byte[bt1.length+bt2.length];
		int i=0;
		for(byte bt: bt1){
			bt3[i]=bt;
			i++;
		}

		for(byte bt: bt2){
			bt3[i]=bt;
			i++;
		}
		return bt3;
	}

	/*
	 * 字符转换为字节
	 */
	private static byte charToByte(char c) {
		return (byte) "0123456789ABCDEF".indexOf(c);
	}
}

