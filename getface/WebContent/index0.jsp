<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%@page import="com.tdr.getface.getFaceDetector"%>
<%@page import="com.tdr.getface.RedisUtil"%>
<%@page import="com.tdr.getface.getfacetool"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<!doctype html>
<html>
<head>
  <meta charset="utf-8">
  <title>tracking.js - face with camera</title>
<!--   <link rel="stylesheet" href="tracking/assets/demo.css"> -->

  <script src="tracking/build/tracking.js"></script>
  <script src="tracking/build/data/face-min.js"></script>
  <script src="tracking/build/data/eye-min.js"></script>
  <script src="tracking/build/data/mouth-min.js"></script>
   <!-- <script src="tracking/node_modules/dat.gui/build/dat.gui.min.js"></script> -->
  <script src="tracking/examples/assets/stats.min.js"></script>
  <script src="getface/js/jquery-1.7.2.min.js"></script>

  <style>
  video, canvas {
    margin-left: 230px;
    margin-top: 120px;
    position: absolute;
  }
  </style>
</head>
<body>
<% 
RedisUtil ru=new RedisUtil().getRu(); 
ru.set("redissuccess", "redis启动成功");
ru.set("00000000000000000000000000000000", "");
new getfacetool().getcomparejpgstr("E:\\chuangyelei\\ruanjian\\facenet\\compare\\photobase\\", "00000000000000000000000000000000");
System.out.println(ru.get("redissuccess"));
System.out.println("redis读取的图片库图片路径字符串："+ru.get("00000000000000000000000000000000"));
//ru.set("s1", "123456t");
//out.println(new getFaceDetector().isphotook("F:\\s1.jpg"));
/* new getFaceDetector().detectFace("F:\\timg2.jpg", 0);
new getFaceDetector().detectFace("F:\\timg3.jpg", 0);
new getFaceDetector().detectFace("F:\\timg4.jpg", 0);
new getFaceDetector().detectFace("F:\\timg5.jpg", 0); */
//new getFaceDetector().detectFace("F:\\timg6.jpg", 0);
%>
  <div class="demo-title">
    <p><a href="http://trackingjs.com" target="_parent">tracking.js</a> － get user's webcam and detect faces</p>
  </div>

  <div class="demo-frame">
    <div class="demo-container">
      <video id="video" width="320" height="240" preload autoplay loop muted></video>
      <canvas id="canvas" width="320" height="240"></canvas>
      
    </div>
    <div><img alt="" src="" id="img1"></div>
  </div>
<form action="getface/ajax/getfacesajax.jsp" method="post" id="postpicform">
<input id="picpost" name="picpost" style="display:none">
</form>
  <script>
    /* var havetake=false;
    var postrect="";
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
	
     window.onload = function() {
      var video = document.getElementById('video');
      var canvas = document.getElementById('canvas');
      var context = canvas.getContext('2d');
	  	
      var tracker = new tracking.ObjectTracker(['face','eye','mouth']);//识别人脸
      //tracker.setInitialScale(4);
      tracker.setStepSize(1.7);//1.1-2
      //tracker.setScaleFactor(1.3);//1.1-2
      //tracker.setEdgesDensity(0.05);

      tracking.track('#video', tracker, { camera: true });

      tracker.on('track', function(event) {
        
        context.clearRect(0, 0, canvas.width, canvas.height);

        event.data.forEach(function(rect) {
	        context.strokeStyle = '#a64ceb';
	        context.strokeRect(rect.x, rect.y, rect.width, rect.height);
	        context.font = '11px Helvetica';
	        context.fillStyle = "#fff";
	        context.fillText('x: ' + rect.x + 'px', rect.x + rect.width + 5, rect.y + 11);
	        context.fillText('y: ' + rect.y + 'px', rect.x + rect.width + 5, rect.y + 22);
			if(!havetake){
	        	havetake=true;
	        	postrect="";
	        	context.drawImage(video,0,0,canvas.width,canvas.height);
		        //var dataURL = canvas.toDataURL('image/jpeg', 0.5);
		        var snapData = canvas.toDataURL('image/png');
		        var blob = dataURItoBlob(snapData);
			    //var imgSrc = "data:image/png;" + snapData;
			    //img1.src=imgSrc;
		        //dataURL=dataURL.substring(dataURL.indexOf("base64,")+7);
		        //console.log("图片数据："+dataURL);
		        //$("#picpost").val(dataURL);
				var myfd = new FormData();
				myfd.append("picfile", blob);
				//console.log("picrect="+postrect);
				//myfd.append("picrect", postrect);
				$.ajax({
					cache : false,
					type : "POST",
					url: "getface/ajax/getfacesajax.jsp",
					data: myfd,
					processData: false, // 必须
					contentType: false, // 必须
					error : function(request) {
							alert("无法连接到服务器！");
					},
					success : function(data) {
						if(trim(data)=="查无此人")
							havetake=false;
						else
							alert(trim(data));
					}
				});
				 
			}
        });
      });

      //var gui = new dat.GUI();
      //gui.add(tracker, 'edgesDensity', 0.1, 0.5).step(0.01);
      //gui.add(tracker, 'initialScale', 1.0, 10.0).step(0.1);
      //gui.add(tracker, 'stepSize', 1, 5).step(0.1);
    }; */ 
  </script>

</body>
</html>
