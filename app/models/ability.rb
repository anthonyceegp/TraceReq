class Ability
  include CanCan::Ability

  def initialize(user)
    if user.present?
      if user.roles.include?(:admin)
        can :manage, :all
        cannot :destroy, User, id: user.id
      end

      if user.roles.include?(:project_manager)
        can :manage, Project, id: user.projects.ids
        can :manage, Demand, project: { id: user.projects.ids }
        can :manage, Artifact, project: { id: user.projects.ids }
        can :manage, Relationship, project: { id: user.projects.ids}
        can [:read, :create], Comment
        can [:update, :destroy], Comment, user_id: user.id
        can [:show, :update], User, id: user.id
      end

      if user.roles.include?(:systems_analyst)
        can :read, Project, id: user.projects.ids
        can :manage, Demand, project: { id: user.projects.ids }
        can :manage, Artifact, project: { id: user.projects.ids }
        can :manage, Relationship, project: { id: user.projects.ids}
        can [:read, :create], Comment
        can [:update, :destroy], Comment, user_id: user.id
        can [:show, :update], User, id: user.id
      end

      if user.roles.include?(:developer)
        can :read, Project, id: user.projects.ids
        can :read, Demand, project: { id: user.projects.ids }
        can [:read, :update, :history, :delete_file], Artifact, project: { id: user.projects.ids }
        can [:read, :filter], Relationship, project: { id: user.projects.ids }
        can [:read, :create], Comment
        can [:update, :destroy], Comment, user_id: user.id
        can [:show, :update], User, id: user.id
      end

      if user.roles.include?(:tester)
        can :read, Project, id: user.projects.ids
        can :read, Demand, project: { id: user.projects.ids }
        can [:read, :update, :history, :delete_file], Artifact, project: { id: user.projects.ids }
        can [:read, :filter], Relationship, project: { id: user.projects.ids }
        can [:read, :create], Comment
        can [:update, :destroy], Comment, user_id: user.id
        can [:show, :update], User, id: user.id
      end

      if user.roles.include?(:guest)
        can :read, Project, id: user.projects.ids
        can :read, Demand, project: { id: user.projects.ids }
        can :read, Artifact, project: { id: user.projects.ids }
        can [:read, :filter], Relationship, project: { id: user.projects.ids}
        can [:read], Comment
        can [:show, :update], User, id: user.id
      end
    end
  end
end