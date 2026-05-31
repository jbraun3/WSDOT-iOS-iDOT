# WSDOT iDOT — Testing Protocol

## Scope

Covers only **Traffic Map**, **My Routes**, and **Ferries** features that are implemented and functional. Stubs, placeholders, and non-functional shells are excluded.

---

## 1. Traffic Map

### 1.1 Map Loads with Default Region

| Step | Action | Expected |
|------|--------|----------|
| 1 | Tap "Traffic Map" from home | Map centered on Seattle (~47.599, -122.335) |
| 2 | Observe loading indicators | Per-layer spinners shown, replaced by markers once each data source loads |

**Pass:** Map renders, all marker types appear after loading.  
**Fail:** Blank map, crash, infinite spinner on any data layer.

### 1.2 Marker Annotations — Tap Opens Detail Sheet

| Step | Action | Expected |
|------|--------|----------|
| 1 | Tap a camera icon on map | Sheet opens with `CameraDetailView` |
| 2 | Tap an alert icon | Sheet opens with `AlertDetailView` |
| 3 | Tap a mountain pass icon | Sheet opens with `MountainPassesDetail` |
| 4 | Tap a rest area icon | Sheet opens with `RestAreaDetailView` |
| 5 | Tap a travel time icon | Sheet opens with `TravelTimeListView` |

**Pass:** Each marker type opens its correct detail sheet with real data.  
**Fail:** Wrong sheet, no sheet, empty content, crash.

### 1.3 Camera Detail View

| Step | Action | Expected |
|------|--------|----------|
| 1 | Open `CameraDetailView` | Camera image loads (or "Camera offline" fallback if fetch fails) |
| 2 | Scroll | Info rows: Road name, Direction, Milepost, Refresh Rate |
| 3 | Observe map section | Map with marker at camera's coordinates |
| 4 | Check toolbar | Favorite star button in top-right |

**Pass:** Image loads gracefully, all info rows populated, map renders, star toggles favorite.  
**Fail:** Image never loads (no fallback), missing info, favorite crashes.

### 1.4 Alert Detail View

| Step | Action | Expected |
|------|--------|----------|
| 1 | Open `AlertDetailView` | Category badge with icon + type description |
| 2 | Scroll | Headline description, extended description (if present) |
| 3 | Scroll further | Info rows: Road, Direction, Region, Priority, County, Updated |
| 4 | Observe map section | Map with marker at alert's coordinates |

**Pass:** All fields populated from API data, map renders at alert location.  
**Fail:** Missing fields, raw HTML shown, map at wrong coordinates.

### 1.5 Rest Area Detail View

| Step | Action | Expected |
|------|--------|----------|
| 1 | Open `RestAreaDetailView` | Location badge, Route, Direction, Milepost, Open/Closed status, Dump station availability |
| 2 | Check amenities | List of amenities with checkmarks |
| 3 | Check notes | Notes section appears if `notes` is non-empty |
| 4 | Observe map section | Map with marker at rest area coordinates |

**Pass:** Data sourced from bundled `restareas.json`, all fields correct.  
**Fail:** Missing amenities, status wrong, map off.

### 1.6 Travel Time Detail View

| Step | Action | Expected |
|------|--------|----------|
| 1 | Open `TravelTimeDetailView` | Route info: Route name, Distance, From/To, Direction |
| 2 | Check travel times card | Current time, Average time, Status (X min slower / X min faster / On time) with color coding |
| 3 | Observe map section | Map with start + end markers |
| 4 | Check toolbar | Favorite star button |

**Pass:** Current vs average comparison works, color coding correct (orange for slower, green for faster/on-time).  
**Fail:** Times missing, wrong delta calc, no color.

### 1.7 Travel Time List View

| Step | Action | Expected |
|------|--------|----------|
| 1 | Tap travel time marker on map | `TravelTimeListView` opens with list of travel times for that corridor |
| 2 | Observe rows | Each row: description, current time in minutes, distance |
| 3 | Tap a row | Navigates to `TravelTimeDetailView` |

