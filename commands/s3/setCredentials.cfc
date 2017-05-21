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
		  boolean global    = false
		, string  bucket    = ""
		, string  accessKey = ""
		, string  secretKey = ""
	) {
		while( !arguments.accesskey.len() ) {
			arguments.accessKey = shell.ask( "Enter your AWS access key: " );
		}
		while( !arguments.secretKey.len() ) {
			arguments.secretKey = shell.ask( "Enter your AWS secret key: " );
		}
		while( !global && !arguments.bucket.len() ) {
			arguments.bucket = shell.ask( "Enter your S3 bucket name: " );
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