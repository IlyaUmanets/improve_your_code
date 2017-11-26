require_relative '../../spec_helper'
require_lib 'improve_your_code/context/root_context'

RSpec.describe ImproveYourCode::Context::RootContext do
  describe '#full_name' do
    it 'reports full context' do
      ast = ImproveYourCode::Source::SourceCode.from('foo = 1').syntax_tree
      root = described_class.new(ast)
      expect(root.full_name).to eq('')
    end
  end
end
