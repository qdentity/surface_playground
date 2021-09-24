defmodule MyContext do
  alias Phoenix.LiveView.Socket

  import Phoenix.LiveView, only: [assign: 3]

  @spec context_assign(socket :: Socket.t(), key :: atom, value :: term) :: Socket.t()
  def context_assign(socket, key, value),
    do:
      assign(
        socket,
        :__context__,
        socket.assigns
        |> Map.get(:__context__, %{})
        |> Map.put({__MODULE__, key}, value)
      )

  @spec context_get(socket :: Socket.t(), key :: atom, default :: default) :: term | default
        when default: term
  def context_get(socket, key, default \\ nil)

  def context_get(%Socket{assigns: %{__context__: context}}, key, default) do
    context
    |> Map.fetch({__MODULE__, key})
    |> case do
      :error -> default
      {:ok, value} -> value
    end
  end

  def context_get(_socket, _key, default), do: default
end

defmodule MyLiveComponent do
  use Surface.LiveComponent

  data foo, :string

  def mount(socket) do
    if connected?(socket) do
      IO.inspect(socket.assigns, label: "component mount")
    end
    {:ok, socket}
  end

  def update(assigns, socket) do
    if connected?(socket) do
      IO.inspect(assigns, label: "update assigns")
    end

    socket = assign(socket, assigns)

    foo = MyContext.context_get(socket, :foo, "'value not set in context'")
    socket = assign(socket, foo: foo)

    {:ok, socket}
  end

  def render(assigns) do
    ~F"""
    <div>
      <Context get={MyContext, foo: _foo}><!-- --></Context>
      This is the component, value for @foo: {@foo}.
    </div>
    """
  end
end

defmodule SurfacePlaygroundWeb.Example do
  use Surface.LiveView

  def mount(_params, _session, socket) do
    socket = MyContext.context_assign(socket, :foo, "set in liveview mount")
    {:ok, socket}
  end

  def render(assigns) do
    ~F"""
    <div>
    This is the liveview.
      <MyLiveComponent id="123"/>
    </div>
    """
  end
end
