from fastapi import APIRouter, HTTPException
from fastapi.responses import JSONResponse
from pydantic import BaseModel
from src.docx_converters import html_to_docx_gcs, markdown_to_docx_gcs

router = APIRouter(prefix="/convert", tags=["Document Conversion"])

# Define the request schema
class DocxRequest(BaseModel):
    query: str
    content: str
    format: str

@router.post("/to-docx")
async def convert_to_docx(request: DocxRequest):
    """
    Convert HTML or Markdown content to a DOCX file, save it to storage,
    and return a downloadable link.
    """
    supported_formats = {"html", "markdown"}

    if request.format not in supported_formats:
        raise HTTPException(status_code=400, detail="Invalid format. Supported formats: html, markdown")

    try:
        # Determine the storage bucket
        bucket_name = "content-maps"  # Replace with your actual bucket name

        # Service account file
        service_account_filename = 'service-account.json'  # Replace with the actual path if needed

        # Convert based on format
        public_url = "Job failed. Please try again."
        
        if request.format == "html":
            public_url = html_to_docx_gcs(
                query=request.query,
                html_content=request.content,
                service_account_filename=service_account_filename,
                bucket_name=bucket_name
            )
        elif request.format == "markdown":
            public_url = markdown_to_docx_gcs(
                query=request.query,
                markdown_content=request.content,
                service_account_filename=service_account_filename,
                bucket_name=bucket_name
            )

        # Return the public URL of the file
        return JSONResponse(content={"download_url": public_url}, status_code=200)

    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
