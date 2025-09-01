# frozen_string_literal: true

module Datanorm
  module Lines
    module V4
      # Converts a single DATANORM v4 line into a Ruby Object.
      #
      class Parse
        include Calls

        # Vorlaufsatz "V": keine Kennzeichen
        # Kundenkontrollsatz "K": keine Kennzeichen
        # Warengruppensatz "S": keine Kennzeichen
        # Rabattsatz "R": keine Kennzeichen
        # Hauptsatz 1 "A": N = Neuanlage; L = Löschung; A = Änderung; X = Artikelnummernänderung
        # Hauptsatz 2 "B": N = Neuanlage; ; A = Änderung
        # Dimensionssatz "D": N = Neuanlage; A = Änderung; L = Löschung
        # Langtextsatz "T": N = Neuanlage; A = Änderung;        L = Löschung
        # Einfügesatz "E": N = Neuanlage; A = Änderung; L = Löschung
        # Staffelpreiszu-/-abschlagssatz "Z": N = Neuanlage; A = Änderung; L = Löschung
        # Leistungssatz "C": N = Neuanlage; A = Änderung; L = Löschung
        # Artikel-Set-Satz "J": N = Neuanlage; A = Änderung; L = Löschung
        # Preisänderungssatz "P": A = Änderung; P = Preisänderung
        CLASSES = {
          'A' => Datanorm::Lines::V4::Product,
          'B' => Datanorm::Lines::V4::Extra,
          'D' => Datanorm::Lines::V4::Dimension,
          'T' => Datanorm::Lines::V4::Text
          # 'P' => Datanorm::Lines::V4::Price,
        }.freeze

        option :columns
        option :source_line_number

        def call
          klass = CLASSES.fetch(columns.first[0], Datanorm::Lines::Base)
          klass.new(columns:, source_line_number:)
        end
      end
    end
  end
end
