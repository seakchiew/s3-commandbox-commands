S3 Commands/Package endpoint for CommandBox
-------------------------------------------

[![Build Status](https://travis-ci.org/pixl8/s3-commandbox-commands.svg?branch=stable)](https://travis-ci.org/pixl8/s3-commandbox-commands)

This CommandBox module wraps the features found in [jcberquist/aws-cfml](https://github.com/jcberquist/aws-cfml) and allows you to install packages from private S3 buckets. Full credit to [jcberquist](https://github.com/jcberquist) for _all_ of the S3 interaction logic.

In its current state, the module _only_ supports installing packages from private S3 buckets and this will only be available on bleeding-edge installs of CommandBox (at time of writing, the stable version of CommandBox was **3.6.0**). In the future, we hope to implement further commands such as `s3 put`, etc.

## Installation

Install into Commandbox with `install s3-commandbox-commands`.

## Usage

### Authenticating private S3 buckets

The module allows you to provide authentication credentials, a **public access key** and a **secret key**, for all S3 operations. It also allows you to provide credentials for _specific buckets_. This is achieved using the `s3 setCredentials` command:

```
# set global default credentials
/> s3 setCredentials global=true accessKey=<accesskey> secretKey=<secretKey>

# set bucket specific credentials
/> s3 setCredentials bucket="my-private-s3-bucket" accessKey=<accesskey> secretKey=<secretKey>
```

### Using private S3 buckets for package endpoints

You can either install packages directly from zip files hosted in private S3 buckets, or set the location of your packages to S3 buckets. The format of S3 endpoint URIs is as follows:

```
s3://<bucket-name>:<optional-s3-region-code>/<path-to-resource-without-zip-extension>
```

For example, if your package zip file lives in a bucket, `myco-commandbox-packages`, in the `eu-west-2` region at location `/my-project/v10.2.3.zip`, your URI would look like this:

```
s3://myco-commandbox-packages:eu-west-2/my-project/v10.2.3
```

_If you do not supply a region, the default `us-east-1` will be used._

### Installing packages directly from S3 buckets

Using the URI syntax above, simply do:

```
install s3://myco-commandbox-packages:eu-west-2/my-project/v10.2.3
```

### Using private S3 assets in private Forgebox packages

Using this approach, you can make use of Forgebox's great publishing and versioning system and keep your assets secure but accessible behind private S3 buckets. Simply use the S3 endpoint URI syntax in the `location` field of your package:

```
{
    "name":"My Project",
    "version":"10.2.3",
    "private":true,
    "location":"s3://myco-commandbox-packages:eu-west-2/my-project/v10.2.3",
    ...
```

