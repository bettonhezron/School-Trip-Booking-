<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Register - Student Trips</title>
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
        }
        input:focus, select:focus {
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
    <h2>Create an Account</h2>

    <c:if test="${not empty errorMessage}">
        <div class="error-message">
            <p><i class="fas fa-exclamation-circle"></i> ${errorMessage}</p>
        </div>
    </c:if>

    <form action="${pageContext.request.contextPath}/register" method="post" id="registerForm" novalidate>
        <div class="form-group">
            <label for="fullName">Full Name:</label>
            <input type="text" id="fullName" name="fullName" placeholder="Enter your full name" required>
                <span class="error-text" id="fullNameError">Full name must be at least 3 characters and contain only letters.</span>
        </div>

        <div class="form-group">
            <label for="email">Email:</label>
            <input type="email" id="email" name="email" placeholder="Enter your email address" required>
            <span class="error-text" id="emailError">Please enter a valid email address.</span>
        </div>

        <div class="form-group">
            <label for="password">Password:</label>
            <input type="password" id="password" name="password" placeholder="Create a strong password" required>
            <span class="error-text" id="passwordError">
                Must be 8+ chars, with uppercase, lowercase, and a number.
            </span>
        </div>

        <div class="form-group">
            <label for="role">Role:</label>
            <select id="role" name="role" required>
                <option value="">-- Select your role --</option>
                <option value="cod">COD (Chair of Department)</option>
                <option value="admin">Administrator</option>
            </select>
            <span class="error-text" id="roleError">Please select a role.</span>
        </div>

        <div class="form-group">
            <label for="departmentId">Department:</label>
            <select id="departmentId" name="departmentId" required>
                <option value="">-- Select your department --</option>
                <option value="1">Computer Science</option>
                <option value="2">Engineering</option>
                <option value="3">Business</option>
            </select>
            <span class="error-text" id="departmentError">Please select a department.</span>
        </div>

        <div class="form-group">
            <button type="submit"><i class="fas fa-user-plus"></i> Register</button>
        </div>
    </form>

    <div class="auth-links">
        <p>Already have an account? <a href="${pageContext.request.contextPath}/login">Login here</a></p>
    </div>
</div>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />

<script>
    document.addEventListener('DOMContentLoaded', function () {
        const form = document.getElementById('registerForm');
        const inputs = {
            fullName: document.getElementById('fullName'),
            email: document.getElementById('email'),
            password: document.getElementById('password'),
            role: document.getElementById('role'),
            department: document.getElementById('departmentId')
        };

        const errors = {
            fullName: document.getElementById('fullNameError'),
            email: document.getElementById('emailError'),
            password: document.getElementById('passwordError'),
            role: document.getElementById('roleError'),
            department: document.getElementById('departmentError')
        };

        function validateField(field, error, type) {
            const value = field.value.trim();
            let valid = true;

            switch (type) {
            case "fullName":
                valid = /^[A-Za-z\s]{3,}$/.test(value.trim());
                break;
                case "email":
                    valid = /^\S+@\S+\.\S+$/.test(value);
                    break;
                case "password":
                    valid = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).{8,}$/.test(value);
                    break;
                case "role":
                case "department":
                    valid = value !== "";
                    break;
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

        // Trigger validation on blur
     Object.keys(inputs).forEach(key => {
    // Validate on blur
    inputs[key].addEventListener('blur', () => {
        validateField(inputs[key], errors[key], key);
    });

    // Live validation while typing
    inputs[key].addEventListener('input', () => {
        validateField(inputs[key], errors[key], key);
    });
});


        form.addEventListener('submit', function (e) {
            let valid = true;
            Object.keys(inputs).forEach(key => {
                const isValid = validateField(inputs[key], errors[key], key);
                if (!isValid) valid = false;
            });

            if (!valid) e.preventDefault(); // prevent form submission
        });
    });
</script>
</body>
</html>
