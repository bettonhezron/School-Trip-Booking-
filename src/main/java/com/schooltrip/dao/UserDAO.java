package com.schooltrip.dao;

import java.sql.*;
import java.util.Optional;

import com.schooltrip.model.User;
import com.schooltrip.util.DBConnection;
import com.schooltrip.util.PasswordHashUtil;

public class UserDAO {
    public boolean registerUser(User user, String password) throws Exception {
        String sql = "INSERT INTO users (full_name, email, password, role, department_id) VALUES (?, ?, ?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            pstmt.setString(1, user.getFullName());
            pstmt.setString(2, user.getEmail());
            pstmt.setString(3, PasswordHashUtil.hashPassword(password));
            pstmt.setString(4, user.getRole());
            pstmt.setInt(5, user.getDepartmentId());

            int affectedRows = pstmt.executeUpdate();
            return affectedRows > 0;
        }
    }

    public Optional<User> authenticateUser(String email, String password) throws Exception {
        String sql = "SELECT u.*, d.department_name FROM users u " +
                     "JOIN departments d ON u.department_id = d.department_id " +
                     "WHERE u.email = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, email);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    String storedPassword = rs.getString("password");
                    
                    if (PasswordHashUtil.verifyPassword(password, storedPassword)) {
                        User user = new User();
                        user.setUserId(rs.getInt("user_id"));
                        user.setFullName(rs.getString("full_name"));
                        user.setEmail(rs.getString("email"));
                        user.setRole(rs.getString("role"));
                        user.setDepartmentId(rs.getInt("department_id"));
                        user.setDepartmentName(rs.getString("department_name"));
                        
                        return Optional.of(user);
                    }
                }
            }
        }
        return Optional.empty();
    }
    public boolean emailExists(String email) throws Exception {
        String sql = "SELECT COUNT(*) FROM users WHERE email = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, email);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        }
        return false;
    }
}