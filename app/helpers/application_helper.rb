# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def embed_cmd(cmds)
    "api_handler(#{cmds.to_json})"
  end
end
