class BookingsController < ApplicationController
  def index
    # The back-end protection is implemented in the
    # BookingPolicy::Scope#resolve
    @bookings = policy_scope(Booking)
  end
end
