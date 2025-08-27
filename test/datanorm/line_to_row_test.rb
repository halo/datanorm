# require 'rails_helper'

# RSpec.describe Datanorm::LineToRow do
#   describe '.call' do
#     context 'when Datanorm 4 Header' do
#       it 'is a Header' do
#         columns = ['V 050321                                                                                                                   04EUR']
#         header = Datanorm::Rows::Header.new(['V 050321                                                                                                                   04EUR'])

#         row = described_class.call(columns, header: header)

#         expect(row).to be_header
#         expect(row.version).to eq '04'
#         expect(row).to be_four
#         expect(row.date).to eq Date.new(2021, 3, 5)
#       end
#     end

#     context 'when Datanorm 5 Header' do
#       it 'is a Header' do
#         columns = 'V;050;A;20201210;EUR;Produktkatalog 2021;ACME INC.;;;;;;;;;'.split(';')
#         header = Datanorm::Rows::Header.new('V;050;A;20201210;EUR;Produktkatalog 2021;ACME INC.;;;;;;;;;'.split(';'))

#         row = described_class.call(columns, header: header)

#         expect(row).to be_header
#         expect(row.version).to eq '050'
#         expect(row).to be_five
#         expect(row.date).to eq Date.new(2020, 12, 10)
#       end
#     end

#     context 'when Datanorm 4 Text' do
#       it 'is a Text' do
#         columns = 'T;N;00022926;;27;;verlegbar;28;;Lieferumfang;'.split(';')
#         header = Datanorm::Rows::Header.new(['V 050321                                                                                                                   04EUR'])

#         row = described_class.call(columns, header: header)

#         expect(row).to be_text
#         expect(row.line_number).to eq 27
#         expect(row.content).to eq "verlegbar\nLieferumfang"
#       end
#     end

#     context 'when Datanorm 5 Text' do
#       it 'is a Text' do
#         columns = 'T;N;T020-876;1;13;Die Box muss direkt an der linken;'.split(';')
#         header = Datanorm::Rows::Header.new('V;050;A;20201210;EUR;Produktkatalog 2021;ACME INC.;;;;;;;;;'.split(';'))

#         row = described_class.call(columns, header: header)

#         expect(row).to be_text
#         expect(row.id).to eq 'T020-876'
#         expect(row.line_number).to eq 13
#         expect(row.content).to eq "Die Box muss direkt an der linken"
#       end
#     end

#     context 'when Datanorm 4 Primary' do
#       it 'is a Primary' do
#         columns = 'A;N;PES178 AHL;50;Seitenwand Pega speziell 780x1850mm;silber hochglanz;1;0;ST;79900;G5CD; ; ;'.split(';')
#         header = Datanorm::Rows::Header.new(['V 050321                                                                                                                   04EUR'])

#         row = described_class.call(columns, header: header)

#         expect(row).to be_primary
#         expect(row.id).to eq 'PES178 AHL'
#         expect(row.item_title).to eq 'Seitenwand Pega speziell 780x1850mm silber hochglanz'
#         expect(row.price).to be_instance_of BigDecimal
#         expect(row.price).to eq 799
#         expect(row.quantity_unit).to eq 'ST'
#         expect(row.quantity).to eq 1
#       end
#     end

#     context 'when Datanorm 4 Extra' do
#       it 'is a Extra' do
#         columns = 'B;N;VXFHBMK046500;SONNENSCHUTZ;1467597; ;0;0;0; ; ; ;0;0; ; ;'.split(';')
#         header = Datanorm::Rows::Header.new(['V 050321                                                                                                                   04EUR'])

#         row = described_class.call(columns, header: header)

#         expect(row).to be_extra
#         expect(row.id).to eq 'VXFHBMK046500'
#         expect(row.matchcode).to eq 'SONNENSCHUTZ'
#         expect(row.vendor_item_id).to eq '1467597'
#       end
#     end

#     context 'when Datanorm 5 Primary' do
#       it 'is a Primary' do
#         columns = 'A;N;100078941;Sensorkabel rot;SKM-95/03 ;m;1;1;760;14;008;008.840;;;;TELENOT;100078941;SKM-95/03 Rot;;;;;4;TNT2977;;;;;;'.split(';')
#         header = Datanorm::Rows::Header.new('V;050;A;20201210;EUR;Produktkatalog 2021;ACME INC.;;;;;;;;;'.split(';'))

#         row = described_class.call(columns, header: header)

#         expect(row).to be_primary
#         expect(row.id).to eq '100078941'
#         expect(row.item_title).to eq 'Sensorkabel rot SKM-95/03'
#         expect(row.price).to be_instance_of BigDecimal
#         expect(row.price).to eq 7.6
#         expect(row.quantity_unit).to eq 'm'
#         expect(row.quantity).to eq 1
#       end
#     end

#     context 'when Datanorm 4 Dimension' do
#       it 'is a Dimension' do
#         columns = 'D;N;DEWURK1003F;11;F;;1 Schublade oben mit Siphonausschnitt;12;F;;1 Schublade unten;'.split(';')
#         header = Datanorm::Rows::Header.new(['V 050321                                                                                                                   04EUR'])

#         row = described_class.call(columns, header: header)

#         expect(row).to be_dimension
#         expect(row.id).to eq 'DEWURK1003F'
#         expect(row.line_number).to eq 11
#         expect(row.content).to eq "1 Schublade oben mit Siphonausschnitt\n1 Schublade unten"
#       end
#     end

#     context 'when Datanorm 4 Price' do
#       it 'is a Price' do
#         columns = 'P;A;QATA207569016;1;300;1;3700;;;;;QLF2002009016;1;240;1;0;;;;;QLF2002009016;2;88;;;;;;;'.split(';')
#         header = Datanorm::Rows::Header.new(['V 050321                                                                                                                   04EUR'])

#         row = described_class.call(columns, header: header)

#         expect(row).to be_price

#         discounts = row.discounts
#         expect(discounts[0].id).to eq 'QATA207569016'
#         expect(discounts[1].id).to eq 'QLF2002009016'
#         expect(discounts[2].id).to eq 'QLF2002009016'
#         expect(discounts[0].target_purchase_price).to eq 1.89
#         expect(discounts[1].target_purchase_price).to eq 2.4
#         expect(discounts[2].target_purchase_price).to eq 0.88
#       end
#     end
#   end
# end
