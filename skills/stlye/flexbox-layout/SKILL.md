---
name: flexbox-layout
description: >-
  Build CSS layouts with Flexbox in a readable, intention-revealing style.
  Use this whenever the user asks to lay out, position, or align UI — "横並びにして",
  "中央寄せ", "ナビバー作って", "サイドバーとメインを並べて", "カードを均等に並べたい",
  "this row should space out", "stack these vertically", "center this", "build a header" —
  even if they never say the word "flexbox". Covers plain CSS/SCSS, Tailwind utility
  classes, and CSS-in-JS (styled-components / emotion / React inline styles). Trigger
  on any layout/alignment/spacing work; don't wait for the user to name Flexbox explicitly.
---

# Flexbox Layout

The goal is layouts a human can read and trust: the CSS should say *what the author meant*, not just what happens to render correctly. Flexbox is the right default for almost all UI layout — rows, columns, navbars, toolbars, card lists, centering. Build with it directly instead of reaching for Grid.

## Core principles

These exist because layout bugs almost always come from *implicit* behavior — a default value someone forgot was there, a magic pixel no one can explain, a margin fighting another margin. Making intent explicit is what keeps a layout readable months later.

### 1. Reach for the `flex` shorthand by default; expand only to clarify intent

`flex: 1` is the idiom every CSS developer reads instantly — "this item takes the remaining space." Writing it out as three properties every time is noise that buries the one case that actually deserves attention. So default to the shorthand, and stay consistent about it: a file that mixes `flex: 1` here and three-property blocks there for no reason is harder to scan than one that always uses the concise form.

```css
/* the common case — say it the short way */
.item { flex: 1; }
```

The shorthand also fills in sensible defaults you'd otherwise have to remember: `flex: 1` means `1 1 0%`, `flex: auto` means `1 1 auto`, `flex: none` means `0 0 auto`. Use the named forms when they fit:

```css
.fills-space { flex: 1; }      /* grow from zero, share space equally */
.sizes-to-content { flex: auto; } /* grow, but start from natural size */
.fixed { flex: none; }         /* never grow or shrink */
```

Expand to `flex-grow` / `flex-shrink` / `flex-basis` only when the value is *unusual enough that the shorthand would mislead* — e.g. an item that grows but must not shrink, or a non-zero basis. There the explicit form earns its space by flagging "this is deliberately not the normal case":

```css
/* grows to fill, but is pinned to a minimum and never shrinks below it */
.panel {
  flex-grow: 1;
  flex-shrink: 0;
  flex-basis: var(--panel-min-width);
}
```

### 2. Spacing lives in `gap`, never scattered margins

Space *between* items is a property of the container, not of each child. `gap` says that directly, and it never produces the leading/trailing-margin asymmetry that `margin-right: …` on every child does. Don't reach for `margin` to push siblings apart — set `gap` on the flex container.

```css
.toolbar {
  display: flex;
  gap: var(--space-3);
}
```

Margins are still fine for a one-off nudge that isn't about sibling spacing (e.g. `margin-inline-start: auto` to push one item to the far edge — a legitimate and readable Flexbox idiom).

### 3. No magic numbers — define variables on `:root`

A bare `gap: 16px` or `flex-basis: 237px` tells the reader nothing about *why* 16 or 237. Promote spacing and sizing to named custom properties on `:root` so the values are centralized, consistent, and self-documenting. Reuse the scale rather than inventing a new pixel value each time.

```css
:root {
  --space-2: 0.5rem;
  --space-3: 1rem;
  --space-4: 1.5rem;
  --sidebar-width: 16rem;
}
```

If the project already defines a spacing scale or design tokens, use those instead of adding a parallel set — match what's there.

### 4. Make alignment legible

Centering and distribution should be stated, not stumbled into. Write `justify-content` (main axis) and `align-items` (cross axis) explicitly when they carry meaning, so a reader knows the alignment was a decision. Name the direction too when it isn't an obvious row.

```css
.hero {
  display: flex;
  flex-direction: column;
  justify-content: center;  /* main axis: vertical here */
  align-items: center;      /* cross axis: horizontal here */
}
```

### 5. Stay in Flexbox

