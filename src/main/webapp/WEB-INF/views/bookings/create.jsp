<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>School Trip Registration - School Trips Booking System</title>
<link rel="stylesheet" href="css/main.css">
</head>
<body>
<jsp:include page="/WEB-INF/views/common/header.jsp" />
<jsp:include page="/WEB-INF/views/common/navigation.jsp" />

<div class="container">
    <h1>School Trip Registration</h1>
    
    <c:if test="${not empty errorMessage}">
        <div class="error-message">
            ${errorMessage}
        </div>
    </c:if>
    
    <div class="dashboard">
        <form action="book" method="post">
            <div class="form-group">
                <label for="department">Department Name:</label>
                <input type="text" id="department" name="department" required>
            </div>
            
            <div class="form-group">
                <label for="destination">Destination:</label>
                <input type="text" id="destination" name="destination" required>
            </div>
            
            <div class="form-group">
                <label for="days">Number of Days:</label>
                <input type="number" id="days" name="days" min="1" required>
            </div>
            
            <div class="form-group">
                <label for="description">Trip Description:</label>
                <textarea id="description" name="description" rows="4" required></textarea>
            </div>
            
            <div class="form-group">
                <label for="special_request">Special Requests:</label>
                <textarea id="special_request" name="special_request" rows="4"></textarea>
            </div>
            
            <div class="form-group">
                <label for="total_students">Total Students:</label>
                <input type="number" id="total_students" name="total_students" min="1" required>
            </div>
            
            <div class="form-group">
                <button type="submit">Submit Trip Request</button>
            </div>
        </form>
    </div>
    
    <p><a href="list">Back to Trip List</a></p>
</div>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />
<script src="js/script.js"></script>
</body>
</html>