# frozen_string_literal: true

module Datanorm
  module Lines
    module V4
      # 1 : Satzartenkennzeichen[1] : Buchstabe B für Hauptsatz 2
      # 2 : Verarbeitungskennzeichen[1] : N=Neuanlage, L=Löschung, A=Änderung
      # 3 : Artikelnummer[15] : Inhalt alphanumerische Zeichen
      # 4 : Matchcode[15] : alphanumerische Zeichen
      # 5 : Alternativ-Artikelnummer[15] : alphanumerische Zeichen
      # 6 : Katalogseite[8] : alphanumerische Zeichen
      # 7 : Bereich für Kupferzuschlag
      # 7a : Bereich für Kupferzuschlag
      # 7b : Bereich für Kupferzuschlag
      # 7c : Bereich für Kupferzuschlag
      # 8 : EAN-Nummer[13] : alphanumerische Zeichen
      # 9 : Anbindungsnummer[12] : alphanumerische Zeichen, zur Anbindung von Bildern
      # 10 : Warengruppe[10] : alphanumerische Zeichen s.a. .WRG-Datei
      # 11 : Kostenart[2/0] : numerisch
      # 12 : Verpackungsmenge[5/0] : numerisch
      # 13 : Referenznummer-Erstellerkürzel[4] : alphanumerische Zeichen
      # 14 : Referenznummer[17] : alphanumerische Zeichen
      class Extra < ::Datanorm::Lines::Base
        def to_s
          "EXTRA     [#{id}] #{"{#{matchcode}}" unless matchcode.empty?} EAN: #{ean}"
        end

        def extra?
          true
        end

        def id
          encode columns[2]
        end

        # This is like a tag. E.g. a product category.
        def matchcode
          encode columns[3].to_s.strip
        end

        def alternative_id
          encode columns[4]
        end

        def ean
          encode columns[9]
        end

        def as_json
          { id:, alternative_id:, matchcode:, ean: }
        end
      end
    end
  end
end
