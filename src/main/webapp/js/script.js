// Common validation functions
function showError(inputElement, message) {
    const formGroup = inputElement.parentElement;
    const errorText = formGroup.querySelector('.error-text') || createErrorElement(formGroup);
    
    // Force style application
    inputElement.style.border = "2px solid #ff3333";
    inputElement.style.backgroundColor = "#fff0f0";
    formGroup.classList.add('has-error');
    errorText.textContent = message;
    errorText.style.display = 'block';
    
    console.log("Showing error for:", inputElement.id, message);
}

function clearError(inputElement) {
    const formGroup = inputElement.parentElement;
    const errorText = formGroup.querySelector('.error-text');
    
    // Reset styles
    inputElement.style.border = "1px solid #cce2cc";
    inputElement.style.backgroundColor = "";
    formGroup.classList.remove('has-error');
    
    if (errorText) {
        errorText.textContent = '';
        errorText.style.display = 'none';
    }
}

function createErrorElement(formGroup) {
    const errorText = document.createElement('span');
    errorText.className = 'error-text';
    formGroup.appendChild(errorText);
    return errorText;
}

// Email validation
function validateEmail(email) {
    const re = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
    return re.test(String(email).toLowerCase());
}

// Password validation - at least 8 characters, one uppercase, one lowercase, one number
function validatePassword(password) {
    const re = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d]{8,}$/;
    return re.test(String(password));
}

// Name validation - should not be a number
function validateName(name) {
    // Check if the trimmed name is not empty
    if (!name.trim()) return false;
    
    // Check if name contains only numbers
    const numbersOnly = /^\d+$/;
    if (numbersOnly.test(name)) return false;
    
    // Name should be at least 3 characters
    if (name.trim().length < 3) return false;
    
    return true;
}

// Initialize validation for login form
function initLoginFormValidation() {
    console.log("Initializing login form validation");
    const loginForm = document.querySelector('form[action*="login"]');
    if (!loginForm) {
        console.log("Login form not found");
        return;
    }

    console.log("Login form found, attaching submit handler");
    loginForm.addEventListener('submit', function(e) {
        console.log("Login form submitted");
        let hasErrors = false;
        
        // Email validation
        const emailInput = document.getElementById('email');
        if (!emailInput.value.trim()) {
            showError(emailInput, 'Email is required');
            hasErrors = true;
        } else if (!validateEmail(emailInput.value)) {
            showError(emailInput, 'Please enter a valid email address');
            hasErrors = true;
        } else {
            clearError(emailInput);
        }
        
        // Password validation
        const passwordInput = document.getElementById('password');
        if (!passwordInput.value.trim()) {
            showError(passwordInput, 'Password is required');
            hasErrors = true;
        } else {
            clearError(passwordInput);
        }
        
        if (hasErrors) {
            console.log("Validation errors found, preventing form submission");
            e.preventDefault();
        }
    });
    
    // Real-time validation
    const inputs = loginForm.querySelectorAll('input');
    inputs.forEach(input => {
        input.addEventListener('input', function() {
            clearError(this);
        });
        
        // Add blur event for real-time validation as user leaves each field
        input.addEventListener('blur', function() {
            if (this.id === 'email' && this.value.trim()) {
                if (!validateEmail(this.value)) {
                    showError(this, 'Please enter a valid email address');
                }
            }
            if (this.id === 'password' && this.value.trim() && this.value.length < 8) {
                showError(this, 'Password must be at least 8 characters');
            }
        });
    });
}

