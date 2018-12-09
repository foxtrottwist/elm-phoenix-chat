defmodule VmesteWeb.MessageView do
  use VmesteWeb, :view
  alias VmesteWeb.MessageView

  def render("index.json", %{messages: messages}) do
    %{data: render_many(messages, MessageView, "message.json")}
  end

  def render("show.json", %{message: message}) do
    %{data: render_one(message, MessageView, "message.json")}
  end

  def render("message.json", %{message: message}) do
    %{id: message.id,
      name: message.name,
      body: message.body}
  end
end
