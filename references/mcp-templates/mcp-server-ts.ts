/**
 * MCP server template using McpServer + Zod.
 *
 * install: pnpm add @modelcontextprotocol/sdk zod
 */

import { McpServer } from "@modelcontextprotocol/sdk/server/mcp.js";
import { StdioServerTransport } from "@modelcontextprotocol/sdk/server/stdio.js";
import { z } from "zod";

const server = new McpServer({
  name: "tool-name",
  version: "0.1.0",
});

server.registerTool(
  "search_items",
  {
    description: "Search items matching query and return formatted results.",
    inputSchema: {
      query: z.string().min(1).describe("Non-empty search query"),
      maxResults: z.number().int().min(1).max(20).default(5),
    },
  },
  async ({ query, maxResults }) => {
    const result = await runSearch(query, maxResults);
    return {
      content: [{ type: "text", text: result }],
    };
  },
);

async function runSearch(query: string, maxResults: number): Promise<string> {
  throw new Error(`not implemented: query=${query}, maxResults=${maxResults}`);
}

async function main(): Promise<void> {
  const transport = new StdioServerTransport();
  await server.connect(transport);
}

main().catch((err: unknown) => {
  console.error(err);
  process.exit(1);
});
