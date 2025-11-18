<?php
session_start();
if(!isset($_SESSION['member_loggedin'])){
    header("Location: user_login.php");
    exit;
}
require 'db.php';

$id = $_SESSION['member_id'];
// Fetch logged-in user's MLM ID
$stmtMy = $mysqli->prepare("SELECT mlm_id FROM members WHERE id = ?");
$stmtMy->bind_param("i", $id);
$stmtMy->execute();
$myData = $stmtMy->get_result()->fetch_assoc();
$myMLM = $myData['mlm_id'] ?? '';

function h($s){ return htmlspecialchars($s, ENT_QUOTES|ENT_SUBSTITUTE, 'UTF-8'); }

// ---------- AJAX endpoint: return children as JSON ----------
if (isset($_GET['action']) && $_GET['action'] === 'fetch_children_json' && isset($_GET['parent_id'])) {
    $parent = trim($_GET['parent_id']);

    $stmt = $mysqli->prepare("SELECT mlm_id, full_name, phone, status FROM members WHERE ref_id = ? ORDER BY mlm_id ASC");
    $stmt->bind_param("s", $parent);
    $stmt->execute();
    $res = $stmt->get_result();

    $out = [];
    while ($r = $res->fetch_assoc()) {
        // get children count
        $chk = $mysqli->prepare("SELECT COUNT(*) AS c FROM members WHERE ref_id = ?");
        $chk->bind_param("s", $r['mlm_id']);
        $chk->execute();
        $chk_res = $chk->get_result();
        $count = 0;
        if ($chk_row = $chk_res->fetch_assoc()) $count = intval($chk_row['c']);

        $out[] = [
            'mlm_id' => $r['mlm_id'],
            'full_name' => $r['full_name'],
            'phone' => $r['phone'],
            'status' => $r['status'],
            'children_count' => $count
        ];
    }

    header('Content-Type: application/json; charset=utf-8');
    echo json_encode(['children' => $out]);
    exit;
}
// ------------------------------------------------------------

// ---------- Normal page rendering ----------
$member = null;
if (isset($_GET['mlm_id'])) {
    $mlm = trim($_GET['mlm_id']);
    $q = $mysqli->prepare("SELECT mlm_id, full_name, phone, status FROM members WHERE mlm_id = ?");
    $q->bind_param("s", $mlm);
    $q->execute();
    $member = $q->get_result()->fetch_assoc();
}

// ----------------- INFINITE DOWNLINE COUNTER -----------------
function getAllDescendants($mysqli, $rootIds, &$collector = []) {

    if (empty($rootIds)) return;

    // Create placeholders (?, ?, ?, ...)
    $placeholders = implode(',', array_fill(0, count($rootIds), '?'));
    $types = str_repeat('s', count($rootIds));

    $sql = "SELECT mlm_id FROM members WHERE ref_id IN ($placeholders)";
    $stmt = $mysqli->prepare($sql);
    $stmt->bind_param($types, ...$rootIds);
    $stmt->execute();
    $res = $stmt->get_result();

    $newIds = [];
    while($r = $res->fetch_assoc()){
        $collector[] = $r['mlm_id'];   // store id
        $newIds[] = $r['mlm_id'];      // prepare for next level
    }

    // RECURSIVE CALL — go deeper
    if (!empty($newIds)) {
        getAllDescendants($mysqli, $newIds, $collector);
    }
}
// -------------- TOTAL DESCENDANTS FOR ROOT -----------------
$descCollector = [];

if ($member) {
    getAllDescendants($mysqli, [$member['mlm_id']], $descCollector);
    $totalDownline = count($descCollector);  // COUNT of all levels
} else {
    $totalDownline = 0;
}


?>
<!doctype html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width,initial-scale=1">
<title>Bubble Tree View — MLM</title>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">

<style>
:root{
  --bg:#f5f7fb;
  --card:#fff;
  --muted:#6b7280;
  --accent:#2b6ef6;
  --line:#cdd6e6;
}

/* page */
body{ background:var(--bg); font-family: Inter, system-ui, sans-serif; }
.container-app { max-width:1200px; margin:28px auto; padding:18px; }

/* header */
.header { display:flex; justify-content:space-between; align-items:center; gap:12px; margin-bottom:14px; }

