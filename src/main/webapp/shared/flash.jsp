<% String flash = (String) session.getAttribute("flash");
   if (flash != null) { %>
  <div class="alert alert-success"><%= flash %></div>
  <% session.removeAttribute("flash"); } %>
