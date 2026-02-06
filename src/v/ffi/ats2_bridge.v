// SPDX-License-Identifier: PMPL-1.0-or-later
//
// ATS2 FFI Bridge
// V bindings for ATS2 formally verified operations

module ffi

// C-compatible structures matching ATS2 exports
pub struct CBatchResult {
pub mut:
	success_count int
	failure_count int
	skipped_count int
	message       &char
}

// Convert C string to V string
fn c_string_to_v(s &char) string {
	if s == 0 {
		return ''
	}
	return unsafe { cstring_to_vstring(s) }
}

// ========== ATS2 C Function Declarations ==========

fn C.c_validate_spdx(&char) int

fn C.c_license_update(&char, &char, &char, int, int, int) CBatchResult

fn C.c_git_sync(&char, int, &char, int, int) CBatchResult

fn C.c_file_replace(&char, &char, &char, int, int, int) CBatchResult

fn C.c_get_version() &char

// ========== V-friendly wrappers ==========

// BatchResult is the V-friendly version of batch results
pub struct BatchResult {
pub mut:
	success_count int
	failure_count int
	skipped_count int
	message       string
}

// Validates SPDX identifier
// Returns true if valid, false otherwise
pub fn validate_spdx(license string) bool {
	result := C.c_validate_spdx(license.str)
	return result == 1
}

// LicenseUpdateParams contains parameters for license update
pub struct LicenseUpdateParams {
pub:
	old_license string
	new_license string
	base_dir    string
	max_depth   int
	dry_run     bool
	backup      bool
}

// Performs license update operation
// Calls formally verified ATS2 implementation
pub fn license_update(params LicenseUpdateParams) BatchResult {
	dry_run_flag := if params.dry_run { 1 } else { 0 }
	backup_flag := if params.backup { 1 } else { 0 }

	c_result := C.c_license_update(
		params.old_license.str,
		params.new_license.str,
		params.base_dir.str,
		params.max_depth,
		dry_run_flag,
		backup_flag
	)

	return BatchResult{
		success_count: c_result.success_count
		failure_count: c_result.failure_count
		skipped_count: c_result.skipped_count
		message: c_string_to_v(c_result.message)
	}
}

// GitSyncParams contains parameters for git sync
pub struct GitSyncParams {
pub:
	base_dir      string
	max_depth     int
	commit_msg    string
	parallel_jobs int
	dry_run       bool
}

// Performs git batch sync operation
// Calls formally verified ATS2 implementation
// This replaces sync_repos.sh with type-safe version
pub fn git_sync(params GitSyncParams) BatchResult {
	dry_run_flag := if params.dry_run { 1 } else { 0 }

	c_result := C.c_git_sync(
		params.base_dir.str,
		params.max_depth,
		params.commit_msg.str,
		params.parallel_jobs,
		dry_run_flag
	)

	return BatchResult{
		success_count: c_result.success_count
		failure_count: c_result.failure_count
		skipped_count: c_result.skipped_count
		message: c_string_to_v(c_result.message)
	}
}

// FileReplaceParams contains parameters for file replace
pub struct FileReplaceParams {
pub:
	pattern     string
	replacement string
	base_dir    string
	max_depth   int
	dry_run     bool
	backup      bool
}

// Performs file replace operation
// Calls formally verified ATS2 implementation
pub fn file_replace(params FileReplaceParams) BatchResult {
	dry_run_flag := if params.dry_run { 1 } else { 0 }
	backup_flag := if params.backup { 1 } else { 0 }

	c_result := C.c_file_replace(
		params.pattern.str,
		params.replacement.str,
		params.base_dir.str,
		params.max_depth,
		dry_run_flag,
		backup_flag
	)

	return BatchResult{
		success_count: c_result.success_count
		failure_count: c_result.failure_count
		skipped_count: c_result.skipped_count
		message: c_string_to_v(c_result.message)
	}
}

// Gets version from ATS2 core
pub fn get_version() string {
	c_version := C.c_get_version()
	return c_string_to_v(c_version)
}

// Prints batch result in human-readable format
pub fn (result BatchResult) print() {
	println('\n=== Batch Operation Results ===')
	println('Success: ${result.success_count}')
	println('Failure: ${result.failure_count}')
	println('Skipped: ${result.skipped_count}')
	println('Total:   ${result.success_count + result.failure_count + result.skipped_count}')
	if result.message != '' {
		println('\nMessage: ${result.message}')
	}
	println('')
}

// Checks if operation was successful
pub fn (result BatchResult) is_success() bool {
	return result.failure_count == 0
}

// Checks if any operations failed
pub fn (result BatchResult) has_failures() bool {
	return result.failure_count > 0
}
