require_relative '../../spec_helper'
require_lib 'improve_your_code/smell_detectors/unused_private_method'

RSpec.describe ImproveYourCode::SmellDetectors::UnusedPrivateMethod do
  it 'reports the right values' do
    src = <<-EOS
      class Alfa
        private

        def charlie
        end
      end
    EOS

    expect(src).to improve_your_code_of(:UnusedPrivateMethod,
                           lines:   [4],
                           context: 'Alfa',
                           message: "has the unused private instance method 'charlie'",
                           source:  'string',
                           name:    'charlie')
  end

  it 'does count all occurences' do
    src = <<-EOS
      class Alfa
        private

        def charlie
        end

        def charlie
        end
      end
    EOS

    expect(src).
      to improve_your_code_of(:UnusedPrivateMethod, lines: [4], name: 'charlie').
      and improve_your_code_of(:UnusedPrivateMethod, lines: [7], name: 'charlie')
  end

  context 'when a class has unused private methods' do
    it 'reports instance methods' do
      source = <<-EOF
        class Alfa
          private
          def bravo; end
          def charlie; end
        end
      EOF

      expect(source).
        to improve_your_code_of(:UnusedPrivateMethod, name: 'bravo').
        and improve_your_code_of(:UnusedPrivateMethod, name: 'charlie')
    end

    it 'reports instance methods in the correct class' do
      source = <<-EOF
        class Alfa
          class Bravo
            private
            def charlie; end
          end
        end
      EOF

      expect(source).
        to improve_your_code_of(:UnusedPrivateMethod, context: 'Alfa::Bravo', name: 'charlie').
        and not_improve_your_code_of(:UnusedPrivateMethod, context: 'Alfa', name: 'charlie')
    end

    it 'discounts calls to identically named methods in nested classes' do
      source = <<-EOF
        class Alfa
          class Bravo
            def bravo
              charlie
            end

            private
            def charlie; end
          end

          private
          def charlie; end
        end
      EOF

      expect(source).
        to improve_your_code_of(:UnusedPrivateMethod, context: 'Alfa', name: 'charlie').
        and not_improve_your_code_of(:UnusedPrivateMethod, context: 'Alfo::Bravo', name: 'charlie')
    end

    it 'creates warnings correctly' do
      source = <<-EOF
        class Alfa
          private
          def bravo; end
          def charlie; end
        end
      EOF

      expect(source).
        to improve_your_code_of(:UnusedPrivateMethod, name: 'bravo', lines: [3]).
        and improve_your_code_of(:UnusedPrivateMethod, name: 'charlie', lines: [4])
    end

    it 'reports instance methods defined as private with a modifier' do
      source = <<-EOF
        class Alfa
          private def bravo; end
        end
      EOF

      expect(source).
        to improve_your_code_of(:UnusedPrivateMethod, name: 'bravo')
    end
  end

  context 'when the detector is configured via a source code comment' do
    it 'does not report methods we excluded' do
      source = <<-EOF
        # :improve_your_code:UnusedPrivateMethod: { exclude: [ bravo ] }
        class Alfa
          private
          def bravo; end
          def charlie; end
        end
      EOF

      expect(source).
        to improve_your_code_of(:UnusedPrivateMethod, name: 'charlie').
        and not_improve_your_code_of(:UnusedPrivateMethod, name: 'bravo')
    end
  end

  context 'when a class has only used private methods' do
    it 'reports nothing' do
      source = <<-EOF
        class Alfa
          def bravo
            charlie
          end

          private
          def charlie; end
        end
      EOF

      expect(source).not_to improve_your_code_of(:UnusedPrivateMethod)
    end
  end

  context 'when a class has unused protected methods' do
    it 'reports nothing' do
      source = <<-EOF
        class Alfa
          protected
          def bravo; end
        end
      EOF

      expect(source).not_to improve_your_code_of(:UnusedPrivateMethod)
    end
  end

  context 'when a class has unused public methods' do
    it 'reports nothing' do
      source = <<-EOF
        class Alfa
          def bravo; end
        end
      EOF

      expect(source).not_to improve_your_code_of(:UnusedPrivateMethod)
    end
  end

  describe 'preventing methods from being reported' do
    let(:source) do
      <<-EOF
        class Alfa
          private
          def bravo; end
          def charlie; end
        end
      EOF
    end

    it 'excludes them via direct match in the app configuration' do
      config = { ImproveYourCode::SmellDetectors::BaseDetector::EXCLUDE_KEY => ['Alfa#charlie'] }

      expect(source).
        to improve_your_code_of(:UnusedPrivateMethod, name: 'bravo').with_config(config).
        and not_improve_your_code_of(:UnusedPrivateMethod, name: 'charlie').with_config(config)
    end

    it 'excludes them via regex in the app configuration' do
      config = { ImproveYourCode::SmellDetectors::BaseDetector::EXCLUDE_KEY => [/charlie/] }

      expect(source).
        to improve_your_code_of(:UnusedPrivateMethod, name: 'bravo').with_config(config).
        and not_improve_your_code_of(:UnusedPrivateMethod, name: 'charlie').with_config(config)
    end
  end
end
