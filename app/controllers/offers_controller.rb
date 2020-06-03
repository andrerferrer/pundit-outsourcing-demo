class OffersController < ApplicationController
  def index
    # The logic here is that the user can see it if:
    # 1- the user is the owner of the offer
    # 2- the user is the booker of the offer
    @offers = policy_scope(Offer)
  end

  def show
    @offer = Offer.find params[:id]
    authorize @offer
  end
  
end
