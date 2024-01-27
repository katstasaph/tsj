require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "User creation happy path" do
    user = User.new(username: "georgeeliot", name: "George Eliot", password_confirmation: "whatevs")
    assert user.valid?
  end

  test "User creation invalid without username" do
    user = User.new(name: "George Eliot", password_confirmation: "whatevs")
    assert_not user.valid?
  end

  test "User creation invalid without password confirmation" do
    user = User.new(username: "georgeeliot", name: "George Eliot")
    assert_not user.valid?
  end

  test "User creation requires unique email address" do
    user1 = User.create(username: "georgeeliot", password_confirmation: "whatevs", email: "george@example.com")
    user2 = User.new(username: "georgeconstanza", password_confirmation: "whatevs",  email: "george@example.com")
    assert_not user2.valid?
  end
end
