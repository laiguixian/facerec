<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
  <meta charset="utf-8">
  <title>@tuts Face Detection Tutorial</title>
<script src="tracking/build/tracking.js"></script>
  <script src="tracking/build/data/face-min.js"></script>
  <script src="tracking/build/data/eye-min.js"></script>
  <script src="tracking/build/data/mouth-min.js"></script>


  <style>
  .rect {
    border: 2px solid #a64ceb;
    left: -1000px;
    position: absolute;
    top: -1000px;
  }

  #img {
    position: absolute;
    top: 50%;
    left: 50%;
    margin: -173px 0 0 -300px;
  }
  </style>
// tracking code.
<script>
    window.onload = function() {
      var img = document.getElementById('img');

      var tracker = new tracking.ObjectTracker(['face', 'eye', 'mouth']); // Based on parameter it will return an array.
      tracker.setStepSize(1.7);

      tracking.track('#img', tracker);

      tracker.on('track', function(event) {
        event.data.forEach(function(rect) {
          draw(rect.x, rect.y, rect.width, rect.height);
        });
      });

      function draw(x, y, w, h) {
        var rect = document.createElement('div');
        document.querySelector('.imgContainer').appendChild(rect);
        rect.classList.add('rect');
        rect.style.width = w + 'px';
        rect.style.height = h + 'px';
        rect.style.left = (img.offsetLeft + x) + 'px';
        rect.style.top = (img.offsetTop + y) + 'px';
      };
    };
  </script>

</head>
<body>
<div class="imgContainer">
  <img id="img" src="assets/face.jpg" />
</div>

</body>
</html>
