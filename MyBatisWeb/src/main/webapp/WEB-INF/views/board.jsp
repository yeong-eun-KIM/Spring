<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="loginId" value="${sessionScope.id }"/>
<c:set var="loginout" value="${sessionScope.id == null? 'Login' : 'Logout' }"/>
<c:set var="loginoutlink" value="${sessionScope.id == null? '/login/login' : '/login/logout'}" />

<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="<c:url value="/resources/css/menu.css" />">
	<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.8.2/css/all.min.css">
	<script src="http://code.jquery.com/jquery-1.11.3.js"></script>
	<style type="text/css">
		*{
			box-sizing: border-box;
			margin: 0;
			padding: 0;
			font-family: "Noto Sans KR", sans-selif;
		}
		.container {
			width: 50%;
			margin: auto;
		}
		.writing-header{
			position: relative;
			margin: 20px 0 0 0;
			padding-bottom: 10px;
			border-bottom: 1px solid #323232;
		}
		.frm {
			width: 100%;
		}
		input {
			width: 100%;
			height: 35px;
			margin: 5px 0px 10px 0px;
			border: 1px solid #e9e8e8;
			padding: 8px;
			background: #f8f8f8;
			outline-color: #e6e6e6;
		}
		input[name="bno"]{
			display: none;
		}
		textarea{
			width: 100%;
			background: #f8f8f8;
			margin: 5px 0px 10px 0px;
			border: 1px solid #e9e8e8;
			resize: none;
			padding: 8px;
			outline-color: #e6e6e6;
		}
		.btn {
			background-color: rgb(236, 236, 236);
			border: none;
			color: black;
			padding: 6px 12px;
			font-size: 16px;
			cursor: pointer;
			border-radius: 5px;
		}
		.btn:hover {
			text-decoration: underline;
		}
	</style>
	<title>게시글 조회</title>
