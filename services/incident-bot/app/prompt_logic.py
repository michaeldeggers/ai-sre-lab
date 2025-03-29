import os
import openai

openai.api_key = os.getenv("OPENAI_API_KEY")

def summarize_alert(alert_text):
    prompt = f'''
You are an SRE assistant. Given this alert:

{alert_text}

Summarize it in plain English, guess the root cause, and suggest one fix.
'''
    response = openai.ChatCompletion.create(
        model="gpt-4",
        messages=[{"role": "user", "content": prompt}],
        temperature=0.3
    )
    return response['choices'][0]['message']['content']
