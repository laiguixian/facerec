package com.tdr.getface;

import java.io.File;
import java.util.Random;

import com.tdr.getface.RedisUtil;

public class getfacetool {
	/*
	 * 获取用于比对图片库的图片文件名连接字符串
	 * @param specid 传入的特征串，比如用户名
	 */
	public String getcomparejpgstr(String photobasepath,String specid) {
		String resultstr="";
		RedisUtil ru=new RedisUtil().getRu();
		resultstr=ru.get(specid);
		if(resultstr==null)
			resultstr="";
		if(resultstr.length()<=0) {
			String comparepathspec=photobasepath+specid+"\\";
			File comparepathdir=new File(comparepathspec);
			if(comparepathdir.exists()) {
				if (comparepathdir.isDirectory()) {
		            String[] children = comparepathdir.list();
		            //递归删除目录中的子目录下
		            for (int i=0; i<children.length; i++) {
		            	resultstr=resultstr+(resultstr.length()>0?",":"")+comparepathspec+children[i];
		            }
		            ru.set(specid, resultstr);
		        }else {
		        	return "特征不存在";
		        }
			}else {
				return "特征不存在";
			}
		}
		return resultstr;
	}
	/*
	 * 获取同时使用人脸识别的人数
	 */
	public int getusetotal(int intime) {
		return 200+new Random().nextInt(500);
	}
}
