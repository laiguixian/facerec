<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%@page import="com.tdr.getface.getfacetool"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<!doctype html>
<html>
<head>
  <meta charset="utf-8">
  <title>免费人脸识别接口源码下载</title>
  <link rel="stylesheet" href="demo.css">

  <script src="tracking/build/tracking.js"></script>
  <script src="tracking/build/data/face-min.js"></script>
  <script src="tracking/build/data/eye-min.js"></script>
  <script src="tracking/build/data/mouth-min.js"></script>
   <!-- <script src="tracking/node_modules/dat.gui/build/dat.gui.min.js"></script> -->
  <script src="tracking/examples/assets/stats.min.js"></script>
  <script src="getface/js/jquery-1.7.2.min.js"></script>

  <style>
  video, canvas {
    margin-left: 100px;
    margin-top: 35px;
    position: absolute;
  }
  
  button{
  	border-radius:5px 5px 5px 5px;
  	width:60px;
  	height:30px;
  	cursor:pointer;
  }
  
  .black_overlay{ 
            display: none; 
            position: absolute; 
            top: 0%; 
            left: 0%; 
            width: 100%; 
            height: 100%; 
            background-color: #b7bdce; 
            z-index:1001; 
            -moz-opacity: 0.8; 
            opacity:.80; 
            filter: alpha(opacity=80); 
   } 
   .white_content { 
       display: none; 
       position: absolute; 
       top: 25%; 
       left: 25%; 
       width: 55%; 
       height: 55%; 
       padding: 20px; 
       border: 10px solid orange; 
       background-color: white; 
       z-index:1002; 
       overflow: auto; 
   }
  </style>
