require 'test_helper'

class AdministratorTest < ActiveSupport::TestCase
  test "should be valid with no changes" do
    administrator = FactoryGirl.build(:administrator)
    assert administrator.valid?
  end

  test "should not be valid without a name" do
    administrator = FactoryGirl.build(:administrator, name: nil)
    assert_not administrator.valid?
  end

  test "should not be valid with a duplicate name" do
    administrator2 = FactoryGirl.create(:administrator)
    administrator = FactoryGirl.build(:administrator, name: administrator2.name)
    assert_not administrator.valid?
  end

  test "should not be valid without a password" do
    administrator = FactoryGirl.build(:administrator, password: nil)
    assert_not administrator.valid?
  end

  test "should not be valid with an empty password" do
    administrator = FactoryGirl.build(:administrator, password: '', password_confirmation: '')
    assert_not administrator.valid?
  end

  test "should not be valid with a short password" do
    administrator = FactoryGirl.build(:administrator, password: 'short', password_confirmation: 'short')
    assert_not administrator.valid?
  end

  test "should not be valid with a confirmation mismatch" do
    administrator = FactoryGirl.build(:administrator, password: 'initial password', password_confirmation: 'another password')
    assert_not administrator.valid?
  end

  test "should be valid with a new valid password" do
    administrator = FactoryGirl.build(:administrator, password: 'new password', password_confirmation: 'new password')
    assert administrator.valid?
  end

  test "should authenticate with correct credentials" do
    administrator2 = FactoryGirl.create(:administrator)
    administrator = Administrator.authenticate(administrator2.name, administrator2.password)
    assert_equal administrator2.id, administrator.id
  end

  test "should not authenticate with incorrect credentials" do
    administrator2 = FactoryGirl.create(:administrator)
    administrator = Administrator.authenticate(administrator2.name, '123123')
    assert_nil administrator
  end

  test "should save last login time on authentication" do
    administrator2 = FactoryGirl.create(:administrator)
    now = Time.current
    administrator = Administrator.authenticate(administrator2.name, administrator2.password)
    assert_equal now.to_i, administrator.last_login_at.to_i
  end

  test "should not destroy last administrator" do
    administrator = FactoryGirl.create(:administrator)
    assert_equal 1, Administrator.count

    assert_no_difference 'Administrator.count' do
      assert_raises RuntimeError do
        administrator.destroy
      end
    end
  end
end
