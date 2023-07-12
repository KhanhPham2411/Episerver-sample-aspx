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
<%@ Import Namespace="Mediachase.BusinessFoundation.Data" %>
<%@ Import Namespace="Mediachase.BusinessFoundation.Data.Meta.Management" %>
<%@ Import Namespace="Mediachase.BusinessFoundation.MetaForm" %>

<form id="form1" runat="server" enctype="multipart/form-data">
    <h2><asp:Button runat="server" OnClick="UpdateMetaClassTitle" Text="Update Meta Class Title" /></h2>

    <h2><asp:Button runat="server" OnClick="AddMetaFieldCheckboxBoolean" Text="Add MetaField Checkbox Boolean" /></h2>
    <h2><asp:Button runat="server" OnClick="DeleteMetaField" Text="Delete MetaField" /></h2>
    <h2><asp:Button runat="server" OnClick="ChangeMetaField" Text="Change MetaField" /></h2>
</form>

<script language="C#" type="text/C#" runat="server">
     void UpdateMetaClassTitle(object sender, EventArgs e)
    { 
        var metaClass = DataContext.Current.MetaModel.MetaClasses[ContactEntity.ClassName];
        using (var myEditScope = DataContext.Current.MetaModel.BeginEdit())
        {
            metaClass.TitleFieldName = "Code";

            myEditScope.SaveChanges();
        }
    }

    void CreateMetaField(MetaClass metaClass, string metaFieldName, string metaFieldFriendlyName, string type)
    {
        if (metaClass.Fields[metaFieldName] == null)
        {
            metaClass.CreateMetaField(metaFieldName, metaFieldFriendlyName, type, true, "", new Mediachase.BusinessFoundation.Data.Meta.Management.AttributeCollection());
            FormController.AddMetaPrimitive(metaClass.Name, "[MC_BaseForm]", metaFieldName);
            FormController.AddMetaPrimitive(metaClass.Name, "[MC_ShortViewForm]", metaFieldName);
            FormController.AddMetaPrimitive(metaClass.Name, "[MC_GeneralViewForm]", metaFieldName);
        }
    }
   
    void AddMetaFieldCheckboxBoolean(object sender, EventArgs e)
    {
        string name = "Test9";
        string friendlyName = name;
        var typeName = MetaFieldType.LongText;

        var orgMetaClass = DataContext.Current.MetaModel.MetaClasses[OrganizationEntity.ClassName];
        var metaClass = orgMetaClass;
        

        var existingField = metaClass.Fields[name];
        if (existingField == null)
        {
            using (var myEditScope = DataContext.Current.MetaModel.BeginEdit())
            {
                metaClass.CreateMetaField(name, friendlyName, typeName, new Mediachase.BusinessFoundation.Data.Meta.Management.AttributeCollection());
                metaClass.Fields[name].AccessLevel = AccessLevel.Customization;
                //metaClass.Fields[name].Owner = "Development";

                myEditScope.SaveChanges();
            }

            Log(String.Format("Meta field {0} is added to meta class {1}", name, OrganizationEntity.ClassName));
        }
        else
        {
            Log(String.Format("Meta field {0} is already exist in meta class {1}", name, OrganizationEntity.ClassName));
        }

    }

    void DeleteMetaField(object sender, EventArgs e)
    {
        string name = "Attends";
        string className = OrganizationEntity.ClassName;
        string typeName = MetaFieldType.Text;

        string friendlyName = name;
        var orgMetaClass = DataContext.Current.MetaModel.MetaClasses[className];
        var metaClass = orgMetaClass;


        var existingField = metaClass.Fields[name];
        if (existingField != null)
        {
            metaClass.DeleteMetaField(name);

            Log(String.Format("Meta field {0} is removed in meta class {1}", name, className));
        }
        else
        {
            Log(String.Format("Meta field {0} is not exist in meta class {1}", name, className));
        }

    }

    void AssignMetaField()
    {
        string name = "Line3";
        string className = AddressEntity.ClassName;
        string typeName = MetaFieldType.Text;

        string friendlyName = name;
        var entityMetaClass = DataContext.Current.MetaModel.MetaClasses[className];

        var existingField = entityMetaClass.Fields[name];
        if (existingField != null)
        {
            using (var myEditScope = DataContext.Current.MetaModel.BeginEdit())
            {
                IMetaFieldInstaller mcInstaller = MetaFieldType.GetInstaller(typeName);

                if (mcInstaller != null)
                {
                    // Assign Data Source
                    mcInstaller.AssignDataSource(existingField);

                    // Assign Validators
                    mcInstaller.AssignValidators(existingField);
                }

                myEditScope.SaveChanges();
            }

            Log(String.Format("Meta field {0} is assgined to meta class {1}", name, className));
        }
        else
        {
            Log(String.Format("Meta field {0} is not exist in meta class {1}", name, className));
        }
    }

    void ChangeMetaField(object sender, EventArgs e)
    {
        string name = "Test2";
        string friendlyName = name;
        var typeName = MetaFieldType.LongText;

        var metaClass = DataContext.Current.MetaModel.MetaClasses[ContactEntity.ClassName];


        var existingField = metaClass.Fields[name];
        if (existingField != null)
        {
            using (MetaClassManagerEditScope editScope = DataContext.Current.MetaModel.BeginEdit())
            {
                var field =  metaClass.Fields[name];
                field.Attributes["MaxLength"] = 11;

                editScope.SaveChanges();
            }

            Log(String.Format("Meta field {0} with attribute MaxLength changed", name, ContactEntity.ClassName));
        }
        else
        {
            Log(String.Format("Meta field {0} is not exist in meta class {1}", name, ContactEntity.ClassName));
        }
    }

    void Log(string text)
    {
        Response.Write("<div>" + text + "</div>");
    }
</script>

<%
    Response.Write("<h3> Metafield Testing </h3>");
%>
