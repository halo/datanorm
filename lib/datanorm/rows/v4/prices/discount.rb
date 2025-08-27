module Datanorm
  module Rows
    module V4
      module Prices
        class Discount < ::Datanorm::Rows::Base
          def to_s
            "[#{id}] DISCOUNT-4 #{%|PERCENTAGE #{percentage}| if percentage_discount?} #{'FIXED' if fixed_price?} EUR #{price} -> EUR #{target_purchase_price}"
          end

          def discount?
            true
          end

          def id
            columns[0]
          end

          def target_purchase_price
            if percentage_discount?
              price * (1 - percentage)
            elsif fixed_price?
              price
            else
              raise "What is this #{columns}"
            end
          end

          def <=>(other)
            precedence <=> other.precedence
          end

          def precedence
            return 2 if fixed_price?
            return 1 if percentage_discount?
            0
          end

          private

          attr_reader :columns

          def percentage_discount?
            columns[1] == '1'
          end

          def fixed_price?
            columns[1] == '2'
          end

          def price
            columns[2].to_d / 100
          end

          def percentage
            raise "cannot handle value #{columns}" unless percentage_discount?

            # 3700 == 37% == 0.37
            columns[4].to_d / 100 / 100
          end
        end
      end
    end
  end
end
