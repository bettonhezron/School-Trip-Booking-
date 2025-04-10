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
        .error-message {
            padding: 10px;
            background-color: #ffecec;
            border-left: 4px solid #e74c3c;
            margin-bottom: 20px;
            animation: fadeIn 0.3s ease;
        }
        @keyframes fadeIn {
            from { opacity: 0; }
            to { opacity: 1; }
        }
        @keyframes fadeOut {
            from { opacity: 1; }
            to { opacity: 0; }
        }
        .fade-out {
            animation: fadeOut 0.5s ease forwards;
        }
    </style>
</head>
<body>
<jsp:include page="/WEB-INF/views/common/header.jsp" />
<jsp:include page="/WEB-INF/views/common/navigation.jsp" />

<div class="container auth-container">
    <h2>Create an Account</h2>

    <c:if test="${not empty errorMessage}">
        <div class="error-message" id="serverErrorMessage">
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
            <select id="departmentId" name="departmentId" required disabled>
                <option value="">-- Select your department --</option>
                <c:forEach items="${departments}" var="dept">
                    <option value="${dept.departmentId}">${dept.departmentName}</option>
                </c:forEach>
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

        // Auto-dismiss server error messages after 5 seconds
        const serverErrorMessage = document.getElementById('serverErrorMessage');
        if (serverErrorMessage) {
            setTimeout(() => {
                serverErrorMessage.classList.add('fade-out');
                setTimeout(() => {
                    serverErrorMessage.style.display = 'none';
                }, 500);
            }, 5000);
        }

        // Helper: show error
        function showError(field, error) {
            field.classList.add("input-error");
            error.classList.add("error-visible");
            
            // Auto-dismiss client-side errors after 5 seconds
            setTimeout(() => {
                hideError(field, error);
            }, 5000);
        }

        // Helper: hide error
        function hideError(field, error) {
            field.classList.remove("input-error");
            error.classList.remove("error-visible");
        }

        // Validation logic
        function validateField(field, error, type) {
            const value = field.value.trim();
            let valid = true;

            switch (type) {
                case "fullName":
                    valid = /^[A-Za-z\s]{3,}$/.test(value);
                    break;
                case "email":
                    valid = /^\S+@\S+\.\S+$/.test(value);
                    break;
                case "password":
                    valid = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).{8,}$/.test(value);
                    break;
                case "role":
                    valid = value !== "";
                    break;
                case "department":
                    valid = field.disabled || value !== "";
                    break;
            }

            if (!valid) {
                showError(field, error);
            }

            return valid;
        }
        
        Object.keys(inputs).forEach(key => {
            inputs[key].addEventListener('input', () => {
                hideError(inputs[key], errors[key]);
            });
        });
        
        const roleSelect = inputs.role;
        const departmentSelect = inputs.department;

        // Watch for changes in the role dropdown
        roleSelect.addEventListener('change', () => {
            if (roleSelect.value === 'cod') {
                departmentSelect.disabled = false;
                departmentSelect.required = true;
            } else {
                departmentSelect.disabled = true;
                departmentSelect.required = false;
                departmentSelect.value = ''; 
                hideError(departmentSelect, errors.department);
            }
        });

        // Validate on submit only
        form.addEventListener('submit', function (e) {
            let valid = true;
            Object.keys(inputs).forEach(key => {
                if (key === 'department' && inputs.role.value !== 'cod') {
                    // Skip department validation if not COD
                    return;
                }
                
                const isValid = validateField(inputs[key], errors[key], key);
                if (!isValid) {
                    valid = false;
                }
            });

            if (!valid) e.preventDefault(); // stop form submission if invalid
        });
    });
</script>

</body>
</html>