class BookingPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  # the 'easy' solution is implemented here and in the offers#index view as a conditional (if/else)
  def index?

  end
end
