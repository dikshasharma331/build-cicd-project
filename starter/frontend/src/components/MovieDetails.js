import React, { useState, useEffect } from 'react';
import axios from 'axios';

function MovieDetail({ movie }) {
  const [details, setDetails] = useState(null);
  useEffect(() => {
    const apiUrl =
      process.env.REACT_APP_MOVIE_API_URL ||
      'http://a1b2914772400482da06e03ad20893aa-609970314.us-east-1.elb.amazonaws.com';
    axios
      .get(`${apiUrl}/movies/${movie.id}`)
      .then((response) => {
        if (response && response.data) {
          setDetails(response.data);
        }
      })
      .catch((error) => {
        console.error('Failed to fetch movie details:', error);
      });
  }, [movie]);

  return (
    <div>
      <h2>{details?.movie.title}</h2>
      <p>{details?.movie.description}</p>
    </div>
  );
}

export default MovieDetail;
