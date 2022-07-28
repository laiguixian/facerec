package com.tdr.getface;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.io.File;
import java.net.URLDecoder;

import javax.servlet.http.HttpServlet;

//import org.jboss.weld.context.ApplicationContext;

public class pubclass {
	
	public String getapppath() {// 获取项目目录
		String path = "";
		try {
			path = URLDecoder.decode(
					this.getClass().getResource("/").getPath(), "gb2312");
		} catch (UnsupportedEncodingException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}// 获取class存放目录
		path = path.toUpperCase();
		if(path.substring(0,1).equals("/"))
			path=path.substring(1);
		path = path.substring(0, path.lastIndexOf("CLASSES") - 1);
		path = path.substring(0, path.lastIndexOf("WEB-INF") - 1);
		if (path.substring(path.length() - 1).equals("/") == false) {
			path = path + "/";
		}
		return path;
	}
	
	public String getprorootpath() {// 获取项目�?��的根目录
		String path = "";
		try {
			path = URLDecoder.decode(
					this.getClass().getResource("/").getPath(), "gb2312");
		} catch (UnsupportedEncodingException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}// 获取class存放目录
		path = path.toUpperCase();
		if(path.substring(0,1).equals("/"))
			path=path.substring(1);
		String returnpath=path.substring(0, path.indexOf("/"))+"\\";
		return returnpath;
	}
	
	public String getopenofficedealpath() {// 获取tomcat的web目录
		String path=getprorootpath();
		String ypoofdealpath=path+"ypoofdeal\\";
		return ypoofdealpath;
	}
	
	public String getinipath() {// 获取tomcat的web目录
		String path=getapppath();
		String inipath=path.substring(0, path.indexOf("/WEBAPPS/"))+"/webapps/";
		return inipath;
	}
	
