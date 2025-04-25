# Makefile for Medusa Docker image

# Variables
IMAGE_NAME = medusa-docker
IMAGE_TAG = latest
CONTAINER_NAME = medusa-container
PORT = 9000

# Default target
.PHONY: all
all: build run

# build run non-dev
.PHONY: non-dev
non-dev: build run-non-dev

# Build the Docker image
.PHONY: build
build:
	@echo "Building Docker image $(IMAGE_NAME):$(IMAGE_TAG)..."
	docker build -t $(IMAGE_NAME):$(IMAGE_TAG) .

# Run the Docker container
.PHONY: run
run:
	@echo "Running Docker container $(CONTAINER_NAME) on port $(PORT)..."
	-docker stop $(CONTAINER_NAME) >/dev/null 2>&1
	-docker rm $(CONTAINER_NAME) >/dev/null 2>&1
	docker run -e MODE=dev -d --name $(CONTAINER_NAME) -p $(PORT):$(PORT) $(IMAGE_NAME):$(IMAGE_TAG)
	@echo "Medusa is now running at http://localhost:$(PORT)"

# Run the Docker container non-dev
.PHONY: run-non-dev
run-non-dev:
	@echo "Running Docker container $(CONTAINER_NAME) on port $(PORT)..."
	-docker stop $(CONTAINER_NAME) >/dev/null 2>&1
	-docker rm $(CONTAINER_NAME) >/dev/null 2>&1
	docker run -d --name $(CONTAINER_NAME) -p $(PORT):$(PORT) $(IMAGE_NAME):$(IMAGE_TAG)
	@echo "Medusa is now running at http://localhost:$(PORT)"

# Stop and remove the Docker container
.PHONY: stop
stop:
	@echo "Stopping Docker container $(CONTAINER_NAME)..."
	-docker stop $(CONTAINER_NAME)
	-docker rm $(CONTAINER_NAME)

# Clean up Docker container and image
.PHONY: clean
clean: stop
	@echo "Removing Docker image $(IMAGE_NAME):$(IMAGE_TAG)..."
	-docker rmi $(IMAGE_NAME):$(IMAGE_TAG)

# Extract a fresh copy of the container DB.
.PHONY: exportdata
exportdata:
	@echo "Extracting a fresh copy of the container DB"
	-docker exec -e PGPASSWORD=medusa -t $(CONTAINER_NAME) \
       pg_dump -U medusa -h localhost -d medusa > ./data-dump/medusa-data.sql

# Help target
.PHONY: help
help:
	@echo "Makefile for Medusa Docker image"
	@echo ""
	@echo "Targets:"
	@echo "  all         - Build the Docker image and run the container in dev mode (default)"
	@echo "  non-dev     - Build the Docker image and run the container in non-dev mode"
	@echo "  build       - Build the Docker image"
	@echo "  run         - Run the Docker container in dev mode"
	@echo "  run-non-dev - Run the Docker container in non-dev mode"
	@echo "  stop        - Stop and remove the Docker container"
	@echo "  clean       - Clean up Docker container and image"
	@echo "  exportdata  - Extract a fresh copy of the container DB to data-dump/medusa-data.sql"
	@echo "  help        - Show this help message"
	@echo ""
	@echo "Variables:"
	@echo "  IMAGE_NAME     - Docker image name (default: $(IMAGE_NAME))"
	@echo "  IMAGE_TAG      - Docker image tag (default: $(IMAGE_TAG))"
	@echo "  CONTAINER_NAME - Docker container name (default: $(CONTAINER_NAME))"
	@echo "  PORT           - Port to expose (default: $(PORT))"
