require 'spec_helper'

describe ActsAsVatableAddress::Address do
  let(:postcode_berlin) { 10179 }
  let(:postcode_madrid) { 28999 }
  let(:postcode_helgoland) { 27498 }
  let(:postcode_canary_islands) { 38400 }

  let(:postcode) { postcode_berlin }
  let(:german_address) { GermanAddress.create! postcode: postcode, country: country }  
  let(:german_address_with_overwritten_vatable) { GermanAddressWithOverwrittenVatable.create! postcode: postcode, country: country }  
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
        it { should be_false }
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
        it { should be_false }
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

    context "when Argentinian address" do
      let(:country) { 'Argentina' }
      it { should be_true }
    end

    context "when German address" do
      let(:country) { 'Germany' }
      it { should be_false }
    end
  end

  describe '#vatable?' do
    subject { german_address.vatable? }
    
    context 'when home country' do
      let(:country) { 'Germany' }

      context 'inland address' do
        let(:postcode) { postcode_berlin }

        context 'with gem method' do
          it { should be_true }
        end

        context 'with overwritten method' do
          subject { german_address_with_overwritten_vatable.vatable? }
          it { should be_false }
        end
      end

      context 'third country territory' do
        let(:postcode) { postcode_helgoland }
        it { should be_false }
      end
    end

    context 'when eu country' do
      let(:country) { 'Spain' }

      context 'in-country address' do
        let(:postcode) { postcode_madrid }
        it { should be_false }
      end

      context 'third country territory' do
        let(:postcode) { postcode_canary_islands }
        it { should be_false }
      end
    end

    context 'when third country (outside eu)' do
      let(:country) { 'Argentina' }
      it { should be_false }
    end
  end
end