// Initialize validation for registration form
function initRegisterFormValidation() {
    console.log("Initializing registration form validation");
    const registerForm = document.querySelector('form[action*="register"]');
    if (!registerForm) {
        console.log("Registration form not found");
        return;
    }

    console.log("Registration form found, attaching submit handler");
    registerForm.addEventListener('submit', function(e) {
        console.log("Registration form submitted");
        let hasErrors = false;
        
        // Full name validation
        const fullNameInput = document.getElementById('fullName');
        if (!validateName(fullNameInput.value)) {
            showError(fullNameInput, 'Full name must be at least 3 characters and cannot be just numbers');
            hasErrors = true;
        } else {
            clearError(fullNameInput);
        }
        
        // Email validation
        const emailInput = document.getElementById('email');
        if (!emailInput.value.trim()) {
            showError(emailInput, 'Email is required');
            hasErrors = true;
        } else if (!validateEmail(emailInput.value)) {
            showError(emailInput, 'Please enter a valid email address');
            hasErrors = true;
        } else {
            clearError(emailInput);
        }
        
        // Password validation
        const passwordInput = document.getElementById('password');
        if (!passwordInput.value.trim()) {
            showError(passwordInput, 'Password is required');
            hasErrors = true;
        } else if (!validatePassword(passwordInput.value)) {
            showError(passwordInput, 'Password must be at least 8 characters long and include uppercase, lowercase and a number');
            hasErrors = true;
        } else {
            clearError(passwordInput);
        }
        
        // Role validation
        const roleInput = document.getElementById('role');
        if (!roleInput.value) {
            showError(roleInput, 'Please select a role');
            hasErrors = true;
        } else {
            clearError(roleInput);
        }
        
        // Department validation
        const departmentInput = document.getElementById('departmentId');
        if (!departmentInput.value) {
            showError(departmentInput, 'Please select a department');
            hasErrors = true;
        } else {
            clearError(departmentInput);
        }
        
        if (hasErrors) {
            console.log("Validation errors found, preventing form submission");
            e.preventDefault();
        }
    });
    
    // Real-time validation
    const inputs = registerForm.querySelectorAll('input, select');
    inputs.forEach(input => {
        input.addEventListener('input', function() {
            clearError(this);
        });
        
        input.addEventListener('change', function() {
            clearError(this);
        });
        
        // Add blur event for real-time validation as user leaves each field
        input.addEventListener('blur', function() {
            if (this.id === 'fullName' && this.value.trim()) {
                if (!validateName(this.value)) {
                    showError(this, 'Full name must be at least 3 characters and cannot be just numbers');
                }
            }
            if (this.id === 'email' && this.value.trim()) {
                if (!validateEmail(this.value)) {
                    showError(this, 'Please enter a valid email address');
                }
            }
            if (this.id === 'password' && this.value.trim()) {
                if (!validatePassword(this.value)) {
                    showError(this, 'Password must be at least 8 characters long and include uppercase, lowercase and a number');
                }
            }
        });
    });
}

// Success and error message handling
function initMessageHandling() {
    console.log("Initializing message handling");
    
    try {
        // Handle success messages
        const successMessages = document.querySelectorAll('.success-message');
        console.log("Found success messages:", successMessages.length);
        
        successMessages.forEach(message => {
            if (!message) return; // Skip if null
            
            console.log("Processing success message");
            
            // Add close button to success message if not already there
            if (!message.querySelector('.close-btn')) {
                const closeBtn = document.createElement('span');
                closeBtn.innerHTML = '&times;';
                closeBtn.className = 'close-btn';
                message.appendChild(closeBtn);
                
                // Close button functionality
                closeBtn.addEventListener('click', function() {
                    fadeOutAndRemove(message);
                });
            }
            
            // Auto-hide success message after 5 seconds
            setTimeout(function() {
                console.log("Auto-hiding success message");
                fadeOutAndRemove(message);
            }, 5000);
        });
        
        // Handle error messages
        const errorMessages = document.querySelectorAll('.error-message');
        console.log("Found error messages:", errorMessages.length);
        
        errorMessages.forEach(message => {
            if (!message) return; // Skip if null
            
            console.log("Processing error message");
            
            // Add close button to error message if not already there
            if (!message.querySelector('.close-btn')) {
                const closeBtn = document.createElement('span');
                closeBtn.innerHTML = '&times;';
                closeBtn.className = 'close-btn';
                message.appendChild(closeBtn);
                
                // Close button functionality
                closeBtn.addEventListener('click', function() {
                    fadeOutAndRemove(message);
                });
            }
            
            // Auto-hide error message after 5 seconds
            setTimeout(function() {
                console.log("Auto-hiding error message");
                fadeOutAndRemove(message);
            }, 5000);
        });
    } catch (e) {
        console.error("Error in message handling:", e);
    }
}

function fadeOutAndRemove(element) {
    if (!element) return; // Add null check
    
    console.log("Fading out element:", element);
    element.style.opacity = '0';
    element.style.transition = 'opacity 0.5s ease';
    
    setTimeout(function() {
        if (element && element.parentNode) {
            console.log("Removing element from DOM");
            element.parentNode.removeChild(element);
        }
    }, 500);
}





// Initialize all scripts when DOM is loaded
document.addEventListener('DOMContentLoaded', function() {
    console.log("DOM fully loaded");
    initLoginFormValidation();
    initRegisterFormValidation();
    
    // Slight delay for message handling to ensure all elements are available
    setTimeout(initMessageHandling, 100);
});