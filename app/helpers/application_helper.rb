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

  def active_settings?
    active =  active_for(controller: "artifact_types") +
              active_for(controller: "relationship_types") +
              active_for(controller: "projects", action: "users") +
              active_for(controller: "projects", action: "add_users")

    active == 'active' ? true : false
  end

  def active_project?
    active = active_for(controller: "demands", action: "index") +
             active_for(controller: "projects", action: "artifacts") +
             active_for(controller: "projects", action: "show")

    if active_for(controller: "artifacts") == 'active'
      active = 'active' unless request.path.match(/\/projects\/\d+\/artifacts/).nil?
    end

    active == 'active' ? true : false
  end

  def active_demand?
    active =  active_for(controller: "relationships") +
              active_for(controller: "demands", action: "show") +
              active_for(controller: "demands", action: "edit") +
              active_for(controller: "demands", action: "import") +
              active_for(controller: "demands", action: "conflict")

    if active_for(controller: "artifacts") == 'active'
      active = 'active' unless request.path.match(/\/projects\/\d+\/demands\/\d+\/artifacts/).nil?
    end

    active == 'active' ? true : false
  end
end
