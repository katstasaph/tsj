require "application_system_test_case"

# Run these tests with `bundle exec rails test:system`

class AnnouncementsTest < ApplicationSystemTestCase
  include Devise::Test::IntegrationHelpers
    test "updating announcement via form updates the index " do
      sign_in users(:bob)
      visit root_path

      click_on "Edit announcement"

      fill_in_rich_text_area "announcement_content", with: "Regret to inform, Drake is At It Again"

      click_on "Update Announcement"

      assert_text "Updated announcement!"
      assert_text "Regret to inform, Drake is At It Again"
    end
end
