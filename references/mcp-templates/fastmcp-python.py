"""FastMCP server template.

requires: uv add mcp
run: uv run python fastmcp-python.py
"""

from __future__ import annotations

import logging

from mcp.server.fastmcp import FastMCP

logger = logging.getLogger(__name__)
mcp = FastMCP("tool-name")

@mcp.tool()
async def search_items(query: str, max_results: int = 5) -> str:
    """Search items matching query and return formatted results."""
    if not query.strip():
        raise ValueError("query must be non-empty")
    if not 1 <= max_results <= 20:
        raise ValueError(f"max_results must be between 1 and 20, got {max_results}")

    logger.info("search_items called: query=%s max_results=%d", query, max_results)
    raise NotImplementedError("implement tool logic here")

def main() -> None:
    mcp.run(transport="stdio")

if __name__ == "__main__":
    main()
