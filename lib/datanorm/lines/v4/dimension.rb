# frozen_string_literal: true

module Datanorm
  module Lines
    module V4
      # Immediate product description texts. Should take precedence over Text records.
      # Aufbau der „D“ Zeile (Dimensionstextsatz)
      # 1 : Satzartenkennzeichen[1] : Buchstabe D für Dimensionstext
      # 2 : Verarbeitungskennzeichen[1] : N=Neuanlage, L=Löschung, A=Änderung
      # 3 : Artikelnummer[15] : Inhalt alphanumerische Zeichen
      # 4 : Zeilennummer[2/0] : numerisch
      # 5 : Unterkennzeichen[1] : alphanumerisch, F = freier Text,. T = Einfügen von Textblöcken, E = Einfügungen von Textblöcken und Werten
      # 6 : Frei[8] : alphanumerische Zeichen
      # 7 : Zeilentext[40] : alphanumerische Zeichen
      # 8 : Zeilennummer[2/0] : numerisch
      # 9 : Unterkennzeichen[1] : alphanumerisch, F = freier Text,. T = Einfügen von Textblöcken, E = Einfügungen von Textblöcken und Werten
      # 10 : Frei[8] : alphanumerische Zeichen
      # 11 : Zeilentext[40] : alphanumerische Zeichen
      class Dimension < ::Datanorm::Lines::Base
        def to_s
          "DIMENSION [#{id}] #{line_number.to_s.rjust(3)} #{content.encode('UTF-8', 'CP850').gsub("\n", '⏎')}"
        end

        def id
          encode columns[2]
        end

        def line_number
          columns[3].to_i
        end

        def content
          "#{encode(columns[6])}\n#{encode(columns[10])}"
        end

        def <=>(other)
          line_number <=> other.line_number
        end
      end
    end
  end
end