	/**
     * 递归删除目录下的�?��文件及子目录下所有文�?
     * @param dir 将要删除的文件目�?
     * @return boolean Returns "true" if all deletions were successful.
     *                 If a deletion fails, the method stops attempting to
     *                 delete and returns "false".
     */
	public boolean deleteDir(File dir) {
        if (dir.isDirectory()) {
            String[] children = dir.list();
            //递归删除目录中的子目录下
            for (int i=0; i<children.length; i++) {
                boolean success = deleteDir(new File(dir, children[i]));
                if (!success) {
                    return false;
                }
            }
        }
        // 目录此时为空，可以删�?
        return dir.delete();
    }

	
	/*
	public String getfilesavepath() { // 进行转码操作的方�?
		String filesavepath="";
		IniReader reader;
		try {
			reader = new IniReader(getinipath() + "ypcyzqconfig.ini");//System.out.println(getinipath() + "jyxmjxconfig.ini");
			//System.out.println(replaceall(reader.getValue("databasecon", "filesavepath"),"\\","/"));
			filesavepath=replaceall(reader.getValue("databasecon", "filesavepath"),"\\","/");
			if(filesavepath.charAt(filesavepath.length()-1)!='/'){
				filesavepath=filesavepath+"/";
			}
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		//System.out.println("filesavepath:"+filesavepath);
		return filesavepath;
	}

	public String getlanguage() { // 进行转码操作的方�?
		String returnlan="chn1";
		IniReader reader;
		try {
			reader = new IniReader(getinipath() + "ypcyzqconfig.ini");//System.out.println(getinipath() + "jyxmjxconfig.ini");
			//System.out.println(replaceall(reader.getValue("databasecon", "filesavepath"),"\\","/"));
			returnlan=reader.getValue("systemset", "language");
			if((returnlan==null)||(returnlan.length()<=0))
				returnlan="chn1";
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		//System.out.println("filesavepath:"+filesavepath);
		return returnlan;
	}
	
	public String getspepicopentype() { // 进行转码操作的方�?
		String spepicopentype="web";
		IniReader reader;
		try {
			reader = new IniReader(getinipath() + "ypcyzqconfig.ini");//System.out.println(getinipath() + "jyxmjxconfig.ini");
			//System.out.println(replaceall(reader.getValue("databasecon", "filesavepath"),"\\","/"));
			spepicopentype=reader.getValue("systemset", "spepicopentype");
			if((spepicopentype==null)||(spepicopentype.length()<=0))
				spepicopentype="web";
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		//System.out.println("filesavepath:"+filesavepath);
		return spepicopentype;
	}

	public String getYoyatouchmovie() { //从ini里边获取机构代码和密�?
		String returnyoya="jxds;58ae7feebb0ec1253942b94600000000";
		IniReader reader;
		try {
			reader = new IniReader(getinipath() + "ypcyzqconfig.ini");//获取系统相关文件
			returnyoya=reader.getValue("yoyatouchmovie", "org")+";"+reader.getValue("yoyatouchmovie", "key")+";"+reader.getValue("yoyatouchmovie", "serviceurl");
			
			if((returnyoya==null)||(returnyoya.length()<=0))
				returnyoya="jxds;58ae7feebb0ec1253942b94600000000";
		} catch (IOException e) {
			e.printStackTrace();
		}
		return returnyoya;
	}
	*/
	/*//从ini里边获取表单设计器的�?��模块------表单设计�?
	public String getModule() {
		String returnmodule="系统管理,部门管理,考核评测,项目管理,资源管理,活动管理";
		IniReader reader;
		try {
			reader = new IniReader(getinipath() + "ypcyzqconfig.ini");//获取系统相关文件
			returnmodule=reader.getValue("property", "promodule");
			if((returnmodule==null)||(returnmodule.length()<=0))
				returnmodule="系统管理,部门管理,考核评测,项目管理,资源管理,活动管理";
		} catch (IOException e) {
			e.printStackTrace();
		}
		return returnmodule;
	}*/
	/*//从ini里边获取部门管理的部门类�?-----部门管理树型节点
	public String getDepartmentType() {
		String returndeptype="学校,学院,系部,专业,班级,人员";
		IniReader reader;
		try {
			reader = new IniReader(getinipath() + "ypcyzqconfig.ini");//获取系统相关文件
			returndeptype=reader.getValue("property", "departmenttype");
			if((returndeptype==null)||(returndeptype.length()<=0))
				returndeptype="学校,学院,系部,专业,班级,人员";
		} catch (IOException e) {
			e.printStackTrace();
		}
		return returndeptype;
	}*/
	/*//从ini里边获取部门管理的部门类�?-----部门管理树型节点
	public String getActivityType() {
		String returnacttype="比赛,讲座,培训,论坛";
		IniReader reader;
		try {
			reader = new IniReader(getinipath() + "ypcyzqconfig.ini");//获取系统相关文件
			returnacttype=reader.getValue("property", "activitytype");
			if((returnacttype==null)||(returnacttype.length()<=0))
				returnacttype="比赛,讲座,培训,论坛";
		} catch (IOException e) {
			e.printStackTrace();
		}
		return returnacttype;
	}*/
	/*//从ini里边获取表单设计器的多表统计和正表统计的数据------表单设计�?
	public String getTabstatistics() {
		String returntabsta="�?平均,总和,�?��,�?��";
		IniReader reader;
		try {
			reader = new IniReader(getinipath() + "ypcyzqconfig.ini");//获取系统相关文件
			returntabsta=reader.getValue("property", "tabstatistics");
			if((returntabsta==null)||(returntabsta.length()<=0))
				returntabsta="�?平均,总和,�?��,�?��";
		} catch (IOException e) {
			e.printStackTrace();
		}
		return returntabsta;
	}

	public String getPosition(){
		String returnposi="false";
		IniReader reader;
		try {
			reader = new IniReader(getinipath() + "ypcyzqconfig.ini");//获取系统相关文件
			returnposi=reader.getValue("systemset", "location");
			
			if((returnposi==null)||(returnposi.length()<=0))
				returnposi="false";
		} catch (IOException e) {
			e.printStackTrace();
		}
		return returnposi;
	}
	*/
	
