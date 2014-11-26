class UserMailer < ActionMailer::Base
  default from: "from@example.com"

  def booking_created(user)
    @user = user
    mail(to: @user[:email], subject: 'Reserva creada')
  end

  def booking_approved(user)
    @user = user
    mail(to: @user[:email], subject: 'Reserva aprobada')
  end

  def booking_rejected(user)
    @user = user
    mail(to: @user[:email], subject: 'Reserva rechazada')
  end
  def booking_cancelled(user)
    @user = user
    mail(to: @user[:email], subject: 'Reserva cancelada')
  end
    
    
end
