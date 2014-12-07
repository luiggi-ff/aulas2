class UserMailer < ActionMailer::Base
  default from: "from@example.com"

  def booking_created(booking,resource)
    @user = booking.owner
    @booking = booking
    @resource = resource
    mail(to: @user[:email], subject: 'Reserva creada')
  end

  def booking_approved(booking,resource)
    @user = booking.owner
    @booking = booking
    @resource = resource    
    mail(to: @user[:email], subject: 'Reserva aprobada')
  end

  def booking_rejected(booking,resource)
    @user = booking.owner
    @booking = booking
    @resource = resource    
    mail(to: @user[:email], subject: 'Reserva rechazada')
  end
  def booking_cancelled(booking,resource)
    @user = booking.owner
    @booking = booking
    @resource = resource
    mail(to: @user[:email], subject: 'Reserva cancelada')
  end
    
    
end
