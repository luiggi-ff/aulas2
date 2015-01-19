class UserMailer < ActionMailer::Base
  default from: "from@example.com"

  def booking_created(booking,resource)
    @user = booking.owner
    @booking = booking
    @resource = resource
    mail(to: @user[:email], subject: 'Reserva creada')
  end
    
  def booking_reminder(booking_id,resource_id)
    @resource = Resource.find(resource_id)
    @booking = Booking.for_resource(resource_id).find(booking_id)
    unless @booking.nil?
      @user = @booking.owner
        mail(to: @user[:email], subject: 'Recordatorio de Reserva')
    end 
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
