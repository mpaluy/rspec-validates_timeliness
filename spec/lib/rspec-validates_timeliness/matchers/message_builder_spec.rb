require 'spec_helper'

describe RSpec::ValidatesTimeliness::Matchers::MessageBuilder do
  describe '#full_message' do
    subject { model.full_message }

    let(:model) { described_class.new(base_message) }
    let(:base_message) { 'abc' }
    let(:option_messages) { %w[123 456 789] }
    let(:result) { 'abc 123 and 456 and 789' }

    before do
      option_messages.each do |text|
        model << text
      end
    end

    it 'returns exactly full message' do
      is_expected.to eq result
    end
  end

  describe '#<<' do
    subject { model.instance_variable_get(:@option_messages) }

    let(:model) { described_class.new(nil) }
    let(:text) { 'abc' }

    before { model << text }

    it 'pushes text to @option_messages' do
      is_expected.to eq [text]
    end
  end
end
