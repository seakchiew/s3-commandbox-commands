/**
 * Register credentials for S3 operations
 *
 **/
component {

	property name="S3CommandUtils" inject="S3CommandUtils@s3-commandbox-commands";

	/**
	 * @global.hint      Whether or not the credentials should be stored as global defaults
	 * @bucket.hint      Name of S3 bucket to which the credentials should be associated
	 * @accessKey.hint   The public access key of the credential pair
	 * @secretKey.hint   The secret key of the credential pair
	 **/
	function run(
		  required boolean global
		, required string  bucket
		, required string  accessKey
		, required string  secretKey
	) {
		if ( !arguments.accesskey.len() ) {
			print.redLine( "Please enter an AWS access key" );
			return;
		}
		if ( !arguments.secretKey.len() ) {
			print.redLine( "Please enter an AWS secret key" );
			return;
		}
		if ( !arguments.global && !arguments.bucket.len() ) {
			print.redLine( "If the credential is not global, you must specify a bucket. Please enter an S3 bucket name with which to associate the S3 credentials" );
			return;
		}

		S3CommandUtils.storeCredentials( argumentCollection=arguments );

		if ( arguments.global ) {
			print.greenLine( "Thank you, global default credentials for S3 access have been set." );
		} else {
			print.greenLine( "Thank you, credentials for S3 access to the bucket, [#arguments.bucket#], have been set." );
		}

		return;
	}

}