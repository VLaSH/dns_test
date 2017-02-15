require 'rails_helper'

RSpec.describe LookupService do
  describe '.new' do
    subject { LookupService.new(address) }

    context 'return service instance' do
      let(:address) { Faker::Internet.ip_v4_address }

      it { is_expected.to be_a(LookupService) }
    end
  end

  describe '#call' do
    let(:lookup_service) { LookupService.new(address) }
    let(:address)   { Faker::Internet.ip_v4_address }
    let(:domains)   { [Faker::Internet.domain_name] }

    before do |example|
      if %w(forward both).include?(example.metadata[:stub])
        allow_any_instance_of(Resolv::DNS).to receive(:getaddresses).
                                              with(domains.first).
                                              and_return(addresses)
      end
      if %w(reverse both).include?(example.metadata[:stub])
        allow_any_instance_of(Resolv::DNS).to receive(:getnames).
                                              with(address).
                                              and_return(domains)
      end
    end

    context 'param is missing' do
      let(:address) { nil }

      it { expect { lookup_service.call }.to raise_error(DNS::Errors::ParamIsMissingError) }
    end

    context 'no records found', stub: 'reverse' do
      let(:domains) { [] }

      it { expect(lookup_service.call.errors.first).to be }
    end

    context 'records mismatch', stub: 'both' do
      let(:addresses) { [Faker::Internet.ip_v4_address] }

      it { expect(lookup_service.call.errors?).to be_truthy }
    end

    context 'records match', stub: 'both' do
      let(:addresses) { [address] }

      it { expect(lookup_service.call.errors?).to be_falsey }
    end

    context 'returns result of reverse lookup', stub: 'both' do
      let(:addresses) { [address] }

      it { expect(lookup_service.call.result).to eq(domains) }
    end
  end
end
