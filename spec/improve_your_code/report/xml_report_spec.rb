require_relative '../../spec_helper'
require_lib 'improve_your_code/examiner'
require_lib 'improve_your_code/report/xml_report'

RSpec.describe ImproveYourCode::Report::XMLReport do
  let(:xml_report) { described_class.new }

  context 'with an empty source' do
    it 'prints empty checkstyle XML' do
      xml_report.add_examiner ImproveYourCode::Examiner.new('')
      xml = "<?xml version='1.0'?>\n<checkstyle/>\n"
      expect { xml_report.show }.to output(xml).to_stdout
    end
  end

  context 'with a source with violations' do
    it 'prints non-empty checkstyle XML' do
      xml_report.add_examiner ImproveYourCode::Examiner.new(SMELLY_FILE)
      xml = SAMPLES_PATH.join('checkstyle.xml').read
      xml = xml.gsub(SMELLY_FILE.to_s, SMELLY_FILE.expand_path.to_s)
      expect { xml_report.show }.to output(xml).to_stdout
    end
  end
end
