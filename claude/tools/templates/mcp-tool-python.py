"""
mcp tool template python

copy this file and implement the tool logic.
rename the class, tool name, description, and input schema.

requires: mcp (pip install mcp)
"""

from mcp.server import Server
from mcp.server.stdio import stdio_server
from mcp.types import Tool, TextContent
from pydantic import BaseModel
import asyncio
import logging

logger = logging.getLogger(__name__)

# input schema

class ToolInput(BaseModel):
    query: str
    max_results: int = 5

# tool implementation

async def run_tool(params: ToolInput) -> str:
    """implement the tool logic here. return a string result."""
    raise NotImplementedError

# server setup

server = Server("tool-name")

@server.list_tools()
async def list_tools() -> list[Tool]:
    return [
        Tool(
            name="tool_name",
            description="one sentence describing what this tool does and when to use it.",
            inputSchema=ToolInput.model_json_schema(),
        )
    ]

@server.call_tool()
async def call_tool(name: str, arguments: dict) -> list[TextContent]:
    if name != "tool_name":
        raise ValueError(f"unknown tool: {name}")

    params = ToolInput(**arguments)
    result = await run_tool(params)
    return [TextContent(type="text", text=result)]

# entry point

async def main() -> None:
    async with stdio_server() as (read, write):
        await server.run(read, write, server.create_initialization_options())

if __name__ == "__main__":
    asyncio.run(main())