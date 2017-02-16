require 'rails_helper'

RSpec.describe DKIMService do
  describe '.new' do
    subject { DKIMService.new(domain, prefix) }

    context 'return service instance' do
      let(:prefix) { Faker::Lorem.word }
      let(:domain) { Faker::Internet.domain_name }

      it { is_expected.to be_a(DKIMService) }
    end
  end

  describe '#call' do
    let(:dkim_service) { DKIMService.new(domain, prefix) }
    let(:address) { Faker::Internet.ip_v4_address }
    let(:prefix) { Faker::Lorem.word }
    let(:domain) { Faker::Internet.domain_name }
    let(:selector) { "#{prefix}.#{DNS::DKIM::POLICY}.#{domain}" }

    before do |example|
      case example.metadata[:stub]
      when 'resolv'
        allow_any_instance_of(Resolv::DNS).to receive(:getresources).
                                              with(selector, Resolv::DNS::Resource::IN::TXT).
                                              and_return(records)
      when 'dns'
        allow_any_instance_of(DNS::DKIM).to receive(:search).
                                              with(domain, prefix).
                                              and_return(records)
      end
    end

    context 'param is missing' do
      let(:domain) { nil }
      let(:prefix) { nil }

      it { expect(dkim_service.call.errors?).to be_truthy }
    end

    context 'no records found', stub: 'resolv' do
      let(:records) { [] }

      it { expect(dkim_service.call.errors?).to be_truthy }
    end

    context 'public key not found', stub: 'dns' do
      let(:records) { [Faker::Lorem.word] }

      it { expect(dkim_service.call.errors?).to be_truthy }
    end

    context 'public key found', stub: 'dns' do
      let(:records) { ['p=key'] }

      it { expect(dkim_service.call.errors?).to be_falsey }
    end

    context 'returns result of dkim search lookup', stub: 'dns' do
      let(:records) { ['p=key'] }

      it { expect(dkim_service.call.result).to eq(records) }
    end
  end
end
