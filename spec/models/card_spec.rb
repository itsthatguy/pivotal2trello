require_relative '../../lib/P2t/models/card.rb'

describe P2t::Card do
  it "should be true" do
    P2t::Card.new.the_truth.should be_true
  end
end
