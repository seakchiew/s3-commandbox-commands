/**
*********************************************************************************
* Copyright Since 2014 CommandBox by Ortus Solutions, Corp
* www.coldbox.org | www.ortussolutions.com
********************************************************************************
* @author Brad Wood, Luis Majano, Denny Valliant
*
* I am the file endpoint.  I get packages from a local file.
*/
component accessors="true" implements="commandbox.system.endpoints.IEndpoint" singleton {

	property name="consoleLogger"  inject="logbox:logger:console";
	property name="s3CommandUtils" inject="s3CommandUtils@s3-commandbox-commands";
	property name="httpsResolver"  inject="commandbox.system.endpoints.HTTPS";

	property name="namePrefixes" type="string";

	function init() {
		setNamePrefixes( 's3' );

		return this;
	}

	public string function resolvePackage( required string package, boolean verbose=false ) {
		var bucket      = arguments.package.listFirst( "/" ).listFirst( ":" );
		var objectKey   = arguments.package.listRest( "/" );
		var region      = arguments.package.listFirst( "/" ).listRest( ":" );
		var credentials = s3CommandUtils.getCredentials( bucket );

		if ( !credentials.accessKey.len() || !credentials.secretKey.len() ) {
			throw( "No access credentials have been setup for S3. Use the 's3 setcredentials' command to register your credentials.", 'endpointException' );
		}

		if ( !region.len() ) {
			region = "us-east-1";
		}

		var aws = new "commandbox.modules.s3-commandbox-commands.aws-cfml.aws" (
			  awsKey       = credentials.accessKey
			, awsSecretKey = credentials.secretKey
			, region       = region
		);

		var presignedUrl = "//" & aws.s3.generatePresignedURL(
			  bucket    = bucket
			, objectKey = objectKey & ( objectKey.endsWith( ".zip" ) ? "" : ".zip" )
			, expires   = 300
		);

		return httpsResolver.resolvePackage( argumentCollection=arguments, package=presignedUrl );
	}

	/**
	* Determines the name of a package based on its ID if there is no box.json
	*/
	public function getDefaultName( required string package ) {
		return arguments.package.listLast( "/" );
	}

	public function getUpdate( required string package, required string version, boolean verbose=false ) {
		consoleLogger.info( "not implemented!" );

		return false;
	}

}