	public boolean fileallowupload(String upfilename){
		String notallowext=",exe,dll,jsp,asp,php,java,js,xml,html,htm,shtml,perl,cgi,c,h,class,dhtml,xhtml,shtm,xhtm,";
		String upfileext=upfilename.substring(upfilename.lastIndexOf(".")+1);
		if(notallowext.indexOf(","+upfileext+",")>-1)
			return false;
		else
			return true;
	}
	
	public boolean filenotupload(String suffixs,String upfilename){
		String[] sufStrings=suffixs.split(";");
		for(int i=0;i<sufStrings.length;i++){
			if(upfilename.endsWith(sufStrings[i])){
				return true;				
			}
		}
		return false;
	}
	
	
	public String toChinese(String str) { // 进行转码操作的方�?
		if (str == null)
			str = "";
		try {
			str = new String(str.getBytes("ISO-8859-1"), "gb2312");
		} catch (UnsupportedEncodingException e) {
			str = "";
			e.printStackTrace();
		}
		return str;
	}

	public String decodeUTF8(String str) { // 进行转码操作的方�?
		if (str == null)
			str = "";
		try {
			if(!(str.equals(""))){
				str=str.trim();
			}
			if(str.equals(new String(str.getBytes("ISO-8859-1"), "ISO-8859-1"))){
				str = new String(str.getBytes("ISO-8859-1"), "utf-8");
			}
		} catch (UnsupportedEncodingException e) {
			str = "";
			e.printStackTrace();
		}
		return str;
	}
	//将null转换为空，并去左右空�?
	public String toStr(String str) { // 将null转换�?"的方�?
		if (str == null)
			str = "";
		else 
			str = str.trim();
		return str;
	}
	//将Object类型的null转换为空，并去左右空�?
	public String toObjStr(Object str) { // 将null转换�?"的方�?
		String newstr = "";
		if (str == null)
			newstr = "";
		else 
			newstr = str.toString().trim();
		return newstr;
	}

	public String getwhereconvertlikesql(String sqlwhere, String columnname,
			String columnvalue) {// 以like方式获取sql语句中where部分
		if ((columnvalue != null) && (columnvalue.length() > 0)) {
			if (sqlwhere.length() <= 0) {
				sqlwhere = sqlwhere + " CONVERT(varchar(100), " + columnname
						+ ", 20) like '%" + columnvalue + "%'";
			} else {
				sqlwhere = sqlwhere + " and  CONVERT(varchar(100), "
						+ columnname + ", 20) like '%" + columnvalue + "%'";
			}
		}
		return sqlwhere;
	}

	public String getwherelikesql(String sqlwhere, String columnname,
			String columnvalue) {// 以like方式获取sql语句中where部分
		if ((columnvalue != null) && (columnvalue.length() > 0)) {
			if (sqlwhere.length() <= 0) {
				sqlwhere = sqlwhere + " " + columnname + " like '%"
						+ columnvalue + "%'";
			} else {
				sqlwhere = sqlwhere + " and " + columnname + " like '%"
						+ columnvalue + "%'";
			}
		}
		return sqlwhere;
	}

	public String getwhereequssql(String sqlwhere, String columnname,
			String columnvalue) {// 以等于方式获取sql语句中where部分
		if ((columnvalue != null) && (columnvalue.length() > 0)) {
			if (sqlwhere.length() <= 0) {
				sqlwhere = sqlwhere + " " + columnname + " = '" + columnvalue
						+ "'";
			} else {
				sqlwhere = sqlwhere + " and " + columnname + " = '"
						+ columnvalue + "'";
			}
		}
		return sqlwhere;
	}

