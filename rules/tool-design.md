## tool design (CLI and MCP)

rules for designing tool names, descriptions, and schemas for agent consumption.

### descriptions

- write a plain description for every tool, subcommand, or operation before making other edits. never leave operations documented only by their route path, function name, or signature.
- state what the tool returns, not only what it accepts.
- when two or more sibling tools share a domain, name prefix, or overlapping purpose, add a one-sentence boundary clause to each sibling stating where it ends and naming the sibling to use for the other case.
  - example: `"Returns active user records by email. For deleted or archived accounts, use list_archived_users."`
- do not rely on careful rewording without a boundary clause; generic polish alone does not reliably separate sibling tools.

### names and schemas

- avoid relying on renaming alone to fix sibling confusion. routing decisions occur as the shared leading prefix is generated, so pair clear names with explicit boundary clauses.
- treat parameter schema changes as routing changes. diverging schemas between siblings can undo gains from description edits.
- check omitted-argument behavior: if a user request omits a required argument, verify whether the schema makes calling a sibling tool (such as a lookup/list tool) the intended first step and document that explicitly.

### verification on the target model

- test sibling tool pairs with labeled, paraphrased requests on the exact model that will be deployed.
- do not assume a larger model will confuse a pair less, and do not rely on surface similarity between specs to predict which pairs fail.
- do not treat high model confidence as evidence of a correct tool call; post-trained models are often near-certain on wrong sibling calls.
- re-run the sibling routing check after every name, description, or schema edit.

### harness and registry checks

when building an MCP server, CLI surface, or tool registry:
- flag tool pairs that share leading name prefixes/subwords and have close descriptions.
- require a plain description and, for flagged pairs, a boundary clause before deployment.
- gate tool-set changes on a small labeled confusion check per sibling pair.
