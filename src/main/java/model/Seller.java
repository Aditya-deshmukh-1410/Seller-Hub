package model;

public class Seller {
    private String port_id;
    private String name;
    private String email;
    private String location;
    private String password;

    public Seller(String port_id, String name, String email, String location, String password) {
        this.port_id = port_id;
        this.name = name;
        this.email = email;
        this.location = location;
        this.password = password;
    }
    public String getPortId() { 
        return port_id; 
    }
    
    public void setPortId(String portId) { 
        this.port_id = portId;  
    }
    
    public String getName() { 
        return name; 
    }
    
    public void setName(String name) { 
        this.name = name; 
    }
    
    public String getEmail() { 
        return email; 
    }
    
    public void setEmail(String email) { 
        this.email = email; 
    }
    
    public String getLocation() { 
        return location; 
    }
    
    public void setLocation(String location) { 
        this.location = location; 
    }
    
    public String getPassword() { 
        return password; 
    }
    
    public void setPassword(String password) { 
        this.password = password; 
    }
    
}
