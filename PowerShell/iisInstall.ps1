configuration IISInstall 
{ 
    node "localhost"
    { 
        WindowsFeature IIS 
        { 
            Ensure = "Present" 
            Name = "Web-Server"                       
        }

        WindowsFeature IISManagementTools
        {
            Name = "Web-Mgmt-Tools"
            Ensure = "Present"
        }
    } 
}