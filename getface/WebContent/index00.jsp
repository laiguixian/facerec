<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%@page import="com.tdr.getface.getFaceDetector"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<!doctype html>
<html>
<head>
  <meta charset="utf-8">
  <title>人脸识别例子</title>
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
<%
//out.println(new getFaceDetector().isphotook("F:\\s1.jpg"));
/* new getFaceDetector().detectFace("F:\\timg2.jpg", 0);
new getFaceDetector().detectFace("F:\\timg3.jpg", 0);
new getFaceDetector().detectFace("F:\\timg4.jpg", 0);
new getFaceDetector().detectFace("F:\\timg5.jpg", 0);
new getFaceDetector().detectFace("F:\\timg6.jpg", 0); */
%>
  <div class="demo-title">
    <p>人脸识别例子，注意：本站人脸识别接口供国内程序员和公司体验快速高效的人脸识别，注册和使用完全免费，本例子是特征提取接口和1对N人脸识别接口的例子（可以下载源码自行观看），建议在电脑上运行此例子，使用一般的摄像头即可，其他接口的使用，请自行根据文档来调用，在某些手机上使用有时视频会变成横向，调起来比较繁琐，而这只是一个例子也就不费这个劲了，自行换手机看吧。在电脑上谷歌浏览器（Chrome）和火狐浏览器（Firefox）测试通过，在手机上UC浏览器测试通过，其余浏览器没有试过，亲们可以自行试一下。接口免费调用，调用方法请点击“接口文档”获取</p>
  </div>
  <!-- 用于显示视频 -->
  <div class="demo-frame" id="cap-frame" class="white_content">
    <div class="demo-container">
      <video id="video" width="600" height="450" preload autoplay loop muted></video>
      <canvas id="canvas" width="600" height="450"></canvas>
      <div class="button-container" style="height:600px;width:100px;float:right;margin-top: 130px;text-align:center;">
      <button id="begindetect" onclick="begindetect()">开始识别</button>
      <p><label></label>&nbsp<p>
      <p><label></label>&nbsp<p>
      <button id="getspec" onclick="getspec()">提取特征</button>
      <p><label></label>&nbsp<p>
      <p><label></label>&nbsp<p>
      <button id="regspec" onclick="showregspec()">接口注册</button>
      <p><label></label>&nbsp<p>
      <p><label></label>&nbsp<p>
      <button id="getdoc" onclick="showspec()">接口文档</button>
      <p><label></label>&nbsp<p>
      <p>同时识别人数：<%out.print(200+new Random().nextInt(500));%>
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
 <p align="left" style="color:red;font-size:15px;">注册须知：以上信息若有误，即使申请成功依然会被取消使用资格，另因接口免费的缘故，我们可能在不通知您的情况下停止服务，若需要稳定的服务建议联系我们架设属于您自己的专门服务。谢谢！
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
     window.onload = function() {
      var video = document.getElementById('video');
      var canvas = document.getElementById('canvas');
      var context = canvas.getContext('2d');
      
      var facecount=0;
	  var mouthcount=0;
	  var eyecount=0;
      
   	  // 使用新方法打开摄像头
      /* if (navigator.mediaDevices && navigator.mediaDevices.getUserMedia) {
        navigator.mediaDevices.getUserMedia({//优先使用前置摄像头
          video: { facingMode: "user",frameRate: { ideal: 10, max: 15 } },
          audio: true
        }).then(function(stream) {
          console.log(stream);
     
          mediaStreamTrack = typeof stream.stop === 'function' ? stream : stream.getTracks()[1];
     
          video.src = (window.URL || window.webkitURL).createObjectURL(stream);
          video.play();
        }).catch(function(err) {
           console.log(err);
        })
      } */ 
      var constraints = { audio: true, video: { height: 1280, width: 720 } }; 

      navigator.mediaDevices.getUserMedia(constraints)
      .then(function(mediaStream) {
        var video = document.querySelector('video');
        video.srcObject = mediaStream;
        video.onloadedmetadata = function(e) {
          video.play();
        };
      })
     
   // 使用新方法打开摄像头
      /* if (navigator.mediaDevices && navigator.mediaDevices.getUserMedia) {
        navigator.mediaDevices.getUserMedia({
          video: {facingMode: "user",frameRate: { ideal: 10, max: 15 },height: 450, width: 600},
          audio: true
        }).then(function(stream) {
          console.log(stream);
     
          mediaStreamTrack = typeof stream.stop === 'function' ? stream : stream.getTracks()[1];
     
          video.src = (window.URL || window.webkitURL).createObjectURL(stream);
          video.play();
        }).catch(function(err) {
          console.log(err);
        })
      } */
   	  function gettimesp(){
   		  var now=new Date();
   		  return now+" "+now.getMilliseconds();
   	  }
       function getimg(){
    	  
    	  //context.clearRect(0, 0, video.width, video.height);
    	  //context.drawImage(video, 0, 0, video.width, video.height);
    	  var snapData = canvas.toDataURL('image/jpeg');
		  var imgSrc = "data:image/jpeg;" + snapData;
		  //context.clearRect(0, 0, video.width, video.height);
		  img1.src=imgSrc;
		  //探测人脸数目 -用于展示
	      var tracker = new tracking.ObjectTracker(['face']); // Based on parameter it will return an array.
	      tracker.setInitialScale(4);
	      tracker.setStepSize(1.7);//1.1-2
	      tracker.setEdgesDensity(0.1);

	      tracking.track('#video', tracker,{});
	      tracker.on('track', function(event) {context.clearRect(0, 0, video.width, video.height);
			event.data.forEach(function(rect) {
				context.strokeStyle = '#a64ceb';
			 context.strokeRect(rect.x, rect.y, rect.width, rect.height);
			 context.font = '11px Helvetica';
			 context.fillStyle = "#fff";
			});
	      });
	      try {
	    	  if((!havetake)&&(detecttimes<3)&&(!dealing)){
	    		  console.log("执行新的识别"+gettimesp());
		    	  //探测人脸数目
			      var facetracker = new tracking.ObjectTracker(['face']); // Based on parameter it will return an array.
			      //facetracker.setInitialScale(4);
			      facetracker.setStepSize(1.7);//1.1-2
			      //facetracker.setEdgesDensity(0.1);
		
			      tracking.track('#img1', facetracker);
		
			      facetracker.on('track', function(event) {
			    	  facecount=event.data.length;
			    	  //event.data.forEach(function(rect) {
			    		  
			    	  //}
			    	  //console.log("符合条件的人脸:"+event.data.length);
			      });
			      console.log("识别中"+gettimesp());
			      //探测眼睛数目
			      var eyetracker = new tracking.ObjectTracker(['eye']); // Based on parameter it will return an array.
			      eyetracker.setStepSize(1.7);//1.1-2
		
			      tracking.track('#img1', eyetracker);
		
			      eyetracker.on('track', function(event) {
			    	  eyecount=event.data.length;
			    	  //console.log("符合条件的眼睛:"+event.data.length);
			      });
			      
			      //探测嘴巴数目
			      var mouthtracker = new tracking.ObjectTracker(['mouth']); // Based on parameter it will return an array.
			      mouthtracker.setStepSize(1.7);//1.1-2
		
			      tracking.track('#img1', mouthtracker);
		
			      mouthtracker.on('track', function(event) {
			    	  mouthcount=event.data.length;
			    	  //console.log("符合条件的嘴巴："+event.data.length);
			      });
	    	  }
	      }catch(e){
	    	  
	      }finally{
	    	  if((!havetake)&&(detecttimes<3)&&(!dealing)){//detecttimes:发送后台识别的次数
		    	  if((facecount>=1) || (eyecount>=1) || (mouthcount>=1)){
		    		  detecttimes=detecttimes+1;
		    		  //alert("符合条件的人脸哦"+gettimesp()+","+captyle);
		    		  
		    		  console.log("符合条件的人脸哦"+gettimesp());
		    		  if(captyle=="识别人脸"){
		    			  dealing=true;//将处理中的标志置为true，防止其他方法冲突
		    			  var updata="{\"userreg\":\"00000000000000000000000000000000\",\"detecttype\":\"0\",\"picdatas\":[{\"picdata\":\""+snapData.substring(snapData.indexOf("base64,")+7)+"\"}]}";
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
			                  //async: false, //同步传递
			                  //contentType: "application/json",
			                  //contentType:"text/xml;charset=UTF-8",
			                  //url: "https://www.taiderui.com:5665/getface/services/getfacews",
			                  url: "https://192.168.6.104:5665/getface/services/getfacews",
			                  //data: "{\"injsonstr\":\""+updata+"\",\"gettype\":\"0\"}",
			                  data: soap,
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
			                		  alert(returnjson.message);
			                		  dealing=false;//将处理中的标志置为false，以便让其他方法可以继续
			                		  
			                	  }
			                	  if(detecttimes>=3){
			                		  havetake=true;
				                	  setbuttonenable();//将按钮置为正常（可用）
			                	  }
			                  }
			              });
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
		      //setTimeout(function(){getimg();} ,100);
	      }
	      
	  } 
      setTimeout(function(){getimg();} ,100); 

      //var gui = new dat.GUI();
      //gui.add(tracker, 'edgesDensity', 0.1, 0.5).step(0.01);
      //gui.add(tracker, 'initialScale', 1.0, 10.0).step(0.1);
      //gui.add(tracker, 'stepSize', 1, 5).step(0.1);
    };
    function showspec(){
    	document.getElementById('cap-frame').style.display='none';
    	document.getElementById('spec-frame').style.display='block';
    }
    function closespec(){
    	document.getElementById('cap-frame').style.display='block';
    	document.getElementById('spec-frame').style.display='none';
    }
    function setbuttondisable(){////将按钮置灰色（不可用）
    	$("#begindetect").attr("disabled","disabled");//将“开始识别”按钮置灰色（不可用）
		$("#getspec").attr("disabled","disabled");//将“开始识别”按钮置灰色（不可用）
    }
    function setbuttonenable(){////将按钮置为正常（可用）
    	$("#begindetect").removeAttr("disabled");//将“开始识别”按钮置为正常（可用）
		$("#getspec").removeAttr("disabled");//将“开始识别”按钮置为正常（可用）
    }
    function begindetect(){
    	if(!dealing){
    		captyle="识别人脸";
    		havetake=false;
    		detecttimes=0;//发送后台识别的次数
    		setbuttondisable();//将按钮置灰色（不可用）
    	}else{
    		alert("正在处理中，请先停止识别");
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
            //async: false, //同步传递
            //contentType: "application/json",
            //contentType:"text/xml;charset=UTF-8",
            //url: "https://www.taiderui.com:5665/getface/services/getfacews",
            url: "https://192.168.6.104:5665/getface/services/getfacews",
            //data: "{\"injsonstr\":\""+updata+"\",\"gettype\":\"0\"}",
            data: soap,
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
	      		  alert(returnjson.message);
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
    function showregspec(){
    	document.getElementById('cap-frame').style.display='none';
    	document.getElementById('reg-frame').style.display='block';
    }
    function closeregspec(){
    	document.getElementById('cap-frame').style.display='block';
    	document.getElementById('reg-frame').style.display='none';
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
            //async: false, //同步传递
            //contentType: "application/json",
            //contentType:"text/xml;charset=UTF-8",
            //url: "https://www.taiderui.com:5665/getface/services/getfacews",
            url: "https://192.168.6.104:5665/getface/services/getfacews",
            //data: "{\"injsonstr\":\""+updata+"\",\"gettype\":\"0\"}",
            data: soap,
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
  </script>

</body>
</html>