**Pass:** HOV routes filtered out, rows tappable, navigation works.  
**Fail:** HOV routes shown, empty list despite data, navigation broken.

### 1.8 Layer Toggles on Settings Tab

| Step | Action | Expected |
|------|--------|----------|
| 1 | Tap "Settings" tab in Traffic Map | Toggle switches: Traffic Layer, WSDOT Alerts, Mountain Passes, Rest Areas, Travel Times, Cluster Cameras |
| 2 | Toggle each OFF then ON | Corresponding markers hide/reappear on map |
| 3 | Kill and relaunch app | Toggle states persist via `@AppStorage` |

**Pass:** All 6 toggles control their markers. Persistence across launches.  
**Fail:** Toggle has no effect, wrong markers affected, state lost.

### 1.9 Map Style Picker

| Step | Action | Expected |
|------|--------|----------|
| 1 | Tap "Style" row in Settings | Confirmation dialog with System / Light / Dark / Cancel |
| 2 | Select "Dark" | Map switches to dark `.standard` style |
| 3 | Select "Light" | Map switches back |
| 4 | Kill and relaunch | Style persists |

**Pass:** Map style changes immediately and persists.  
**Fail:** No visual change, style resets.

### 1.10 Traffic Layer Toggle

| Step | Action | Expected |
|------|--------|----------|
| 1 | Toggle "Traffic Layer" ON | Map shows traffic flow overlays (colored road segments) |
| 2 | Toggle OFF | Traffic overlays disappear |

**Pass:** `showsTraffic` on `MapStyle` follows the toggle.  
**Fail:** No traffic data shown when on.

### 1.11 Legend Popup

| Step | Action | Expected |
|------|--------|----------|
| 1 | On Traffic Map, tap the ellipsis (···) button | `LegendPopup` appears with glass-effect background |
| 2 | Scroll | Traffic Flow gradient (Clear → Slow), Alert Severity icons (Low/Medium/High/Closure), Alert Types (Construction/Maintenance/Incident/Bridges/Ferries) |
| 3 | Tap outside the popup | Popup dismisses |

**Pass:** All 3 sections render with correct icons, dismiss works on outside tap.  
**Fail:** Missing sections, wrong icons, no dismiss.

### 1.12 My Location Button

| Step | Action | Expected |
|------|--------|----------|
| 1 | Tap location circle button (bottom of stack) | If location authorized: map centers on user location |
| 2 | If location denied | Alert dialog with explanation and link to Settings |
| 3 | After centering, pan the map | Button still functional, re-centers on tap |

**Pass:** Location permission handled gracefully in all states.  
**Fail:** No alert on denial, app crashes, button non-functional.

### 1.13 Camera Toggle Button

| Step | Action | Expected |
|------|--------|----------|
| 1 | On Traffic Map, tap camera circle button | Camera markers toggle on/off immediately |
| 2 | Observe icon change | SF Symbol switches between `camera.fill` (on) and `camera` (off) |

**Pass:** Quick toggle without entering Settings.  
**Fail:** No visual change, markers unaffected.

### 1.14 Map Position Persistence

| Step | Action | Expected |
|------|--------|----------|
| 1 | Pan/zoom the map to a new region | Position saved to `UserDefaults` after 300ms debounce |
| 2 | Navigate away (e.g., tap a marker sheet, go back) | Region stored |
| 3 | Kill and relaunch, open Traffic Map | Map restores to last saved position |

**Pass:** Last map region restored.  
**Fail:** Always resets to Seattle default.

### 1.15 Auto-Refresh of Alerts

| Step | Action | Expected |
|------|--------|----------|
| 1 | Leave Traffic Map open for ≥60 seconds | Alerts array refreshes via `Timer.publish(every: 60)` |
| 2 | Observe visual update | If new alerts appeared or old ones cleared, they update on map |

