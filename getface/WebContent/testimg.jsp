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
//out.println(new getFaceDetector().isphotook("F:\\s1.jpg"));
/* new getFaceDetector().detectFace("F:\\timg2.jpg", 0);
new getFaceDetector().detectFace("F:\\timg3.jpg", 0);
new getFaceDetector().detectFace("F:\\timg4.jpg", 0);
new getFaceDetector().detectFace("F:\\timg5.jpg", 0);
new getFaceDetector().detectFace("F:\\timg6.jpg", 0); */
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
<center><button id="snap">123</button><button id="close">456</button></center>
  <script>
    var havetake=false;
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
      
      var facecount=0;
	  var mouthcount=0;
	  var eyecount=0;
      
   	  // 使用新方法打开摄像头
      if (navigator.mediaDevices && navigator.mediaDevices.getUserMedia) {
        navigator.mediaDevices.getUserMedia({
          video: true,
          audio: true
        }).then(function(stream) {
          console.log(stream);
     
          mediaStreamTrack = typeof stream.stop === 'function' ? stream : stream.getTracks()[1];
     
          video.src = (window.URL || window.webkitURL).createObjectURL(stream);
          video.play();
        }).catch(function(err) {
          console.log(err);
        })
      }
      function getimg(){
    	  
    	  context.clearRect(0, 0, video.width, video.height);
    	  context.drawImage(video, 0, 0, video.width, video.height);
    	  var snapData = canvas.toDataURL('image/png');
		  var imgSrc = "data:image/png;" + snapData;
		  context.clearRect(0, 0, video.width, video.height);
		  img1.src=imgSrc;
		  /* var tracker = new tracking.ObjectTracker(['face', 'eye', 'mouth']); // Based on parameter it will return an array.
	      tracker.setStepSize(1.7);

	      tracking.track('#img1', tracker);

	      tracker.on('track', function(event) {
			event.data.forEach(function(rect) {
				context.strokeStyle = '#a64ceb';
			 context.strokeRect(rect.x, rect.y, rect.width, rect.height);
			 context.font = '11px Helvetica';
			 context.fillStyle = "#fff";
			});
	    	console.log("找到图片："+event.data.length);
	      }); */
	      /* //探测人脸数目
	      var tracker = new tracking.ObjectTracker(['face']); // Based on parameter it will return an array.
	      tracker.setInitialScale(4);
	      tracker.setStepSize(1.7);//1.1-2
	      //tracker.setScaleFactor(1.3);//1.1-2
	      tracker.setEdgesDensity(0.1);

	      tracking.track('#img1', tracker);

	      tracker.on('track', function(event) {
	    	  facecount=event.data.length;
	      }); */
	      try {
		      //探测人脸数目
		      var facetracker = new tracking.ObjectTracker(['face']); // Based on parameter it will return an array.
		      //facetracker.setInitialScale(4);
		      facetracker.setStepSize(1.7);//1.1-2
		      //facetracker.setEdgesDensity(0.1);
	
		      tracking.track('#img1', facetracker);
	
		      facetracker.on('track', function(event) {
		    	  facecount=event.data.length;
		    	  console.log("符合条件的人脸:"+event.data.length);
		      });
		      
		      //探测眼睛数目
		      var eyetracker = new tracking.ObjectTracker(['eye']); // Based on parameter it will return an array.
		      eyetracker.setStepSize(1.7);//1.1-2
	
		      tracking.track('#img1', eyetracker);
	
		      eyetracker.on('track', function(event) {
		    	  eyecount=event.data.length;
		    	  console.log("符合条件的眼睛:"+event.data.length);
		      });
		      
		      //探测嘴巴数目
		      var mouthtracker = new tracking.ObjectTracker(['mouth']); // Based on parameter it will return an array.
		      mouthtracker.setStepSize(1.7);//1.1-2
	
		      tracking.track('#img1', mouthtracker);
	
		      mouthtracker.on('track', function(event) {
		    	  mouthcount=event.data.length;
		    	  console.log("符合条件的嘴巴："+event.data.length);
		      });
	      }catch(e){
	    	  
	      }
	      
	      console.log(facecount+","+eyecount+","+mouthcount);
	      //if(facecount==1 && eyecount==2 && mouthcount==1)
	    	//if(facecount=1)
	    	  //console.log("符合条件的人脸");

		  setTimeout(function(){getimg();} ,1000);
	  } 
      setTimeout(function(){getimg();} ,1000);
      //window.setInterval(getimg(), 1000);
   // 截取图像
      /* $("#snap")[0].addEventListener('click', function() {
        context.drawImage(video, 0, 0, 200, 150);
        var snapData = canvas.toDataURL('image/png');
		  var imgSrc = "data:image/png;" + snapData;
		  img1.src=imgSrc;
		  context.clearRect(0, 0, video.width, video.height);
      }, false);
     
      // 关闭摄像头
      $("#close")[0].addEventListener('click', function() {
        mediaStreamTrack && mediaStreamTrack.stop();
      }, false); */
      /* var tracker = new tracking.ObjectTracker(['face','eye','mouth']);//识别人脸
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
				 
			}
        });
      }); */

      //var gui = new dat.GUI();
      //gui.add(tracker, 'edgesDensity', 0.1, 0.5).step(0.01);
      //gui.add(tracker, 'initialScale', 1.0, 10.0).step(0.1);
      //gui.add(tracker, 'stepSize', 1, 5).step(0.1);
    }; 
  </script>

</body>
</html>
