require 'rails_helper'

RSpec.describe DNS::SPF do
  describe '#search' do
    context 'domain is missing' do
      subject { -> { DNS::SPF.new.search(domain) } }

      let(:domain) { nil }

      it { is_expected.to raise_error(DNS::Errors::ParamIsMissingError) }
    end

    context 'no records' do
      subject { -> { DNS::SPF.new.search(domain) } }

      let(:resources) { [] }
      let(:domain) { Faker::Lorem.word }

      before do
        allow_any_instance_of(Resolv::DNS).to receive(:getresources).
                                              with(domain, Resolv::DNS::Resource::IN::TXT).
                                              and_return(resources)
      end

      it { is_expected.to raise_error(DNS::Errors::NoRecordsFoundError) }
    end

    context 'records present' do
      context 'returns correct result' do
        subject { DNS::SPF.new.search(domain) }

        let(:result_value) { [Faker::Internet.ip_v4_cidr] }
        let(:raw_value) { "ip4:#{result_value.first}" }
        let(:resources) { [double(strings: raw_value)] }
        let(:domain) { Faker::Lorem.word }

        before do
          allow_any_instance_of(Resolv::DNS).to receive(:getresources).
                                                with(domain, Resolv::DNS::Resource::IN::TXT).
                                                and_return(resources)
        end

        it { is_expected.to eq(result_value) }
      end

      context 'sets correct ranges based on cidr' do
        subject do
          spf = DNS::SPF.new
          spf.search(domain)
          spf
        end

        let(:result_value) { [Faker::Internet.ip_v4_cidr] }
        let(:raw_value) { "ip4:#{result_value.first}" }
        let(:resources) { [double(strings: raw_value)] }
        let(:domain) { Faker::Lorem.word }
        let(:correct_range) { IPAddr.new(result_value.first).to_range }

        before do
          allow_any_instance_of(Resolv::DNS).to receive(:getresources).
                                                with(domain, Resolv::DNS::Resource::IN::TXT).
                                                and_return(resources)
        end

        it { expect(subject.ranges.first).to eq(correct_range) }
      end
    end
  end
end
