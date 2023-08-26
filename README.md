# quisp-container

To build the container:
`docker build -t quisp:latest .`

To run within the container:
`docker run -it --rm -v $(pwd):/work quisp:latest /bin/bash`
