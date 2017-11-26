require_relative '../../spec_helper'
require_lib 'improve_your_code/smell_detectors/class_variable'

RSpec.describe ImproveYourCode::SmellDetectors::ClassVariable do
  it 'reports the right values' do
    src = <<-EOS
      class Alfa
        @@bravo = 5
      end
    EOS

    expect(src).to improve_your_code_of(:ClassVariable,
                           lines:   [2],
                           context: 'Alfa',
                           message: "declares the class variable '@@bravo'",
                           source:  'string',
                           name:    '@@bravo')
  end

  it 'does count all class variables' do
    src = <<-EOS
      class Alfa
        @@bravo = 42
        @@charlie = 99
      end
    EOS

    expect(src).
      to improve_your_code_of(:ClassVariable, name: '@@bravo').
      and improve_your_code_of(:ClassVariable, name: '@@charlie')
  end

  it 'does not report class instance variables' do
    src = <<-EOS
      class Alfa
        @bravo = 42
      end
    EOS

    expect(src).not_to improve_your_code_of(:ClassVariable)
  end

  context 'with no class variables' do
    it 'records nothing in the class' do
      src = <<-EOS
        class Alfa
          def bravo; end
        end
      EOS

      expect(src).not_to improve_your_code_of(:ClassVariable)
    end

    it 'records nothing in the module' do
      src = <<-EOS
        module Alfa
          def bravo; end
        end
      EOS

      expect(src).not_to improve_your_code_of(:ClassVariable)
    end
  end

  ['class', 'module'].each do |scope|
    context "when examining a #{scope}" do
      it 'reports a class variable set in a method' do
        src = <<-EOS
          #{scope} Alfa
            def bravo
              @@charlie = {}
            end
          end
        EOS

        expect(src).to improve_your_code_of(:ClassVariable, name: '@@charlie')
      end

      it 'reports a class variable used in a method' do
        src = <<-EOS
          #{scope} Alfa
            def bravo
              puts @@charlie
            end
          end
        EOS

        expect(src).to improve_your_code_of(:ClassVariable, name: '@@charlie')
      end

      it "reports a class variable set in the #{scope} body and used in a method" do
        src = <<-EOS
          #{scope} Alfa
            @@bravo = 42

            def charlie
              puts @@bravo
            end
          end
        EOS

        expect(src).to improve_your_code_of(:ClassVariable, name: '@@bravo')
      end
    end
  end
end
