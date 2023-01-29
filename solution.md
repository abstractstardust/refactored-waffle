# Solution

## Prerequisites

- Installations: Python3, Terraform, AWS CLI
- Permissions: AWS Credentials

## Build

### Terraform

```sh
terraform init
```

```sh
terraform apply
```

## Use

There are several ways to use this program.

1. **Terminal or Bash Script**

    Example:

   ```sh
   curl "$(terraform output -raw base_url)/fearless.tech"
   ```

    `fearless.tech` can be replaced with another domain to check for its validity.

2. **On the AWS Website**
   1. Go to the AWS website, login, and navigate to the Amazon API Gateway section. 
   2. Click on CertficateAPI.
   3. On the left hand menu, click stages, then alpha.
   4. Find and click on the Invoke URL
   5. Add a slash to the invoke URL
   6. Enter the desired domain into the address bar
      1. Should look like: `xyz.amazonaws.com/alpha/fearless.tech`

3. **Postman or Insomnia**
   1. Find the Invoke URL for the API.
   2. Enter the desired domain after alpha/.
      1. Should look like: `xyz.amazonaws.com/alpha/fearless.tech`
   3. Click send to run the request

---

## Future Updates, Changes, or Outstanding Code Recommendations

- Right now, the way to use the program is rather clunky. Depending on the business and project needs, I could automate running through the various domains overseen by the company using bash scripts.
- We need to decide what we are going to do with the invalid certificates. This is a high priority item.