part of '../health.dart';

/// Custom Exception for the plugin. Used when a Health Data Type is requested,
/// but not available on the current platform.
class HealthException implements Exception {
  /// Data Type that was requested.
  dynamic dataType;

  /// Cause of the exception.
  String cause;

  HealthException(this.dataType, this.cause);

  @override
  String toString() =>
      "Error requesting health data type '$dataType' - cause: $cause";
}

/// Represents errors that can occur when interacting with health data platforms.
///
/// This class provides more detailed error information from the native health platforms
/// (Apple HealthKit and Google Health Connect).
class HealthError implements Exception {
  /// The error code from the native platform
  final String code;

  /// A human-readable error message
  final String message;

  /// Additional details about the error (may be null)
  final Map<String, dynamic>? details;

  const HealthError({
    required this.code,
    required this.message,
    this.details,
  });

  /// Creates a HealthError from a PlatformException
  factory HealthError.fromPlatformException(PlatformException e) {
    return HealthError(
      code: e.code,
      message: e.message ?? 'Unknown error',
      details: e.details is Map<String, dynamic>
          ? e.details as Map<String, dynamic>
          : null,
    );
  }

  /// Returns true if this error is related to authorization/permissions
  bool get isAuthorizationError =>
      code == 'authorization_not_determined' ||
      code == 'authorization_denied' ||
      code == 'authorization_restricted' ||
      code == 'authorization_error';

  /// Returns true if this error is related to iOS version requirements
  bool get isVersionError =>
      code == 'version_error' || code == 'ios_version_error';

  /// Returns true if this error is related to invalid arguments
  bool get isInvalidArgumentError =>
      code == 'invalid_argument' || code == 'plugin_error';

  /// Returns true if this error is related to database access
  bool get isDatabaseError => code == 'database_inaccessible';

  /// Returns true if this error is related to no data being available
  bool get isNoDataError => code == 'no_data';

  @override
  String toString() {
    final detailsStr = details != null ? ' Details: $details' : '';
    return 'HealthError: [$code] $message$detailsStr';
  }
}

/// The status of Google Health Connect.
///
/// **NOTE** - The enum order is arbitrary. If you need the native value,
/// use [nativeValue] and not the index.
///
/// Reference:
/// https://developer.android.com/reference/kotlin/androidx/health/connect/client/HealthConnectClient#constants_1
enum HealthConnectSdkStatus {
  /// https://developer.android.com/reference/kotlin/androidx/health/connect/client/HealthConnectClient#SDK_UNAVAILABLE()
  sdkUnavailable(1),

  /// https://developer.android.com/reference/kotlin/androidx/health/connect/client/HealthConnectClient#SDK_UNAVAILABLE_PROVIDER_UPDATE_REQUIRED()
  sdkUnavailableProviderUpdateRequired(2),

  /// https://developer.android.com/reference/kotlin/androidx/health/connect/client/HealthConnectClient#SDK_AVAILABLE()
  sdkAvailable(3);

  const HealthConnectSdkStatus(this.nativeValue);

  /// The native value that matches the value in the Android SDK.
  final int nativeValue;

  factory HealthConnectSdkStatus.fromNativeValue(int value) {
    return HealthConnectSdkStatus.values.firstWhere(
        (e) => e.nativeValue == value,
        orElse: () => HealthConnectSdkStatus.sdkUnavailable);
  }
}
