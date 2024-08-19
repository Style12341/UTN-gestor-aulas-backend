module DateHelper
  def day_to_wday(day_name)
    day_to_wday = {
      'Lunes' => 1,
      'Martes' => 2,
      'Miércoles' => 3,
      'Miercoles' => 3, # Without accents
      'Jueves' => 4,
      'Viernes' => 5,
      'Sábado' => 6,
      'Sabado' => 6, # Without accents
      'Domingo' => 0
    }
    day_to_wday[day_name]
  end
end
