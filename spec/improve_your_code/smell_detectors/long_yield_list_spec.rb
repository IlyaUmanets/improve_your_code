require_relative '../../spec_helper'
require_lib 'improve_your_code/smell_detectors/long_yield_list'

RSpec.describe ImproveYourCode::SmellDetectors::LongYieldList do
  it 'reports the right values' do
    src = <<-EOS
      class Alfa
        def bravo(charlie, delta, echo, foxtrot)
          yield charlie, delta, echo, foxtrot
        end
      end
    EOS

    expect(src).to improve_your_code_of(:LongYieldList,
                           lines:   [3],
                           context: 'Alfa#bravo',
                           message: 'yields 4 parameters',
                           source:  'string',
                           count:   4)
  end

  it 'does count all occurences' do
    src = <<-EOS
      class Alfa
        def bravo(charlie, delta, echo, foxtrot)
          yield charlie, delta, echo, foxtrot
        end

        def golf(hotel, india, juliett, kilo)
          yield hotel, india, juliett, kilo
        end
      end
    EOS

    expect(src).
      to improve_your_code_of(:LongYieldList, lines: [3], context: 'Alfa#bravo').
      and improve_your_code_of(:LongYieldList, lines: [7], context: 'Alfa#golf')
  end

  it 'does not report yield with 3 parameters' do
    src = <<-EOS
      def alfa(bravo, charlie, delta)
        yield bravo, charlie, delta
      end
    EOS

    expect(src).not_to improve_your_code_of(:LongYieldList)
  end
end
