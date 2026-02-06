;; SPDX-License-Identifier: PMPL-1.0-or-later
;; META.scm - Meta-level project information

(define meta
  '((architecture-decisions
     ((adr-001
       (status "accepted")
       (date "2026-02-06")
       (context "Language selection for formally verified batch operations")
       (decision "Use ATS2 for core logic with dependent type proofs, V for CLI/execution")
       (consequences
        "ATS2 provides theorem-proving capabilities for operation correctness.
         V provides fast compilation and simple FFI for CLI and parallel execution.
         Idris2 used for ABI definitions (per RSR standard).
         Zig used for any C FFI needs."))
      (adr-002
       (status "accepted")
       (date "2026-02-06")
       (context "Operation model: watch folder vs CLI arguments")
       (decision "Support both watch folder (batch mode) and CLI arguments (interactive)")
       (consequences
        "Watch folder enables fire-and-forget batch operations.
         CLI arguments support interactive and scripted use.
         Both modes use same underlying operation engine."))
      (adr-003
       (status "accepted")
       (date "2026-02-06")
       (context "Operation safety guarantees")
       (decision "All file operations must be validated before execution with ATS2 proofs")
       (consequences
        "Prevents destructive operations through type-level guarantees.
         Dry-run mode required for all operations.
         Rollback mechanisms for failed batch operations."))))

    (development-practices
     (code-style "ATS2: follow ATS style guide. V: follow V conventions.")
     (security "SPDX headers, OpenSSF Scorecard compliance, formal verification")
     (testing "Property-based tests for ATS2 proofs, integration tests for V CLI")
     (versioning "Semantic versioning")
     (documentation "README.adoc, inline comments, architecture docs")
     (branching "main branch, feature branches, PRs required"))

    (design-rationale
     ((formal-verification
       "ATS2 dependent types prove operation correctness at compile-time.
        Prevents entire classes of errors: file overwrites without backup,
        invalid license replacements, git operations on non-repos.")
      (parallel-execution
       "V's coroutines enable efficient parallel repository processing.
        Matches GNU parallel approach from sync_repos.sh but with type safety.")
      (watch-folder-pattern
       "Drop operation files into watch/ folder for batch processing.
        Enables scheduled batch operations via cron/systemd timers.
        Separates operation definition from execution.")))))
