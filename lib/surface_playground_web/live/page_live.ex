defmodule SurfacePlaygroundWeb.PageLive do
  use Surface.LiveView

  alias Surface.Components.Form
  alias Surface.Components.Form.{Field, Label}

  def render(assigns) do
    ~F"""
    <Form for={:email} submit="update_email" opts={[id: "update_email"]}>
      <Field name={:email}>
        <Label class="block text-sm font-medium text-gray-700">
          Email
        </Label>
      </Field>
    </Form>
    """
  end
end
