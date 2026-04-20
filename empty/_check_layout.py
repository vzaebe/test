"""Render the HTML and screenshot each `.scr` block to find layout issues."""
import asyncio, pathlib, sys
from playwright.async_api import async_playwright

HTML = pathlib.Path(__file__).parent / "asskd_unified_v4.html"
OUT = pathlib.Path(__file__).parent / "_shots"
OUT.mkdir(exist_ok=True)

async def main():
    async with async_playwright() as p:
        browser = await p.chromium.launch()
        context = await browser.new_context(viewport={"width": 1600, "height": 900}, device_scale_factor=1)
        page = await context.new_page()
        await page.goto("file:///" + str(HTML).replace("\\", "/"))
        await page.wait_for_load_state("networkidle")

        # Find all sections (article.scr)
        scrs = await page.query_selector_all("article.scr")
        print(f"Found {len(scrs)} screens")
        report = []
        for i, scr in enumerate(scrs):
            sid = await scr.get_attribute("id") or f"scr-{i}"
            box = await scr.bounding_box()
            if not box:
                continue
            # Collect descendants and check overlaps among siblings
            # Try to find children inside .scr-b that visually overlap the scr-h header or each other in unexpected ways
            await scr.scroll_into_view_if_needed()
            try:
                await scr.screenshot(path=str(OUT / f"{i:03d}_{sid}.png"))
            except Exception as e:
                print(f"failed {sid}: {e}")
            report.append((i, sid, box))
        print("\n".join(f"{i:03d} {sid} h={int(box['height'])}" for i, sid, box in report))
        await browser.close()

asyncio.run(main())
