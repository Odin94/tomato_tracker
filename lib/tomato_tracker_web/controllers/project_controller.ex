defmodule TomatoTrackerWeb.ProjectController do
  use TomatoTrackerWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html", projects: StorageHandler.get_tomatoes_by_task_by_project())
  end

  def new(conn, _params) do
    render(conn, "new.html", projects: StorageHandler.get_tomatoes_by_task_by_project())
  end

  def create(conn, %{"project" => %{"name" => name}}) do
    StorageHandler.put_project(name)

    conn
    |> put_flash(:info, "Created project #{name}.")
    |> redirect(to: NavigationHistory.last_path(conn, default: "/"))
  end

  def show(conn, %{"id" => project_id}) do
    project_id = String.to_integer(project_id)

    case StorageHandler.get_tomatoes_by_task_by_project(project_id) do
      [] ->
        conn
        |> put_status(:not_found)
        |> put_view(TomatoTrackerWeb.ErrorView)
        |> render("404.html")

      [project] ->
        render(conn, "show.html", project: project)
    end
  end

  def update(conn, %{"id" => project_id, "project" => %{"name" => project_name}}) do
    IO.inspect(project_name)

    conn
    |> put_flash(:info, "Updated project #{project_name}.")
    |> redirect(to: NavigationHistory.last_path(conn, default: "/"))
  end
end