Grid is rarely the right tool for app UI — it shines only for genuine two-dimensional layouts (e.g. a dense data table or a poster-like page where rows *and* columns must align simultaneously). Those are uncommon. For the everyday work — rows, columns, nesting flex containers inside flex containers — Flexbox composes cleanly and stays readable. Don't switch to Grid to dodge a Flexbox problem; nest another flex container instead.

### 6. No comments explaining the layout

Well-written Flexbox reads on its own — explicit flex properties, named variables, and stated alignment already say what's happening. Don't add comments narrating what the CSS does. (Brief axis hints like the ones above are illustrative for *this guide*; production output should stay clean.)

## Output by syntax

The principles are identical across syntaxes — only the surface changes. Match whatever the project already uses; if it's a fresh request with no context, default to plain CSS with `:root` variables.

### Plain CSS / SCSS
As shown above. Define variables on `:root` (or a SCSS map / `$variables` if the codebase uses SCSS conventions), use `display: flex`, explicit `flex-grow/shrink/basis`, and `gap`.

### Tailwind CSS
Tailwind's `flex-1` / `flex-auto` / `flex-none` are exactly the concise shorthands you want here — they map to the CSS shorthands above and are the idiomatic Tailwind way to say "fill" / "size to content" / "fixed". Use them by default; reach for the granular `grow` / `shrink` / `basis-*` utilities only for the unusual mixes that the shorthand can't express (e.g. `grow shrink-0 basis-64`).

Spacing and magic numbers are where Tailwind layouts actually go wrong, so that's where to stay disciplined: use `gap-*` for spacing between siblings (never `space-x`/`mr-*`), and use theme spacing/sizing tokens rather than arbitrary bracket values like `gap-[16px]` or `basis-[calc(50%-0.5rem)]`.

```html
<!-- the common case — flex-1 reads cleanly, gap-4 from the theme scale -->
<div class="flex items-center gap-4">
  <nav class="flex-1">…</nav>
  <aside class="flex-none">…</aside>
</div>
```

Map: `flex:1`→`flex-1`, `flex:auto`→`flex-auto`, `flex:none`→`flex-none`. For sizing, prefer theme tokens (`basis-64`, `w-64`) over arbitrary values; extend `tailwind.config` if a needed token is missing rather than hardcoding `basis-[237px]`. For an equal-width wrapping row, `flex-1` on each child plus `flex-wrap` and a `min-w-*` token beats hand-computed `basis-[calc(...)]` percentages.

### CSS-in-JS (styled-components / emotion / inline styles)
Same rules; values come from a theme object instead of `:root`. Pull spacing/sizing from the theme (`${({theme}) => theme.space[3]}` or `theme.space(3)`) rather than literal pixels. Use the `flex` shorthand by default here too — `flex: 1` in a template literal, or `flex: 1` as an inline-style string — and expand to `flexGrow`/`flexShrink`/`flexBasis` only for the unusual mixes.

```jsx
const Toolbar = styled.div`
  display: flex;
  align-items: center;
  gap: ${({ theme }) => theme.space[3]};
`;

const Main = styled.main`
  flex: 1;
`;

// React inline style — shorthand reads fine as a string
<div style={{ display: 'flex', flex: 1 }} />
```

If no theme exists, introduce a small tokens object (or `:root` variables consumed via `var()`) rather than scattering literals.

## Quick reference

| Need | Flexbox approach |
|---|---|
| Items in a row | `display: flex` (row is the default direction) |
| Items in a column | `display: flex; flex-direction: column` |
| Space between items | `gap: var(--space-N)` — never per-child margin |
| One item fills remaining space | `flex: 1` (Tailwind `flex-1`) |
| Item keeps natural size, can grow | `flex: auto` (Tailwind `flex-auto`) |
| Item fixed, never grows/shrinks | `flex: none` (Tailwind `flex-none`) |
| Grows but must not shrink (unusual) | spell it out: `flex-grow:1; flex-shrink:0; flex-basis:<token>` |
| Center on both axes | `justify-content: center; align-items: center` |
| Push one item to the far end | `margin-inline-start: auto` on that item |
| Wrap onto multiple lines | `flex-wrap: wrap` + `gap` for row *and* column spacing |
| Equal-width columns | each child `flex: 1` |
