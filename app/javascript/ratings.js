document.addEventListener("turbo:load", () => { // Cuando cargue la página
  const stars = document.querySelectorAll(".star"); // Conseguir las estrellas
  stars.forEach((star) => {
    star.addEventListener("click", (event) => { // Hacer las estrellas clickeables
      const score = event.target.dataset.score; // Conseguir la puntuación
      const movieId = event.target.parentElement.dataset.movieId; // Conseguir la id de la película
      fetch("/ratings", { // Enviar a la base de datos
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          "X-CSRF-Token": document
            .querySelector("meta[name='csrf-token']")
            .getAttribute("content"),
        },
        body: JSON.stringify({
          rating: {
            score: score,
            movie_api_id: movieId,
          },
        }),
      })
        .then((response) => {
          if (response.redirected) { // Redigir al login si el usuario no ha iniciado sesión
            window.location.href = response.url;
          } else if (!response.ok) {
            throw new Error("Request failed");
          } else {
            return response.json();
          }
        })
        .then((data) => {
          if (data) {
            const ratingDiv = document.querySelector( // Conseguir el contenedor del rating de la película
              `.movie-rating[data-movie-id="${movieId}"]`
            );
            if (ratingDiv) {
              const voteAverageRaw = ratingDiv.getAttribute("vote-average");
              const voteAverage = parseFloat(voteAverageRaw) / 2;
              const dbRatings = parseFloat(data.ratings);
              const voteCount = parseInt(ratingDiv.getAttribute("vote-count"), 10);
              const dbCount = parseInt(data.count, 10);
              const ratingsText = ratingDiv.getAttribute("ratings-text") || "";
              const totalRatingSum = voteAverage * voteCount + dbRatings * dbCount;
              const totalVotes = voteCount + dbCount;
              const combinedAverage = totalVotes > 0 ? totalRatingSum / totalVotes : 0;
              const formattedAverage = combinedAverage.toFixed(1);
              // Combinar los ratings de la API con los de la base de datos
              ratingDiv.querySelector(".rating-score").textContent = `${formattedAverage} / 5 (${totalVotes} ${ratingsText})`;
            }
          }
        })
        .catch((error) => {
          console.error("There was a problem with the fetch operation:", error);
        });
    });
  });
});
