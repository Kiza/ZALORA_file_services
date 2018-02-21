# ZALORA_file_services

## Task

Write a program that provides an HTTP API to store and retrieve files. It should support the following features:

- Upload a new file
- Retrieve an uploaded file by name
- Delete an uploaded file by name
- Bonus point 1: include a NixOS module to provide the API as a service
- Bonus point 2: if multiple files have similar contents, reuse the contents somehow to save space.


# Requirement and depedencies

- Ruby version: ruby 2.4.1

# Get started
- check out source code
- run `bundle`


# Run test
- run `rails t`

# Start services
- run `rake db:migrate`
- run `rake db:setup`
- run `rails s`

Services will be running at `http://localhost:3000`

# API
## Upload a file
```
curl -X POST -F file=@"/path/to/file" http://localhost:3000/files
```

## Download a file
```
curl -X GET http://localhost:3000/files/filename
```

## Remove a file
```
curl -X DELETE http://localhost:3000/files/filename
```

# Design

- Assume filename is unique, so user can retrive files with filename
- Uploaded file will be saved in small chunks
    - if two chunks have the same chunk size, hash value, and hash function, then we assume these chunks are identical
    - current hash fucntion is SHA256
    - for testing, current chunk size is 1024 * 10 bytes

# Potential issues

- We are using chunk size and hash value to track the duplicated chunks, which could be problematic when there is a hash collision. 
- We are using BLOB data type in the database, which could lead to performance issue.

# Future improvement

- Better duplicate logic should be used. 
- Dedicated storage services like S3 should be used. 
- Currently, all the hash check is done on the server, and the entire file needs to be uploaded. If user can upload files with a client (on desktop, or mobile phone), then
    - we do not need to upload the entire file to the server, instead, we can only upload the different
    - we improve performace by push hash check to the client as well.