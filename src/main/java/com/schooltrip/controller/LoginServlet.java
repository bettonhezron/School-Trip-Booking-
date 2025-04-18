package com.schooltrip.controller;
import java.io.IOException;
import java.util.Optional;
import com.schooltrip.dao.UserDAO;
import com.schooltrip.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
	private UserDAO userDAO;
    
    public void init() {
        userDAO = new UserDAO();
    }
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/views/users/login.jsp").forward(request, response);
    }
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");
       
        try {
            Optional<User> userOptional = userDAO.authenticateUser(email, password);
            
            if (userOptional.isPresent()) {
                User user = userOptional.get();
                HttpSession session = request.getSession();
                session.setAttribute("user", user);
                session.setAttribute("loggedUser", user);
                
                // Add success message to session
                session.setAttribute("successMessage", "Welcome back, " + user.getFullName() + "! You've successfully logged in.");
                
                // Redirect to home page
                response.sendRedirect(request.getContextPath() + "/home");
            } else {
                request.setAttribute("errorMessage", "Invalid email or password");
                request.getRequestDispatcher("/WEB-INF/views/users/login.jsp").forward(request, response);
            }
        
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "An error occurred during login");
            request.getRequestDispatcher("/WEB-INF/views/users/login.jsp").forward(request, response);
        }
    }
}