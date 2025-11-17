<?php
session_start();
if (!isset($_SESSION['admin_loggedin']) || $_SESSION['admin_loggedin'] !== true) {
    header("Location: admin_login.php");
    exit;
}

include 'db.php';

function h($s){ return htmlspecialchars($s, ENT_QUOTES|ENT_SUBSTITUTE, 'UTF-8'); }

// ---------- AJAX endpoint: return children as JSON ----------
if (isset($_GET['action']) && $_GET['action'] === 'fetch_children_json' && isset($_GET['parent_id'])) {
    $parent = trim($_GET['parent_id']);

    // fetch direct children
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
?>
<!doctype html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width,initial-scale=1">
<title>Vertical Tree View — MLM</title>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">

<style>
:root{
  --accent: #0d6efd;
  --muted: #6b7280;
  --card-bg: #ffffff;
  --line: #c9d2df;
}

/* container */
.container-tree {
  max-width:1100px;
  margin:28px auto;
  background:linear-gradient(180deg,#fff,#fbfcff);
  padding:22px;
  border-radius:12px;
  box-shadow:0 6px 30px rgba(18,38,63,0.08);
}

/* search area */
.form-inline { gap:8px; display:flex; justify-content:center; margin-bottom:18px; }

/* tree */
.tree-root { padding-left:8px; }

/* node row */
.node-row {
  display:flex;
  align-items:center;
  gap:12px;
  padding:10px 12px;
  border-radius:8px;
  background:var(--card-bg);
  box-shadow:0 1px 0 rgba(18,38,63,0.03);
  transition: transform .08s ease, background .12s;
  margin-bottom:6px;
}

/* hovered node */
.node-row:hover { transform: translateY(-2px); }

/* caret */
.caret {
  width:34px; height:34px;
  display:inline-flex; align-items:center; justify-content:center;
  border-radius:8px; cursor:pointer; flex:0 0 34px;
  transition: transform .18s ease;
  color:var(--muted);
}
.caret.disabled { opacity:.25; cursor:default; }
.caret.open { transform: rotate(90deg); color:var(--accent); }

/* node content */
.node-main { flex:1; min-width:0; display:flex; align-items:center; gap:12px;}
.node-info { min-width:0; }
.node-info h6 { margin:0; font-size:15px; white-space:nowrap; overflow:hidden; text-overflow:ellipsis; }
.node-info .sub { font-size:13px; color:var(--muted); white-space:nowrap; overflow:hidden; text-overflow:ellipsis; }

/* badges */
.badge-count { background:#eef2ff; color:var(--accent); font-weight:600; padding:4px 8px; border-radius:999px; font-size:13px; }
.status-prime { background:#1fa750; color:#fff; padding:4px 8px; border-radius:8px; font-weight:600; font-size:12px; }
.status-prime1 { background:#f7b731; color:#000; padding:4px 8px; border-radius:8px; font-weight:600; font-size:12px; }
.status-red { background:#e63946; color:#fff; padding:4px 8px; border-radius:8px; font-weight:600; font-size:12px; }

/* children block (indented) */
.children-block {
  margin-left:46px;
  border-left:2px solid var(--line);
  padding-left:18px;
  margin-top:8px;
  overflow:visible;
}

/* collapsed hide animation */
.hidden { display:none; }

/* small responsive tweaks */
@media (max-width:720px){
  .container-tree{ margin:12px; padding:12px; }
  .node-row{ padding:10px; }
  .node-info h6{ font-size:14px; }
}

/* subtle connector dot */
.node-dot { width:10px; height:10px; border-radius:50%; background:var(--line); margin-right:8px; }
</style>
</head>
<body>

<div class="container container-tree">

  <div class="d-flex justify-content-between align-items-center mb-3">
    <h4 class="mb-0"><i class="fa-solid fa-sitemap me-2"></i>Visual Folder Tree</h4>
    <a href="admin_main.php" class="btn btn-sm btn-warning"><i class="fa fa-arrow-left"></i> Back</a>
  </div>

  <form class="form-inline" onsubmit="event.preventDefault(); goTo();">
    <input id="mlm_input" name="mlm_id" class="form-control w-50" placeholder="Enter Member ID (e.g. DE00001)" value="<?= isset($member['mlm_id']) ? h($member['mlm_id']) : '' ?>" required>
    <button class="btn btn-primary">Go</button>
    <div style="width:14px"></div>
    <div class="text-muted small mt-1">Click caret to expand/collapse. Counts show number of direct children.</div>
  </form>

  <?php if (!$member): ?>
    <div class="text-center text-muted py-5">
      <p class="mb-1">Type a Member ID and press Go to view their downline in a clean folder-style tree.</p>
      <p class="small">This view loads children lazily for performance.</p>
    </div>
  <?php else: ?>
    <div id="treeRoot" class="tree-root" role="tree" aria-label="MLM tree">
      <!-- root node -->
      <div class="node-row" data-mlm="<?= h($member['mlm_id']) ?>" role="treeitem" aria-expanded="false">
        <div class="caret disabled" title="root"><i class="fa-solid fa-user"></i></div>
        <div class="node-main">
          <div class="node-dot"></div>
          <div class="node-info">
            <h6><?= h($member['mlm_id']) ?> <small class="text-muted"> - <?= h($member['full_name']) ?></small></h6>
            <div class="sub"><?= h($member['phone']) ?></div>
          </div>
        </div>
        <div>
          <?php
            $sc = ($member['status']=='prime1') ? 'status-prime1' : (($member['status']=='prime')?'status-prime':'status-red');
            // get direct count for root
            $cstmt = $mysqli->prepare("SELECT COUNT(*) AS c FROM members WHERE ref_id = ?");
            $cstmt->bind_param("s", $member['mlm_id']);
            $cstmt->execute();
            $cres = $cstmt->get_result()->fetch_assoc();
            $root_count = intval($cres['c']);
          ?>
          <span class="badge-count me-2"><?= $root_count ?></span>
          <span class="<?= $sc ?>"><?= h($member['status']) ?></span>
        </div>
      </div>

      <!-- children container to be filled by JS -->
      <div id="children-<?= h($member['mlm_id']) ?>" class="children-block" role="group"></div>
    </div>
  <?php endif; ?>

</div>

<script>
// small helper
function qs(sel, root=document) { return root.querySelector(sel); }
function qsa(sel, root=document) { return Array.from(root.querySelectorAll(sel)); }

function goTo(){
  const id = document.getElementById('mlm_input').value.trim();
  if(!id) return;
  window.location.search = '?mlm_id=' + encodeURIComponent(id);
}

// ---------- build one node DOM ----------
function makeNode(item){
  // wrapper
  const row = document.createElement('div');
  row.className = 'node-row';
  row.setAttribute('data-mlm', item.mlm_id);
  row.setAttribute('role', 'treeitem');
  row.setAttribute('aria-expanded', 'false');

  // caret
  const caret = document.createElement('button');
  caret.className = 'caret';
  caret.type = 'button';
  caret.title = 'Expand';
  const caretI = document.createElement('i');
  // use arrow if has children else user icon
  if(item.children_count && item.children_count > 0){
      caret.innerHTML = '<i class="fa-solid fa-caret-right"></i>';
  } else {
      caret.innerHTML = '<i class="fa-regular fa-circle-dot"></i>';
      caret.classList.add('disabled');
  }
  row.appendChild(caret);

  // main info
  const main = document.createElement('div');
  main.className = 'node-main';
  const dot = document.createElement('div'); dot.className='node-dot';
  const info = document.createElement('div'); info.className='node-info';
  const h6 = document.createElement('h6');
  h6.innerHTML = item.mlm_id + ' <small class="text-muted"> - ' + item.full_name + '</small>';
  const sub = document.createElement('div');
  sub.className = 'sub';
  sub.textContent = item.phone || '';
  info.appendChild(h6); info.appendChild(sub);
  main.appendChild(dot); main.appendChild(info);
  row.appendChild(main);

  // right side badges
  const right = document.createElement('div');
  const badgeCount = document.createElement('span');
  badgeCount.className = 'badge-count me-2';
  badgeCount.textContent = item.children_count;
  right.appendChild(badgeCount);

  const status = document.createElement('span');
  const statusClass = (item.status === 'prime1') ? 'status-prime1' : ((item.status === 'prime') ? 'status-prime' : 'status-red');
  status.className = statusClass;
  status.textContent = item.status;
  right.appendChild(status);

  row.appendChild(right);

  // create empty children container (collapsed)
  const childrenContainer = document.createElement('div');
  childrenContainer.className = 'children-block hidden';
  childrenContainer.setAttribute('role', 'group');

  // attach event on caret to toggle
  caret.addEventListener('click', function(){
      if(caret.classList.contains('disabled')) return;
      const expanded = row.getAttribute('aria-expanded') === 'true';
      if(!expanded){
          // open -> fetch children if not loaded
          if(childrenContainer.dataset.loaded === '1'){
              childrenContainer.classList.remove('hidden');
              row.setAttribute('aria-expanded','true');
              caret.classList.add('open');
          } else {
              fetchChildren(item.mlm_id, childrenContainer, function(countLoaded){
                  childrenContainer.dataset.loaded = '1';
                  if(countLoaded === 0){
                      // no children; disable caret
                      caret.classList.add('disabled');
                      caret.innerHTML = '<i class="fa-regular fa-circle-dot"></i>';
                  } else {
                      childrenContainer.classList.remove('hidden');
                      row.setAttribute('aria-expanded','true');
                      caret.classList.add('open');
                      // update badge count in case changed
                      badgeCount.textContent = countLoaded;
                  }
              });
          }
      } else {
          // collapse
          childrenContainer.classList.add('hidden');
          row.setAttribute('aria-expanded','false');
          caret.classList.remove('open');
      }
  });

  // when clicking the row (not caret) toggle selection / quick expand
  row.addEventListener('dblclick', function(e){
      // double click expands/collapses if not disabled
      caret.click();
  });

  return { row, childrenContainer };
}

// ---------- fetch children via AJAX (JSON) ----------
function fetchChildren(parentId, containerEl, cb){
  fetch(window.location.pathname + '?action=fetch_children_json&parent_id=' + encodeURIComponent(parentId))
    .then(r => r.json())
    .then(data => {
        const children = data.children || [];
        containerEl.innerHTML = ''; // clear
        children.forEach(child => {
            const built = makeNode(child);
            // append node row and its children container
            containerEl.appendChild(built.row);
            containerEl.appendChild(built.childrenContainer);
            // for better UX, if child has no children, mark disabled caret style
            if(child.children_count === 0){
                const c = built.row.querySelector('.caret');
                if(c) c.classList.add('disabled');
            }
        });
        cb(children.length);
    })
    .catch(err => {
        console.error('Failed to load children', err);
        containerEl.innerHTML = '<div class="text-muted small p-2">Failed to load children.</div>';
        cb(0);
    });
}

// ---------- initialize: load root children ----------
document.addEventListener('DOMContentLoaded', function(){
  const rootEl = document.getElementById('treeRoot');
  if(!rootEl) return;
  const rootMlm = rootEl.querySelector('.node-row')?.getAttribute('data-mlm');
  if(!rootMlm) return;
  const rootChildren = document.getElementById('children-' + rootMlm);
  // lazy load top level automatically (so user sees first level)
  if(rootChildren){
      fetchChildren(rootMlm, rootChildren, function(count){
          // expand root visually
          const rootRow = rootEl.querySelector('.node-row');
          if(count > 0 && rootRow){
              rootRow.setAttribute('aria-expanded','true');
              const caret = rootRow.querySelector('.caret');
              if(caret){
                  caret.innerHTML = '<i class="fa-solid fa-caret-right"></i>';
                  caret.classList.add('open');
              }
          }
      });
  }
});
</script>

</body>
</html>
