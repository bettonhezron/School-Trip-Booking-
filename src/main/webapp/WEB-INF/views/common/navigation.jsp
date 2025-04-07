<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<nav>
    <ul>
        <li><a href="${pageContext.request.contextPath}/index.jsp">Home</a></li>
        
        <c:if test="${empty sessionScope.user}">
            <li><a href="${pageContext.request.contextPath}/login">Login</a></li>
            <li><a href="${pageContext.request.contextPath}/register">Register</a></li>
        </c:if>
        
        <c:if test="${not empty sessionScope.user}">
            <li><a href="${pageContext.request.contextPath}/list">Trips</a></li>
            <c:if test="${sessionScope.user.role == 'admin'}">
                <li><a href="${pageContext.request.contextPath}/department/list.jsp">Departments</a></li>
            </c:if>
            <li><a href="${pageContext.request.contextPath}/logout">Logout</a></li>
        </c:if>
    </ul>
</nav>