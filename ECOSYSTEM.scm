;; SPDX-License-Identifier: PMPL-1.0-or-later
;; ECOSYSTEM.scm - Project ecosystem position

(ecosystem
 (version "1.0")
 (name "repo-batcher")
 (type "tool")
 (purpose "Mass batch operations across git repositories with formal correctness guarantees")

 (position-in-ecosystem
  "repo-batcher is a repository management tool in the hyperpolymath ecosystem.
   It enables mass operations across multiple git repositories with type-safe,
   formally verified operations. Complements gitvisor (visualization) and
   rhodium-standard-repositories (standards enforcement).")

 (related-projects
  ((gitvisor "sibling-tool" "Repository visualization and analysis")
   (rhodium-standard-repositories "standards-source" "RSR compliance validation")
   (gitbot-fleet "potential-consumer" "Bot orchestration for automated operations")
   (robot-repo-automaton "potential-consumer" "Automated repository fixes")))

 (what-this-is
  "A formally verified batch operation tool for mass repository management.
   Uses ATS2 for type-safe core logic with dependent type proofs,
   V for fast CLI and parallel execution, and supports operations like:
   - License updates across all repos
   - File replacements with validation
   - Git batch operations (sync, commit, push)
   - Workflow updates and dependency management
   - Custom operation templates")

 (what-this-is-not
  "Not a replacement for git itself.
   Not for one-off manual repository operations.
   Not a repository hosting service.
   Not a CI/CD pipeline (use gitbot-fleet for that)."))
