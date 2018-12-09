module ApplicationHelper
	def active_for(options = {})
    name_of_controller = options[:controller] || nil
    name_of_action     = options[:action]     || nil
    request_path       = options[:path]       || nil

    if request_path.nil?
      if (name_of_action.nil? or name_of_action == action_name) and name_of_controller == controller_name
        'active'
      else
        ''
      end
    else
      request_path == request.path ? 'active' : ''
    end
  end

  def active_project?
    active = active_for(controller: "demands", action: "index") +
             active_for(controller: "demands", action: "new") +
             active_for(controller: "demands", action: "create") +
             active_for(controller: "projects", action: "artifacts") +
             active_for(controller: "projects", action: "show") +
             active_for(controller: "projects", action: "edit") +
             active_for(controller: "projects", action: "users") +
             active_for(controller: "projects", action: "add_users") +
             active_for(controller: "projects", action: "status") +
             active_for(controller: "artifact_types") +
             active_for(controller: "artifact_statuses") +
             active_for(controller: "relationship_types") 

    if active_for(controller: "artifacts") == 'active'
      active = 'active' unless request.path.match(/\/projects\/\d+\/artifacts/).nil?
    end

    if active_for(controller: "relationships") == 'active'
      active = 'active' unless request.path.match(/\/projects\/\d+\/relationships/).nil?
    end

    active == 'active' ? true : false
  end

  def active_demand?
    active =  active_for(controller: "demands", action: "show") +
              active_for(controller: "demands", action: "edit") +
              active_for(controller: "demands", action: "import") +
              active_for(controller: "demands", action: "conflict") +
              active_for(controller: "demands", action: "status")

    if active_for(controller: "artifacts") == 'active'
      active = 'active' unless request.path.match(/\/projects\/\d+\/demands\/\d+\/artifacts/).nil?
    end

    if active_for(controller: "relationships") == 'active'
      active = 'active' unless request.path.match(/\/projects\/\d+\/demands\/\d+\/relationships/).nil?
    end

    if active_for(controller: "comments") == 'active'
      active = 'active' unless request.path.match(/\/projects\/\d+\/demands\/\d+\/artifacts\/\d+\/comments/).nil?
    end

    active == 'active' ? true : false
  end

  def is_invalid(object, symbol)
    object.errors.include?(symbol) ? " is-invalid" : ""
  end

  def error_message_for(object, symbol)
    raw "<div class='invalid-feedback'>#{object.errors.full_messages_for(symbol).first}</div>" if object.errors[symbol].present?
  end
end
