defmodule VmesteWeb.MessageController do
  use VmesteWeb, :controller

  alias Vmeste.Besada
  alias Vmeste.Besada.Message

  action_fallback VmesteWeb.FallbackController

  def index(conn, _params) do
    messages = Besada.list_messages()
    render(conn, "index.json", messages: messages)
  end

  def create(conn, %{"message" => message_params}) do
    with {:ok, %Message{} = message} <- Besada.create_message(message_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.message_path(conn, :show, message))
      |> render("show.json", message: message)
    end
  end

  def show(conn, %{"id" => id}) do
    message = Besada.get_message!(id)
    render(conn, "show.json", message: message)
  end

  def update(conn, %{"id" => id, "message" => message_params}) do
    message = Besada.get_message!(id)

    with {:ok, %Message{} = message} <- Besada.update_message(message, message_params) do
      render(conn, "show.json", message: message)
    end
  end

  def delete(conn, %{"id" => id}) do
    message = Besada.get_message!(id)

    with {:ok, %Message{}} <- Besada.delete_message(message) do
      send_resp(conn, :no_content, "")
    end
  end
end
