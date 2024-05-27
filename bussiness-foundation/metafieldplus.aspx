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

<%@ Import Namespace="Mediachase.Commerce.Customers" %>
<%@ Import Namespace="Mediachase.Commerce.Catalog" %>
<%@ Import Namespace="Mediachase.MetaDataPlus.Configurator" %>


<form id="form1" runat="server" enctype="multipart/form-data">

    <h2><asp:Button runat="server" OnClick="AddMetaField" Text="Add MetaField" /></h2>
</form>

<script language="C#" type="text/C#" runat="server">
    void AddMetaField(object sender, EventArgs e)
    { 
        var metaFieldName = "TestField";
        var metaClassName = "FashionProduct";

        var metaField = MetaField.Load(CatalogContext.MetaDataContext, metaFieldName);
        if (metaField == null) {
            Log(String.Format("Creating the field {0} due to not found \n", metaFieldName));
            metaField = createMetaFieldInternal(metaFieldName);
        }

        var metaClass = MetaClass.Load(CatalogContext.MetaDataContext, metaClassName);

        if (!metaClass.MetaFields.Contains(metaField))
        {
            metaClass.AddField(metaField);
            Log(String.Format("Successfully, field {0} has been added to class {1}", metaField.Name, metaClass.Name));
            return;
        }

        Log(String.Format("Failed, field {0} has already been added to class {1}", metaField.Name, metaClass.Name));
    }

    public MetaField createMetaFieldInternal(string name) {
        var metaNamespace = string.Empty;
        var friendlyName = name;
        var description = string.Empty;
        var metaFieldType = MetaDataType.LongString;
        var isNullable = true;
        var length = 0;
        var isMultiLanguage = false;
        var isSearchable = false;
        var isEncrypted = false;


        var metaField = MetaField.Create(CatalogContext.MetaDataContext,
                            metaNamespace,
                            name,
                            friendlyName,
                            description,
                            metaFieldType,
                            length,
                            isNullable,
                            isMultiLanguage,
                            isSearchable,
                            isEncrypted);
        return metaField;
    }

    void Log(string text)
    {
        Response.Write("<div>" + text + "</div>");
    }
</script>

<%
    Response.Write("<h3> Metafield Testing </h3>");
%>
