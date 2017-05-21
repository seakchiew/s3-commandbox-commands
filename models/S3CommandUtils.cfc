component {
	property name="configService" inject="configService";

	function init() {
		return this;
	}

	public void function storeCredentials(
		  required boolean global
		, required string  bucket
		, required string  accessKey
		, required string  secretKey
	) {
		var configKey = "s3credentials." & ( arguments.global ? "global" : arguments.bucket );

		configService.setSetting( configKey & ".accesskey", arguments.accessKey );
		configService.setSetting( configKey & ".secretkey", arguments.secretKey );
	}

	public struct function getCredentials( required string bucket ) {
		var bucketConfigKey  = "s3credentials." & arguments.bucket;
		var globalConfigKey  = "s3credentials.global";

		if ( configService.settingExists( bucketConfigKey & ".accessKey" ) ) {
			return {
				  accessKey = configService.getSetting( bucketConfigKey & ".accessKey", "" )
				, secretKey = configService.getSetting( bucketConfigKey & ".secretKey", "" )
			};
		}

		return {
			  accessKey = configService.getSetting( globalConfigKey & ".accessKey", "" )
			, secretKey = configService.getSetting( globalConfigKey & ".secretKey", "" )
		};
	}
}