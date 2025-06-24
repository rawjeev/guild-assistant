# src/app.py

import gradio as gr

def chat_guild_assistant(user_input):
    # Placeholder for LangChain RAG pipeline
    return "Hello! Guild Assistant here. This feature is under development."

iface = gr.Interface(
    fn=chat_guild_assistant,
    inputs=gr.Textbox(lines=5, label="Ask about guild design"),
    outputs=gr.Textbox(label="Guild Assistant Reply")
)

if __name__ == "__main__":
    iface.launch()
