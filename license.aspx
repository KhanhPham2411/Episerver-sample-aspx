<%@ Page Language="C#" AutoEventWireup="true" %>
<%@ Import Namespace="EPiServer.Cms.UI.AspNetIdentity" %>
<%@ Import Namespace="Microsoft.AspNet.Identity" %>

<%@ Import Namespace="EPiServer.Framework" %>
<%@ Import Namespace="EPiServer.Framework.Initialization" %>
<%@ Import Namespace="Microsoft.AspNet.Identity.EntityFramework" %>

<%@ Import Namespace="System" %>
<%@ Import Namespace="System.Collections.Generic" %>
<%@ Import Namespace="System.Configuration.Provider" %>
<%@ Import Namespace="System.Linq" %>
<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="System.IO.Compression" %>

<%@ Import Namespace="EPiServer.DataAbstraction" %>
<%@ Import Namespace="EPiServer.DataAccess.Internal" %>
<%@ Import Namespace="EPiServer.ServiceLocation" %>


<form id="form1" runat="server" enctype="multipart/form-data">
    <h2>
        <input placeholder="" type="text" id="test" name="test" />
        <asp:Button runat="server" OnClick="GetMachineOrGenericLicenseFile" Text="Get Machine Or Generic License File" />
    </h2>
</form>

<script language="C#" type="text/C#" runat="server">

    private static FileInfo GetRootedFile(string fileName)
    {
        if(Path.IsPathRooted(fileName))
            return new FileInfo(fileName);

        return new FileInfo(Path.Combine(AppDomain.CurrentDomain.BaseDirectory, fileName));
    }
    void GetMachineOrGenericLicenseFile(object sender, EventArgs e)
    {
        GetMachineOrGenericLicenseFile();
    }
    FileInfo GetMachineOrGenericLicenseFile()
    {
        string fileName = "License.config";
        FileInfo file = GetRootedFile(fileName);
        String machineNameAndFileName = Environment.MachineName + file.Name;
        // absolute path in the config 
        FileInfo machineFile = new FileInfo(Path.Combine(file.Directory.FullName, machineNameAndFileName));
        if (machineFile.Exists)
        {
            return machineFile;
        }

        if (file.Exists)
        {
            Log("The license file exist" + file.FullName);
            return file;
        }
        Log("The license file \"{0}\" does not exist " + file.FullName);
        throw new Exception("The license file \"{0}\" does not exist" + file.FullName);
    }

    void Log(string text)
    {
        Response.Write("<div>" + text + "</div>");
    }
</script>

<%
    Response.Write("<h3> License Testing </h3>");
%>
