- # 1. Display Home Page and Add Groups
  - ## Requirements
    - Initial `home page` will display "You have not created any groups yet"

  - ## Implementation
    1. Create a route "/groups" that displays "You have not created any groups." if groups have not been created in the session
    2. If there are groups, display the total amount at the top of the page
        - Example: "You have created #{number_of_groups} groups."
    3. Add a link that redirects you to "/new_group"
        - Within this new page, you will have a: 
          - Form that asks for a group name
            - Empty names not allowed. 
          - Submit button
            - If names are not valid, re-render the current template
            - If names are valid, redirect to "/"

    ## Tests
      - Create a test that determines if a group was created
        - Test will check if group creation page is rendered correct
        - Test will check if group appears on the homepage

- # 2. Add a contact to groups
  - ## Requirements
      - Group page should show contacts and give you the option to add new ones

  - ## Implementation
    1. Render new template when clicking group name
    2. Within that template, show all current contacts and a button to add contacts
    3. Clicking on adding contacts renders a new page
        - Within that template a form will be included with:
          - Name
          - Celphone number
          - Email address
          - Birthday
    4. There will be a submit button that submits form
    5. If info is valid, redirect to current group directory
    6. If info is not valid, re-render template

    ## Tests
      - Create a test that determines if contact was created
        - Test will check if new contact page is rendered
        - Test will check if contact is created succesfully
        - Test will check if empty fields are handled correctly


- # 3. Edit group name
  - ## Requirements
    - Add an option on group page to edit group name

  - ## Implementation
    1. Add a link on the group page "Edit Group"
    2. Render a new page with a text box with label "please enter new group name"
    3. If name is valid, redirect to current group page
    4. If name is not valid, re-render page with message "Name is not valid"

    ## Tests
      - Test that checks if name changed

- # 4. Delete group
  - ## Requirements
    - Add an option on group page to delete group 
  
  - ## Implementation
    1. Add a button to `"contacts.erb"` that says "Delete group"
    2. This button submits a post request to delete the current group
    3. After deleting current group, user is re-directed to homepage

    ## Tests
      - Create a test that checks if group was deleted
        1. Create a group
        2. Make sure group was created
        3. Delete group
        4. Check flash message is displayed and group is deleted

- # 5. Edit contact info
  - ## Requirements
    - Add an option on group page to edit contact info

  - ## Implementation
    1. Add a button to `"contact.erb"` that says "Edit info"
    2. Render a new page with all the fields that are included
    3. Submit info and redirect to contact

    ## Tests
      - Create a test that checks if info was edited
        1. Create a group and contact
        2. Edit info
        3. Check if name changed on contacts page
        4. Check if info changed in specific contact's page

- # 6. Delete contact
  - ## Requirements
    - Add an option on contact page to delete contact
  
  - ## Implementation
    1. Add a button to `"contact.erb"` that says "Delete contact"
    2. This button submits a post request to delete the current contact
    3. After deleting current contact, user is re-directed to contacts

    ## Tests
      - Create a test that checks if contact was deleted
        1. Create a contact
        2. Make sure contact was created
        3. Delete contact
        4. Check flash message is displayed and contact is deleted 
