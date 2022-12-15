require "test_helper"

class CalendarsControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get calendars_create_url
    assert_response :success
  end
end
