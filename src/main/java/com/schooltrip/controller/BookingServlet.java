package com.schooltrip.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import com.schooltrip.util.DBConnection;

@WebServlet("/book")
public class BookingServlet extends HttpServlet {
	
	 protected void doGet(HttpServletRequest request, HttpServletResponse response) 
	            throws ServletException, IOException {
	        request.getRequestDispatcher("/WEB-INF/views/bookings/create.jsp").forward(request, response);
	    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws IOException, ServletException {
        String department = req.getParameter("department");
        String destination = req.getParameter("destination");
        String days = req.getParameter("days");
        String description = req.getParameter("description");
        String specialRequest = req.getParameter("special_request");
        String totalStudents = req.getParameter("total_students");
        String status = "PENDING";
        
        String query = "INSERT INTO trips (department, destination, days, description, special_request, total_students, status) " +
                       "VALUES (?, ?, ?, ?, ?, ?, ?)";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement stmt = con.prepareStatement(query)) {

            // Setting parameters
            stmt.setString(1, department);
            stmt.setString(2, destination);
            stmt.setInt(3, Integer.parseInt(days));
            stmt.setString(4, description);
            stmt.setString(5, specialRequest);
            stmt.setInt(6, Integer.parseInt(totalStudents));
            stmt.setString(7, status);

            // Execute update
            int rowsAffected = stmt.executeUpdate();
            if (rowsAffected > 0) {
                System.out.println("Data inserted successfully.");
            } else {
                System.out.println("Error inserting data.");
            }
            res.sendRedirect("list");
        } catch (SQLException ex) {
            // Handle SQL exception
            System.out.println("Database error: " + ex.getMessage());
            ex.printStackTrace();
        } catch (NumberFormatException ex) {
            // Handle invalid number format
            System.out.println("Error with input format: " + ex.getMessage());
        }
    }
}
