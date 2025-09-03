# frozen_string_literal: true

module Datanorm
  module Lines
    module V4
      # Represents one line containting a product main name, quantity unit and price.
      #
      # Example:
      #   A;N;QBMK10208R;50;Brandmeldekabel rot;1;3;M;228313;2AED; ; ;
      #
      # 1. Stelle:  Satzartenkennzeichen "A"
      # 2. Stelle:  Verarbeitungskennzeichen (N=Neuanlage, L=Löschung, A=Änderung, X=Artikel-nummernänderung)
      # 3. Stelle:  Artikelnummer
      # 4. Stelle:  Textkennzeichen
      # 5. Stelle:  Artikelbezeichnung 1 (Kurztextzeile 1) / Artikelbezeichnung 2 (Kurztextzeile 2)
      #
      # [5] Preiskennzeichen (see `Datanorm::Lines::V4::Price`)
      #
      # 8. Stelle:  Preiseinheit (0= per Mengeneinheit 1; 1=10, 2=100, 3=1000)
      # 9. Stelle:  Mengeneinheit (Stk, m, lfm)
      # 10. Stelle:  Preis (Wenn Hersteller die Preise mit Satzart "P" liefern, braucht hier kein Preis (0) eingetragen werden)
      # 11. Stelle:  Rabattgruppe (Zur Ermittlung des Netto-Artikelpreises über die Rabattmatrix)
      # 12. Stelle:  Hauptwarengruppe
      # 13. Stelle:  Langtextschlüssel (Mit dem Langtextschlüssel wird ein Text aus mehreren Zeilen (Satzart T) an den Artikel gekettet.
      class Product < ::Datanorm::Lines::Base
        def to_s
          "<Product #{as_json}>"
        end

        def id
          ::Datanorm::Helpers::Utf8.call columns[2]
        end

        def text_id
          ::Datanorm::Helpers::Utf8.call columns[12]
        end

        def retail_price?
          columns[5] == '1'
        end

        def wholesale_price?
          columns[5] == '2'
        end

        def cents
          columns[9].to_i
        end

        def title
          ::Datanorm::Helpers::Utf8.call columns[4..5].join(' ').strip
        end

        def quantity_unit
          ::Datanorm::Helpers::Utf8.call columns[8]
        end

        def quantity
          case columns[7].to_i
          when 0 then 1
          when 1 then 10
          when 2 then 100
          when 3 then 1000
          end
        end

        def discount_group
          ::Datanorm::Helpers::Utf8.call columns[9]
        end

        def as_json # rubocop:disable Metrics/MethodLength
          {
            id:,
            text_id:,
            is_retail_price: retail_price?,
            is_wholesale_price: wholesale_price?,
            cents:,
            title:,
            quantity_unit:,
            quantity:,
            discount_group:
          }
        end
      end
    end
  end
end
