<%@ Page Language="C#" AutoEventWireup="true" %>
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

<%@ Import Namespace="Mediachase.Commerce.Catalog" %>
<%@ Import Namespace="EPiServer.Core" %>
<%@ Import Namespace="EPiServer" %>
<%@ Import Namespace="EPiServer.ServiceLocation" %>
<%@ Import Namespace="EPiServer.Commerce.Catalog.Linking" %>
<%@ Import Namespace="Mediachase.Commerce.Catalog.Managers" %>

<%@ Import Namespace="EPiServer.DataAbstraction" %>
<%@ Import Namespace="EPiServer.DataAccess.Internal" %>
<%@ Import Namespace="Swegon.Domain.EpiModels.Pages" %>
<%@ Import Namespace="Swegon.Business.StartPageResolver" %>
<%@ Import Namespace="System.Globalization" %>


<form id="form1" runat="server" enctype="multipart/form-data">
    <h2><asp:Button runat="server" OnClick="SiteSettings" Text="SiteSettings" /></h2>
</form>

<script language="C#" type="text/C#" runat="server">
    public SettingsPage GetSiteSettings()
    {
        var _startPageResolver = ServiceLocator.Current.GetInstance<IStartPageResolver>();
        var _contentLoader = ServiceLocator.Current.GetInstance<IContentLoader>();
        var _contentRepository = ServiceLocator.Current.GetInstance<IContentRepository>();

        var culture = new CultureInfo("en");

        //var startPage = _startPageResolver.GetStartPage(culture);
        //if (startPage == null)
        //{
        //    Log("Fake market detected. Missing start page for market {0} ({1})");
        //    return null;
        //}

        //if (ContentReference.IsNullOrEmpty(startPage.SettingsPage))
        //{
        //    Log("Could not resolve site settings page for the site. Please make sure that the current installation has a site and a configured site settings page for that site.");
        //}

        // _contentLoader.TryGet(startPage.SettingsPage, culture, out SettingsPage settingsPage);
        _contentRepository.TryGet(new ContentReference(7), culture, out SettingsPage settingsPage);

        var items = settingsPage.ProductMenuItems.ToList();
        
        LogItems(items);
        return settingsPage;
    }

    void SiteSettings(object sender, EventArgs e)
    {

        //var _siteSettings = ServiceLocator.Current.GetInstance<ISiteSettings>();
        
        //var items = _siteSettings.ProductMenuItems.ToList();
        //LogItems(items);
        
        GetSiteSettings();
    }
    void LogItems(IList<ContentReference> items)
    {
        Log(items.Count().ToString());
       
        foreach(var item in items)
        {
            Log(item.ID.ToString());
        }
    }

    void Log(string text)
    {
        Response.Write("<div>" + text + "</div>");
    }
</script>

<%
    Response.Write("<h3> SiteSettings Testing </h3>");
%>
