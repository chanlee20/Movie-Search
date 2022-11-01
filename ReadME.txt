Movie Search App (Swift)
Credits to TMDB for all the data pulled

Functionalities:

1. The app implements a tab bar with at least two tabs: one to search for movies, and
the other for their saved favorites. Each tab should have a custom image (no built-in images).
2. Data is pulled from the API and populated in a collection view with multiple
columns. Each search should return at least 20 movies (less if there aren’t 20 results). JSON
results are processed using the Codable protocol.
3. Users can see the title and an image for each movie.
4. Images are cached to allow for smooth scrolling. This means don’t make a network
request for an image every time a new cell appears on screen. Reuse the cells instead of
creating new ones.
5. Selecting a movie pushes a new view controller onto the navigation stack with a
larger (higher resolution) image and at least 3 additional pieces of information about the movie
(hint: you might have to make an additional API request to get this data).
6. The user can change the search query by editing a text field.
7. A spinner is shown when the data is being pulled from the API, and the request is
done in the background, not locking up the user interface.
8. Users can save a movie to their favorites.
9. Users can delete a movie from their favorites.
10. The layout is clean and easy to use.
11. Properly attribute TMDb as the source of the movie data.
12. Favorites are maintained between app launches (data saved locally).
13. The project should adhere to the MVC design pattern and Swift guidelines as in Lab
14. Clear Favorites List
15. Gain access to top 20 most popular actors in a different tab bar
16. Have data in collection view of up coming movies and popular movies based on the segement control button
17. Have detailed information (reviews, similar movies) for favorite movies when touched on the table view
