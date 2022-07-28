package com.tdr.getface;

import java.io.IOException;
import java.util.Collection;
import java.util.Enumeration;
import java.util.Iterator;
import java.util.List;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class CORSFilter implements Filter{
    private boolean isCross = false;

    @Override
    public void destroy() {
        // TODO Auto-generated method stub
        isCross = false;
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response,
            FilterChain chain) throws IOException, ServletException {
        // TODO Auto-generated method stub
        if(isCross){
            //设置允许跨域访问开始
        	HttpServletRequest httpServletRequest = (HttpServletRequest)request;
            HttpServletResponse httpServletResponse = (HttpServletResponse)response;
            System.out.println("拦截请求: "+httpServletRequest.getServletPath());
            Enumeration<String> inhds=httpServletRequest.getHeaderNames();
            //Iterator its = inhds.iterator();
            while (inhds.hasMoreElements()) {
            	String inname=inhds.nextElement();
            	String inhd=httpServletRequest.getHeader(inname);
	            System.out.println(inname+": " + inhd);
            }
            String origin=httpServletRequest.getHeader("origin");
            String accesscontrolrequestheaders=httpServletRequest.getHeader("access-control-request-headers");
            System.out.println("允许头: " + origin);
            //httpServletResponse.setHeader("Access-Control-Allow-Origin", "*");
            //httpServletResponse.setHeader("Access-Control-Allow-Origin", "https://localhost:5665");
            httpServletResponse.setHeader("Access-Control-Allow-Origin", origin);//直接传进来什么，设置什么
            httpServletResponse.setHeader("Access-Control-Allow-Methods", "*");  
            //httpServletResponse.setHeader("Access-Control-Max-Age", "0");  
            //httpServletResponse.setHeader("Access-Control-Allow-Headers", "Origin, No-Cache, X-Requested-With,Access-Control-Request-Headers,accept,Access-Control-Request-Method, If-Modified-Since, Pragma, Last-Modified, Cache-Control, Expires, Content-Type, X-E4M-With,userId,token"); 
            //httpServletResponse.setHeader("Access-Control-Allow-Headers", "*");
            //httpServletResponse.setHeader("Access-Control-Allow-Headers", "content-type,soapaction");
            httpServletResponse.setHeader("Access-Control-Allow-Headers", accesscontrolrequestheaders);//直接传进来什么，设置什么
            httpServletResponse.setHeader("Access-Control-Allow-Credentials", "true");
            httpServletResponse.setHeader("XDomainRequestAllowed","1"); 
            //httpServletResponse.setHeader("Access-Control-Request-Headers","content-type");
            httpServletResponse.setHeader("Access-Control-Expose-Headers", "*");
          //设置允许跨域访问结束
        }
        chain.doFilter(request, response);
    }

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // TODO Auto-generated method stub
        String isCrossStr = filterConfig.getInitParameter("IsCross");
        isCross = isCrossStr.equals("true")?true:false;
        System.out.println(isCrossStr);
    }

}