# DEMO
This was created from [this repo](https://github.com/andrerferrer/rename-references-demo) 

This is a demo to show-case how we can authorize a model with a user using another model in a rails app.
We'll implement this as a scope and in the create action.

## Schema
This is the schema.
Offer here represents whatever you're offering: a pet, an apartment, a ride in you car etc.
A booking here represents the purchasing of this offer.

```

  +--------------+       +-------------+
  |     users    |       |    offers   |
  +--------------+       +-------------+
+-| id           |---+   | id          |-+
| | first_name   |   |   | name        | |
| | last_name    |   |   | description | |
| | address      |   +-->| owner_id    | |
| | phone_number |       +-------------+ |
| +--------------+                       |
|                                        |
|            +-------------+             |
|            |  bookings   |             |
|            +-------------+             |
|            | id          |             |
|            | start_time  |             |
|            | end_time    |             |
+----------->| customer_id |             |
             | offer_id    |<------------+
             +-------------+

```

## What can be done for a booking create?

### 1. We need to set up [Pundit](https://github.com/varvet/pundit)
### 2. We need to adjust our [Policy](https://github.com/andrerferrer/pundit-outsourcing-demo/blob/master/app/policies/booking_policy.rb)
```ruby
# BookingPolicy
  def create?
    # You can create a booking if 
    # you're not the owner of the offer
    OfferPolicy.new(user, record.offer).not_owner?
  end
```

```ruby
# OfferPolicy
  def not_owner?
    user != record.owner
  end
```
### 3. We need to adjust our [Controller](https://github.com/andrerferrer/pundit-outsourcing-demo/blob/master/app/controllers/bookings_controller.rb)
```ruby
# BookingsController

  def create
    @offer = Offer.find params[:offer_id]
    @booking = Booking.new(
      customer: current_user,
      offer: @offer
    )
    
    # Create the booking if the user is not the owner 
    authorize @booking
  
    if @booking.save
      redirect_to bookings_path
    else
      render 'offers/show'
    end

  end
```
### 4. We need to adjust our [View](https://github.com/andrerferrer/pundit-outsourcing-demo/blob/master/app/views/offers/show.html.erb)
```erb
<% if policy(@offer).not_owner? %>
  <%= link_to "Book #{@offer.name}", offer_bookings_path(@offer), method: :create %>
<% end %>
```

## What can be done for the booking index?

### If you want the easy path

Protect it in the back-end

```ruby
# BookingPolicy
  # the 'easy' solution is implemented here and in the offers#index view as a conditional (if/else)
  # we will implement this in the Bookings#index view as well
  def index?
    record.customer == user || record.offer.owner == user
  end
```

Protect it in the front-end

```erb
#views/bookings/index.html.erb

<% @bookings.each do |booking| %>

  <%# Protect it in the front-end: %>
  <%# the user can see it if the user is in the policy for booking#index? %>
  <% if policy(booking).index? %>
    <h2>
      Booking offer: <%= booking.offer.name %>
    </h2>
    <p>
      Owner: <%= "#{booking.offer.owner.first_name} #{booking.offer.owner.last_name}" %>
    </p>
    <p>
      Customer: <%= "#{booking.customer.first_name} #{booking.customer.last_name}" %>
    </p>
  <% end %>

<% end %>
```

### If you want the not so easy path
```ruby
# BookingPolicy
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
```

And we're good to go 🤓