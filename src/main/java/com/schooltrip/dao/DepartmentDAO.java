package com.schooltrip.dao;

import com.schooltrip.model.Department;
import com.schooltrip.util.DBConnection;

import java.sql.*;
import java.util.*;

public class DepartmentDAO {
    private Connection connection;

    public DepartmentDAO() throws SQLException {
        connection = DBConnection.getConnection(); 
    }

    public List<Department> getAllDepartments() {
        List<Department> departments = new ArrayList<>();
        String sql = "SELECT id, name FROM department";

        try (PreparedStatement stmt = connection.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                Department dept = new Department();
                dept.setId(rs.getInt("id"));
                dept.setName(rs.getString("name"));
                departments.add(dept);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return departments;
    }
}
