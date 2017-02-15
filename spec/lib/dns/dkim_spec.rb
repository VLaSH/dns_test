require 'rails_helper'

RSpec.describe DNS::DKIM do
  describe '#search' do
    subject { -> { DNS::DKIM.new.search(prefix, domain) } }

    let(:prefix) { Faker::Lorem.word }
    let(:domain) { Faker::Lorem.word }
    let(:selector) { "#{prefix}._domainkey.#{domain}" }

    before do |example|
      if example.metadata[:stub]
        allow_any_instance_of(Resolv::DNS).to receive(:getresources).
                                              with(selector, Resolv::DNS::Resource::IN::TXT).
                                              and_return(resources)
      end
    end

    context 'all params missing' do
      let(:prefix) { nil }
      let(:domain) { nil }

      it { is_expected.to raise_error(DNS::Errors::ParamIsMissingError) }
    end

    context 'prefix is missing' do
      let(:prefix) { nil }
      let(:domain) { Faker::Lorem.word }

      it { is_expected.to raise_error(DNS::Errors::ParamIsMissingError) }
    end

    context 'domain is missing' do
      let(:prefix) { Faker::Lorem.word }
      let(:domain) { nil }

      it { is_expected.to raise_error(DNS::Errors::ParamIsMissingError) }
    end

    context 'no records', stub: true do
      let(:resources) { [] }

      it { is_expected.to raise_error(DNS::Errors::NoRecordsFoundError) }
    end

    context 'records present', stub: true do
      subject { DNS::DKIM.new.search(prefix, domain) }

      let(:result_value) { [Faker::Lorem.word] }
      let(:resources) { [double(strings: result_value)] }

      it { is_expected.to eq(result_value) }
    end
  end
end