**Pass:** Alerts layer updates every 60 seconds without manual refresh.  
**Fail:** No refresh, stale alerts persist indefinitely.

### 1.16 Traffic Map Alerts Tab

| Step | Action | Expected |
|------|--------|----------|
| 1 | Tap "Alerts" tab in Traffic Map | List of all highway alerts loaded from API (or "No current alerts" / error state) |
| 2 | Tap an alert row | Navigates to `AlertDetailView` |

**Pass:** Alerts fetched, displayed as tappable rows, detail navigation works.  
**Fail:** Infinite loading, raw error visible, crash on tap.

### 1.17 Alert Row Display

| Step | Action | Expected |
|------|--------|----------|
| 1 | Observe an alert row | Shows: category icon (`conealerttype`/`car`/etc.), headline description, road name, time ago |

**Pass:** All fields populated from API.  
**Fail:** Missing fields, wrong time ago, layout misalignment.

---

## 2. My Routes

### 2.1 Tab View Navigation

| Step | Action | Expected |
|------|--------|----------|
| 1 | Tap "My Routes" from home | Tab view with "Map" and "Routes" tabs, toolbar shows `+` button on Map tab |
| 2 | Tap "Routes" tab | Switches to saved routes list (or "No saved routes" empty state) |

**Pass:** Both tabs render, toolbar button visible only on Map tab.  
**Fail:** Tabs missing, button visible on both tabs, empty state broken.

### 2.2 Route Finder — Search Locations

| Step | Action | Expected |
|------|--------|----------|
| 1 | On Map tab, tap `+` button | Route finder sheet slides up (`.fraction(0.35)` detent, expandable to `.large`) |
| 2 | Type in "Starting Location" | `SearchCompleter` shows suggestions |
| 3 | Select a suggestion | Field populates, location geocodes, `startResult` set |
| 4 | Type in "Ending Location" | Suggestions shown, select one → geocodes → `endResult` set |
| 5 | If both locations set | `fetchRouteOptions` called, route polylines rendered on map |

**Pass:** Search completions work, geocoding succeeds, route options appear on map.  
**Fail:** No suggestions, geocode fails silently, no routes.

### 2.3 Route Option Selection

| Step | Action | Expected |
|------|--------|----------|
| 1 | After both locations are set | Route options appear in horizontal scroll below fields, sorted by distance |
| 2 | Tap a non-default route | Map highlights that route (green stroke), chosen route updates |

**Pass:** Alternate routes shown (if API returns them), selection updates visual.  
**Fail:** Only one option, selection has no visual effect.

### 2.4 Save a Route

| Step | Action | Expected |
|------|--------|----------|
| 1 | With start, end, and route selected | "Save Route" button enabled (green) |
| 2 | Tap "Save Route" | Sheet dismisses, toast "Route saved" appears, route inserted into SwiftData with name format `"Start → End via RouteName"` |
| 3 | Tap "Routes" tab | New route appears in list |

**Pass:** Route persisted, toast confirmed, listed in Routes tab.  
**Fail:** Button never enables, no toast, route missing from list.

### 2.5 Route Detail — Overview

| Step | Action | Expected |
|------|--------|----------|
| 1 | Tap a saved route in Routes tab | `RouteDetailView` opens |
| 2 | Observe layout | Route name header, map with polyline (green), date picker, segmented control (Alerts / Travel Times / Cameras) |

**Pass:** Map renders polyline between start/end, all sections visible.  
**Fail:** Map blank, polyline missing, layout broken.

### 2.6 Route Detail — Alerts Tab

| Step | Action | Expected |
|------|--------|----------|
| 1 | Default tab is "Alerts" | Loading spinner shown while alerts + polyline coords are fetched |
| 2 | After loading | Alerts filtered to those within 100m of route polyline AND active on selected date |
| 3 | If matching alerts exist | Tappable alert cards displayed |
| 4 | If no matching alerts | Empty state: "No alerts on this route" with checkmark icon |

