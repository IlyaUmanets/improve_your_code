require_relative '../../spec_helper'
require_lib 'improve_your_code/smell_detectors/too_many_methods'

RSpec.describe ImproveYourCode::SmellDetectors::TooManyMethods do
  let(:config) do
    { ImproveYourCode::SmellDetectors::TooManyMethods::MAX_ALLOWED_METHODS_KEY => 3 }
  end

  it 'reports the right values' do
    src = <<-EOS
      class Alfa
        def bravo; end
        def charlie; end
        def delta; end
        def echo; end
      end
    EOS

    expect(src).to improve_your_code_of(:TooManyMethods,
                           lines:   [1],
                           context: 'Alfa',
                           message: 'has at least 4 methods',
                           source:  'string',
                           count:   4).with_config(config)
  end

  it 'does not report if we stay below max_methods' do
    src = <<-EOS
      class Alfa
        def bravo; end
        def charlie; end
        def delta; end
      end
    EOS

    expect(src).not_to improve_your_code_of(:TooManyMethods).with_config(config)
  end

  it 'stops at a nested module' do
    src = <<-EOS
      class Alfa
        def bravo; end
        def charlie; end

        module Hidden
          def delta; end
          def echo; end
        end
      end
    EOS

    expect(src).not_to improve_your_code_of(:TooManyMethods).with_config(config)
  end
end
