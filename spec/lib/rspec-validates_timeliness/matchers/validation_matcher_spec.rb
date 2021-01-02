require 'spec_helper'

describe RSpec::ValidatesTimeliness::Matchers::ValidationMatcher do
  let(:attr_name) { :one }
  let(:model) { described_class.new(attr_name) }

  %i[is_at after on_or_after before on_or_before].each do |option_name|
    describe "##{option_name}" do
      subject { model.try(option_name, value) }

      shared_examples 'exactly chain' do
        it 'returns itself' do
          is_expected.to eq model
          options = model.instance_variable_get(:@options)
          expect(options[option_name]).to eq value
        end
      end

      context 'with not block given' do
        let(:value) { Date.current }

        it_behaves_like 'exactly chain'
      end

      context 'with block given' do
        let(:value) { proc { Date.current } }

        it_behaves_like 'exactly chain'
      end
    end
  end

  describe '#between' do
    subject { model.between(value) }

    shared_examples 'exactly chain' do
      it 'returns itself' do
        is_expected.to eq model
        options = model.instance_variable_get(:@options)
        expect(options[:on_or_after]).to eq value.first
        key = value.is_a?(Range) && value.exclude_end? ? :before : :on_or_before
        expect(options[key]).to eq value.last
      end
    end

    context 'value is kind of Array' do
      let(:value) { [1.week.ago.to_date, 1.week.since.to_date] }

      it_behaves_like 'exactly chain'
    end

    context 'value is kind of Range' do
      context 'with exclude_end' do
        let(:value) { 1.week.ago.to_date..1.week.since.to_date }

        it_behaves_like 'exactly chain'
      end

      context 'with not exclude_end' do
        let(:value) { 1.week.ago.to_date...1.week.since.to_date }

        it_behaves_like 'exactly chain'
      end
    end
  end

  describe '#matches' do
    subject { model.matches?(expected) }

    let(:expected) { nil }

    before do
      expect(model).to receive(:attribute_exist?).and_return(true)
      expect(model).to receive(:all_options_correct?).and_return(true)
    end

    it { is_expected.to be_truthy }
  end

  describe '#failure_message' do
    subject { model.failure_message }

    let(:base_description) { "validate that :#{attr_name} must be" }
    let(:result) { "Expected #{base_description}" }

    it { is_expected.to match result }
  end

  describe '#failure_message_when_negated' do
    subject { model.failure_message_when_negated }

    let(:base_description) { "validate that :#{attr_name} must be" }
    let(:result) { "Did not expect #{base_description}" }

    it { is_expected.to match result }
  end
end
