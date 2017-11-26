require_relative '../../spec_helper'
require_lib 'improve_your_code/smell_detectors/syntax'

RSpec.describe ImproveYourCode::SmellDetectors::Syntax do
  it 'reports the right values' do
    src = <<-EOS
      class Alfa
      edn
    EOS

    expect(src).to improve_your_code_of(:Syntax,
                           lines: [3],
                           context: 'This file',
                           message: 'has unexpected token $end',
                           source: 'string')
  end
end
