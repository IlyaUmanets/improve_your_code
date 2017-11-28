require_relative '../../spec_helper'
require_lib 'improve_your_code/examiner'
require_lib 'improve_your_code/report/json_report'
require_lib 'improve_your_code/report/formatter'

require 'json'
require 'stringio'

RSpec.describe ImproveYourCode::Report::JSONReport do
  let(:options) { {} }
  let(:instance) { described_class.new(options) }
  let(:examiner) { ImproveYourCode::Examiner.new(source) }

  before do
    instance.add_examiner examiner
  end

  context 'with empty source' do
    let(:source) { '' }

    it 'prints empty json' do
      expect { instance.show }.to output(/^\[\]$/).to_stdout
    end
  end

  context 'with smelly source' do
    let(:source) { 'def simple(a) a[3] end' }

    it 'prints smells as json' do
      out = StringIO.new
      instance.show(out)
      out.rewind
      result = JSON.parse(out.read)
      expected = JSON.parse <<-EOS
        [
          {
            "context":        "simple",
            "lines":          [1],
            "message":        "has the parameter name 'a'",
            "smell_type":     "UncommunicativeParameterName",
            "source":         "string",
            "name":           "a"
          },
          {
            "context":        "simple",
            "lines":          [1],
            "message":        "doesn't depend on instance state (maybe move it to another class?)",
            "smell_type":     "UtilityFunction",
            "source":         "string"
          }
        ]
      EOS

      expect(result).to eq expected
    end

    context 'with link formatter' do
      let(:options) { { warning_formatter: ImproveYourCode::Report::Formatter::WikiLinkWarningFormatter.new } }

      it 'prints documentation links' do
        out = StringIO.new
        instance.show(out)
        out.rewind
        result = JSON.parse(out.read)
        expected = JSON.parse <<-EOS
          [
            {
              "context":        "simple",
              "lines":          [1],
              "message":        "has the parameter name 'a'",
              "smell_type":     "UncommunicativeParameterName",
              "source":         "string",
              "name":           "a",
              "wiki_link":      "https://github.com/troessner/improve_your_code/blob/master/docs/Uncommunicative-Parameter-Name.md"
            },
            {
              "context":        "simple",
              "lines":          [1],
              "message":        "doesn't depend on instance state (maybe move it to another class?)",
              "smell_type":     "UtilityFunction",
              "source":         "string",
              "wiki_link":      "https://github.com/troessner/improve_your_code/blob/master/docs/Utility-Function.md"
            }
          ]
        EOS

        expect(result).to eq expected
      end
    end
  end
end