/* canvas */
.canvas {
  position:relative;
  background:linear-gradient(180deg,#ffffff,#fbfdff);
  border-radius:12px;
  padding:20px;
  min-height:420px;
  box-shadow:0 10px 30px rgba(20,40,80,0.06);
  overflow:auto;
}

/* svg overlay (for connectors) */
.connector-svg {
  position:absolute;
  left:0; top:0; width:100%; height:100%;
  pointer-events:none;
  z-index:5;
}

/* bubble area */
.bubble-stage { position:relative; display:flex; flex-direction:column; align-items:center; gap:28px; padding:28px 12px; }

/* central root bubble */
.bubble {
  width:140px; height:140px;
  border-radius:50%;
  background:var(--card);
  display:flex; flex-direction:column; align-items:center; justify-content:center;
  box-shadow:0 6px 18px rgba(15,40,90,0.08);
  transition: transform .18s ease, box-shadow .18s ease;
  cursor:pointer;
  z-index:10;
  text-align:center;
  padding:8px;
}
.bubble.small { width:86px; height:86px; font-size:13px; padding:6px; }
.bubble:hover { transform: translateY(-6px); box-shadow:0 12px 30px rgba(12,40,100,0.12); }

/* name + id inside bubble */
.bubble .id { font-weight:700; font-size:14px; }
.bubble .name { font-size:12px; color:var(--muted); margin-top:3px; overflow:hidden; text-overflow:ellipsis; white-space:nowrap; width:88%; }

/* children ring */
.ring { display:flex; flex-wrap:wrap; justify-content:center; gap:18px; padding:6px; }

/* child bubble style */
.child-bubble { width:92px; height:92px; border-radius:50%; background:var(--card); display:flex; flex-direction:column; align-items:center; justify-content:center; box-shadow:0 6px 18px rgba(12,40,90,0.06); cursor:pointer; transition:transform .12s linear; position:relative; }
.child-bubble:hover { transform: translateY(-6px); }

/* small labels under bubble */
.child-label { font-size:12px; color:var(--muted); margin-top:6px; text-align:center; max-width:110px; overflow:hidden; text-overflow:ellipsis; white-space:nowrap; }

/* badges */
.badge-count { position:absolute; right:-6px; top:-6px; background:#eef2ff; color:var(--accent); padding:4px 7px; border-radius:999px; font-weight:700; font-size:12px; box-shadow:0 2px 6px rgba(10,30,80,0.06); }
.status-chip { margin-top:6px; padding:4px 8px; border-radius:999px; font-size:11px; font-weight:700; display:inline-block; }
.status-prime { background:#1fa750; color:#fff; }
.status-prime1 { background:#f7b731; color:#000; }
.status-red { background:#e63946; color:#fff; }

/* controls */
.controls { display:flex; gap:8px; align-items:center; }

/* small helper */
.hint { font-size:13px; color:var(--muted); }

/* responsive */
@media (max-width:860px){
  .bubble { width:120px; height:120px; }
  .child-bubble { width:80px; height:80px; }
  .container-app { margin:12px; padding:8px; }
}

/* selected bubble */
.bubble.selected, .child-bubble.selected { outline:4px solid rgba(43,110,246,0.12); box-shadow:0 20px 40px rgba(20,60,120,0.08); transform:translateY(-8px); }

/* animation when nodes appear */
.fade-in { animation: fadeInScale .22s ease both; }
@keyframes fadeInScale { from { opacity:0; transform:scale(.96) translateY(6px);} to { opacity:1; transform:scale(1) translateY(0);} }
</style>
</head>
<body>

<div class="container-app">
  <div class="header">
    <div>
      <h4 class="mb-0"><i class="fa-solid fa-circle-nodes me-2"></i> Bubble Tree (Radial / Ring)</h4>
      <div class="small text-muted">Click a bubble to load its direct children beneath it. Lines show relationships.</div>
    </div>
    <div class="controls">
      <a href="user_dashboard.php" class="btn btn-sm btn-warning me-2"><i class="fa fa-arrow-left"></i> Back</a>

      <form id="searchForm" class="d-flex" onsubmit="event.preventDefault(); goSearch();">

       <input id="mlm_input" class="form-control form-control-sm"
       placeholder="Member ID (eg. DE00001)"
       value="<?= isset($_GET['mlm_id']) ? h($_GET['mlm_id']) : h($myMLM) ?>" readonly>

        <button class="btn btn-primary btn-sm ms-2">Go</button>
      </form>
    </div>
  </div>

  <div id="canvas" class="canvas">
    <!-- svg connectors overlay -->
    <svg id="connectorSvg" class="connector-svg" xmlns="http://www.w3.org/2000/svg"></svg>

    <?php if (!$member): ?>
      
    <?php else: ?>
      <div id="stage" class="bubble-stage" aria-live="polite">
        <!-- root (center bubble) -->
        <div style="position:relative; display:inline-block;">
    <span style="
        position:absolute;
        top:-10px;
        right:-10px;
        background:#2b6ef6;
        color:#fff;
        padding:6px 10px;
        border-radius:999px;
        font-weight:700;
        font-size:13px;
        box-shadow:0 2px 6px rgba(20,60,120,0.20);
        z-index:20;
    ">
        <?= $totalDownline ?>
    </span>

    <div id="bubble-<?= h($member['mlm_id']) ?>" 
         class="bubble fade-in selected"
         tabindex="0"
         data-mlm="<?= h($member['mlm_id']) ?>"
         data-full="<?= h($member['full_name']) ?>"
         data-phone="<?= h($member['phone']) ?>"
         data-status="<?= h($member['status']) ?>">
      
        <div class="id"><?= h($member['mlm_id']) ?></div>
        <div class="name"><?= h($member['full_name']) ?></div>
        <div class="small hint"><?= h($member['phone']) ?></div>

    </div>
</div>


        <!-- dynamic area where rings/children are appended -->
        <div id="ringsContainer" style="width:100%;"></div>
      </div>
    <?php endif; ?>
  </div>
</div>

<script>
// helper
function qs(sel,root=document){return root.querySelector(sel);}
function qsa(sel,root=document){return Array.from(root.querySelectorAll(sel));}
function goSearch(){ const id = qs('#mlm_input').value.trim(); if(!id) return; window.location.search='?mlm_id='+encodeURIComponent(id); }

// SVG connector drawing
const svg = qs('#connectorSvg');
function clearSVG(){ while(svg.firstChild) svg.removeChild(svg.firstChild); }
function makeLine(x1,y1,x2,y2){ const ns='http://www.w3.org/2000/svg'; const line=document.createElementNS(ns,'line'); line.setAttribute('x1',x1); line.setAttribute('y1',y1); line.setAttribute('x2',x2); line.setAttribute('y2',y2); line.setAttribute('stroke','#9fb0d9'); line.setAttribute('stroke-width','2'); line.setAttribute('stroke-linecap','round'); svg.appendChild(line); }

// compute positions and draw connectors parent->children (re-run on resize)
function drawConnectors(){
  clearSVG();
  const stage = qs('#stage');
  if(!stage) return;
  // set svg size
  const r = stage.getBoundingClientRect();
  svg.setAttribute('width', r.width); svg.setAttribute('height', r.height);

  // find all parent bubbles that have a following ring
  const rings = qsa('.ring');
  rings.forEach(ring => {
    const parentId = ring.getAttribute('data-parent');
    const parentEl = qs('#bubble-' + parentId);
    if(!parentEl) return;
    const pRect = parentEl.getBoundingClientRect();
    const prx = pRect.left + pRect.width/2 - r.left;
    const pry = pRect.top + pRect.height/2 - r.top;

    // each child bubble in ring
    const children = Array.from(ring.querySelectorAll('.child-bubble'));
    children.forEach(child => {
      const cRect = child.getBoundingClientRect();
      const crx = cRect.left + cRect.width/2 - r.left;
      const cry = cRect.top + cRect.height/2 - r.top;
      makeLine(prx, pry, crx, cry);
    });
  });
}

// fetch children JSON via AJAX
function fetchChildren(parentId, callback){
  fetch(window.location.pathname + '?action=fetch_children_json&parent_id=' + encodeURIComponent(parentId))
    .then(r => r.json())
    .then(data => callback(null, data.children || []))
    .catch(err => callback(err, []));
}

// create ring DOM for given parent and children array
function buildRing(parentEl, parentId, children){
  // if no children -> show nothing
  if(!children || children.length === 0) return null;

  // create ring container
  const ringWrap = document.createElement('div');
  ringWrap.className = 'ring fade-in';
  ringWrap.style.marginTop = '6px';
  ringWrap.setAttribute('data-parent', parentId);

  children.forEach((c, idx) => {
    // child bubble
    const child = document.createElement('div');
    child.className = 'child-bubble';
    child.id = 'bubble-'+c.mlm_id;
    child.tabIndex = 0;
    child.setAttribute('data-mlm', c.mlm_id);
    child.setAttribute('data-full', c.full_name);
    child.setAttribute('data-phone', c.phone);
    child.setAttribute('data-status', c.status);
    child.innerHTML = '<div style="font-weight:700;">' + c.mlm_id + '</div><div style="font-size:12px;color:'+ (c.full_name? '#556':'#999') +'">'+ (c.full_name || '') +'</div>';

    // child label (name truncated)
    const label = document.createElement('div');
    label.className = 'child-label';
    label.textContent = c.full_name;

    // count badge
    const badge = document.createElement('span');
    badge.className = 'badge-count';
    badge.textContent = c.children_count;

    // status chip small (below)
    const status = document.createElement('div');
    const sc = (c.status === 'prime1') ? 'status-prime1' : ((c.status === 'prime') ? 'status-prime' : 'status-red');
    status.className = 'status-chip ' + sc;
    status.textContent = c.status;

    // append pieces
    child.appendChild(badge);
    // add click to select/load this node's children
    child.addEventListener('click', function(e){
      onSelectBubble(c.mlm_id, child);
    });
    // keyboard support
    child.addEventListener('keydown', function(e){
      if(e.key === 'Enter' || e.key === ' ') { e.preventDefault(); child.click(); }
    });

    // wrapper for bubble + label + status
    const wrapper = document.createElement('div');
    wrapper.style.display = 'flex';
    wrapper.style.flexDirection = 'column';
    wrapper.style.alignItems = 'center';
    wrapper.appendChild(child);
    wrapper.appendChild(label);
    wrapper.appendChild(status);

    ringWrap.appendChild(wrapper);
  });

  return ringWrap;
}

// handle selecting a bubble: mark selected, load its children and display ring under it (remove existing ring for same parent)
function onSelectBubble(mlm, bubbleEl){
  // remove previous "selected" class
  qsa('.selected').forEach(n => n.classList.remove('selected'));
  // mark current
  bubbleEl.classList.add('selected');

  const ringsContainer = qs('#ringsContainer');

  // if ring for this parent already exists -> toggle show/hide
  const existingRing = ringsContainer.querySelector('[data-parent="'+mlm+'"]');
  if(existingRing){
    // if it's visible remove it (collapse)
    if(existingRing.style.display !== 'none'){
      existingRing.style.display = 'none';
      drawConnectors();
      return;
    } else {
      existingRing.style.display = '';
      drawConnectors();
      return;
    }
  }

  // otherwise fetch children and create ring
  fetchChildren(mlm, function(err, children){
    if(err){
      alert('Failed to load children');
      return;
    }
    const ring = buildRing(bubbleEl, mlm, children);
    if(ring){
      // insert ring after the parent bubble in the stage
      // find parent bubble wrapper position: we want ring just below the parent bubble
      // To visually group rings, append to ringsContainer. We will position rings vertically stacked as user clicks different nodes.
      ringsContainer.appendChild(ring);
      // after DOM changes, wait then draw connectors
      setTimeout(drawConnectors, 60);
    } else {
      // no children => maybe show a tiny hint briefly
      // place a brief message under bubble
      const hint = document.createElement('div');
      hint.className = 'small text-muted';
      hint.style.marginTop = '6px';
      hint.textContent = 'No direct children';
      const wrapper = bubbleEl.parentElement;
      // remove any previous hint
      const prev = wrapper.querySelector('.small.text-muted');
      if(prev) prev.remove();
      wrapper.appendChild(hint);
      setTimeout(() => { if(hint) hint.remove(); }, 2300);
    }
  });
}

// initial behaviour: auto-click root to load first ring
document.addEventListener('DOMContentLoaded', function(){
  const root = qs('#stage .bubble');
  if(!root) return;
  // ensure svg covers stage size on load and resize
  setTimeout(drawConnectors, 160);
  window.addEventListener('resize', function(){ clearTimeout(window._bubble_resize); window._bubble_resize = setTimeout(drawConnectors, 120); });

  // simulate a short click to load root children automatically
  root.addEventListener('click', function(){ onSelectBubble(root.getAttribute('data-mlm'), root); });
  // auto fire first click once
  setTimeout(()=>{ root.click(); }, 220);
});

// also redraw connectors after images/fonts load (safety)
window.addEventListener('load', function(){ setTimeout(drawConnectors, 180); });
</script>

</body>
</html>
