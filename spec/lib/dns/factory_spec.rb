require 'rails_helper'

RSpec.describe DNS::SPF do
  describe '.dns_inst' do
    subject { -> { DNS::Factory.dns_inst(constant_name) } }

    context 'constant_name is missing' do
      let(:constant_name) { nil }

      it { is_expected.to raise_error(DNS::Errors::ParamIsMissingError) }
    end

    context 'undefined dns constant' do
      let(:constant_name) { Faker::Lorem.word }

      it { is_expected.to raise_error(DNS::Errors::UndefinedDNSConstantError) }
    end

    context 'returns dns constant' do
      let(:constant_name) { DNS::Factory::CONSTANTS.first.downcase }
      let(:constant) { Object.const_get(DNS::Factory::WRAPPER + constant_name.capitalize) }

      it { expect(subject.call).to be_a(constant) }
    end
  end
end
