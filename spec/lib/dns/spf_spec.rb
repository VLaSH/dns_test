require 'rails_helper'

RSpec.describe DNS::SPF do
  describe '#search' do
    let(:spf_lib) { DNS::SPF.new }
    let(:result_value) { [Faker::Internet.ip_v4_cidr] }
    let(:domain) { Faker::Lorem.word }

    before do |example|
      if example.metadata[:stub]
        allow_any_instance_of(Resolv::DNS).to receive(:getresources).
                                              with(domain, Resolv::DNS::Resource::IN::TXT).
                                              and_return(records)
      end
    end

    context 'param is missing' do
      let(:domain) { nil }
      let(:records) { [] }

      it { expect { spf_lib.search(domain) }.to raise_error(DNS::Errors::ParamIsMissingError) }
    end

    context 'no records', stub: true do
      let(:domain) { Faker::Internet.domain_name }
      let(:records) { [] }

      it { expect { spf_lib.search(domain) }.to raise_error(DNS::Errors::NoRecordsFoundError) }
    end

    context 'record format is invalid', stub: true do
      let(:records) { [double(strings: [Faker::Lorem.word])] }

      it { expect { spf_lib.search(domain) }.to raise_error(DNS::Errors::RecordIsInvalidError) }
    end

    context 'returns correct result', stub: true do
      let(:records) { [double(strings: ["v=spf1 ip4:#{result_value.first}"])] }

      it { expect(spf_lib.search(domain)).to eq(result_value) }
    end
  end
end
