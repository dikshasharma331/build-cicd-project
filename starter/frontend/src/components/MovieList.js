import React, { useState, useEffect } from 'react';
import PropTypes from 'prop-types';
import axios from 'axios';

function MovieList({ onMovieClick }) {
  const [movies, setMovies] = useState([]);

  useEffect(() => {
    const apiUrl =
      process.env.REACT_APP_MOVIE_API_URL ||
      'http://a1b2914772400482da06e03ad20893aa-609970314.us-east-1.elb.amazonaws.com';
    axios
      .get(`${apiUrl}/movies`)
      .then((response) => {
        if (response && response.data && Array.isArray(response.data.movies)) {
          setMovies(response.data.movies);
        }
      })
      .catch((error) => {
        console.error('Failed to fetch movies:', error);
      });
  }, []);

  return (
    <ul>
      {movies.map((movie) => (
        <li className="movieItem" key={movie.id} onClick={() => onMovieClick(movie)}>
          {movie.title}
        </li>
      ))}
    </ul>
  );
}

MovieList.propTypes = {
  onMovieClick: PropTypes.func.isRequired,
};

export default MovieList;