	public String getupdatesetsql(String updatesql,
			String loginusergongnengstr, String xianshistr, String baocunstr,
			String columnname, String columnvalue) {// 以Update,set方式获取sql语句中set后面部分
		if ((loginusergongnengstr.indexOf(xianshistr) >= 0)
				&& (loginusergongnengstr.indexOf(baocunstr) >= 0)) {
			if (updatesql.length() <= 0) {
				updatesql = updatesql + columnname + "='" + columnvalue + "'";
			} else {
				updatesql = updatesql + "," + columnname + "='" + columnvalue
						+ "'";
			}
		}
		return updatesql;
	}

	public String getinsertcolumnnamesql(String insertcolumnnamesql,
			String loginusergongnengstr, String xianshistr, String baocunstr,
			String columnname) {// 以Update,set方式获取sql语句中set后面部分
		if ((loginusergongnengstr.indexOf(xianshistr) >= 0)
				&& (loginusergongnengstr.indexOf(baocunstr) >= 0)) {
			if (insertcolumnnamesql.length() <= 0) {
				insertcolumnnamesql = insertcolumnnamesql + columnname;
			} else {
				insertcolumnnamesql = insertcolumnnamesql + "," + columnname;
			}
		}
		return insertcolumnnamesql;
	}

	public String getinsertcolumnvaluesql(String insertcolumnnamesql,
			String loginusergongnengstr, String xianshistr, String baocunstr,
			String columnvalue) {// 以Update,set方式获取sql语句中set后面部分
		if ((loginusergongnengstr.indexOf(xianshistr) >= 0)
				&& (loginusergongnengstr.indexOf(baocunstr) >= 0)) {
			if (insertcolumnnamesql.length() <= 0) {
				insertcolumnnamesql = insertcolumnnamesql + "'" + columnvalue
						+ "'";
			} else {
				insertcolumnnamesql = insertcolumnnamesql + ",'" + columnvalue
						+ "'";
			}
		}
		return insertcolumnnamesql;
	}

	public void deletefile(String filename) {
		File file = new File(filename);
		if (file.exists()) {
			file.delete();
		}
	}

