local orgs = import 'vendor/otterdog-defaults/otterdog-defaults.libsonnet';

orgs.newOrg('eclipse-langium') {
  settings+: {
    description: "",
    name: "Eclipse Langium",
    web_commit_signoff_required: false,
    workflows+: {
      actions_can_approve_pull_request_reviews: false,
    },
  },
  _repositories+:: [
    orgs.newRepo('langium') {
      allow_update_branch: false,
      delete_branch_on_merge: false,
      description: "Next-gen language engineering / DSL framework",
      gh_pages_build_type: "workflow",
      has_discussions: true,
      has_projects: false,
      has_wiki: false,
      homepage: "https://langium.org/",
      squash_merge_commit_title: "PR_TITLE",
      topics+: [
        "domain-specific-language",
        "dsl",
        "language-engineering",
        "language-server-protocol",
        "typescript",
        "vscode"
      ],
      web_commit_signoff_required: false,
      webhooks: [
        orgs.newRepoWebhook('https://services.gitpod.io/apps/ghe/') {
          content_type: "json",
          events+: [
            "push"
          ],
          secret: "********",
        },
      ],
      secrets: [
        orgs.newRepoSecret('NPM_TOKEN') {
          value: "********",
        },
        orgs.newRepoSecret('OVSX_TOKEN') {
          value: "********",
        },
        orgs.newRepoSecret('VSCE_TOKEN') {
          value: "********",
        },
      ],
      branch_protection_rules: [
        orgs.newBranchProtectionRule('main') {
          required_approving_review_count: 1,
        },
      ],
      environments: [
        orgs.newEnvironment('github-pages') {
          branch_policies+: [
            "main"
          ],
          deployment_branch_policy: "selected",
        },
      ],
    },
    orgs.newRepo('langium-previews') {
      default_branch: "previews",
      description: "Hosting PR previews for langium-website",
      gh_pages_build_type: "legacy",
      gh_pages_source_branch: "previews",
      gh_pages_source_path: "/",
      has_issues: false,
      has_projects: false,
      has_wiki: false,
      web_commit_signoff_required: false,
      environments: [
        orgs.newEnvironment('github-pages') {
          branch_policies+: [
            "previews"
          ],
          deployment_branch_policy: "selected",
        },
      ],
    },
    orgs.newRepo('langium-website') {
      allow_update_branch: false,
      delete_branch_on_merge: false,
      dependabot_alerts_enabled: false,
      description: "Source of langium.org",
      gh_pages_build_type: "workflow",
      has_projects: false,
      has_wiki: false,
      homepage: "https://langium.org/",
      topics+: [
        "documentation",
        "language-engineering",
        "language-server-protocol",
        "website"
      ],
      web_commit_signoff_required: false,
      secrets: [
        orgs.newRepoSecret('DEPLOY_PREVIEW_TOKEN') {
          value: "pass:bots/ecd.langium/github.com/preview-token",
        },
      ],
      branch_protection_rules: [
        orgs.newBranchProtectionRule('main') {
          required_approving_review_count: 1,
          requires_status_checks: false,
          requires_strict_status_checks: true,
        },
      ],
      environments: [
        orgs.newEnvironment('github-pages') {
          branch_policies+: [
            "main"
          ],
          deployment_branch_policy: "selected",
        },
        orgs.newEnvironment('pull-request-preview'),
      ],
    },
  ],
} + {
  # snippet added due to 'https://github.com/EclipseFdn/otterdog-configs/blob/main/blueprints/add-dot-github-repo.yml'
  _repositories+:: [
    orgs.newRepo('.github')
  ],
}