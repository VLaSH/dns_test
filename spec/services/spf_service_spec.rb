require 'rails_helper'

RSpec.describe DNS::SPFService do
  let(:spf_service) { DNS::SPFService.new(address, domain) }

  describe '.new' do
    subject { DNS::SPFService.new(address, domain) }

    context 'invalid IP address' do
      let(:address) { Faker::Lorem.word }
      let(:domain)  { Faker::Internet.domain_name }

      it { expect(spf_service.errors).to include('invalid address') }
    end

    context 'return service instance' do
      let(:address) { Faker::Internet.ip_v4_address }
      let(:domain)  { Faker::Internet.domain_name }

      it { expect(spf_service).to be_a(DNS::SPFService) }
    end
  end

  describe '#call' do
    let(:address) { Faker::Internet.ip_v4_address }
    let(:domain) { Faker::Internet.domain_name }

    before do |example|
      if example.metadata[:stub] == 'resolv'
        allow_any_instance_of(Resolv::DNS).to receive(:getresources).
                                              with(domain, Resolv::DNS::Resource::IN::TXT).
                                              and_return(records)
      end
    end

    context 'param is missing' do
      let(:domain) { nil }

      it { expect(spf_service.call.errors).to include(I18n.t('errors.missing_param')) }
    end

    context 'no records found', stub: 'resolv' do
      let(:records) { [] }

      it { expect(spf_service.call.errors).to include(I18n.t('errors.no_records', subject: domain)) }
    end

    context 'record format is invalid', stub: 'resolv' do
      let(:records) { [double(strings: [Faker::Lorem.word])] }

      it { expect(spf_service.call.valid?).to be_falsey }
    end

    context 'record format is valid', stub: 'resolv' do
      let(:records) { [double(strings: ['v=spf1'])] }

      it { expect(spf_service.call.valid?).to be_truthy }
    end

    context 'address is not listed in records', stub: 'resolv' do
      let(:records) { [double(strings: ["v=spf1 ip4:#{Faker::Internet.ip_v4_address}"])] }

      it { expect(spf_service.call.listed?).to be_falsey }
    end

    context 'address is listed in records', stub: 'resolv' do
      let(:records) { [double(strings: ["v=spf1 ip4:#{address}"])] }

      it { expect(spf_service.call.listed?).to be_truthy }
    end

    context 'result is present', stub: 'resolv' do
      let(:records) { [double(strings: ["v=spf1 ip4:#{address}"])] }

      it { expect(spf_service.call.result).to eq([address]) }
    end
  end
end