	public String getstringrs(ResultSet inrs, String findlabel) {
		String returnvalue = "";
		try {
			if (inrs.getRow() > 0) {
				returnvalue = inrs.getString(findlabel);
				if (returnvalue != null && returnvalue.length() > 0) {
					returnvalue = inrs.getString(findlabel).trim();
				}
				if (returnvalue == null)
					returnvalue = "";
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return returnvalue;
	}

	public int gotorecord(ResultSet inrs, String findlabel, String findvalue,
			String findtype) {
		int returnrow = 0;
		int rowid = 0;
		boolean continuefind = true;
		String nowvalue = "";
		try {
			inrs.beforeFirst();// inrs.last();//System.out.println("�?+inrs.getRow()+"�?);
			while (continuefind && (inrs.next())) {
				rowid = rowid + 1;
				nowvalue = getstringrs(inrs, findlabel);
				// System.out.println(findtype+";"+findtype.length());
				if (findtype.equals("all")) {
					if (nowvalue.equals(findvalue)) {
						returnrow = rowid;
						continuefind = false;
					}
				} else if (findtype.equals("part")) {
					if (nowvalue.indexOf(findvalue) > -1) {
						returnrow = rowid;
						continuefind = false;
					}
				}
			}
		} catch (Exception ex) {
			rowid = 0;
		}
		return returnrow;
	}

	public String getmenustr(ResultSet inrs, String menudot) {
		String returnstr = "";
		if (gotorecord(inrs, "proxy", "CR", "all") > 0) {
			returnstr = getstringrs(inrs, "name");
		}
		return returnstr;
	}

	public String checksel(ResultSet inresultset, String fieldname,
			String invalue) {
		String returnvalue = "";
		if (getstringrs(inresultset, fieldname).equals(invalue)) {
			returnvalue = " selected=\"selected\"";
		}
		return returnvalue;
	}
	
	public String replaceall(String instring,String olddot,String newdot){
		String returnstring="";
		String inpstring=instring;
		while(inpstring.indexOf(olddot)>-1){
			inpstring=inpstring.replace(olddot, newdot);
		}
		returnstring=inpstring;
		return returnstring;
	}
	
	//分页-----�?��-----totalcount：�?记录数，pagerow：每页显示的记录数，pagenostr：当前页�?
	public String total_noPage(int totalcount,int pagerow,String pagenostr){
		int pageno=0;      //当前页数
		int totalpage=0;     //总页�?
		String total_noStr="";    //当前页数+","+总页�?
		if (pagenostr != null && !"".equals(pagenostr)&&!"null".equals(pagenostr)) {
			pageno = Integer.parseInt(pagenostr);
		} else {
			pageno = 1;
		}
		if (pagerow > totalcount) {
			pagerow = totalcount;
		}
		int modi, divi;
		if (pagerow > 0) {
			modi = totalcount % pagerow;
		}//取余，如果余数大�?则在取整的基�?��加一�?
		else {
			modi = 0;
		}
		if (pagerow > 0) {
			divi = totalcount / pagerow;
		}//取整，取得的数是有满数据页的页数
		else {
			divi = 0;
		}
		if (modi > 0) {
			totalpage = divi + 1;
		} else {
			totalpage = divi;
		}
		if (pageno > totalpage) {
			pageno = totalpage;
		}
		if(pageno<=0)
			pageno=1;
		total_noStr=pageno+","+totalpage+","+pagerow;
		return total_noStr; 
	}
	//分页-----结束
	
	//创建将字符串中的数据进行排序的方�? 
    public static String sortString(String s){    
    	System.out.println("排序前的字符串："+s);
        //将字符串进行分割，转成字符串数组  
        String[] c = s.split(";");   
        //对int数组中的元素进行排序  
        sortIntArray(c);  
        //将int数组转换为字符串输出  
        String str=intArrayToString(c);
        System.out.println("排序后的字符串："+str);
        return str;
    } 
    //对int数组进行排序  
    private static void sortIntArray(String[] arr){    
        for(int i =0;i<arr.length-1;i++){  
            for(int j=i+1;j<arr.length;j++){  
                if(Integer.parseInt(arr[i].split(",")[0])>Integer.parseInt(arr[j].split(",")[0]))  
                    swap(arr,i,j);  
            }  
        }  
    }  
    //对数据进行交�?  
    private static void swap(String[] arr,int i, int j) {  
        String temp = arr[i];  
        arr[i] = arr[j];  
        arr[j]= temp;  
    }
    //将int数组中的元素转成字符串并输出  
    private static String intArrayToString(String[] arr)  
    {   
        String sb = ""; 
        for(int i =0;i<arr.length;i++){  
        	sb=sb+arr[i]+";";  
        }
        return sb;
    }
    //去除重复数据
    public static String noRepeat(String str){ 
    	if(!"".equals(str)){
    		List<String> data = new ArrayList<String>();
            for (int i = 0; i < str.split(",").length; i++) {
                if (!data.contains(str.split(",")[i])) {
                    data.add(str.split(",")[i]);
                }
            }
            String result = "";
            for (String s : data) {
                result = result+(result.length()>0?",":"")+s;
            }
            return result;
    	}else{
    		return "";
    	} 
    }
    
  
  //判断是否是私有资�?
    public boolean isprivatesource(String instring,String stardstring){
    	 String[]  starstringarr=stardstring.split(",");
    	 String[]  instringarr=instring.split(",");
	   	 for(int i=0;i<starstringarr.length;i++){
	   		 for(int j=0;j<instringarr.length;j++){
	   			 if(starstringarr[i].equals(instringarr[j])){
	   				 return true;
	   			 }
	   		 } 
	   	 }
	   	 return false;
    }
}









