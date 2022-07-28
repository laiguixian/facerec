package com.tdr.getface;

import java.io.File;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Random;

import org.apache.commons.io.FileUtils;
import org.json.JSONArray;
import org.json.JSONObject;

public class getfacews {
	
	String comparepath="E:\\chuangyelei\\ruanjian\\facenet\\compare\\";//人脸比对图片路径
	String photobasepath=comparepath+"photobase\\";//人脸比对人脸库图片路径
	
	/*
	 * 通过输入的图片数据获取注册数据进行注册
	 * @param inpicdata 输入的注册数据
	 */
	public String reginfos(String indata) {
		String waitregpass="E:\\chuangyelei\\ruanjian\\facenet\\注册待审核\\";
		String resultvalue="";
		//{"indatas":[{"name":"张三","cell":"13700000000","mail":"000000@qq.com","app":"人脸识别","appdes":"该款应用是用于展示人脸识别技术的例子，人脸识别用在展示的环节，主要用到特征提取接口和1:N识别接口"}]}
		try {
			JSONObject indataobj = null;
			JSONArray datasary = null;
			JSONObject dataobj = null;
			indataobj = new JSONObject(indata);//将输入的字符串转为json对象
			datasary = indataobj.getJSONArray("indatas");//获取输入数据
			for(int i=0;i<datasary.length();i++){//遍历数据
				dataobj = datasary.getJSONObject(i);
				if((dataobj.getString("name").length()==0)||(dataobj.getString("cell").length()==0)
						||(dataobj.getString("mail").length()==0)||(dataobj.getString("app").length()==0)
						||(dataobj.getString("appdes").length()==0)) {
					resultvalue="{\"message\":\"姓名，手机，邮箱，应用，应用描述均不能为空不能为空，请检查\"}";
				}else {
					String onedata="姓名："+dataobj.getString("name")+"\\r\\n"+
					"手机："+dataobj.getString("cell")+"\\r\\n"+
					"邮箱："+dataobj.getString("mail")+"\\r\\n"+
					"应用："+dataobj.getString("app")+"\\r\\n"+
					"应用描述："+dataobj.getString("appdes");//获取单个数据
					//生成新的待审核注册文件
					String fileNamestr = new SimpleDateFormat("yyyyMMddHHmmss").format(new Date())+ new Random().nextInt();
					String fileName = "waitregpass"+fileNamestr + ".txt";
					//生成待注册文件
					new htmlpar().writeTxtFile(onedata, waitregpass+fileName);
					resultvalue="{\"message\":\"数据提交成功，请等待审核，审核结果将发送到您提交的邮箱\"}";
				}
			}
			//{"message":"数据提交成功，请等待审核，审核结果将发送到您提交的邮箱"}
		}catch(Exception ee) {
			return "{\"message\":\"数据提交失败，请检查数据格式是否符合要求\"}";
		}
		return resultvalue;
	}
	
