# ProjectPurpleCow - SRE Template

### Assignment
* Build a proof of concept according to the requirements below and check it into a public Git repository (e.g. Github) and link that repository in the response.  
    * Git history is important, but only for the main branch
* In a solution.md in the root of the repository:
    * List any future updates, changes, or outstanding code you would like to add or would recommend be added 
    * Document any assumptions, changes, or details of the implementation that materially impact the addition of future features.
* Be prepared to spend 15 minutes discussing your approach and implementation with another Site Reliability Engineer.

### Must Haves
* An updated AWS Lambda function which checks the SSL certificate expiration and responds in JSON
    * The function response should be compatible with API Gateway
    * The function should take the domain name as an argument named host
    * The function should return the following values
        * days_until_expiration 
        * is_valid
        * domain_name
* Update the Terraform Infrastructure as Code to create an API Gateway around the existing Lambda
* Includes a solution.md that provides relevant documentation including how to build and run the solution
### Nice to Haves
* Implement test cases for the python function, to test both happy and sad paths. Badssl.com is a great resource for expired/invalid ssl sites.
* Configure the function to publish a message to an SNS topic if the certificate is not valid, failing safely and completing the function execution if anything goes wrong.
### Additional Guidance
* The trial project evaluates your problem solving and coding skills. We want to see that you:
    * Have the ability to write Infrastructure as Code (IaC)
    * Have the ability to write functional, maintainable code