**Pass:** Alerts filtered by both proximity and date. Empty state when none match.  
**Fail:** All alerts shown regardless of route, date ignored, crash during load.

**⚠ Known limitation — K1:** The AlertCard in `RouteAlerts` is a minimal stub: it only shows the alert's `headlineDescription` text and a colored leading bar. It does NOT show alert type, priority, duration, or estimated clear time. Tap the card (navigates to `AlertDetailView`) for full details.

### 2.7 Route Detail — Date Picker Filters

| Step | Action | Expected |
|------|--------|----------|
| 1 | In Route Detail, change date picker to tomorrow | Alerts re-filter to those active on that date |
| 2 | Change to a date with no matching active alerts | Empty state shown |
| 3 | Change back to today | Original alerts reappear |

**Pass:** `isActive()` logic respects start/end times from alert data.  
**Fail:** Date change has no effect, incorrect filtering.

### 2.8 Route Detail — Travel Times Tab (excluded)

**Excluded:** `RouteTravelTimes` is a stub that displays `"RouteTravelTimes"` text only.

### 2.9 Route Detail — Cameras Tab (excluded)

**Excluded:** `RouteCameras` is a stub that displays `"Route Cameras"` text only.

### 2.10 Favorites Integration

| Step | Action | Expected |
|------|--------|----------|
| 1 | On Route Detail view | Favorite star in toolbar (`.wsdotFavorite` modifier) |
| 2 | Tap star (outline) | Star fills, toast "Added to favorites" appears |
| 3 | Go to home, swipe up | Route appears under "My Routes" category |
| 4 | Tap the favorite row | Navigates back to Route Detail for that route |

**Pass:** Add/remove favorite works, navigation from home to route detail works.  
**Fail:** Star missing, favorite not persisted, deep-link fails.

---

## 3. Ferries

### 3.1 Ferry Routes List Loads

| Step | Action | Expected |
|------|--------|----------|
| 1 | Tap "Ferries" from home | `FerriesList` shows loading spinner, then list of ferry routes from WSDOT Schedule API |
| 2 | Observe rows | Each row: ferry icon, `displayName` (e.g. "Seattle ↔ Bainbridge Island"), `crossingTimeDisplay` (e.g. "~35 min") |
| 3 | Pull or navigate back and re-enter | Routes re-fetched on each appear |

**Pass:** Routes fetched, display name formatted with ↔, crossing time formatted.  
**Fail:** Empty list, raw JSON visible, crossing time wrong format.

### 3.2 Ferry Route Detail View

| Step | Action | Expected |
|------|--------|----------|
| 1 | Tap a ferry route row | `FerryDetail` opens |
| 2 | Observe crossing time card | "Approximate Crossing Time" heading with formatted duration |
| 3 | If route has flags | "Route Info" card shows: Reservations available, International route, and/or Passenger-only badges |
| 4 | If `generalRouteNotes` non-empty | "Notes" card displays notes text |
| 5 | If `seasonalRouteNotes` non-empty | "Seasonal Notes" card displays notes text |
| 6 | Check toolbar | Favorite star button |

**Pass:** Crossing time formatted correctly (minutes → "~X hr Y min" for ≥60 min). All optional cards only appear when data present.  
**Fail:** Crossing time wrong or raw, empty cards shown for nil notes, missing data.

### 3.3 Ferry Favorites Integration

| Step | Action | Expected |
|------|--------|----------|
| 1 | On Ferry Detail, tap star | Favorite added with category `.ferryRoute`, `itemId` = route ID, `title` = display name |
| 2 | Go to home, swipe up | Ferry route appears under "Ferries" section |
| 3 | Tap the ferry favorite | Navigates to `FerryRouteFavoriteLoader` → loads all routes → finds match → opens `FerryDetail` |