	/*
	 * 通过输入的图片数据获取图片中包含的人脸数据
	 * @param inpicdata 输入的图片数据
	 */
	public String detectfaces(String inpicdata) {
		String resultvalue="";
		//{"userreg":"00000000000000000000000000000000","picdatas":[{"picname":"123-赖桂显","picdata":"图片base64加密字符串"},{"picname":"123-张三","picdata":"图片base64加密字符串"}]}
		try {
			JSONObject inpicdataobj = null;
			JSONArray picdatasary = null;
			JSONObject picdataobj = null;
			inpicdataobj = new JSONObject(inpicdata);//将输入的字符串转为json对象
			String userreg=inpicdataobj.getString("userreg");//获取用户识别串
			if(userreg==null || userreg.length()==0) {
				return "{\"status\":\"识别失败\",\"mainmessage\":\"请输入用户识别串\",\"detectresults\":[]}";
			}
			String photobasepathspec=photobasepath+userreg+"\\";
			File photobasepathspecf=new File(photobasepathspec);
			if((!photobasepathspecf.exists())||(!photobasepathspecf.isDirectory())){
				return "{\"status\":\"识别失败\",\"mainmessage\":\"错误的用户识别串\",\"detectresults\":[]}";
			}
			picdatasary = inpicdataobj.getJSONArray("picdatas");//获取图片数据
			for(int i=0;i<picdatasary.length();i++){//遍历图片数据
				String detvaluestr="";//检测到的人脸识别结果累加字符串
				picdataobj = picdatasary.getJSONObject(i);
				String picname=picdataobj.getString("picname");//获取人脸识别字符串
				String picdata=picdataobj.getString("picdata");//获取图片数据，此时是base64字符串
				String tocomparepath=photobasepathspec+picname+".jpg";//待比对的人脸图片路径
				File tocomparepathf=new File(tocomparepath);
				if((!tocomparepathf.exists())||(!tocomparepathf.isFile())) {
					return "{\"status\":\"识别失败\",\"mainmessage\":\"第"+i+"个图片在人脸库里面没有记录\",\"detectresults\":[]}";
				}
				//生成新的文件名
				String fileNamestr = new SimpleDateFormat("yyyyMMddHHmmss").format(new Date())+ new Random().nextInt();
				String fileName = fileNamestr + ".jpg";
				//将传入的base64转成图片
				if(new base64class().Base64ToImage(picdata, comparepath+fileName)){
					//检测并获取传入图片的人脸数
					String[] sepfacesres=new getFaceDetector().detectFace(comparepath+fileName, 1);
					if(sepfacesres[2].equals("符合识别条件")) {//如果符合识别条件：存在人脸且符合detecttype的要求
						String[] sepfacespath=sepfacesres[0].split(",");//获取识别出的人脸截图列表
						
						for(int j=0;j<1;j++) {//遍历截取出来的人脸路径
							
							//生成新的文件名
							String dofileNamestr = new SimpleDateFormat("yyyyMMddHHmmss").format(new Date())+ new Random().nextInt();
							//用于读取识别值
							String detectvalue="";
							//生成识别文件
							new htmlpar().writeTxtFile(tocomparepathf+","+sepfacespath[j], comparepath+"tocompare"+dofileNamestr+".txt");
							boolean havedone=false;//已经被识别完毕
							while(!havedone){
							    File isdonefile=new File(comparepath+"tocompare"+dofileNamestr+".txt.done");
							    if(isdonefile.exists()){
							       havedone=true;
							       detectvalue=new htmlpar().readTxtFile(comparepath+"tocompare"+dofileNamestr+".txt.done").trim();
							       //isdonefile.delete();//删除识别结果文件
							    }
							}
							//删除识别文件
							File todetectfile=new File(comparepath+"tocompare"+dofileNamestr+".txt");
							todetectfile.delete();
							if(detectvalue.length()>0 && detectvalue.lastIndexOf("\\")>0){
								detectvalue=detectvalue.substring(detectvalue.lastIndexOf("\\")+1);
								if(detectvalue.indexOf(",")>0){
									if(Float.parseFloat(detectvalue.substring(detectvalue.indexOf(",")+1))<0.7){
										detvaluestr="一致";
										//resultstr=new pubclass().decodeUTF8(resultstr);
									}else {
										detvaluestr="不一致";
									}
								}
							}
							//删除待识别人脸（因为已经识别了）
							File sepgetfacefile=new File(sepfacespath[j]);
							//sepgetfacefile.delete();
						}
					}
					
					//删除传入base64数据转成的图片（已经识别完成可以删除了）
					File inbase64picfile=new File(comparepath+fileName);
					//inbase64picfile.delete();
					
					if(detvaluestr.length()>0) {
						resultvalue=resultvalue+(resultvalue.length()>0?",":"")+"{\"message\":\"识别成功\",\"detvalue\":\""+detvaluestr+"\"}";
					}else {
						if(sepfacesres[2].equals("符合识别条件"))
							resultvalue=resultvalue+(resultvalue.length()>0?",":"")+"{\"message\":\"不一致\",\"detvalue\":\"\"}";
						else
							resultvalue=resultvalue+(resultvalue.length()>0?",":"")+"{\"message\":\""+sepfacesres[2]+"\",\"detvalue\":\"\"}";
					}
				}else {
					return "{\"status\":\"识别失败\",\"mainmessage\":\"第"+i+"个图片base64数据在转成图片时出错，请检查\",\"detectresults\":[]}";
				}
			}
			//{"status":"success","message":"success","detectresults":[{"message":"识别成功","detvalue":"一致"},{"message":"不符合识别条件，多于一个人脸","detvalue":""}]}
		}catch(Exception ee) {
			return "{\"status\":\"识别失败\",\"mainmessage\":\"请检查数据是否按要求的格式输入\",\"detectresults\":[]}";
		}
		if(resultvalue.length()>0) {
			resultvalue="{\"status\":\"识别成功\",\"mainmessage\":\"识别成功\",\"detectresults\":["+resultvalue+"]}";
		}
		return resultvalue;
	}
	
