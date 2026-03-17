/**
 * mcp tool template typescript
 *
 * copy this file and implement the tool logic.
 * rename the tool name, description, and input schema.
 *
 * requires: @modelcontextprotocol/sdk
 * install: npm install @modelcontextprotocol/sdk zod
 */

import { Server } from "@modelcontextprotocol/sdk/server/index.js";
import { StdioServerTransport } from "@modelcontextprotocol/sdk/server/stdio.js";
import {
  CallToolRequestSchema,
  ListToolsRequestSchema,
} from "@modelcontextprotocol/sdk/types.js";
import { z } from "zod";

// input schema

const ToolInputSchema = z.object({
  query: z.string().describe("the search query"),
  maxResults: z.number().int().min(1).max(20).default(5),
});

type ToolInput = z.infer<typeof ToolInputSchema>;

// tool implementation

async function runTool(params: ToolInput): Promise<string> {
  // implement tool logic here. return a string result.
  throw new Error("not implemented");
}

// server setup
const server = new Server(
  { name: "tool-name", version: "0.1.0" },
  { capabilities: { tools: {} } }
);

server.setRequestHandler(ListToolsRequestSchema, async () => ({
  tools: [
    {
      name: "tool_name",
      description:
        "one sentence describing what this tool does and when to use it.",
      inputSchema: {
        type: "object",
        properties: {
          query: { type: "string", description: "the search query" },
          maxResults: { type: "number", default: 5 },
        },
        required: ["query"],
      },
    },
  ],
}));

server.setRequestHandler(CallToolRequestSchema, async (request) => {
  if (request.params.name !== "tool_name") {
    throw new Error(`unknown tool: ${request.params.name}`);
  }

  const params = ToolInputSchema.parse(request.params.arguments);
  const result = await runTool(params);

  return {
    content: [{ type: "text", text: result }],
  };
});

// entry point

async function main(): Promise<void> {
  const transport = new StdioServerTransport();
  await server.connect(transport);
}

main().catch((err) => {
  console.error(err);
  process.exit(1);
});