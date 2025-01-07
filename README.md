## portfolio
I needed a central repository where I could describe and demonstrate the various projects I worked on over the years,
so I decided to build a full-stack web application using frameworks that uses Python and Javascript as languages. 

While a few static html pages paired with some css might have been enough to showcase previous projects properly, it would be heavily lacking in reusability for other projects in the future
that might require more complex functionalities.

By following a microservice architecture, the ui, api and databases can be easily reused as templates.
Another objective of this project is to explore different deployment strategies, along with the different configurations required for the application to run properly.

# Usage 
## Cloning this repository:

Since my current repository architecture contains submodules,`git clone` will only clone the top-level repository.

To clone this repository along with its submodule, use the following command: 

`git clone --recurse-submodules --remote-submodules https://github.com/Merst/portfolio`

## Infrastructure:

This project currently run on AWS, using infrastructure as code through Terraform in order to create the required resources for the application.
To create the required infrastructure:
1. Install Terraform
2. `cd` to either infra/test or infra/prod, depending on your objective.
3. `terraform init` will set up the prerequisites and dependancies. 
4. `export AWS_ACCESS_KEY_ID= <access-key-id>`
5. `export AWS_SECRET_ACCESS_KEY= <access-key-password>`
6. `terraform apply -var="db_password=<Password of Database>"` will create the required resources.

If we need to destroy the current infrastructure: `terraform destroy`.

## Building:

This project uses `docker-compose` to set up the required environments (prod/dev).