	/*
	 * 通过输入的图片数据获取图片中包含的人脸数据
	 * @param inpicdata 输入的图片数据
	 */
	public String checkfaces(String inpicdata) {
		String resultvalue="";
		String photobasepath=comparepath+"photobase\\";
		//{"userreg":"00000000000000000000000000000000","detecttype":"0","picdatas":[{"picdata":"图片base64加密字符串"},{"picdata":"图片base64加密字符串"}]}
		try {
			JSONObject inpicdataobj = null;
			JSONArray picdatasary = null;
			JSONObject picdataobj = null;
			inpicdataobj = new JSONObject(inpicdata);//将输入的字符串转为json对象
			int detecttype=Integer.parseInt(inpicdataobj.getString("detecttype"));//获取识别类型
			String userreg=inpicdataobj.getString("userreg");//获取用户识别串
			if(userreg==null || userreg.length()==0) {
				return "{\"status\":\"识别失败\",\"mainmessage\":\"请输入用户识别串\",\"detectresults\":[]}";
			}
			String photobasepathspec=photobasepath+userreg+"\\";
			File photobasepathspecf=new File(photobasepathspec);
			if((!photobasepathspecf.exists())||(!photobasepathspecf.isDirectory())){
				return "{\"status\":\"识别失败\",\"mainmessage\":\"错误的用户识别串\",\"detectresults\":[]}";
			}
			picdatasary = inpicdataobj.getJSONArray("picdatas");//获取图片数据
			for(int i=0;i<picdatasary.length();i++){//遍历图片数据
				String detvaluestr="";//检测到的人脸识别结果累加字符串
				picdataobj = picdatasary.getJSONObject(i);
				String picdata=picdataobj.getString("picdata");//获取图片数据，此时是base64字符串
				//生成新的文件名
				String fileNamestr = new SimpleDateFormat("yyyyMMddHHmmss").format(new Date())+ new Random().nextInt();
				String fileName = fileNamestr + ".jpg";
				//将传入的base64转成图片
				if(new base64class().Base64ToImage(picdata, comparepath+fileName)){
					//检测并获取传入图片的人脸数
					String[] sepfacesres=new getFaceDetector().detectFace(comparepath+fileName, detecttype);
					if(sepfacesres[2].equals("符合识别条件")) {//如果符合识别条件：存在人脸且符合detecttype的要求
						String[] sepfacespath=sepfacesres[0].split(",");//获取识别出的人脸截图列表
						for(int j=0;j<sepfacespath.length;j++) {//遍历截取出来的人脸路径
							
							//生成新的文件名
							String dofileNamestr = new SimpleDateFormat("yyyyMMddHHmmss").format(new Date())+ new Random().nextInt();
							//用于读取识别值
							String detectvalue="";
							//生成识别文件
							new htmlpar().writeTxtFile(sepfacespath[j]+"\n"+userreg, comparepath+"tocompare"+dofileNamestr+".txt");
							boolean havedone=false;//已经被识别完毕
							while(!havedone){
							    File isdonefile=new File(comparepath+"tocompare"+dofileNamestr+".txt.done");
							    if(isdonefile.exists()){
							       havedone=true;
							       detectvalue=new htmlpar().readTxtFile(comparepath+"tocompare"+dofileNamestr+".txt.done").trim();
							       //isdonefile.delete();//删除识别结果文件
							    }
							}
							//删除识别文件
							File todetectfile=new File(comparepath+"tocompare"+dofileNamestr+".txt");
							todetectfile.delete();
							if(detectvalue.length()>0 && detectvalue.lastIndexOf("\\")>0){
								detectvalue=detectvalue.substring(detectvalue.lastIndexOf("\\")+1);
								if(detectvalue.indexOf(",")>0){
									if(Float.parseFloat(detectvalue.substring(detectvalue.indexOf(",")+1))<0.7){
										detectvalue=detectvalue.substring(0,detectvalue.indexOf(",")-4);
										detvaluestr=detvaluestr+(detvaluestr.length()>0?",":"")+detectvalue;
										//resultstr=new pubclass().decodeUTF8(resultstr);
									}
								}
							}
							//删除待识别人脸（因为已经识别了）
							File sepgetfacefile=new File(sepfacespath[j]);
							sepgetfacefile.delete();
						}
					}
					
					//删除传入base64数据转成的图片（已经识别完成可以删除了）
					File inbase64picfile=new File(comparepath+fileName);
					inbase64picfile.delete();
					
					if(detvaluestr.length()>0) {
						resultvalue=resultvalue+(resultvalue.length()>0?",":"")+"{\"message\":\"识别成功\",\"detvalue\":\""+detvaluestr+"\"}";
					}else {
						if(sepfacesres[2].equals("符合识别条件"))
							resultvalue=resultvalue+(resultvalue.length()>0?",":"")+"{\"message\":\"图片库中找不到匹配的记录\",\"detvalue\":\"\"}";
						else
							resultvalue=resultvalue+(resultvalue.length()>0?",":"")+"{\"message\":\""+sepfacesres[2]+"\",\"detvalue\":\"\"}";
					}
				}else {
					return "{\"status\":\"识别失败\",\"mainmessage\":\"第"+i+"个图片base64数据在转成图片时出错，请检查\",\"detectresults\":[]}";
				}
			}
			//{"status":"success","message":"success","detectresults":[{"message":"识别成功","detvalue":"S123,B125,D126"},{"message":"不符合识别条件，多于一个人脸","detvalue":"张三,李四,王五"}]}
		}catch(Exception ee) {
			return "{\"status\":\"识别失败\",\"mainmessage\":\"请检查数据是否按要求的格式输入\",\"detectresults\":[]}";
		}
		if(resultvalue.length()>0) {
			resultvalue="{\"status\":\"识别成功\",\"mainmessage\":\"识别成功\",\"detectresults\":["+resultvalue+"]}";
		}
		return resultvalue;
	}
	
