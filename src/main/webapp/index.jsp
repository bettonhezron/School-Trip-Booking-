<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Students Academic Trips Booking System</title>
    <link rel="stylesheet" href="css/main.css">
</head>
<body>
    <jsp:include page="/WEB-INF/views/common/header.jsp" />
    <jsp:include page="/WEB-INF/views/common/navigation.jsp" />
    
    <div class="container">
        <h1>Welcome to School Trips Booking System</h1>
        
        <c:if test="${empty sessionScope.user}">
            <p>Please <a href="login">login</a> or <a href="register">register</a> to access the system.</p>
        </c:if>
        
        <c:if test="${not empty sessionScope.user}">
            <p>Welcome, ${sessionScope.user.fullName}!</p>
            <div class="dashboard">
                <h2>Quick Actions</h2>
                <ul>
                    <li><a href="book">Request a Trip</a></li>
                    <li><a href="list">View Trips</a></li>
                    <c:if test="${sessionScope.user.role == 'admin'}">
                        <li><a href="department/manage.jsp">Manage Departments</a></li>
                    </c:if>
                </ul>
            </div>
        </c:if>
    </div>
    
    <jsp:include page="/WEB-INF/views/common/footer.jsp" />
    <script src="js/script.js"></script>
</body>
</html>