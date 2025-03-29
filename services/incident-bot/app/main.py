from fastapi import FastAPI, Request
from pydantic import BaseModel
from prompt_logic import summarize_alert

app = FastAPI()

class AlertInput(BaseModel):
    alert_text: str

@app.post("/summarize")
async def summarize(input: AlertInput):
    result = summarize_alert(input.alert_text)
    return {"summary": result}
