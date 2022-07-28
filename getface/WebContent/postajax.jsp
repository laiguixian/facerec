<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>Insert title here</title>
<script src="getface/js/jquery-1.7.2.min.js"></script>
</head>
<body>
<script>
window.onload = function() {
	var myfd = new FormData();
	myfd.append("picfile", "123");
	$.ajax({
		//cache : false,
		type : "POST",
		url: "getajax.jsp",
		data: myfd,
		processData: false, // 必须
		contentType: 'application/json;charset=utf-8',
		error : function(request) {
				alert("无法连接到服务器！");
		},
		success : function(data) {
			alert(data);
		}
	});
}
</script>
</body>
</html>