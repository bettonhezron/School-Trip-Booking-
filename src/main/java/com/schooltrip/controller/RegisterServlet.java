package com.schooltrip.controller;
import java.io.IOException;
import java.sql.SQLException;

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
import java.util.List;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
	private UserDAO userDAO;
	private DepartmentDAO departmentDAO;
    
    public void init() {
        userDAO = new UserDAO();
        try {
			departmentDAO = new DepartmentDAO();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
       
	
    }
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
    	
    	List<Department> departments = departmentDAO.getAllDepartments();
        request.setAttribute("departments", departments);
        request.getRequestDispatcher("/WEB-INF/views/users/register.jsp").forward(request, response);
    }
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String role = request.getParameter("role");
        int departmentId = Integer.parseInt(request.getParameter("departmentId"));
        
        User user = new User(fullName, email, role, departmentId);
        
        try {
            // Check if email already exists
            if (userDAO.emailExists(email)) {
                request.setAttribute("errorMessage", "Email already exists. Please use a different email address.");
                request.getRequestDispatcher("/WEB-INF/views/users/register.jsp").forward(request, response);
                return;
            }
            
         // Check of name is number
            if (fullName == null || fullName.trim().isEmpty() || fullName.trim().length() < 3 || fullName.matches("^\\d+$")) {
                request.setAttribute("errorMessage", "Full name must be at least 3 characters and cannot be just numbers.");
                request.getRequestDispatcher("/WEB-INF/views/users/register.jsp").forward(request, response);
                return;
            }
            // Validate input (expanded validation)
            if (fullName == null || fullName.trim().isEmpty()) {
                request.setAttribute("errorMessage", "Full name is required.");
                request.getRequestDispatcher("/WEB-INF/views/users/register.jsp").forward(request, response);
                return;
            }
            
            if (email == null || email.trim().isEmpty() || !email.contains("@")) {
                request.setAttribute("errorMessage", "Valid email address is required.");
                request.getRequestDispatcher("/WEB-INF/views/users/register.jsp").forward(request, response);
                return;
            }
            
            if (password == null || password.length() < 8) {
                request.setAttribute("errorMessage", "Password must be at least 8 characters long.");
                request.getRequestDispatcher("/WEB-INF/views/users/register.jsp").forward(request, response);
                return;
            }
            
            // Register user
            if (userDAO.registerUser(user, password)) {
                // Redirect to login with detailed success message
                HttpSession session = request.getSession();
                session.setAttribute("successMessage", "Registration successful!. Please log in.");
                response.sendRedirect(request.getContextPath() + "/login");
            } else {
                request.setAttribute("errorMessage", "Registration failed. Please try again.");
                request.getRequestDispatcher("/WEB-INF/views/users/register.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "An error occurred during registration: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/users/register.jsp").forward(request, response);
        }
    }


}