require 'cta/bus_api'

RSpec.describe CTA::BusAPI  do
  context "can be initialized" do
    it "stores api token" do
      token = "123"
      busTrack = CTA::BusAPI.new(token)
      expect(busTrack.api_key).to eq token
    end
  end

  context "simple api calls" do
    it "can get cta bus time" do
      busTrack = CTA::BusAPI.new("123")

    end
  end
end