**Pass:** Favorite added, shown on home, navigation restores correct detail.  
**Fail:** Favorite not added, wrong category, deep-link fails.

### 3.4 Ferry Map Tab (excluded)

**Excluded:** `FerriesMap` is a stub: `"FerriesMap - Coming Soon!"`.

### 3.5 Ferry Alerts Tab (excluded)

**Excluded:** `FerriesAlert` is a stub: `"FerriesAlert - Coming Soon!"`.

### 3.6 Ferry Reserve Tab (excluded)

**Excluded:** `FerriesReserve` is a stub: `"FerriesReserve - Coming Soon!"`.

---

## Known Bugs & Limitations

| ID | Feature | Issue | Workaround |
|----|---------|-------|------------|
| K1 | RouteAlerts AlertCard | Only shows `headlineDescription` text + colored bar. Does NOT show alert type, duration, or estimated clear time. | Tap the card → navigates to full `AlertDetailView` for complete info. |
| K2 | Route Detail Travel Times | `RouteTravelTimes` is a stub (`"RouteTravelTimes"` text). | No travel time data shown on route detail yet. |
| K3 | Route Detail Cameras | `RouteCameras` is a stub (`"Route Cameras"` text). | No camera data shown on route detail yet. |
| K4 | Ferries Map | "Coming Soon!" placeholder. | Use the Ferries list tab instead. |
| K5 | Ferries Alerts | "Coming Soon!" placeholder. | Use the Traffic Map Alerts tab for general highway alerts. |
| K6 | Ferries Reserve | "Coming Soon!" placeholder. | Book via the WSDOT website directly. |
| K7 | Traffic Map auto-refresh | Only alerts refresh on the 60-second timer. Cameras, passes, travel times, and rest areas are loaded once and never refreshed. | Navigate away and back to force full reload. |
| K8 | Map position persistence | Zoom calculation in `saveMapPosition()` is a heuristic (`0.5 / delta`). May not match perfectly across launches. | Manually re-pan/zoom if position is off. |
| K9 | Camera image loading | Images fetched with cache-busting URL parameter (`?` + minutes). Some cameras may return errors or be offline. | "Camera offline" fallback shown; no retry mechanism. |
| K10 | Color reference typos | Some color references use `.wsdoTprimarygreen` and `.wsdoTlimegreen` (missing 't'). Must match actual names in asset catalog. | Ensure asset catalog defines colors under `wsdoTprimarygreen` and `wsdoTlimegreen`. |
| K11 | Icons / Assets | Map marker icons (`icMapCamera`, `icMapAlertLow`, `icMapRestArea`, `icMountainPass`, `icTravelTime`, etc.) must exist in asset catalog. Missing assets render as blank squares. | Verify all named icons exist in `Assets.xcassets`. |
| K12 | Ferries API key | Ferries Schedule API uses `ApiKeys.wsdotKey` which requires a valid key in `Secrets.plist`. API may return 403 if key is expired/invalid. | Verify `API-Key` value in `Secrets.plist`. |
| K13 | Rest area data | Rest areas come from bundled `restareas.json`, not a live API. Data may be stale vs WSDOT's current rest area status. | No workaround — data is static until the JSON is updated. |

---

## Features Explicitly EXCLUDED

The following are **not implemented** and have no tests in this protocol:

- `FerriesMap` — stub ("Coming Soon!")
- `FerriesAlert` — stub ("Coming Soon!")
- `FerriesReserve` — stub ("Coming Soon!")
- `RouteCameras` — stub ("Route Cameras")
- `RouteTravelTimes` — stub ("RouteTravelTimes")
- Border wait detail from favorites ("not available yet")
- New navigation system (sidebar, bottom nav, carousel)
- Tutorial / onboarding
- Auto-refresh for non-alert data layers
- Alert duration/time-to-clear display in RouteAlerts cards
- Any feature outside Traffic Map, My Routes, and Ferries
