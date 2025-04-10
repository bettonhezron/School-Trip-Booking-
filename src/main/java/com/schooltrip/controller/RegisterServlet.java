package com.schooltrip.controller;

import com.schooltrip.dao.DepartmentDAO;
import com.schooltrip.dao.UserDAO;
import com.schooltrip.model.Department;
import com.schooltrip.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.regex.Pattern;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private UserDAO userDAO;
    private DepartmentDAO departmentDAO;
    // Regular expression for validating email
    private static final Pattern EMAIL_PATTERN = 
        Pattern.compile("^[A-Za-z0-9+_.-]+@(.+)$");
    
    @Override
    public void init() {
        try {
            userDAO = new UserDAO();
            departmentDAO = new DepartmentDAO();
        } catch (Exception e) {
            // Log the error properly instead of just printing stack trace
            getServletContext().log("Error initializing DAOs", e);
        }
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            List<Department> departments = departmentDAO != null ? 
                departmentDAO.getAllDepartments() : new ArrayList<>();
            request.setAttribute("departments", departments);
        } catch (Exception e) {
            getServletContext().log("Error retrieving departments", e);
            request.setAttribute("errorMessage", "Error loading departments. Please try again later.");
        }
        request.getRequestDispatcher("/WEB-INF/views/users/register.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String role = request.getParameter("role");
        String departmentIdParam = request.getParameter("departmentId");
        int departmentId = 0;
        
        // Load departments for potential form redisplay
        loadDepartments(request);
        
        // Validate all inputs first
        if (!validateInputs(fullName, email, password, role, departmentIdParam, request)) {
            request.getRequestDispatcher("/WEB-INF/views/users/register.jsp").forward(request, response);
            return;
        }
        
        // Parse departmentId after validation
        try {
            departmentId = Integer.parseInt(departmentIdParam);
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid department selection.");
            request.getRequestDispatcher("/WEB-INF/views/users/register.jsp").forward(request, response);
            return;
        }
        
        User user = new User(fullName, email, role, departmentId);
        
        try {
            // Check if email already exists
            if (userDAO.emailExists(email)) {
                request.setAttribute("errorMessage", "Email already exists. Please use a different email address.");
                request.getRequestDispatcher("/WEB-INF/views/users/register.jsp").forward(request, response);
                return;
            }

            // Check if department exists
            if (!departmentDAO.departmentExists(departmentId)) {
                request.setAttribute("errorMessage", "Selected department does not exist.");
                request.getRequestDispatcher("/WEB-INF/views/users/register.jsp").forward(request, response);
                return;
            }

            // Register user
            if (userDAO.registerUser(user, password)) {
                HttpSession session = request.getSession();
                session.setAttribute("successMessage", "Registration successful! Please log in.");
                response.sendRedirect(request.getContextPath() + "/login");
            } else {
                request.setAttribute("errorMessage", "Registration failed. Please try again.");
                request.getRequestDispatcher("/WEB-INF/views/users/register.jsp").forward(request, response);
            }
        } catch (Exception e) {
            getServletContext().log("Error during user registration", e);
            request.setAttribute("errorMessage", "An error occurred during registration. Please try again later.");
            request.getRequestDispatcher("/WEB-INF/views/users/register.jsp").forward(request, response);
        }
    }
    
    private boolean validateInputs(String fullName, String email, String password, 
                                  String role, String departmentIdParam, 
                                  HttpServletRequest request) {
        
        if (fullName == null || fullName.trim().isEmpty() || fullName.matches("^\\d+$")) {
            request.setAttribute("errorMessage", "Full name must be at least 3 characters and cannot be just numbers.");
            return false;
        }
        
        if (email == null || email.trim().isEmpty() || !EMAIL_PATTERN.matcher(email).matches()) {
            request.setAttribute("errorMessage", "Valid email address is required.");
            return false;
        }
        
        if (password == null || password.length() < 8) {
            request.setAttribute("errorMessage", "Password must be at least 8 characters long.");
            return false;
        }
        
        if (role == null || role.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Role selection is required.");
            return false;
        }
        
        if (departmentIdParam == null || departmentIdParam.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Department selection is required.");
            return false;
        }
        
        try {
            Integer.parseInt(departmentIdParam);
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid department selection.");
            return false;
        }
        
        return true;
    }
    
    private void loadDepartments(HttpServletRequest request) {
        try {
            List<Department> departments = departmentDAO != null ? 
                departmentDAO.getAllDepartments() : new ArrayList<>();
            request.setAttribute("departments", departments);
        } catch (Exception e) {
            getServletContext().log("Error retrieving departments", e);
            request.setAttribute("departments", new ArrayList<>());
        }
    }
}