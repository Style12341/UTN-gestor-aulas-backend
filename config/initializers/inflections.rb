# Be sure to restart your server when you modify this file.

# Add new inflection rules using the following format. Inflections
# are locale specific, and you may define rules for as many different
# locales as you wish. All of these examples are active by default:
# ActiveSupport::Inflector.inflections(:en) do |inflect|
#   inflect.plural /^(ox)$/i, "\\1en"
#   inflect.singular /^(ox)en/i, "\\1"
#   inflect.irregular "person", "people"
#   inflect.uncountable %w( fish sheep )
# end

# These inflection rules are supported but not enabled by default:
# ActiveSupport::Inflector.inflections(:en) do |inflect|
#   inflect.acronym "RESTful"
# end
ActiveSupport::Inflector.inflections do |inflect|
  inflect.irregular 'validacion', 'validaciones'
  inflect.irregular 'bedel', 'bedeles'
  inflect.irregular 'usuario', 'usuarios'
  inflect.irregular 'administrador', 'administradores'
  inflect.irregular 'reserva_periodica', 'reservas_periodicas'
  inflect.irregular 'reserva_esporadica', 'reservas_esporadicas'
  inflect.irregular 'reserva', 'reservas'
  inflect.irregular 'renglon_reserva_esporadica', 'renglones_reserva_esporadica'
  inflect.irregular 'renglon_reserva_periodica', 'renglones_reserva_periodica'
  inflect.irregular 'periodicidad', 'periodicidades'
end
