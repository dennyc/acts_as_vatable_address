require 'spec_helper'

describe ActsAsVatableAddress do
  let(:postcode) { 12345 }
  let(:german_address) { GermanAddress.create! postcode: postcode, country: country }  
  let(:french_address) { FrenchAddress.create! zip: postcode, country_code: country }

  describe '#home_country?' do
    subject { german_address.home_country? }

    context 'when Germany' do
      let(:country) { 'Germany' }
      
      it { should be_true }
    end

    context 'when Croatia' do
      let(:country) { 'Croatia' }

      it { should be_false }
    end
  end

  describe '#eu?' do
    context "with country name" do
      subject { german_address.eu? }

      context "when european union country" do
        let(:country) { 'Germany' }
        it { should be_true }
      end

      context "when no european union country" do
        let(:country) { 'Uzbekistan' }
        it { should_not be_true }
      end
    end

    context 'with country iso code' do
      subject { french_address.eu? }

      context "when european union country" do
        let(:country) { 'DE' }
        it { should be_true }
      end

      context "when no european union country" do
        let(:country) { 'UZ' }
        it { should_not be_true }
      end
    end
  end

  describe '#eu_without_home_country?' do
    subject { german_address.eu_without_home_country? }

    context 'when Germany' do
      let(:country) { 'Germany' }

      it { should be false }
    end

    context 'when Poland' do
      let(:country) { 'Poland' }

      it { should be_true }
    end
  end

  describe '#third_country?' do
    subject { german_address.third_country? }

    context "when Berlin address" do
      let(:postcode) { 10115 }
      let(:country) { 'Germany' }

      it { should be_false }
    end

    context "when Helgoland address" do
      let(:postcode) { 27498 }
      let(:country) { 'Germany' }

      it { should be_true }
    end

    context "when Canary Island address" do
      let(:postcode) { 38400 }
      let(:country) { 'Spain' }

      it { should be_true }
    end
  end

  describe '#vatable?' do
    subject { german_address.vatable? }
    
    context 'when home country' do
      let(:country) { 'Germany' }
      it { should be_true }
    end

    context 'when eu country' do
      let(:country) { 'United Kingdom' }
      it { should be_false }
    end

    context 'when third country home territory' do
      let(:country) { 'Spain' }
      it { should be_false }
    end

    context 'when third country eu territory' do
      let(:country) { 'Spain' }
      it { should be_false }
    end

    context 'when third country outside eu' do
      let(:country) { 'Argentina' }
      it { should be_true }
    end
  end




















end