</head>
<body>
  <div class="demo-title">
    <p>人脸识别例子，注意：本站人脸识别接口完全由本人自行开发，未使用百度，谷歌等任何其他收费或免费接口，供国内程序员和公司体验快速高效的人脸识别，提供的接口注册和使用完全免费。关于本例子的使用请点击“例子说明”按钮查看，可以点击“例子下载”下载调用接口例子的源码。电脑上建议用Chrome或Firefox浏览器，手机上建议用Firefox浏览器或UC浏览器，建议使用实际像素100万像素以上的摄像头。每天的0时至5时为维护时间，例子的图片库约每三天清理一次。</p>
  </div>
  <!-- 用于显示视频 -->
  <div class="demo-frame" id="cap-frame" class="white_content">
    <div class="demo-container">
      <video id="video" width="600" height="450" preload autoplay loop muted></video>
      <canvas id="canvas" width="600" height="450"></canvas>
      <div class="button-container" style="height:600px;width:100px;float:right;margin-top: 23px;text-align:center;">
      <button id="begindetect" onclick="begindetect()">人脸比对</button>
      <p><label></label>&nbsp<p>
      <p><label></label>&nbsp<p>
      <button id="beginsearch" onclick="beginsearch()">人脸识别</button>
      <p><label></label>&nbsp<p>
      <p><label></label>&nbsp<p>
      <button id="getspec" onclick="getspec()">提取特征</button>
      <p><label></label>&nbsp<p>
      <p><label></label>&nbsp<p>
      <button id="showexpl" onclick="showexpl()">例子说明</button>
      <p><label></label>&nbsp<p>
      <p><label></label>&nbsp<p>
      <button id="regspec" onclick="showregspec()">接口注册</button>
      <p><label></label>&nbsp<p>
      <p><label></label>&nbsp<p>
      <button id="getdoc" onclick="getdoc()">接口文档</button>
      <p><label></label>&nbsp<p>
      <p><label></label>&nbsp<p>
      <button id="downloadsource" onclick="downloadsource()">例子下载</button>
      <p><label></label>&nbsp<p>
      <p>同时识别人数：<%
      out.print(new getfacetool().getusetotal(10));//10秒内同时使用人脸识别的人数
      %>
      </div>
    </div>
    <div style="display:none"><img alt="" src="" id="img1"></div>
  </div>
  <!-- 用于提取特征值 -->
  <div id="spec-frame" class="black_overlay" style="height:100%;width:100%;">
  <div style="height:300px;width:400px;text-align:center;top:0;left:0;bottom:0;right:0;position: absolute;margin: auto;">
  <img alt="" src="" id="getimg1" name="getimg1" width="150px" height="200px">
  <p><label></label>&nbsp<p>
  输入识别标识：<input id="detectid" name="detectid" style="height:30px;width:160px"/>
  <p><label></label>&nbsp<p>
  <button id="specok" onclick="addspecok()">确认</button>&nbsp<button id="speccancel" onclick="addspeccancel()">取消</button>
  </div>
  </div>
  <!-- 用于输入特征值 -->
  <div id="specde-frame" class="black_overlay" style="height:100%;width:100%;">
  <div style="height:300px;width:400px;text-align:center;top:0;left:0;bottom:0;right:0;position: absolute;margin: auto;">
  输入识别标识：<input id="detectdeid" name="detectdeid" style="height:30px;width:160px"/>
  <p><label></label>&nbsp<p>
  <button id="detfaceok" onclick="detfaceok()">确认</button>&nbsp<button id="detfacecancel" onclick="detfacecancel()">取消</button>
  </div>
  </div>
  <!-- 用于例子说明 -->
  <div id="expl-frame" class="black_overlay" style="height:100%;width:100%;">
  <div style="height:500px;width:800px;text-align:center;top:0;left:0;bottom:0;right:0;position: absolute;margin: auto;">
  <p>本例子是人脸特征提取接口、人脸比对和人脸识别接口的例子（使用方法：先提取人脸特征，然后再进行人脸比对或人脸识别，调用例子可以下载源码自行观看，这里科普一下，特征提取是指人脸特征提取，就像人一样，只有见过了，才认识嘛，这个接口的作用就是这个；人脸比对是指同时传入需要校验的人脸的照片和之前添加的特征识别字符，然后接口判断传入的人脸照片和识别字符跟人脸库里面的记录是否一致，这接口通常用于登录验证，身份确认等，人脸识别是指不知人脸身份，只传入图片数据，然后接口从图片中找出人脸并和人脸库匹配，返回之前添加的人脸识别字符串，这接口通常用于人脸追踪（人员追踪），图片检索（在大量图片里寻找符合条件的人脸）等等），建议在电脑上运行此例子，使用一般的摄像头（经过实测30万实际像素以上就可以了，当然基于提高识别速度的原因，建议使用100万实际像素以上的摄像头，不然可能会需要很久才能捕捉到适合识别的图片）即可，接口性能：实际体验：在有3000张人脸库的环境下，以最占用资源的人脸搜索接口为例，在网络1M的情况下（无下载），摄像头80万实际像素，电脑cpu i3，内存2G的条件下测试上响应速度在2秒左右，单纯调用接口响应速度在0.5秒左右。本人脸识别接口服务器的配置：cpu i5-2320，内存：8G，显卡：GTX 750 Ti 2G，实在算不上是高配置服务器（估计也就算个入门级的低配吧（其实是台7年前用的价格在3000多元的普通家用电脑，花了几百元随便升级一下充用服务器），毕竟是免费的，也就给大家方便方便吧，有盈利再弄个好一点的吧），响应速度快完全是得益于人脸识别算法的相对好一些，需要架设人脸服务器的联系：13799291381（赖桂显）。 其他接口的使用，请自行根据文档来调用，在某些手机上使用有时视频会变成横向，调起来比较繁琐，而这只是一个例子也就不费这个劲了，自行换手机看吧。在电脑上谷歌浏览器（Chrome）和火狐浏览器（Firefox）测试通过，IE未兼容，在手机上UC浏览器测试通过，其余浏览器没有试过，亲们可以自行试一下。接口免费调用，调用方法请点击“接口文档”获取。
  <p><label></label>&nbsp<p>
  <button id="explok" onclick="closeexpl()">确认</button>
  </div>
  </div>
  <!-- 用于注册接口 -->
  <div id="reg-frame" class="black_overlay" style="height:100%;width:100%;">
  <div style="height:300px;width:230px;text-align:center;top:0;left:0;bottom:0;right:0;position: absolute;margin: auto;">
  <p><label></label>接口注册<p>
  <p><label></label>&nbsp<p>
 <p align="left"><star  style="color:red;font-size:15px;">*</star>姓名：<input id="name" name="name" style="height:20px;width:160px" title="姓名必须填写，且必须为真实姓名"/>
 <p align="left"><star  style="color:red;font-size:15px;">*</star>手机：<input id="cell" name="cell" style="height:20px;width:160px" title="手机号码必须填写，且必须为真实的自己的手机号，因为审核的时候可能会打电话核实"/>
 <p align="left"><star  style="color:red;font-size:15px;">*</star>邮箱：<input id="mail" name="mail" style="height:20px;width:160px" title="邮箱必须填写，且必须为真实的自己的邮箱，因为审核通过后会以邮件的形式发送注册识别号"/>
 <p align="left"><star  style="color:red;font-size:15px;">*</star>应用：<input id="app" name="app" style="height:20px;width:160px" title="用于标识您可能将此次注册的人脸识别注册识别号用在的软件上，这个软件可以还没有开发，但得有名字，这里填写的应用就是你的软件的名字"/>
 <p align="left"><star  style="color:red;font-size:15px;">*</star>应用描述：
 <p><textarea rows="" cols="" id="appdes" name="appdes" style="height:60px;width:210px" title="用于描述您将用在的软件的大致功能，人脸识别将用在什么功能必须描述清楚，以防止用于非法用途"></textarea>
 <p><label></label>&nbsp<p>
 <p align="left" style="color:red;font-size:15px;">注册须知：
 <textarea rows="" cols="" id="appdes" name="appdes" style="height:100px;width:220px" title="请仔细阅读注册须知">
 以上信息若有误，即使申请成功依然会被取消使用资格。本人脸识别在我们的实验室环境下，在拥有6000余张人脸数据的测试中准确率在98%-100%之间，所以针对校验用途的人脸识别，该误差范围应该是可以接受的，不能接受的请不要选择我们，谢谢，另因接口免费的缘故，我们可能在不通知您的情况下停止任何单独个人或所有人的服务，若需要稳定的服务建议联系我们架设属于您自己的专门服务。联系电话：13799291381，称呼：赖桂显，谢谢！
 </textarea>
 <p><label></label>&nbsp<p>
 <p align="left" style="color:red;font-size:15px;"><input type="checkbox" id="ikonw" id="ikonw">我已经阅读并同意注册须知
 <p><label></label>&nbsp<p>
 <p><button id="subregok" onclick="regok()">确认</button>&nbsp<button id="subregcancel" onclick="closeregspec()">取消</button>
  </div>
  </div>
  
  <script>
    var havetake=true;
    var postrect="";
    var getimgstr="";
    var captyle="识别人脸";//识别类型：识别人脸，获取特征
    var dealing=false;//正在处理中
    var gettmppic="";//获取的图像的临时数据
    var detecttimes=0;//发送后台识别的次数
    
    function dataURItoBlob(dataURI) {  
	    var byteString = atob(dataURI.split(',')[1]);  
	    var mimeString = dataURI.split(',')[0].split(':')[1].split(';')[0];  
	    var ab = new ArrayBuffer(byteString.length);  
	    var ia = new Uint8Array(ab);  
	    for (var i = 0; i < byteString.length; i++) {  
	        ia[i] = byteString.charCodeAt(i);  
	    }  
	    return new Blob([ab], {type: mimeString});
    }
    
    function trim(str) { // 删除左右两端的空格
		return str.replace(/(^\s*)|(\s*$)/g, "");
	}
    
	function ltrim(str) { // 删除左边的空格
		return str.replace(/(^\s*)/g, "");
	}
	
	function rtrim(str) { // 删除右边的空格
		return str.replace(/(\s*$)/g, "");
	}
	var errocb = function () {

        console.log('sth wrong!');

   }
	function gettimesp(){
 		  var now=new Date();
 		  return now+" "+now.getMilliseconds();
 	  }
   window.onload = function() {
      var video = document.getElementById('video');
      var canvas = document.getElementById('canvas');
      var context = canvas.getContext('2d');
      
      
      
   	  // 使用新方法打开摄像头
      var constraints = { audio: true, video: { height: 450, width: 600 } }; 

      /* navigator.mediaDevices.getUserMedia(constraints)
      .then(function(mediaStream) {
        var video = document.querySelector('video');
        video.srcObject = mediaStream;
        video.onloadedmetadata = function(e) {
          video.play();
        };
      }) */
		if (navigator.mediaDevices && navigator.mediaDevices.getUserMedia(constraints).then(function(stream) {
			video.srcObject = stream;
	        video.onloadedmetadata = function(e) {
	          video.play();
	        };
	        }).catch(function(err) {
	           //console.log(err);
	           //alert("出现错误："+err)
	        	alert("打开不了摄像头，请检查是否有摄像头或摄像头的驱动是否装好等，确保摄像头能正常连接，摄像头装好后请刷新重试");
	        })){
	    }else{ // Standard
	    	alert("打开不了摄像头，请检查是否有摄像头或摄像头的驱动是否装好等，确保摄像头能正常连接，摄像头装好后请刷新重试");
		}
      
      //探测人脸数目 -用于展示
      var tracker = new tracking.ObjectTracker(['face','eye','mouth']); // Based on parameter it will return an array.
      tracker.setInitialScale(4);
      tracker.setStepSize(1.7);//1.1-2
      tracker.setEdgesDensity(0.1);

      tracking.track('#video', tracker,{});
      tracker.on('track', function(event) {
    	  context.clearRect(0, 0, video.width, video.height);
    	  if((!havetake)&&(detecttimes<3)&&(!dealing)){
	  		if(event.data.length>1){
	  		  context.drawImage(video,0,0,canvas.width,canvas.height);
	  		  var snapData = canvas.toDataURL('image/jpeg');
	  		  detecttimes=detecttimes+1;
    		  console.log("符合条件的人脸哦"+gettimesp());
    		  if(captyle=="搜索人脸"){
    			  dealing=true;//将处理中的标志置为true，防止其他方法冲突
    			  var updata="{\"userreg\":\"00000000000000000000000000000000\",\"detecttype\":\"0\",\"picdatas\":[{\"picdata\":\""+snapData.substring(snapData.indexOf("base64,")+7)+"\"}]}";
	    		  //请求体
	    		  var soap = '<?xml version="1.0" encoding="UTF-8"?>'+
	    					 '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:get="http://getface.tdr.com">'+
							   '<soapenv:Header/>'+
							   '<soapenv:Body>'+
							      '<get:searchfaces>'+
							         '<get:inpicdata>'+updata+'</get:inpicdata>'+
							      '</get:searchfaces>'+
							   '</soapenv:Body>'+
							'</soapenv:Envelope>';
		    		
	    		  $.ajax({
	                  type: "POST",
	                  //url: "https://detectface.taiderui.com:5665/getface/services/getfacews",
	                  url: "https://192.168.6.104:5665/getface/services/getfacews",//此处输入接口地址
	                  //url: "services/getfacews",
	                  data: soap,
	                  //async: true,
	                  dataType: 'xml',
	                  headers:{
	                	  "Access-Control-Allow-Origin":"*"
	                  },
	                  beforeSend:function(request){
						  request.setRequestHeader ("Content-Type","text/xml;charset=UTF-8");
						  request.setRequestHeader ("SOAPAction","");
					  },
					  error : function(request) {
						  setbuttonenable();//将按钮置为正常（可用）
						  alert("无法连接到服务器");
						  dealing=false;//将处理中的标志置为false，以便让其他方法可以继续
						  detecttimes=3;
             			  havetake=true;
					  },
	                  success: function(data) {
	                      
	                      //解析webservice的返回值
	                	  var xmlDoc=data;
	                	  var returns = xmlDoc.getElementsByTagName('searchfacesReturn');
	                	  console.log("ws返回值："+returns[0].textContent);
	                	  //alert(returns[0].textContent);
	                	  var returnjson = eval('(' + trim(returns[0].textContent) + ')');
	                	  if(returnjson.status=="识别成功"){
	                		  if(returnjson.detectresults.length>0){
		                		  if(returnjson.detectresults[0].message=="识别成功"){
		                			  detecttimes=3;
		                			  havetake=true;
		                			  alert(returnjson.detectresults[0].detvalue);
		                			  dealing=false;//将处理中的标志置为false，以便让其他方法可以继续
		                		  }else{
		                			  if(detecttimes>=3){
		                				  alert(returnjson.detectresults[0].message);
		                			  }
		                			  dealing=false;//将处理中的标志置为false，以便让其他方法可以继续
		                		  }
	                		  }else{
	                			  if(detecttimes>=3){
	                			  	alert("图片库中无此人的记录");
	                			  }
	                			  dealing=false;//将处理中的标志置为false，以便让其他方法可以继续
	                		  }
	                	  }else{
	                		  detecttimes=3;
	                		  alert(returnjson.mainmessage);
	                		  dealing=false;//将处理中的标志置为false，以便让其他方法可以继续
	                		  
	                	  }
	                	  if(detecttimes>=3){
	                		  havetake=true;
		                	  setbuttonenable();//将按钮置为正常（可用）
	                	  }
	                  }
	              });
    		  }else if(captyle=="识别人脸"){
    			  dealing=true;//将处理中的标志置为true，防止其他方法冲突
    			  detecttimes=3;
    			  var specimgSrc = "data:image/jpeg;" + snapData;
    			  gettmppic=snapData;
    			  console.log("图片数据："+specimgSrc);
    			  getimg1.src=specimgSrc;
    			  showspecde();
    		  }else if(captyle=="获取特征"){
    			  dealing=true;//将处理中的标志置为true，防止其他方法冲突
    			  detecttimes=3;
    			  var specimgSrc = "data:image/jpeg;" + snapData;
    			  gettmppic=snapData;
    			  console.log("图片数据："+specimgSrc);
    			  getimg1.src=specimgSrc;
    			  showspec();
    		  }
    	   }
	 	  }
		    event.data.forEach(function(rect) {
			context.strokeStyle = '#f2a98b';
			context.lineWidth=3;
		 	context.strokeRect(rect.x, rect.y, rect.width, rect.height);
		  });
      });
	      
	    
     
    };
    function showspec(){
    	document.getElementById('cap-frame').style.display='none';
    	document.getElementById('spec-frame').style.display='block';
    }
    function closespec(){
    	document.getElementById('cap-frame').style.display='block';
    	document.getElementById('spec-frame').style.display='none';
    }
    function showspecde(){
    	document.getElementById('cap-frame').style.display='none';
    	document.getElementById('specde-frame').style.display='block';
    }
    function closespecde(){
    	document.getElementById('cap-frame').style.display='block';
    	document.getElementById('specde-frame').style.display='none';
    }
    function setbuttondisable(){////将按钮置灰色（不可用）
    	$("#begindetect").attr("disabled","disabled");//将“搜索人脸”按钮置灰色（不可用）
    	$("#beginsearch").attr("disabled","disabled");//将“搜索人脸”按钮置灰色（不可用）
		$("#getspec").attr("disabled","disabled");//将“开始识别”按钮置灰色（不可用）
    }
    function setbuttonenable(){////将按钮置为正常（可用）
    	$("#begindetect").removeAttr("disabled");//将“搜索人脸”按钮置为正常（可用）
    	$("#beginsearch").removeAttr("disabled");//将“搜索人脸”按钮置为正常（可用）
		$("#getspec").removeAttr("disabled");//将“开始识别”按钮置为正常（可用）
    }
    function beginsearch(){
    	if(!dealing){
    		captyle="搜索人脸";
    		havetake=false;
    		detecttimes=0;//发送后台识别的次数
    		setbuttondisable();//将按钮置灰色（不可用）
    	}else{
    		alert("正在处理中，请等待");
    	}
    	
    }
    function begindetect(){
    	if(!dealing){
    		captyle="识别人脸";
    		havetake=false;
    		detecttimes=0;//发送后台识别的次数
    		setbuttondisable();//将按钮置灰色（不可用）
    	}else{
    		alert("正在处理中，请等待");
    	}
    }
    function getspec(){
    	if(!dealing){
    		captyle="获取特征";
    		havetake=false;
    		detecttimes=0;//发送后台识别的次数
    		setbuttondisable();//将按钮置灰色（不可用）
    	}else{
    		alert("正在处理中，请先点击“停止识别按钮”停止识别或获取");
    	}
    	
    }
    /* 是否是手机 */
    function isMobile(s) {
    	var regu = /^[1][0-9]{10}$/;
    	var re = new RegExp(regu);
    	if (re.test(s)) {
    		return true;
    	} else {
    		return false;
    	}
    }
    /*
    是否是邮箱
     * 
     */
    function isEmail(str) {
    	var myReg = /^[-_A-Za-z0-9]+@([_A-Za-z0-9]+\.)+[A-Za-z0-9]{2,3}$/;
    	if (myReg.test(str))
    		return true;
    	return false;
    }
    function addspecok(){
    	if($("#detectid").attr("value").length==0){
    		alert("识别标识不能为空");
    		return;
    	}
    	var updata="{\"userreg\":\"00000000000000000000000000000000\",\"picdatas\":[{\"picname\":\""+$("#detectid").attr("value")+"\",\"picdata\":\""+gettmppic.substring(gettmppic.indexOf("base64,")+7)+"\"}]}";
		  //请求体
		  var soap = '<?xml version="1.0" encoding="UTF-8"?>'+
					 '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:get="http://getface.tdr.com">'+
					   '<soapenv:Header/>'+
					   '<soapenv:Body>'+
					      '<get:addspecface>'+
					         '<get:inpicdata>'+updata+'</get:inpicdata>'+
					      '</get:addspecface>'+
					   '</soapenv:Body>'+
					'</soapenv:Envelope>';
    	$.ajax({
            type: "POST",
            //url: "https://detectface.taiderui.com:5665/getface/services/getfacews",
            url: "https://192.168.6.104:5665/getface/services/getfacews",//此处输入接口地址
            //url: "services/getfacews",
            data: soap,
            headers:{
          	  "Access-Control-Allow-Origin":"*"
            },
            dataType: 'xml',
            beforeSend:function(request){
				  request.setRequestHeader ("Content-Type","text/xml;charset=UTF-8");
				  request.setRequestHeader ("SOAPAction","");
			  },
			  error : function(request) {
				  setbuttonenable();//将按钮置为正常（可用）
				  alert("无法连接到服务器");
				  dealing=false;//将处理中的标志置为false，以便让其他方法可以继续
				  detecttimes=3;
    			  havetake=true;
			  },
            success: function(data) {
                //console.log("ws返回值："+data);
                //解析webservice的返回值
          	  var xmlDoc=data;
          	  var returns = xmlDoc.getElementsByTagName('addspecfaceReturn');
          	  //alert(returns[0].textContent);
          	  var returnjson = eval('(' + trim(returns[0].textContent) + ')');
	      	  if(returnjson.status=="添加成功"){
	      		  alert(returnjson.addresults[0].message);
	      	  }else{
	      		  alert(returnjson.mainmessage);
	      	  }
          	  closespec();//关闭弹出图层
          	  setbuttonenable();//将按钮置为正常（可用）
          	  dealing=false;//将处理中的标志置为false，以便让其他方法可以继续
          	  havetake=true;
            }
        });
    	//dealing=false;//将处理中的标志置为false，以便让其他方法可以继续
    }
    function addspeccancel(){
    	closespec();
    	setbuttonenable();//将按钮置为正常（可用）
    	dealing=false;//将处理中的标志置为false，以便让其他方法可以继续
    	havetake=true;
    }
    
    function detfaceok(){
    	if($("#detectdeid").attr("value").length==0){
    		alert("识别标识不能为空");
    		return;
    	}
    	var updata="{\"userreg\":\"00000000000000000000000000000000\",\"picdatas\":[{\"picname\":\""+$("#detectdeid").attr("value")+"\",\"picdata\":\""+gettmppic.substring(gettmppic.indexOf("base64,")+7)+"\"}]}";
		  //请求体
		  var soap = '<?xml version="1.0" encoding="UTF-8"?>'+
					 '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:get="http://getface.tdr.com">'+
					   '<soapenv:Header/>'+
					   '<soapenv:Body>'+
					      '<get:detectfaces>'+
					         '<get:inpicdata>'+updata+'</get:inpicdata>'+
					      '</get:detectfaces>'+
					   '</soapenv:Body>'+
					'</soapenv:Envelope>';
    	$.ajax({
            type: "POST",
            //url: "https://detectface.taiderui.com:5665/getface/services/getfacews",
            url: "https://192.168.6.104:5665/getface/services/getfacews",//此处输入接口地址
            //url: "services/getfacews",
            data: soap,
            headers:{
          	  "Access-Control-Allow-Origin":"*"
            },
            dataType: 'xml',
            beforeSend:function(request){
				  request.setRequestHeader ("Content-Type","text/xml;charset=UTF-8");
				  request.setRequestHeader ("SOAPAction","");
			  },
			  error : function(request) {
				  setbuttonenable();//将按钮置为正常（可用）
				  alert("无法连接到服务器");
				  dealing=false;//将处理中的标志置为false，以便让其他方法可以继续
				  detecttimes=3;
    			  havetake=true;
			  },
            success: function(data) {
                //console.log("ws返回值："+data);
                //解析webservice的返回值
          	  var xmlDoc=data;
          	  var returns = xmlDoc.getElementsByTagName('detectfacesReturn');
          	  //alert(returns[0].textContent);
          	  var returnjson = eval('(' + trim(returns[0].textContent) + ')');
	      	  if(returnjson.status=="识别成功"){
	      		  if(returnjson.detectresults[0].message=="识别成功")
	      		  	alert(returnjson.detectresults[0].detvalue);
	      		  else
	      			alert(returnjson.detectresults[0].message);
	      	  }else{
	      		  alert(returnjson.mainmessage);
	      	  }
          	  closespecde();//关闭弹出图层
          	  setbuttonenable();//将按钮置为正常（可用）
          	  dealing=false;//将处理中的标志置为false，以便让其他方法可以继续
          	  havetake=true;
            }
        });
    	//dealing=false;//将处理中的标志置为false，以便让其他方法可以继续
    }
    function detfacecancel(){
    	closespecde();
    	setbuttonenable();//将按钮置为正常（可用）
    	dealing=false;//将处理中的标志置为false，以便让其他方法可以继续
    	havetake=true;
    }
    
    function showregspec(){
    	document.getElementById('cap-frame').style.display='none';
    	document.getElementById('reg-frame').style.display='block';
    }
    function closeregspec(){
    	document.getElementById('cap-frame').style.display='block';
    	document.getElementById('reg-frame').style.display='none';
    }
    function showexpl(){
    	document.getElementById('cap-frame').style.display='none';
    	document.getElementById('expl-frame').style.display='block';
    }
    function closeexpl(){
    	document.getElementById('cap-frame').style.display='block';
    	document.getElementById('expl-frame').style.display='none';
    }
    function regok(){
    	var name=$("#name").attr("value");
    	var cell=$("#cell").attr("value");
    	var mail=$("#mail").attr("value");
    	var app=$("#app").attr("value");
    	var appdes=$("#appdes").attr("value");
    	var allrow=$("#ikonw").attr('checked');
    	console.log(name+","+cell+","+mail+","+app+","+appdes);
    	var datanotnull=((name.length>0)&&(cell.length>0)&&(mail.length>0)&&(app.length>0)&&(appdes.length>0));
    	if(!datanotnull){
    		alert("姓名，手机，邮箱，应用，应用描述均不能为空不能为空，请检查");
    		return;
    	}
    	if(!isMobile(cell)){
    		alert("请输入正确的手机号");
    		return;
    	}
	    if(!isEmail(mail)){
	    	alert("请输入正确的邮箱");
    		return;
		}
    	if(!allrow){
    		alert("如不同意注册须知，请勿使用我们提供的接口服务，如同意则请勾选");
    		return;
    	}
    	var updata="{\"indatas\":[{\"name\":\""+name+"\",\"cell\":\""+cell+"\",\"mail\":\""+mail+"\",\"app\":\""+app+"\",\"appdes\":\""+appdes+"\"}]}";
		  //请求体
		  var soap = '<?xml version="1.0" encoding="UTF-8"?>'+
					 '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:get="http://getface.tdr.com">'+
					   '<soapenv:Header/>'+
					   '<soapenv:Body>'+
					      '<get:reginfos>'+
					         '<get:indata>'+updata+'</get:indata>'+
					      '</get:reginfos>'+
					   '</soapenv:Body>'+
					'</soapenv:Envelope>';
    	$.ajax({
            type: "POST",
            //url: "https://detectface.taiderui.com:5665/getface/services/getfacews",
            url: "https://192.168.6.104:5665/getface/services/getfacews",//此处输入接口地址
            //url: "services/getfacews",
            data: soap,
            headers:{
          	  "Access-Control-Allow-Origin":"*"
            },
            dataType: 'xml',
            beforeSend:function(request){
				  request.setRequestHeader ("Content-Type","text/xml;charset=UTF-8");
				  request.setRequestHeader ("SOAPAction","");
			  },
			  error : function(request) {
				  alert("无法连接到服务器");
			  },
            success: function(data) {
                //console.log("ws返回值："+data);
                //解析webservice的返回值
          	  var xmlDoc=data;
          	  var returns = xmlDoc.getElementsByTagName('reginfosReturn');
          	  //alert(returns[0].textContent);
          	  var returnjson = eval('(' + trim(returns[0].textContent) + ')');
	      	  alert(returnjson.message);
	      	  closeregspec();//关闭弹出图层
            }
        });
    }
    function getdoc(){
    	window.open("rlsbjksms.pdf");
    }
    function downloadsource(){
    	window.open("example.rar");
    }
  </script>

</body>
</html>