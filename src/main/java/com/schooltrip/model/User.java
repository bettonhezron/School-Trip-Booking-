package com.schooltrip.model;

public class User {
    private int userId;
    private String fullName;
    private String email;
    private String role;
    private int departmentId;
    private String departmentName;

    // Constructors
    public User() {}

    public User(String fullName, String email, String role, int departmentId) {
        this.fullName = fullName;
        this.email = email;
        this.role = role;
        this.departmentId = departmentId;
    }

    // Getters and Setters
    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getRole() { return role; }
    public void setRole(String role) { this.role = role; }

    public int getDepartmentId() { return departmentId; }
    public void setDepartmentId(int departmentId) { this.departmentId = departmentId; }
    
    public String getDepartmentName() {
        return departmentName;
    }
    
    public void setDepartmentName(String departmentName) {
        this.departmentName = departmentName;
    }
}