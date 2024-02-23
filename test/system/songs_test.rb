require "application_system_test_case"

# Run these tests with `bundle exec rails test:system`

class SongsTest < ApplicationSystemTestCase
  include Devise::Test::IntegrationHelpers
  test "adding new song redirects back to home and shows flash message" do
    sign_in users(:bob)
    visit new_song_path

    fill_in "Artist", with: "Black Lace"
    fill_in "Title", with: "Agadoo"

    click_on "Create Song"

    assert_text "Added song!"

  end
end
