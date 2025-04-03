package com.schooltrip.controller;


import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import com.schooltrip.model.User;
import com.schooltrip.util.DBConnection;

@WebServlet("/updateStatus")
public class StatusUpdateServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Check if user is admin
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        if (user == null || !"admin".equals(user.getRole())) {
            response.sendRedirect("login");
            return;
        }
        
        // Get parameters
        String idStr = request.getParameter("id");
        String status = request.getParameter("status");
        
        // Validate parameters
        if (idStr == null || status == null || 
            (!status.equals("APPROVED") && !status.equals("CANCELLED"))) {
            response.sendRedirect("list");
            return;
        }
        
        try {
            int id = Integer.parseInt(idStr);
            updateTripStatus(id, status);
            
            // Redirect back to the list page
            response.sendRedirect("list");
            
        } catch (NumberFormatException e) {
            response.sendRedirect("list");
        }
    }
    
    private void updateTripStatus(int tripId, String status) {
        String query = "UPDATE trips SET status = ? WHERE id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            
            stmt.setString(1, status);
            stmt.setInt(2, tripId);
            stmt.executeUpdate();
            
        } catch (SQLException e) {
            System.out.println("Error updating trip status: " + e.getMessage());
            e.printStackTrace();
        }
    }
}