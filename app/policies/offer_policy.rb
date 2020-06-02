class OfferPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end
  
  def show?
    # everyone can see it
    true
  end

end
