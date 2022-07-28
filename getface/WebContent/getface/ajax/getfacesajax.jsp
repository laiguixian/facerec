<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@  page import="java.util.Date" import="java.text.DateFormat"
	import="java.text.SimpleDateFormat"%>
<%@page import="java.text.DecimalFormat"%>
<%@page import="org.apache.commons.fileupload.servlet.ServletFileUpload"%>
<%@page import="org.apache.commons.fileupload.disk.DiskFileItemFactory"%>
<%@page import="org.apache.commons.fileupload.FileItemFactory"%>
<%@page import="java.io.File"%>
<%@page import="java.io.FileReader"%>
<%@page import="java.io.FileWriter"%>
<%@page import="java.util.Random"%>
<%@page import="org.apache.commons.fileupload.FileItem"%>
<%@page import="com.tdr.getface.getFaceDetector"%>
<%@page import="com.tdr.getface.htmlpar"%>
<%@page import="com.tdr.getface.pubclass"%>
<%
	request.setCharacterEncoding("utf-8");
	response.setCharacterEncoding("utf-8");
	FileItemFactory factory = new DiskFileItemFactory();
	ServletFileUpload upload = new ServletFileUpload(factory);
	String comparepath="E:\\chuangyelei\\ruanjian\\facenet\\compare\\";
	String resultstr="";
	//从请求对象中获取文件信息
	System.out.println("执行到此1");
	//System.out.println("文件："+request.getParameter("picpost"));
	List items = upload.parseRequest(request);
	if (items != null) {
		for (int i = 0; i < items.size(); i++) {
			Iterator iterator = items.iterator();
			while (iterator.hasNext()) {
				FileItem item = (FileItem) iterator.next();
					/* if (item.isFormField()) {
						System.out.println("执行到:"+item.getName());
						continue;
					} else { */
						System.out.println("执行到此3");
						String oldfileName = item.getName();
						System.out.println("名称："+item.getFieldName());
						//if(pubclass.filenotupload(notuploadext.toUpperCase(), oldfileName.toUpperCase())){
						//	out.print("<script>alert(' 不支持该文件的上传，请重新选择！');</script>");
						//}else{					
							if(item.getFieldName().trim().equals("picfile")){//遍历到的是文件
								double fileSize = item.getSize()/ (1024.0 * 1024.0);
								fileSize = Double.parseDouble(new DecimalFormat(".000").format(fileSize));
								//int pos = oldfileName.lastIndexOf(".");
								//String ext = oldfileName.substring(pos,oldfileName.length());
								//String oldname = oldfileName.substring(0, pos);
								String fileNamestr = new SimpleDateFormat("yyyyMMddHHmmss").format(new Date())+ new Random().nextInt();
								String fileName = fileNamestr + ".jpg";
								File saveFile = new File(comparepath, fileName);
								//System.out.println(resourcefile);
								System.out.println(fileName);
								//String sourcetype = saveFile.getName().substring(saveFile.getName().lastIndexOf("."));
								item.write(saveFile);
								/* new htmlpar().writeTxtFile(comparepath+fileName, comparepath+"tocompare"+fileNamestr+".txt");
								boolean havedone=false;//已经被识别完毕
								while(!havedone){
								    File isdonefile=new File(comparepath+"tocompare"+fileNamestr+".txt.done");
								    if(isdonefile.exists()){
								       havedone=true;
								       resultstr=new htmlpar().readTxtFile(comparepath+"tocompare"+fileNamestr+".txt.done").trim();
								    }
								} */
								//new getFaceDetector().getfacesfile(comparepath+fileName);
								//System.out.println(comparepath+fileName+","+comparepath+fileName+".jpg");
								//new getFaceDetector().detectEye(comparepath+fileName, comparepath+fileName+".jpg");
								new getFaceDetector().detectEye("F:\\123.jpg", "F:\\123.jpg");
							}/* else if(item.getFieldName().trim().equals("picrect")){//遍历到的是坐标{
							    System.out.println("获取的坐标："+item.getString());
							    
							} */
							
							
					//}		
			}
		}
	}
	if(resultstr.length()>0 && resultstr.lastIndexOf("/")>0){
		resultstr=resultstr.substring(resultstr.lastIndexOf("/")+1);
		System.out.println("数值:"+resultstr.substring(resultstr.indexOf(",")+1));
		if(resultstr.indexOf(",")>0){
			if(Float.parseFloat(resultstr.substring(resultstr.indexOf(",")+1))<0.7){
				resultstr=resultstr.substring(0,resultstr.indexOf(",")-4);
				//resultstr=new pubclass().decodeUTF8(resultstr);
			}else{
			    resultstr="查无此人";
			}
		}else{
			    resultstr="查无此人";
		}
	}else{
		resultstr="查无此人";
	}
	//out.print(resultstr);
	out.print("次日");
	System.out.println("执行到此2:"+resultstr);
%>