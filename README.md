# DocxToGCS API

This repository contains a FastAPI application that converts HTML or Markdown content to DOCX files and uploads them to Google Cloud Storage.

## Overview

The application provides an API endpoint `/convert/to-docx` that accepts a JSON payload containing the content to be converted, the desired format (HTML or Markdown), and a query string. It then converts the content to a DOCX file, uploads it to Google Cloud Storage, and returns a public URL for download.

## Repository Structure

```
├── .gitignore
├── Dockerfile
├── README.md
├── deploy.sh
├── deploy_local.sh
├── main.py
├── requirements.txt
├── src
│   ├── __init__.py
│   ├── auth.py
│   ├── docx_converters.py
│   └── endpoints.py
└── uvicorn_config.py
```

- `.gitignore`: Specifies intentionally untracked files that Git should ignore.
- `Dockerfile`: Defines the Docker image for the application.
- `README.md`: This file, providing an overview of the project.
- `deploy.sh`: Script for deploying the application.
- `deploy_local.sh`: Script for local deployment.
- `main.py`: The main application entry point.
- `requirements.txt`: Lists the Python dependencies.
- `src/`: Contains the application source code.
  - `__init__.py`: Initializes the `src` package.
  - `auth.py`: Handles API authentication.
  - `docx_converters.py`: Contains the logic for converting HTML and Markdown to DOCX.
  - `endpoints.py`: Defines the API endpoints.
- `uvicorn_config.py`: Configuration file for Uvicorn.

## Getting Started

### Prerequisites

- Python 3.7+
- Docker (if you want to run the application in a container)
- Google Cloud SDK (if you want to deploy to Google Cloud)
- A Google Cloud Storage bucket
- A Google Cloud service account JSON key file

### Installation

1.  Clone the repository:

    ```bash
    git clone https://github.com/jmelm93/docx-to-gcs.git
    cd docx-to-gcs
    ```

2.  Create a virtual environment:

    ```bash
    python3 -m venv venv
    source venv/bin/activate  # On Windows use `venv\Scripts\activate`
    ```

3.  Install the dependencies:

    ```bash
    pip install -r requirements.txt
    ```

4.  Set up environment variables:
    - Create a `.env` file in the root directory.
    - Add the following variables:
      ```
      API_USERNAME=your_username
      API_PASSWORD=your_password
      SERVICE_ACCOUNT_JSON=json string of GCP service account
      PORT=8080
      ENV=development # or production
      ```
    - Replace `your_username` and `your_password` with your desired credentials.

### Running the Application

1.  **Locally:**

    ```bash
    python main.py
    ```

    The API will be available at `http://0.0.0.0:8080`.

2.  **With Docker:**

    ```bash
    docker build -t docx-converter .
    docker run -p 8080:8080 docx-converter
    ```

    The API will be available at `http://localhost:8080`.

### API Usage

The API endpoint is `/convert/to-docx`. It accepts a POST request with the following JSON payload:

```json
{
  "query": "Your query string",
  "content": "Your HTML or Markdown content",
  "format": "html" or "markdown"
}
```

The API will return a JSON response with the public URL of the generated DOCX file:

```json
{
  "download_url": "https://storage.googleapis.com/your-bucket/your-file.docx"
}
```

## Authentication

The API is protected with HTTP Basic authentication. You need to provide the correct username and password in the request headers.

## Deployment

The repository includes `deploy.sh` and `deploy_local.sh` scripts for deployment.

- `deploy.sh`: For deploying to Google Cloud Run.
- `deploy_local.sh`: For deploying locally.
