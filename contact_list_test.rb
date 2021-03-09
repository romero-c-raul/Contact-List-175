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

  def test_view_create_contact_page
    post "/groups", group: "Work"

    get "/groups/Work/new_contact"
    assert_equal 200, last_response.status
    assert_includes last_response.body, '<label for="name"'
    assert_includes last_response.body, '<label for="email"'
    assert_includes last_response.body, '<label for="cellphone"'
  end

  def test_create_contacts
    post "/groups", group: "Work"

    post "/groups/Work", name: "Raul", email: "raul@gmail.com", cellphone: "000-111-222"
    assert_equal 302, last_response.status
    assert_equal "Contact has been created!", session[:message]

    get "/groups/Work/contacts/Raul"
    assert_equal 200, last_response.status
    assert_includes last_response.body, "raul@gmail.com"
    assert_includes last_response.body, "000-111-222"
  end

  def test_create_contact_empty_fields
    post "/groups", group: "Work"

    post "/groups/Work"
    assert_includes last_response.body, "Invalid name! Please try again."
  end

  def test_edit_group_name
    post "/groups", group: "Work"

    post "/groups/Work/edit", group_name: "Family"
    assert_equal 302, last_response.status

    get "/groups"
    assert_includes last_response.body, "Family"
    refute_includes last_response.body, "Work"
  end

  def test_edit_group_name_empty_name
    post "/groups", group: "Work"

    post "/groups/Work/edit", group_name: ""
    assert_includes last_response.body, "Invalid name! Please try again."
    assert_includes last_response.body, '<input name="group_name"'
  end

  def test_delete_group 
    post "/groups", group: "Work"
    assert_equal 302, last_response.status
    assert_equal "New group has been created!", session[:message]

    get last_response["Location"]
    assert_includes last_response.body, '<a href="/groups/Work/contacts'

    post "/groups/Work/delete"
    assert_equal 302, last_response.status
    assert_equal "Group has been deleted!", session[:message]

    get last_response["Location"]
    refute_includes last_response.body, '<a href="/groups/Work/contacts'
  end

  def test_edit_contact_info
    post "/groups", group: "Work"
    post "/groups/Work", name: "Raul", email: "raul@gmail.com", cellphone: "000-111-222"

    post "/groups/Work/contacts/Raul", name: "notRaul", email: "notraul@gmail.com", cellphone: "555-555-555"
    assert_equal 302, last_response.status
    assert_equal "Contact info has been edited!", session[:message]
    
    get last_response["Location"]
    assert_includes last_response.body, '<a href="/groups/Work/contacts/notRaul'
    refute_includes last_response.body, '<a href="/groups/Work/contacts/Raul'

    get "/groups/Work/contacts/notRaul"
    assert_equal 200, last_response.status
    assert_includes last_response.body, "notraul@gmail.com"
    assert_includes last_response.body, "555-555-555"
  end

  def test_delete_contact
    post "/groups", group: "Work"

    post "/groups/Work", name: "Raul", email: "raul@gmail.com", cellphone: "000-111-222"
    assert_equal 302, last_response.status
    assert_equal "Contact has been created!", session[:message]

    get last_response["Location"]
    assert_includes last_response.body, "Raul"

    post "groups/Work/contacts/Raul/delete"
    assert_equal 302, last_response.status
    assert_equal "Contact has been deleted!", session[:message]

    get last_response["Location"]
    assert_equal 200, last_response.status
    refute_includes last_response.body, "Raul"
  end
end