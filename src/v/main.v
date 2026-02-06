// SPDX-License-Identifier: PMPL-1.0-or-later
//
// repo-batcher main entry point
// Fast CLI for formally verified batch repository operations

module main

import os
import cli
import ffi
import executor
import utils

const (
	version = '0.1.0'
	app_name = 'repo-batcher'
	default_repos_dir = os.join_path(os.home_dir(), 'Documents', 'hyperpolymath-repos')
)

fn main() {
	mut app := cli.Command{
		name: app_name
		description: 'Formally verified batch operations for mass repository management'
		version: version
		execute: show_help
		commands: [
			cli.Command{
				name: 'list-ops'
				description: 'List all available operations'
				execute: cmd_list_operations
			},
			cli.Command{
				name: 'license-update'
				description: 'Update license across repositories'
				execute: cmd_license_update
				flags: [
					cli.Flag{
						flag: .string
						name: 'old'
						abbrev: 'o'
						description: 'Old license SPDX identifier'
						required: true
					},
					cli.Flag{
						flag: .string
						name: 'new'
						abbrev: 'n'
						description: 'New license SPDX identifier'
						required: true
					},
					cli.Flag{
						flag: .string
						name: 'targets'
						abbrev: 't'
						description: 'Target repositories (comma-separated or @pattern)'
						required: true
					},
					cli.Flag{
						flag: .bool
						name: 'dry-run'
						abbrev: 'd'
						description: 'Preview changes without executing'
					},
					cli.Flag{
						flag: .bool
						name: 'backup'
						abbrev: 'b'
						description: 'Create backups before changes'
					},
				]
			},
			cli.Command{
				name: 'file-replace'
				description: 'Replace files across repositories'
				execute: cmd_file_replace
				flags: [
					cli.Flag{
						flag: .string
						name: 'pattern'
						abbrev: 'p'
						description: 'File pattern to match'
						required: true
					},
					cli.Flag{
						flag: .string
						name: 'replacement'
						abbrev: 'r'
						description: 'Replacement file path'
						required: true
					},
					cli.Flag{
						flag: .string
						name: 'targets'
						abbrev: 't'
						description: 'Target repositories'
						required: true
					},
					cli.Flag{
						flag: .bool
						name: 'dry-run'
						abbrev: 'd'
						description: 'Preview changes without executing'
					},
					cli.Flag{
						flag: .bool
						name: 'backup'
						abbrev: 'b'
						description: 'Create backups before changes'
					},
				]
			},
			cli.Command{
				name: 'git-sync'
				description: 'Batch git sync (add, commit, push) across repositories'
				execute: cmd_git_sync
				flags: [
					cli.Flag{
						flag: .int
						name: 'parallel'
						abbrev: 'p'
						description: 'Number of parallel jobs (default: 4)'
						default_value: ['4']
					},
					cli.Flag{
						flag: .int
						name: 'depth'
						abbrev: 'D'
						description: 'Max depth for repository search (default: 2)'
						default_value: ['2']
					},
					cli.Flag{
						flag: .string
						name: 'commit-message'
						abbrev: 'm'
						description: 'Commit message (default: "chore: batch update")'
						default_value: ['chore: batch update']
					},
					cli.Flag{
						flag: .bool
						name: 'dry-run'
						abbrev: 'd'
						description: 'Preview changes without executing'
					},
				]
			},
			cli.Command{
				name: 'watch'
				description: 'Start watch daemon for batch operations'
				execute: cmd_watch
				flags: [
					cli.Flag{
						flag: .string
						name: 'folder'
						abbrev: 'f'
						description: 'Watch folder path (default: ~/.config/repo-batcher/watch)'
					},
					cli.Flag{
						flag: .int
						name: 'interval'
						abbrev: 'i'
						description: 'Check interval in seconds (default: 30)'
						default_value: ['30']
					},
				]
			},
			cli.Command{
				name: 'rollback'
				description: 'Rollback last operation or specific log'
				execute: cmd_rollback
				flags: [
					cli.Flag{
						flag: .bool
						name: 'last'
						abbrev: 'l'
						description: 'Rollback last operation'
					},
					cli.Flag{
						flag: .string
						name: 'log-id'
						abbrev: 'L'
						description: 'Rollback specific log ID'
					},
				]
			},
		]
	}

	app.setup()
	app.parse(os.args)
}

fn show_help(cmd cli.Command) ! {
	println('repo-batcher v${version}')
	println('Formally verified batch operations for mass repository management')
	println('')
	println('Usage:')
	println('  repo-batcher <command> [options]')
	println('')
	println('Available commands:')
	println('  list-ops          List all available operations')
	println('  license-update    Update license across repositories')
	println('  file-replace      Replace files across repositories')
	println('  git-sync          Batch git sync (add, commit, push)')
	println('  watch             Start watch daemon')
	println('  rollback          Rollback operation')
	println('')
	println('Use "repo-batcher <command> --help" for more information about a command.')
}

fn cmd_list_operations(cmd cli.Command) ! {
	println('Available Operations:')
	println('')
	println('  license-update    Replace license headers and LICENSE files')
	println('                    Safety: Valid SPDX IDs, backup required')
	println('')
	println('  file-replace      Replace files matching pattern')
	println('                    Safety: Backup required, no circular replacements')
	println('')
	println('  git-sync          Batch commit and push across repos')
	println('                    Safety: Valid repos, no conflicts, remote reachable')
	println('')
	println('  workflow-update   Update GitHub Actions workflows')
	println('                    Safety: Valid YAML, SHA pinning validation')
	println('')
	println('  custom            Execute custom operation from template')
	println('                    Safety: Template validation, dry-run enforced')
}

