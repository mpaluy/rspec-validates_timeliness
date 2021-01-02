require 'spec_helper'

describe RSpec::ValidatesTimeliness::Matchers::ExpectedValue do
  describe '#equal' do
    subject { model.equal }

    let(:result) { Date.current }
    let(:model) { described_class.new(result, :date) }

    it { is_expected.to eq result }
  end

  describe '#over' do
    subject { model.over }

    let(:model) { described_class.new(value, type) }

    context 'value is kind of Date' do
      let(:value) { Date.current }
      let(:type) { :date }
      let(:result) { value + 1.day }

      it 'returns value + 1.day (tomorrow)' do
        is_expected.to eq result
      end
    end

    context 'value is not kind of Date' do
      let(:value) { DateTime.current }
      let(:type) { :datetime }
      let(:result) { value + 1.second }

      it 'returns value + 1.second' do
        is_expected.to eq result
      end
    end
  end

  describe '#under' do
    subject { model.under }

    let(:model) { described_class.new(value, type) }

    context 'value is kind of Date' do
      let(:value) { Date.current }
      let(:type) { :date }
      let(:result) { value - 1.day }

      it 'returns value - 1.day (yesterday)' do
        is_expected.to eq result
      end
    end

    context 'value is not kind of Date' do
      let(:value) { DateTime.current }
      let(:type) { :datetime }
      let(:result) { value - 1.second }

      it 'returns value - 1.second' do
        is_expected.to eq result
      end
    end
  end

  describe '#evaluate' do
    subject { model.send(:evaluate, value, type) }

    let(:model) { described_class.new(nil, nil) }
    let(:type) { :datetime }

    shared_examples 'exactly value' do
      let(:result) { value.try("to_#{type}") }

      it { is_expected.to eq result }
    end

    context 'velue is kind of Proc' do
      let(:value) { proc { Date.today } }
      let(:result) { value.call.try("to_#{type}") }

      it { is_expected.to eq result }
    end

    context 'value is kind of Time' do
      let(:value) { Time.now }

      it_behaves_like 'exactly value'
    end

    context 'value is kind of DateTime' do
      let(:value) { DateTime.current }

      it_behaves_like 'exactly value'
    end

    context 'value is kind of Date' do
      let(:value) { Date.current }

      it_behaves_like 'exactly value'
    end

    context 'value is kind of String' do
      let(:value) { '9:00am' }

      it_behaves_like 'exactly value'
    end

    context 'value is not kind of Proc, Time, DateTime, Date' do
      let(:value) { 12_345 }

      it { is_expected.to be_nil }
    end
  end
end
