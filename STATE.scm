;; SPDX-License-Identifier: PMPL-1.0-or-later
;; STATE.scm - Current project state

(define state
  '((metadata
     (version "0.1.0")
     (schema-version "1.0")
     (created "2026-02-06")
     (updated "2026-02-06")
     (project "repo-batcher")
     (repo "hyperpolymath/repo-batcher"))

    (project-context
     (name "repo-batcher")
     (tagline "Mass batch operations across git repositories with formal correctness guarantees")
     (tech-stack (ats2 v-lang idris2 zig)))

    (current-position
     (phase "alpha")
     (overall-completion 40)
     (components
      ((core-ats2 60)
       (cli-v 80)
       (operations 60)
       (watch-system 0)
       (ffi-bridge 70)))
     (working-features
      ("license-update operation with ATS2 proofs"
       "git-sync operation (ported from sync_repos.sh)"
       "file-replace operation skeleton"
       "V CLI with full command structure"
       "ATS2-V FFI bridge via C"
       "SPDX validation")))

    (route-to-mvp
     (milestones
      ((milestone-id "m1")
       (name "Core Architecture")
       (completion 100)
       (items ("Project structure created"
               "Architecture documentation"
               "ATS2 operation types"
               "V CLI skeleton")))
      ((milestone-id "m2")
       (name "Basic Operations")
       (completion 60)
       (items ("License update operation (PMPL) - DONE"
               "File replacement operation - 50%"
               "Git batch sync (from sync_repos.sh) - DONE"
               "Operation validation proofs - DONE")))
      ((milestone-id "m3")
       (name "Watch System")
       (completion 0)
       (items ("Watch folder monitoring"
               "Operation file parser"
               "Target list handling"
               "Parallel execution engine")))
      ((milestone-id "m4")
       (name "Advanced Operations")
       (completion 0)
       (items ("Workflow file updates"
               "Dependency updates"
               "Code pattern replacements"
               "Custom operation templates")))))

    (blockers-and-issues
     (critical ())
     (high ())
     (medium
      ("String manipulation helpers needed in ATS2"
       "File I/O operations need completion"
       "Directory traversal for finding source files"
       "Parallel execution (V coroutines) not yet implemented"))
     (low
      ("More SPDX license texts needed"
       "Better error messages"
       "Progress bars for long operations")))

    (critical-next-actions
     (immediate
      ("Complete string manipulation helpers in ATS2"
       "Implement directory traversal for source file discovery"
       "Test license update on real repositories"
       "Test git-sync on real repositories"))
     (this-week
      ("Implement V coroutines for parallel execution"
       "Complete file-replace operation"
       "Add comprehensive error handling"
       "Create integration tests"))
     (this-month
      ("Implement watch folder system"
       "Add workflow-update operation"
       "Create rollback system"
       "Performance optimization")))))