fn cmd_license_update(cmd cli.Command) ! {
	old := cmd.flags.get_string('old')!
	new := cmd.flags.get_string('new')!
	targets := cmd.flags.get_string('targets')!
	dry_run := cmd.flags.get_bool('dry-run') or { false }
	backup := cmd.flags.get_bool('backup') or { true }

	println('License Update Operation')
	println('  Old: ${old}')
	println('  New: ${new}')
	println('  Targets: ${targets}')
	println('  Dry Run: ${dry_run}')
	println('  Backup: ${backup}')
	println('')

	// Validate SPDX identifiers first
	if !ffi.validate_spdx(old) {
		println('ERROR: Invalid old license SPDX identifier: ${old}')
		return error('Invalid SPDX identifier')
	}

	if !ffi.validate_spdx(new) {
		println('ERROR: Invalid new license SPDX identifier: ${new}')
		return error('Invalid SPDX identifier')
	}

	if dry_run {
		println('[DRY RUN] No changes will be made')
		println('')
	}

	// Resolve repositories from target specification
	println('Resolving target repositories...')
	repos := utils.resolve_targets(targets, default_repos_dir, 2)
	println('Found ${repos.len} repositories')
	println('')

	if repos.len == 0 {
		println('No repositories found matching: ${targets}')
		return
	}

	// Determine parallel jobs (use 4 for license updates, less I/O intensive)
	parallel := if repos.len < 4 { repos.len } else { 4 }

	// Create parallel executor with V coroutines
	mut pool := executor.new_worker_pool(repos, parallel)

	// Execute license-update in parallel
	result := pool.execute_license_update(old, new, backup, dry_run)

	// Print results
	result.print()

	if result.has_failures() {
		return error('License update completed with failures')
	}
}

fn cmd_file_replace(cmd cli.Command) ! {
	pattern := cmd.flags.get_string('pattern')!
	replacement := cmd.flags.get_string('replacement')!
	targets := cmd.flags.get_string('targets')!
	dry_run := cmd.flags.get_bool('dry-run') or { false }
	backup := cmd.flags.get_bool('backup') or { true }

	println('File Replace Operation')
	println('  Pattern: ${pattern}')
	println('  Replacement: ${replacement}')
	println('  Targets: ${targets}')
	println('  Dry Run: ${dry_run}')
	println('  Backup: ${backup}')
	println('')

	// Check replacement file exists
	if !os.exists(replacement) {
		println('ERROR: Replacement file does not exist: ${replacement}')
		return error('Replacement file not found')
	}

	if dry_run {
		println('[DRY RUN] No changes will be made')
		println('')
	}

	// Resolve repositories from target specification
	println('Resolving target repositories...')
	repos := utils.resolve_targets(targets, default_repos_dir, 2)
	println('Found ${repos.len} repositories')
	println('')

	if repos.len == 0 {
		println('No repositories found matching: ${targets}')
		return
	}

	// Determine parallel jobs
	parallel := if repos.len < 4 { repos.len } else { 4 }

	// Create parallel executor with V coroutines
	mut pool := executor.new_worker_pool(repos, parallel)

	// Execute file-replace in parallel
	result := pool.execute_file_replace(pattern, replacement, backup, dry_run)

	// Print results
	result.print()

	if result.has_failures() {
		return error('File replace completed with failures')
	}
}

fn cmd_git_sync(cmd cli.Command) ! {
	parallel := cmd.flags.get_int('parallel') or { 4 }
	depth := cmd.flags.get_int('depth') or { 2 }
	message := cmd.flags.get_string('commit-message') or { 'chore: batch update' }
	dry_run := cmd.flags.get_bool('dry-run') or { false }

	println('Git Batch Sync Operation (ported from sync_repos.sh)')
	println('  Parallel Jobs: ${parallel}')
	println('  Max Depth: ${depth}')
	println('  Commit Message: ${message}')
	println('  Dry Run: ${dry_run}')
	println('')

	if dry_run {
		println('[DRY RUN] No changes will be made')
		println('')
	}

	// Find all repositories
	println('Scanning for repositories (find . -maxdepth ${depth} -name ".git")...')
	repos := utils.find_git_repos(default_repos_dir, depth)
	println('Found ${repos.len} repositories')
	println('')

	if repos.len == 0 {
		println('No repositories found in ${default_repos_dir}')
		return
	}

	// Create parallel executor with V coroutines
	mut pool := executor.new_worker_pool(repos, parallel)

	// Execute git-sync in parallel
	result := pool.execute_git_sync(message, dry_run)

	// Print results
	result.print()

	if result.has_failures() {
		println('NOTE: Some repositories failed. Check logs for details.')
		return error('Git sync completed with failures')
	}
}

fn cmd_watch(cmd cli.Command) ! {
	folder := cmd.flags.get_string('folder') or {
		os.join_path(os.home_dir(), '.config', 'repo-batcher', 'watch')
	}
	interval := cmd.flags.get_int('interval') or { 30 }

	println('Starting Watch Daemon')
	println('  Watch Folder: ${folder}')
	println('  Check Interval: ${interval}s')
	println('')

	// TODO: Implement watch daemon
	println('TODO: Implement watch folder monitoring')
}

fn cmd_rollback(cmd cli.Command) ! {
	last := cmd.flags.get_bool('last') or { false }
	log_id := cmd.flags.get_string('log-id') or { '' }

	if last {
		println('Rolling back last operation...')
		// TODO: Implement rollback
		println('TODO: Implement rollback from latest log')
	} else if log_id != '' {
		println('Rolling back operation: ${log_id}')
		// TODO: Implement rollback
		println('TODO: Implement rollback from specific log ID')
	} else {
		println('Error: Specify --last or --log-id')
		return error('Missing rollback target')
	}
}
