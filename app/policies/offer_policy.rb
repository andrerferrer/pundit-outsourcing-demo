class OfferPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      # Allow the user to see it only if the user is the owner or the customer
      
      # the 'hard' solution is implemented here
      # scope.joins(:bookings).where(owner: user)
      #      .or(
      #        scope.joins(:bookings).where(bookings: { customer: user }
      #      ))

      scope.all
    end
  end
  
  def show?
    # everyone can see it
    true
  end

end
