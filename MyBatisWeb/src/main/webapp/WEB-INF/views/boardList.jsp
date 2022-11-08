<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="loginId" value="${sessionScope.id }"/>
<c:set var="loginout" value="${sessionScope.id == null? 'Login' : 'id:'+= loginId }"/>
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
	<title>게시판 리스트</title>
	
	<style>
		*{
			box-sizing: border-box;
			margin: 0;
			padding: 0;
			font-family: "Noto Sans KR", sans-selif;
		}
		
		a {
			text-decoration: none; 
			color: black;
			}
		button, input {
			border: none;
			outline: none;
		}
		
		.board-container {
			width: 60%;
			height: 1200px;
			margin: 0 auto;
			
		}
		
		.search-container {
			background-color: rgb(253, 253, 250);
			width: 100%;
			height: 110px;
			border: 1px solid #ddd;
			margin-top: 10px;
			margin-bottom: 30px;
			display: flex;
			justify-content: center;
			align-items: center;
		}
		
		table{
			border-collapse: collapse;
			width: 100%;
			border-top: 2px solid rgb(39, 39, 39);
			
		}
		
		tr:nth-child(even){
			background-color: #f0f0f070;
		}
		
		th, td{
			width: 300px;
			text-align: center;
			padding: 10px 12px;
			border-bottom: 1px solid #ddd;
		}
		
		td{
			color: rgb(53,53,53);
			
		}
		
		.no {
			width: 150px;
		}
		
		.title{
			width: 50%;
		}
		
		td.title {
			text-align: left;
		}
/* 		td.writer{
			text-align: center;
		}
		td.viewcnt{
			text-align: center;
		} */
		td.title:hover{
			text-decoration:  underline;
		}
		
		.paging{
			color: black;
			width: 100%;
			align-items: center;
			
		}
		.page {
			color: black;
			padding: 6px;
			margin-right: 10px;
		}
		
		.paging-container{
			width: 100%;
			height: 70px;
			display: flex;
			margin-top: 50px;
			margin: auto;
		}
		
	</style>
	

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
	
	<script>
	
	</script>
	
	<div style="text-align: center;">
		<div class="board-container">
			<div class="search-container">
				<form>
				
				</form>
			</div>
			
				<table>
					<tr>
						<th class="no">번호</th>
						<th class="title">제목</th>
						<th class="writer">이름</th>
						<th class="regdate">등록일</th>
						<th class="viewcnt">조회수</th>
					</tr>
					
					<c:forEach var="boardDto" items="${list }">
						<tr>
							<td class="no">${boardDto.bno }</td>
							<td class="title">
								<a href='<c:url value="/board/read?bno=${boardDto.bno }&page=${ page }&pageSize=${pageSize }" />'>
									${boardDto.title }
								</a>
							</td>
							<td class="writer">
								<a href="">${boardDto.writer }</a>
							</td>
<%--  						<c:choose>
							<c:when test=""> --%>
							<td class="regdate">
								<fmt:formatDate value="${boardDto.reg_date }" pattern="yyyy-MM-dd" type="date"/>
							</td>
<%-- 							</c:when>
							</c:choose> --%>
							<td class="viewcnt">
							${boardDto.view_cnt }
							</td>
						</tr>
					</c:forEach>
				</table>
				
				<br>
				<div class="paging-container">
					<div class="paging">
						<c:if test="${totalCnt == null || totalCnt == 0 }">
							<div>게시물이 없습니다.</div>
						</c:if>
					<c:if test="${totalCnt != null || totalCnt != 0 }">
						<c:if test="${pr.showPrev }">
								<a class="page" href="<c:url value="/board/list/?page=${pr.beginPage -1 }"></c:url>">이전</a>
						</c:if>
						<c:forEach var="i" begin="${pr.beginPage }" end="${pr.endPage }" >
							<a class="page" href="<c:url value='/board/list?page=${i }'/>">${i }</a>
						</c:forEach>
						<c:if test="${pr.showNext }">
							<a class="page" href="<c:url value="/board/list/?page=${pr.endPage +1 }"></c:url>">다음</a>
						</c:if>						
					</c:if>
					</div>
				</div>
		</div>
	</div>
</body>
</html>