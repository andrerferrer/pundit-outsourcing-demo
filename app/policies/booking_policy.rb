class BookingPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      # The logic here is:
      # You can only see the bookings that you are the customer
      # OR
      # The bookings that you are the owner of the offer
      bookings_user_is_customer = scope.where(customer: user)
      bookins_user_is_owner = scope.joins(:offer).where(offers: { owner: user } )

      bookings_user_is_customer + bookins_user_is_owner
    end
  end

  # the 'easy' solution is implemented here and in the offers#index view as a conditional (if/else)
  # we will implement this in the BookingsController#index as well
  def index?
    record.customer == user || record.offer.owner == user
  end
end
