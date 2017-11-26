require_relative '../spec_helper'

RSpec.describe 'ImproveYourCode source code' do
  Pathname.glob('lib/**/*.rb').each do |pathname|
    describe pathname do
      it 'has no smells' do
        expect(pathname).not_to improve_your_code
      end
    end
  end
end
