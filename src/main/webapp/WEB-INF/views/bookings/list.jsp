<%@ page import="java.util.List" %>
<%@ page import="com.schooltrip.model.Trip" %>
<%@ page import="com.schooltrip.dao.Trips" %>
<%@ page import="java.sql.SQLException" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Trip List - School Trips Booking System</title>
<link rel="stylesheet" href="css/main.css">
<style>
  table {
    width: 100%;
    border-collapse: collapse;
    margin-top: 20px;
  }
  th, td {
    border: 1px solid #ddd;
    padding: 8px;
    text-align: left;
  }
  th {
    background-color: #0066cc;
    color: white;
  }
  tr:nth-child(even) {
    background-color: #f2f2f2;
  }
  tr:hover {
    background-color: #e9f0f7;
  }
  .action-buttons {
    display: flex;
    gap: 5px;
  }
  .action-buttons a {
    padding: 5px 10px;
    text-decoration: none;
    border-radius: 3px;
    color: white;
    font-size: 12px;
  }
  .view-btn {
    background-color: #0066cc;
  }
  .edit-btn {
    background-color: #28a745;
  }
  .delete-btn {
    background-color: #dc3545;
  }
  .approve-btn {
    background-color: #28a745;
  }
  .cancel-btn {
    background-color: #dc3545;
  }
  .status-pending {
    background-color: #ffc107;
    color: #212529;
    padding: 3px 8px;
    border-radius: 12px;
    font-size: 12px;
    font-weight: bold;
  }
  .status-approved {
    background-color: #28a745;
    color: white;
    padding: 3px 8px;
    border-radius: 12px;
    font-size: 12px;
    font-weight: bold;
  }
  .status-cancelled {
    background-color: #dc3545;
    color: white;
    padding: 3px 8px;
    border-radius: 12px;
    font-size: 12px;
    font-weight: bold;
  }
</style>
</head>
<body>
<jsp:include page="/WEB-INF/views/common/header.jsp" />
<jsp:include page="/WEB-INF/views/common/navigation.jsp" />

<div class="container">
<h1>List of School Trips</h1>

<div class="dashboard">
<div class="trip-actions">
<a href="book"><button>Request New Trip</button></a>
</div>

<table>
<thead>
<tr>
<th>ID</th>
<th>Department</th>
<th>Destination</th>
<th>Days</th>
<th>Total Students</th>
<th>Status</th>
<th>Created At</th>
<th>Actions</th>
</tr>
</thead>
<tbody>
<%
try {
List<Trip> trips = Trips.getAllTrips();
for (Trip trip : trips) {
    String statusClass = "";
    if ("PENDING".equalsIgnoreCase(trip.getStatus())) {
        statusClass = "status-pending";
    } else if ("APPROVED".equalsIgnoreCase(trip.getStatus())) {
        statusClass = "status-approved";
    } else if ("CANCELLED".equalsIgnoreCase(trip.getStatus())) {
        statusClass = "status-cancelled";
    }
%>
<tr>
<td><%= trip.getId() %></td>
<td><%= trip.getDepartment() %></td>
<td><%= trip.getDestination() %></td>
<td><%= trip.getDays() %></td>
<td><%= trip.getTotalStudent() %></td>
<td><span class="<%= statusClass %>"><%= trip.getStatus() %></span></td>
<td><%= trip.getCreatedAt() %></td>

<td class="action-buttons">
<a href="view?id=<%= trip.getId() %>" class="view-btn">View</a>
<% if (session.getAttribute("user") != null &&
      "admin".equals(((com.schooltrip.model.User)session.getAttribute("user")).getRole())) { 
    
    // Only show approve/cancel buttons if the status is pending
    if ("PENDING".equalsIgnoreCase(trip.getStatus())) { %>
        <a href="updateStatus?id=<%= trip.getId() %>&status=APPROVED" class="approve-btn">Approve</a>
        <a href="updateStatus?id=<%= trip.getId() %>&status=CANCELLED" class="cancel-btn">Cancel</a>
<% } 
    
    // Only show edit/delete buttons if the status is approved
    if ("APPROVED".equalsIgnoreCase(trip.getStatus())) { %>
        <a href="edit?id=<%= trip.getId() %>" class="edit-btn">Edit</a>
        <a href="delete?id=<%= trip.getId() %>" class="delete-btn" onclick="return confirm('Are you sure you want to delete this trip?');">Delete</a>
<% }
} %>
</td>


</tr>
<%
}
if (trips.isEmpty()) {
%>
<tr>
<td colspan="8" style="text-align: center;">No trips found</td>
</tr>
<%
}
} catch (SQLException e) {
out.println("<tr><td colspan='8'>Error fetching trips: " + e.getMessage() + "</td></tr>");
}
%>
</tbody>
</table>
</div>
</div>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />
<script src="js/script.js"></script>
</body>
</html>