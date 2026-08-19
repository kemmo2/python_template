from fastapi import FastAPI

app = FastAPI(title="React + Python Codespaces API")


@app.get("/api/health")
def health() -> dict[str, str]:
    return {"status": "ok", "message": "FastAPI is running"}
