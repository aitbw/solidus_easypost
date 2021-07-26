# frozen_string_literal: true

RSpec.describe SolidusEasypost::ParcelBuilder do
  describe '.from_package', vcr: { cassette_name: 'parcel_builder/from_package' } do
    let(:shipment) { create(:shipment) }
    let(:package) { shipment.to_package }
    let(:parcel_dimension_calculator) { instance_spy('SolidusEasypost.configuration.parcel_dimension_calculator_class') }
    let(:parcel_dimension) { instance_spy('SolidusEasypost::ParcelDimension') }

    before do
      allow(SolidusEasypost.configuration.parcel_dimension_calculator_class)
        .to receive(:new)
        .and_return(parcel_dimension_calculator)

      allow(parcel_dimension_calculator).to receive(:compute).and_return(parcel_dimension)
      allow(parcel_dimension).to receive(:to_h).and_return(dimension_hash)
      allow(EasyPost::Parcel).to receive(:create).and_call_original
    end

    context 'when there is only the weight set' do
      let(:dimension_hash) { { weight: 10.to_f } }

      it 'builds a parcel with the correct attributes' do
        parcel = described_class.from_package(package)

        expect(parcel_dimension_calculator)
          .to have_received(:compute)
          .with(package)

        expect(EasyPost::Parcel)
          .to have_received(:create)
          .with({ weight: 10.to_f })

        expect(parcel).to have_attributes(object: 'Parcel')
      end
    end

    context 'when all the properties are set' do
      let(:dimension_hash) do
        { weight: 10.to_f, height: 2.to_f, width: 3.to_f, depth: 4.to_f }
      end

      it 'builds a parcel with the correct attributes' do
        parcel = described_class.from_package(package)

        expect(parcel_dimension_calculator)
          .to have_received(:compute)
          .with(package)

        expect(EasyPost::Parcel)
          .to have_received(:create)
          .with({ weight: 10.to_f, height: 2.to_f, width: 3.to_f, depth: 4.to_f })

        expect(parcel).to have_attributes(object: 'Parcel')
      end
    end
  end

  describe '.from_return_authorization', vcr: { cassette_name: 'parcel_builder/from_return_authorization' } do
    let(:return_item) { create(:return_item) }
    let(:return_authorization) { return_item.return_authorization }
    let(:parcel_dimension_calculator) { instance_spy('SolidusEasypost.configuration.parcel_dimension_calculator_class') }
    let(:parcel_dimension) { instance_spy('SolidusEasypost::ParcelDimension') }

    before do
      allow(SolidusEasypost.configuration.parcel_dimension_calculator_class)
        .to receive(:new)
        .and_return(parcel_dimension_calculator)

      allow(parcel_dimension_calculator).to receive(:compute).and_return(parcel_dimension)
      allow(parcel_dimension).to receive(:to_h).and_return(dimension_hash)
      allow(EasyPost::Parcel).to receive(:create).and_call_original
    end

    context 'when there is only the weight set' do
      let(:dimension_hash) { { weight: 10.to_f } }

      it 'builds a parcel with the correct attributes' do
        parcel = described_class.from_return_authorization(return_authorization)

        expect(parcel_dimension_calculator)
          .to have_received(:compute)
          .with(return_authorization)

        expect(EasyPost::Parcel)
          .to have_received(:create)
          .with({ weight: 10.to_f })

        expect(parcel).to have_attributes(object: 'Parcel')
      end
    end

    context 'when all the properties are set' do
      let(:dimension_hash) do
        { weight: 10.to_f, height: 2.to_f, width: 3.to_f, depth: 4.to_f }
      end

      it 'builds a parcel with the correct attributes' do
        parcel = described_class.from_return_authorization(return_authorization)

        expect(parcel_dimension_calculator)
          .to have_received(:compute)
          .with(return_authorization)

        expect(EasyPost::Parcel)
          .to have_received(:create)
          .with({ weight: 10.to_f, height: 2.to_f, width: 3.to_f, depth: 4.to_f })

        expect(parcel).to have_attributes(object: 'Parcel')
      end
    end
  end
end
