# Medications List with Login and Home Screen

## Description

This project is a Flutter application that allows users to manage their medications. Users can log in and view a list of medications, with the ability to add, edit, or delete entries.

## Design Choices

1. **Default Medications**:
   - The application initializes with three default medications to demonstrate functionality and provide users with examples.
   
2. **User Authentication**:
   - The application assumes that the user has already created an account, streamlining the login process.

3. **Data Types**:
   - User email and password are represented as strings.
   - Medication name is stored as a string, while time and dose are stored as integers.

4. **Error Handling**:
   - Input validation is implemented to ensure that users provide valid data before adding or updating medications.

## Assumptions

- Users are required to create an account before accessing the application.
- Users will enter a valid email (not empty or null value) and password during the login process.
- Medication names are assumed to be strings, while time and dose are integers.
