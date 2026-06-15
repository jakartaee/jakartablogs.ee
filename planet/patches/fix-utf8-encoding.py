"""Patch Venus spider.py to fix UTF-8 encoding detection.

When the HTTP Content-Type header does not include a charset parameter,
the bundled feedparser (< 6.0) falls back to Windows-1252 / ISO-8859-1
instead of honoring the in-document XML encoding declaration. This causes
UTF-8 multi-byte characters (curly quotes, en-dashes, etc.) to be rendered
as mojibake.

This patch injects 'charset=utf-8' into the Content-Type header when no
charset is specified, which is the correct default for application/xml per
RFC 7303 section 9.1.

See: https://github.com/jakartaee/jakartablogs.ee/issues/121
"""

import sys

SPIDER_PY = '/usr/lib/python2.7/dist-packages/planet/spider.py'

with open(SPIDER_PY, 'r') as f:
    content = f.read()

# Target the line in httpThread where headers are attached to the feed object
PATCH_MARKER = "# Fix: default to charset=utf-8 for XML feeds when Content-Type"

if PATCH_MARKER in content:
    print("Patch already applied to " + SPIDER_PY + ", skipping.")
    sys.exit(0)

old_code = "            setattr(feed, 'headers', resp)"
new_code = (
    "            " + PATCH_MARKER + "\n"
    "            # does not specify a charset (RFC 7303 s9.1, issue #121).\n"
    "            ctype = resp.get('content-type', '').lower()\n"
    "            if 'xml' in ctype and 'charset=' not in ctype:\n"
    "                resp['content-type'] = resp.get('content-type', '') + '; charset=utf-8'\n"
    "            setattr(feed, 'headers', resp)"
)

if old_code not in content:
    print("ERROR: Could not find target line in " + SPIDER_PY)
    print("spider.py may have changed upstream. The patch needs to be updated.")
    sys.exit(1)

content = content.replace(old_code, new_code, 1)

with open(SPIDER_PY, 'w') as f:
    f.write(content)

print("Successfully patched " + SPIDER_PY + " for UTF-8 encoding fix.")
