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
<%@ Import Namespace="System.Web" %>
<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="System.IO.Compression" %>
<%@ Import Namespace="Mediachase.Commerce.Catalog.ImportExport" %>



<form id="form1" runat="server" enctype="multipart/form-data">
    <h2><asp:Button runat="server" OnClick="btnExportClick" Text="Export" value="test" /></h2>
</form>

<script language="C#" type="text/C#" runat="server">
    void btnExportClick(object sender, EventArgs e)
    {
        var catalogName = "Test";
        CatalogImportExport _importExport = new CatalogImportExport();

        FileStream fs = BuildExportPath();
        Log(fs.Name);
        Log(Path.GetDirectoryName(fs.Name));

        _importExport.Export(catalogName, fs, Path.GetDirectoryName(fs.Name));
    }

    FileStream BuildExportPath()
    {
        StringBuilder sbDirName = new StringBuilder(Path.GetTempPath());
        sbDirName.AppendFormat("CatalogExport_test");
        string dirName = sbDirName.ToString();
        if (Directory.Exists(dirName))
            Directory.Delete(dirName, true);
        DirectoryInfo dir = Directory.CreateDirectory(dirName);

        StringBuilder filePath = new StringBuilder(dir.FullName);
        filePath.AppendFormat("\\Catalog.xml");
        FileStream fs = new FileStream(filePath.ToString(), FileMode.Create, FileAccess.ReadWrite);

        return fs;
    }

    void Log(string text)
    {
        Response.Write("<div>" + text + "</div>");
    }
</script>

<%
    Response.Write("<h3> Export testing </h3>");
%>
