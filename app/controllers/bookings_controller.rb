class BookingsController < ApplicationController
  def index
    # The back-end protection is implemented in the
    # BookingPolicy::Scope#resolve
    @bookings = policy_scope(Booking)
  end

  def create
    @offer = Offer.find params[:offer_id]
    @booking = Booking.new(
      offer: @offer,
      customer: current_user
    )
    
    # Create the booking if the user is not the owner 
    authorize @booking
  
    if @booking.save
      redirect_to bookings_path
    else
      flash[:alert] = @booking.errors.messages
      render 'offers/show'
    end

  end
end
