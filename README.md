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
        