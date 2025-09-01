# frozen_string_literal: true

module Datanorm
  module Lines
    module V4
      # Represents one line containting a product main name, quantity unit and price.
      # 1. Stelle:  Satzartenkennzeichen "A"
      # 2. Stelle:  Verarbeitungskennzeichen (N=Neuanlage, L=Löschung, A=Änderung, X=Artikel-nummernänderung)
      # 3. Stelle:  Artikelnummer
      # 4. Stelle:  Textkennzeichen
      # 5. Stelle:  Artikelbezeichnung 1 (Kurztextzeile 1) / Artikelbezeichnung 2 (Kurztextzeile 2)
      # 7. Stelle:  Preiskennzeichen (1=Bruttopreis, 2=Nettopreis)
      # 8. Stelle:  Preiseinheit (0= per Mengeneinheit 1; 1=per Mengeneinheit 10,...)
      # 9. Stelle:  Mengeneinheit (Stk, m, lfm)
      # 10. Stelle:  Preis (Wenn Hersteller die Preise mit Satzart "P" liefern, braucht hier kein Preis (0) eingetragen werden)
      # 11. Stelle:  Rabattgruppe (Zur Ermittlung des Netto-Artikelpreises über die Rabattmatrix)
      # 12. Stelle:  Hauptwarengruppe
      # 13. Stelle:  Langtextschlüssel (Mit dem Langtextschlüssel wird ein Text aus mehreren Zeilen (Satzart T) an den Artikel gekettet.
      class Product < ::Datanorm::Lines::Base
        def to_s
          "PRODUCT   [#{id}] <#{title}> " \
            "<#{raw_quantity unless raw_quantity.to_s == quantity} " \
            "<#{quantity}) #{quantity_unit}> EUR #{price} [#{text_id}]"
        end

        def product?
          true
        end

        def id
          columns[2]
        end

        def text_id
          columns[12]
        end

        def cents
          columns[9].to_i
        end

        # def price
        #   BigDecimal(cents / 100)
        # end

        def title
          columns[4..5].join(' ').strip
        end

        def quantity_unit
          columns[8]
        end

        def quantity
          case raw_quantity.to_i
          when 0 then 1
          when 1 then 10
          when 2 then 100
          when 3 then 1000
          end
        end

        def as_json
          { id:, text_id:, cents:, title:, quantity_unit:, quantity: }
        end

        private

        def raw_quantity
          columns[7]
        end
      end
    end
  end
end
