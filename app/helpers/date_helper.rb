module DateHelper
  def day_to_wday(day_name)
    day_name = day_name&.downcase
    day_to_wday = {
      'lunes' => 1,
      'martes' => 2,
      'miércoles' => 3,
      'miercoles' => 3, # Without accents
      'jueves' => 4,
      'viernes' => 5,
      'sábado' => 6,
      'sabado' => 6, # Without accents
      'domingo' => 0
    }
    day_to_wday[day_name]
  end
  def wday_to_day(num)
    num_to_day = {
      1 => 'Lunes',
      2 => 'Martes',
      3 => 'Miércoles',
      4 => 'Jueves',
      5 => 'Viernes',
      6 => 'Sábado',
      0 => 'Domingo'
    }
    num_to_day[num]
  end
end
