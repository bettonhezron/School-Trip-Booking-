<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Students Academic Trips Booking System</title>
    <link rel="stylesheet" href="css/main.css">
    <style>
        .error-text {
            color: red;
            font-size: 0.9em;
            display: none;
        }

        input:invalid, textarea:invalid {
            border: 1px solid #e74c3c;
        }

        input.valid, textarea.valid {
            border: 1px solid #2ecc71;
        }

        input.invalid, textarea.invalid {
            border: 1px solid #e74c3c;
        }

        .form-group {
            margin-bottom: 1em;
        }

        label {
            font-weight: bold;
        }

        button {
            padding: 10px 15px;
            background-color: #2ecc71;
            color: white;
            border: none;
            cursor: pointer;
            font-size: 1em;
        }

        button:hover {
            background-color: #27ae60;
        }
    </style>
</head>
<body>
<jsp:include page="/WEB-INF/views/common/header.jsp" />
<jsp:include page="/WEB-INF/views/common/navigation.jsp" />

<div class="container">
    <h1>School Trip Registration</h1>

    <c:if test="${not empty errorMessage}">
        <div class="error-message">${errorMessage}</div>
    </c:if>

    <div class="dashboard">
        <form id="tripForm" action="book" method="post" novalidate>
            <div class="form-group">
                <label for="department">Department Name:</label>
                <input type="text" id="department" name="department" value="${sessionScope.loggedUser.department}" readonly>
                <span class="error-text"></span>
            </div>

            <div class="form-group">
                <label for="destination">Destination (Enter the destination of the trip):</label>
                <input type="text" id="destination" name="destination" required pattern="^[A-Za-z\s]+$" title="Only letters and spaces are allowed.">
                <span class="error-text">Destination is required and should only contain letters and spaces.</span>
            </div>

            <div class="form-group">
                <label for="days">Number of Days (Max 7 days):</label>
                <input type="number" id="days" name="days" min="1" max="7" required>
                <span class="error-text">Please enter a valid number of days (min 1, max 7).</span>
            </div>

            <div class="form-group">
                <label for="description">Trip Description (Brief overview of the trip):</label>
                <textarea id="description" name="description" rows="4" required></textarea>
                <span class="error-text">Description is required.</span>
            </div>

            <div class="form-group">
                <label for="special_request">Special Requests (Optional):</label>
                <textarea id="special_request" name="special_request" rows="4"></textarea>
            </div>

            <div class="form-group">
                <label for="total_students">Total Students (Minimum 1 student):</label>
                <input type="number" id="total_students" name="total_students" min="1" required>
                <span class="error-text">Please enter a valid number of students (min 1).</span>
            </div>

            <div class="form-group">
                <button type="submit">Submit Trip Request</button>
            </div>
        </form>
    </div>

    <p><a href="list">Back to Trip List</a></p>
</div>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />

<script>
    const form = document.getElementById('tripForm');
    const inputs = form.querySelectorAll('input[required], textarea[required]');

    form.addEventListener('submit', function (e) {
        let valid = true;

        inputs.forEach(input => {
            const errorText = input.nextElementSibling;
            if (!input.checkValidity() || (input.type === "text" && input.value.trim() === "")) {
                input.classList.remove("valid");
                input.classList.add("invalid");
                errorText.style.display = "block";
                valid = false;
            } else {
                input.classList.remove("invalid");
                input.classList.add("valid");
                errorText.style.display = "none";
            }
        });

        if (!valid) {
            e.preventDefault(); // Stop form submission if invalid
        }
    });

    // Remove error on input
    inputs.forEach(input => {
        input.addEventListener('input', () => {
            if (input.checkValidity()) {
                input.classList.remove("invalid");
                input.classList.add("valid");
                input.nextElementSibling.style.display = "none";
            }
        });
    });
</script>
</body>
</html>
