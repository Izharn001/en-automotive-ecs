fetch("/api/vehicles")
  .then((response) => {
    return response.json();
    })

  .then((data) => {
    console.log(data);
  })

