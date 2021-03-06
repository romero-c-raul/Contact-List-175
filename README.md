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