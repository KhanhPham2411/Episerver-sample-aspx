<%@ Page Language="C#" AutoEventWireup="true" %>
<%@ Import Namespace="EPiServer.Cms.UI.AspNetIdentity" %>
<%@ Import Namespace="Microsoft.AspNet.Identity" %>

<%@ Import Namespace="EPiServer.Framework" %>
<%@ Import Namespace="EPiServer.Framework.Initialization" %>
<%@ Import Namespace="Microsoft.AspNet.Identity.EntityFramework" %>

<%@ Import Namespace="System" %>
<%@ Import Namespace="System.Collections.Generic" %>
<%@ Import Namespace="System.Configuration.Provider" %>
<%@ Import Namespace="System.Globalization" %>
<%@ Import Namespace="System.Linq" %>
<%@ Import Namespace="System.Web" %>
<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="System.IO.Compression" %>

<%@ Import Namespace="Mediachase.Commerce.Catalog" %>
<%@ Import Namespace="EPiServer.Core" %>
<%@ Import Namespace="EPiServer.ServiceLocation" %>
<%@ Import Namespace="EPiServer.Commerce.Catalog.Linking" %>
<%@ Import Namespace="Mediachase.Commerce.Catalog.Managers" %>


<form id="form1" runat="server" enctype="multipart/form-data">
    <h2>
        <input placeholder="0.00002" value="0.00002" type="text" id="decimalValue" name="decimalValue" />
        <asp:Button runat="server" OnClick="Calculate" Text="Calculate" />

    </h2>
</form>

<script language="C#" type="text/C#" runat="server">
    void Calculate(object sender, EventArgs e)
    {
        string decimalValue = Request.Form["decimalValue"];

        Decimal result;
        var result1 = Decimal.TryParse(decimalValue, out result) && result >= 0M;
        var result2 = Decimal.TryParse(decimalValue, NumberStyles.Float, CultureInfo.InvariantCulture, out result) && result >= 0m;

        Log("Input: " + decimalValue);
        Log("[Decimal.TryParse(decimalValue, out result) && result >= 0M] return " + result1);
        Log("[Decimal.TryParse(decimalValue, NumberStyles.Float, CultureInfo.InvariantCulture, out result) && result >= 0m] return " + result2);
    }
    void Log(string text)
    {
        Response.Write("<div>" + text + "</div>");
    }
</script>

<%
    Response.Write("<h3> Relation Testing </h3>");
%>
