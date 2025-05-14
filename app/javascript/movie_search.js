// app/javascript/movie_search.js

document.addEventListener("DOMContentLoaded", function () {
  const params = new URLSearchParams(window.location.search);
  const query = params.get("query");
  console.log("Turbo page load!");
  if (query) {
    const input = document.getElementById("movie-search-textbox"); // Forzar sincronización del textbox con la búsqueda en el link
    if (input) {
      input.value = query;
    }
  }
});