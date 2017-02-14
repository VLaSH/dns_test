require 'rails_helper'

RSpec.describe DNS::Lookup do
  describe '#forward' do
    subject { -> { DNS::Lookup.new.forward(domain) } }

    before do
      allow_any_instance_of(Resolv::DNS).to receive(:getaddresses).
                                            with(domain).
                                            and_return(addresses)
    end

    context 'domain is missing' do
      let(:domain) { nil }
      let(:addresses) { [] }

      it { is_expected.to raise_error(DNS::Errors::ParamIsMissingError) }
    end

    context 'no records found' do
      let(:domain) { Faker::Internet.domain_name }
      let(:addresses) { [] }

      it { is_expected.to raise_error(DNS::Errors::NoRecordsFoundError) }
    end

    context 'records found' do
      let(:domain) { Faker::Internet.domain_name }
      let(:addresses) { [Faker::Internet.ip_v4_address, Faker::Internet.ip_v4_address] }

      it { expect(subject.call).to eq(addresses.sort) }
    end
  end

  describe '#reverse' do
    subject { -> { DNS::Lookup.new.reverse(address) } }

    before do
      allow_any_instance_of(Resolv::DNS).to receive(:getnames).
                                            with(address).
                                            and_return(domain_names)
    end

    context 'address is missing' do
      let(:address) { nil }
      let(:domain_names) { [] }

      it { is_expected.to raise_error(DNS::Errors::ParamIsMissingError) }
    end

    context 'no records found' do
      let(:address) { Faker::Internet.ip_v4_address }
      let(:domain_names) { [] }

      it { is_expected.to raise_error(DNS::Errors::NoRecordsFoundError) }
    end

    context 'records found' do
      let(:address) { Faker::Internet.ip_v4_address }
      let(:domain_names) { [Faker::Internet.domain_name, Faker::Internet.domain_name] }

      it { expect(subject.call).to eq(domain_names.sort) }
    end
  end
end
