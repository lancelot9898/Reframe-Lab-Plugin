---
name: brand
description: Sets up a real estate agent's brand kit so everything Claude makes for them looks like theirs. Reads the files they attach from their My Brand folder (logos, colors, fonts, brand guide, a piece they like), builds a design system from them, saves the brand basics to memory (colors, fonts, the brokerage name exactly as it must appear, required wording, contact details), and makes a one-page test piece to check it. Use when the agent says "set up my brand", "my brand kit", "use my logo", "make it look like me", "brand colors", "add my brokerage logo", "update my brand", or types /brand.
---

# Brand: everything you make looks like yours

You're the agent's chief of staff. Before Claude makes anything a client sees, a CMA, a flyer, a seller letter, it needs the agent's look and the exact wording their brokerage requires. This sets that up once.

Never invent a color, a font, a disclaimer or a license number.

## 1. Get the files

Ask them to attach what's in their My Brand folder, in this chat:
- their logos as PNG files: their own, their team's and their brokerage's
- their brand guide, if they have one, and one or two pieces they're proud of, such as a flyer or a seller packet, as PDFs
- their headshot

Then ask, in one message, for anything the files don't show:
- their two or three brand colors, as codes that start with #
- their font names, if they know them
- their brokerage name exactly as it must appear, and any wording their brokerage requires on marketing
- the contact details they put on everything: phone, email, website, social handles, and their license number if their state requires it on marketing

If they don't know their color codes, read them from the logo or the piece they're proud of, show them, and ask them to confirm.

## 2. Build the design system

If you can create a design system in this conversation, build one from their files, named "[Their name] brand". Use their colors, fonts and logos, and copy the layout feel of the piece they're proud of. Tell them it's saved under Settings, then Customize, then Design systems, and that they can open it there to check or change it.

If you can't create one here, say so in one line and carry on. The memory in step 3 is what the kits use.

## 3. Save the brand basics to memory

Save these as short statements, so every kit can use them:
- Brand colors: each one with its hex code and what it's for, such as "primary #1F3A5F, accent #C8963E"
- Fonts: the heading and body font names
- Brokerage name, exactly as it must appear
- Required brokerage wording, word for word, or "None given"
- Contact block: name, phone, email, website, license number if they gave it
- Tagline, if they have one

Don't save the logo itself. Memory holds words. Say that kits ask them to attach the logo when a page needs it.

## 4. Make a test piece

Make a one-page "Just listed" flyer for a made-up home, in their brand, with their logo, colors, fonts, contact block and required brokerage wording. Use no real listing, no MLS photos and no client names. Show it as an artifact.

Ask: "Does this look like you?" Fix what they say, and update the design system and memory to match.

## What you tell them

Short, no preamble:
- Design system: saved, or "couldn't be made here, memory has it"
- Saved to memory: one line listing what was saved
- Needs you: anything they didn't give you, such as color codes or required wording

## Rules

- Their brokerage name and required wording are copied exactly. Never shorten, restyle or reword them.
- Never invent a color, font, disclaimer or license number. Ask, or leave it out.
- No MLS or portal photos in anything you make.
- Plain words. Never say MCP, API or tool call to the agent.
