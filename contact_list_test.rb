require "minitest/autorun"
require "rack/test"

require_relative "contact_list"

class ContactListTest < Minitest::Test
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  def session
    last_request.env["rack.session"]
  end

  def test_view_create_group_page
    get "/new_group"

    assert_equal 200, last_response.status
    assert_includes last_response.body, '<input name="group"'
    assert_includes last_response.body, '<button type="submit"'
  end

  def test_create_group
    post "/groups", group: "Work"
    assert_equal 302, last_response.status
    assert_equal "New group has been created!", session[:message]

    get "/groups"
    assert_includes last_response.body, "Work"
    assert_includes last_response.body, '<a href="/groups/Work/contacts"'
  end

  def test_create_group_empty_name
    post "/groups", group: "  "
    assert_includes last_response.body, "Invalid name! Please try again."
  end
end