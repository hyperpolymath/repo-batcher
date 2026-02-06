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
     (phase "initialization")
     (overall-completion 5)
     (components
      ((core-ats2 0)
       (cli-v 0)
       (operations 0)
       (watch-system 0)))
     (working-features ()))

    (route-to-mvp
     (milestones
      ((milestone-id "m1")
       (name "Core Architecture")
       (completion 10)
       (items ("Project structure created"
               "Architecture documentation"
               "ATS2 operation types"
               "V CLI skeleton")))
      ((milestone-id "m2")
       (name "Basic Operations")
       (completion 0)
       (items ("License update operation (PMPL)"
               "File replacement operation"
               "Git batch sync (from sync_repos.sh)"
               "Operation validation proofs")))
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
      ("Need to verify ATS2 installation"
       "Need to verify V installation"
       "Determine ATS2-V FFI strategy"))
     (low ()))

    (critical-next-actions
     (immediate
      ("Complete architecture documentation"
       "Create ATS2 operation type definitions"
       "Create V CLI entry point"
       "Implement basic license update operation"))
     (this-week
      ("Port sync_repos.sh functionality"
       "Implement watch folder system"
       "Create operation templates"))
     (this-month
      ("Implement all basic operations"
       "Add parallel execution"
       "Create comprehensive tests")))))