</head>
<body>
	<div id="menu">
		<ul>
			<li id="logo">ezen</li>
			<li><a href="<c:url value='/' />">Home</a></li>
			<li><a href='<c:url value='/board/list' />'>Board</a></li>
			<li><a href='<c:url value='${loginoutlink }' />'>${loginout }</a></li>
			<li><a href='<c:url value='/register/add' />'>SignUp</a></li>
			<li><a href=""><i class="fas fa-search small"></i></a></li>
		</ul>
	</div>
	<script type="text/javascript">
			let bno = 156;
			
			$("#commentList").on("click",".delBtn",function(){
				//commentList안에 있는 delBtn버튼에다가 클릭이벤트 걸어줌
				//alert("삭제버튼 클릭됨")
				let cno = $(this).parent().attr("data-cno")	//<li>태그는 <button>의 부모임
				let bno = $(this).parent().attr("data-bno")	//attr 중 사용자 정의 attr을 선택함
				
				$.ajax({
					type : 'DELETE',
					url : '/heart/comments/'+cno+'?bno='+bno, 
					success : function(result){
						alert(result)
						showList(bno)
					},
					error : function(){alert("error")}
				})				
			
			})
			
			
			let showList = function(bno){
				$.ajax({
					type: 'get',
					url: '/heart/comments?bno='+bno,
					success : function(result){
						$("#commentList").html(toHtml(result))
					},
					error : function(){alert("error")}
				})
			}
			
			let toHtml = function(comments){
			let tmp = "<ul style='display: block;' >"
			
			comments.forEach(function(comment){
				tmp += '<li style="background-color: #f9f9fa;border-bottom:1px solid rgb(235,236,239); color:black;  width: 100%;" data-cno=' + comment.cno
				tmp += ' data-bno=' + comment.bno
				tmp += ' data-pcno=' + comment.pcno +'>'
				tmp += ' <span class="commenter" style="width:100px;">'+comment.commenter +'</span>'
				tmp += ' <span class="comment">'+comment.comment +'</span>'
				tmp += ' <button class="delBtn">삭제</button>'
				tmp += '</li>'
			})
				return tmp += "</ul>"
			}
			$(document).ready(function(){
					$("#sendBtn").click(function(){
						showList(bno)
					})
				//})
			
		//$(document).ready(function() {	/*main()*/
			$("#listBtn").on("click",function(){
				location.href = "<c:url value='/board/list${searchItem.queryString}' />";
				//history.back();
			})
			
			$("#removeBtn").on("click",function(){
				if(!confirm("정말로 삭제하시겠습니까?")) return;
				
				let form = $("#form");
				form.attr("action", "<c:url value='/board/remove${searchItem.queryString}' />");
				form.attr("method", "post");
				form.submit();
			})
			
			$("#writeBtn").on("click",function(){
				
				let form = $("#form");
				form.attr("action","<c:url value='/board/write' />");
				form.attr("method", "post");
				
				if(formCheck())
					form.submit();
			})
			
			let formCheck = function(){
				let form = document.getElementById("form");
				if(form.title.value == "") {
					alert("제목을 입력하세요.");
					form.title.focus();
					return false;
					}
				if(form.content.value == "") {
					alert("내용을 입력하세요.");
					form.content.focus();
					return false;
					}
				return true;
			}
		
			$("#modifyBtn").on("click", function(){
				let form = $("#form");
				let isReadonly = $("input[name=title]").attr('readonly');
				//1. 읽기 상태이면 수정상태로 변경
				if(isReadonly == 'readonly'){
					$(".writing-header").html("게시판 수정");
					$("input[name=title]").attr('readonly',false);
					$("textarea").attr('readonly',false);
					$("#modifyBtn").html("<i class='fa fa-pencil'>등록</i>")
					return;
				}
				//2. 수정 된 내용을 서버로 전송
				form.attr("action","<c:url value='/board/modify${searchItem.queryString}' />");
				form.attr("method","post");
				if(formCheck())
					form.submit();

            })
		})	
	</script>
	
	<script type="text/javascript">
		let msg = "${msg}";
		if(msg == "WRT_ERR") alert("글 등록을 실패하였습니다.");
		if(msg == "MOD_ERR") alert("글 수정을 실패하였습니다.");
		
	</script>
		<div class="container">
		<h2 class="writing-header">게시판 ${mode == "new" ? "글쓰기" : "읽기" }</h2>
		<form id="form" class="frm"action="" method="post">
			<input type="text" name="bno" value="${boardDto.bno }">
			<input type="text" name="title" value="${boardDto.title }" ${mode == "new" ? "": "readonly='readonly'"}>
			<c:if test="${mode ne 'new' }">
				<input type="text" name="viewCnt" value="조회수 ${boardDto.view_cnt }" readonly>
			</c:if>
			<textarea rows="20" name="content" ${mode == "new" ? "": "readonly='readonly'"}>${boardDto.content }</textarea>
			
			<c:if test="${mode eq 'new' }">
				<button type="button" id="writeBtn" class="btn btn-write"><i class="fa fa-pencil"></i>등록</button>
			</c:if>
<%-- 			<c:if test="${mode ne 'new' }">
				<button type="button" id="writeNewBtn" class="btn btn-write"><i class="fa fa-pencil"></i>글쓰기</button>
			</c:if>	 --%>
			<c:if test="${boardDto.writer eq loginId }">
				<button type="button" id="modifyBtn" class="btn btn-modify"><i class="fa fa-edit"></i>수정</button>
				<button type="button" id="removeBtn" class="btn btn-modify"><i class="fa fa-trash"></i>삭제</button>
			</c:if>
			<button type="button" id="listBtn" class="btn btn-list"><i class="fa fa-bars"></i>목록</button>
		</form>
		
		<button id="sendBtn" type="button">SEND</button>
		<div id ="commentList"></div>
		
	</div>
	


</body>
</html>