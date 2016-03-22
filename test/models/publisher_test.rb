require 'test_helper'

class PublisherTest < ActiveSupport::TestCase
  test "should be valid with no changes" do
    publisher = FactoryGirl.build(:publisher)
    assert publisher.valid?
  end

  test "should not be valid without a name" do
    publisher = FactoryGirl.build(:publisher, name: '')
    assert_not publisher.valid?
  end

  test "should not be valid with a duplicate name" do
    publisher2 = FactoryGirl.create(:publisher)
    publisher = FactoryGirl.build(:publisher, name: publisher2.name)
    assert_not publisher.valid?
  end
end
