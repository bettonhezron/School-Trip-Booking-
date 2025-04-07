<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - Students Academic Trips Booking System</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">

    <style>
        .input-error {
            border: 1px solid #e74c3c !important;
            background-color: #fff0f0;
        }
        .error-text {
            color: #e74c3c;
            font-size: 0.85em;
            display: none;
            margin-top: 2px;
        }
        .error-visible {
            display: block;
            opacity: 1;
        }
        input:focus {
            outline: none;
            box-shadow: 0 0 3px 2px #3498db;
            transition: box-shadow 0.2s;
        }
    </style>
</head>
<body>
<jsp:include page="/WEB-INF/views/common/header.jsp" />
<jsp:include page="/WEB-INF/views/common/navigation.jsp" />

<div class="container auth-container">
    <h2>Login to Your Account</h2>

    <!-- Success Message (e.g., after logout) -->
    <c:if test="${not empty successMessage}">
        <div class="success-message" id="successMessage">
            <p><i class="fas fa-check-circle"></i> ${successMessage}</p>
        </div>
        
         <%
        session.removeAttribute("successMessage"); 
    %>
    
        <script>
            setTimeout(function () {
                var msg = document.getElementById("successMessage");
                if (msg) msg.style.display = "none";
            }, 5000);
        </script>
    </c:if>

    <form action="${pageContext.request.contextPath}/login" method="post" id="loginForm" novalidate>
        <div class="form-group">
            <label for="email"><i class="fas fa-envelope"></i> Email:</label>
            <input type="email" id="email" name="email" placeholder="Enter your email address">
            <span class="error-text" id="emailError">Please enter a valid email address.</span>
        </div>
        
        
        <div class="form-group" style="position: relative;">
    <label for="password"><i class="fas fa-lock"></i> Password:</label>
    <div style="position: relative;">
        <input type="password" id="password" name="password" placeholder="Enter your password">
        <span id="togglePasswordText" style="
            position: absolute;
            right: 10px;
            top: 50%;
            transform: translateY(-50%);
            cursor: pointer;
            font-size: 0.85em;
            color: #3498db;
            user-select: none;
        ">Show</span>
    </div>
    <span class="error-text" id="passwordError">Password must be at least 8 characters.</span>
</div>
        
        <!-- Error Message from Servlet -->
        <c:if test="${not empty errorMessage}">
            <div class="error-message">
                <p><i class="fas fa-exclamation-circle"></i> ${errorMessage}</p>
            </div>
        </c:if>

        <div class="form-group">
            <button type="submit"><i class="fas fa-sign-in-alt"></i> Login</button>
        </div>
    </form>

    <div class="auth-links">
        <p>Don't have an account? <a href="${pageContext.request.contextPath}/register">Register here</a></p>
    </div>
</div>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />

<script>
    document.addEventListener('DOMContentLoaded', function () {
        const form = document.getElementById('loginForm');
        const email = document.getElementById('email');
        const password = document.getElementById('password');
        const emailError = document.getElementById('emailError');
        const passwordError = document.getElementById('passwordError');

        function validateField(field, error, type) {
            const value = field.value.trim();
            let valid = true;

            if (type === 'email') {
                valid = /^\S+@\S+\.\S+$/.test(value);
            } else if (type === 'password') {
                valid = value.length >= 8;
            }

            if (!valid) {
                field.classList.add("input-error");
                error.classList.add("error-visible");
            } else {
                field.classList.remove("input-error");
                error.classList.remove("error-visible");
            }

            return valid;
        }
        
        
        const toggleText = document.getElementById("togglePasswordText");
        const passwordInput = document.getElementById("password");

        toggleText.addEventListener("click", function () {
            const isHidden = passwordInput.getAttribute("type") === "password";
            passwordInput.setAttribute("type", isHidden ? "text" : "password");
            toggleText.textContent = isHidden ? "Hide" : "Show";
        });


        // Validate on blur and on input (live validation)
        email.addEventListener('blur', () => validateField(email, emailError, 'email'));
        email.addEventListener('input', () => validateField(email, emailError, 'email'));

        password.addEventListener('blur', () => validateField(password, passwordError, 'password'));
        password.addEventListener('input', () => validateField(password, passwordError, 'password'));

        form.addEventListener('submit', function (e) {
            const isEmailValid = validateField(email, emailError, 'email');
            const isPasswordValid = validateField(password, passwordError, 'password');

            if (!isEmailValid || !isPasswordValid) {
                e.preventDefault();
            }
        });
    });
</script>

</body>
</html>