	/*
	 * 通过输入的图片数据增加人脸数据，增加了才会在人脸库里面有，才能被识别
	 * @param inpicdata 输入的图片数据
	 */
	public String addspecface(String inpicdata) {
		
		String resultvalue="";
		//{"userreg":"00000000000000000000000000000000","picdatas":[{"picname":"123-赖桂显","picdata":"图片base64加密字符串"},{"picname":"125-张三","picdata":"图片base64加密字符串"}]}
		try {
			JSONObject inpicdataobj = null;
			JSONArray picdatasary = null;
			JSONObject picdataobj = null;
			inpicdataobj = new JSONObject(inpicdata);//将输入的字符串转为json对象
			String userreg=inpicdataobj.getString("userreg");//获取用户识别串
			if(userreg==null || userreg.length()==0) {
				return "{\"status\":\"添加失败\",\"mainmessage\":\"请输入用户识别串\",\"addresults\":[]}";
			}
			String photobasepathspec=photobasepath+userreg+"\\";
			File photobasepathspecf=new File(photobasepathspec);
			if((!photobasepathspecf.exists())||(!photobasepathspecf.isDirectory())){
				return "{\"status\":\"添加失败\",\"mainmessage\":\"错误的用户识别串\",\"addresults\":[]}";
			}
			picdatasary = inpicdataobj.getJSONArray("picdatas");//获取图片数据
			for(int i=0;i<picdatasary.length();i++){//遍历图片数据
				picdataobj = picdatasary.getJSONObject(i);
				String picname=picdataobj.getString("picname");//获取图片标识
				String picdata=picdataobj.getString("picdata");//获取图片数据，此时是base64字符串
				//生成新的文件名
				String fileNamestr = new SimpleDateFormat("yyyyMMddHHmmss").format(new Date())+ new Random().nextInt();
				String fileName = fileNamestr + ".jpg";
				//将传入的base64转成图片
				if(new base64class().Base64ToImage(picdata, comparepath+fileName)){
					//检测并获取传入图片的人脸数
					String[] sepfacesres=new getFaceDetector().detectFace(comparepath+fileName, 1);
					//System.out.println("文件判断："+sepfacesres[2]);
					if(sepfacesres[2].equals("符合识别条件")) {//如果符合识别条件：存在人脸且符合detecttype的要求
						//将截出的人脸图片保存到人脸库
						FileUtils.copyFile(new File(sepfacesres[0]),new File(photobasepathspec+picname+".jpg"));
						//读取图片库图片路径字符串文件
						String detectfacestr=new getfacetool().getcomparejpgstr(photobasepath,userreg);
						//String detectfacestr=new htmlpar().readTxtFile(photobasepath+"photobase.txt").trim();
						detectfacestr=detectfacestr+(detectfacestr.indexOf(picname+".jpg")>-1?"":((detectfacestr.length()>0?",":"")+photobasepathspec+picname+".jpg"));
						//将添加后的图片路径字符串写回图片库图片路径字符串文件
						//new htmlpar().writeTxtFile(detectfacestr, photobasepath+"photobase.txt");
						RedisUtil ru=new RedisUtil().getRu();
						ru.set(userreg, detectfacestr);
						//删除截出的暂时保存的人脸（因为已经复制到人脸库了）
						File sepgetfacefile=new File(sepfacesres[0]);
						sepgetfacefile.delete();
					}else {
						resultvalue=resultvalue+(resultvalue.length()>0?",":"")+"{\"message\":\""+sepfacesres[2]+"\"}";
					}
					
					//删除传入base64数据转成的图片（已经识别完成可以删除了）
					File inbase64picfile=new File(comparepath+fileName);
					inbase64picfile.delete();
					
					resultvalue=resultvalue+(resultvalue.length()>0?",":"")+"{\"message\":\"添加成功\"}";
				}else {
					return "{\"status\":\"添加失败\",\"mainmessage\":\"第"+i+"个图片base64数据在转成图片时出错，请检查\",\"addresults\":[]}";
				}
			}
			//{"status":"success","message":"success","addresults":[{"message":"添加成功"},{"message":"不符合识别条件，多于一个人脸"}]}
		}catch(Exception ee) {
			return "{\"status\":\"添加失败\",\"mainmessage\":\"请检查数据是否按要求的格式输入\",\"addresults\":[]}";
		}
		if(resultvalue.length()>0) {
			resultvalue="{\"status\":\"添加成功\",\"mainmessage\":\"添加成功\",\"addresults\":["+resultvalue+"]}";
		}
		return resultvalue;
	}
}