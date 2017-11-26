require_relative '../spec_helper'
require_lib 'improve_your_code/report'

RSpec.describe ImproveYourCode::Report do
  describe '.report_class' do
    it 'returns the correct class' do
      expect(described_class.report_class(:text)).to eq ImproveYourCode::Report::TextReport
    end
  end

  describe '.location_formatter' do
    it 'returns the correct class' do
      expect(described_class.location_formatter(:plain)).to eq ImproveYourCode::Report::Formatter::BlankLocationFormatter
    end
  end

  describe '.heading_formatter' do
    it 'returns the correct class' do
      expect(described_class.heading_formatter(:quiet)).to eq ImproveYourCode::Report::Formatter::QuietHeadingFormatter
    end
  end

  describe '.warning_formatter_class' do
    it 'returns the correct class' do
      expect(described_class.warning_formatter_class(:simple)).to eq ImproveYourCode::Report::Formatter::SimpleWarningFormatter
    end
  end
end
