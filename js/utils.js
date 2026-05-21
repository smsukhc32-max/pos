/* ===== Utility Functions ===== */
function formatCurrency(amount) {
    return new Intl.NumberFormat('th-TH', { style: 'currency', currency: 'THB', minimumFractionDigits: 0 }).format(amount);
}

function formatDate(dateStr, options) {
    const d = new Date(dateStr);
    return d.toLocaleDateString('th-TH', options || { year: 'numeric', month: 'short', day: 'numeric', hour: '2-digit', minute: '2-digit' });
}

function formatDateShort(dateStr) {
    return new Date(dateStr).toLocaleDateString('th-TH', { day: 'numeric', month: 'short', year: '2-digit' });
}

function showToast(message, type = 'info') {
    let container = document.querySelector('.toast-container');
    if (!container) {
        container = document.createElement('div');
        container.className = 'toast-container';
        document.body.appendChild(container);
    }
    const toast = document.createElement('div');
    toast.className = `toast ${type}`;
    toast.innerHTML = `
    <span class="toast-message">${message}</span>
    <button class="toast-close" onclick="this.parentElement.remove()">&times;</button>
  `;
    container.appendChild(toast);
    setTimeout(() => { if (toast.parentElement) toast.remove() }, 3500);
}

function debounce(fn, delay = 300) {
    let timer;
    return (...args) => { clearTimeout(timer); timer = setTimeout(() => fn(...args), delay) };
}

function getInitials(name) {
    if (!name) return '?';
    return name.substring(0, 2); // Use 2 chars for better Thai readability
}

function paymentMethodLabel(method) {
    const map = { cash: '💵 เงินสด', promptpay: '📱 พร้อมเพย์', card: '💳 บัตรเครดิต' };
    return map[method] || method;
}

function statusLabel(status) {
    const map = { completed: 'เสร็จสิ้น', pending: 'รอคิว', cancelled: 'ยกเลิก' };
    return map[status] || status;
}

function statusBadge(status) {
    const cls = { completed: 'completed', pending: 'pending', cancelled: 'cancelled' };
    return `<span class="badge-status status-${cls[status] || 'info'}">${statusLabel(status)}</span>`;
}

/* Simple chart bar renderer */
function renderBarChart(container, data, maxVal) {
    if (!maxVal) maxVal = Math.max(...data.map(d => d.value), 1);
    container.innerHTML = data.map(d => `
    <div style="display:flex;align-items:center;gap:.5rem;margin-bottom:.5rem">
      <span style="width:60px;font-size:.75rem;color:var(--text-secondary);text-align:right">${d.label}</span>
      <div style="flex:1;height:28px;background:var(--bg);border-radius:var(--radius);overflow:hidden">
        <div style="height:100%;width:${(d.value / maxVal * 100).toFixed(1)}%;background:linear-gradient(90deg,var(--primary),var(--primary-light));border-radius:var(--radius);display:flex;align-items:center;justify-content:flex-end;padding:0 .5rem;font-size:.7rem;color:#fff;font-weight:600;transition:width .8s var(--ease)">${d.value}</div>
      </div>
    </div>
  `).join('');
}

function getProductMedia(val, isSmall = false) {
    if (!val) return '🍹';
    // Check if it's an image path (starts with http, /, ., or assets)
    if (val.startsWith('http') || val.startsWith('/') || val.startsWith('.') || val.startsWith('assets/')) {
        const size = isSmall ? '1.5em' : '100%';
        const borderRadius = isSmall ? '4px' : 'inherit';
        const objectFit = isSmall ? 'cover' : 'contain';
        // Use getBasePath() if available to ensure correct relative path from any page
        const basePath = typeof getBasePath === 'function' ? getBasePath() : '../';
        const finalUrl = val.startsWith('assets/') ? basePath + val : val;
        return `<img src="${finalUrl}" style="width:${size}; height:${size}; object-fit:${objectFit}; border-radius:${borderRadius}; vertical-align:middle; display:inline-block;" alt="" class="product-media-img">`;
    }
    return val;
}

function viewProductImage(url, title = 'รูปภาพเมนู') {
  const modal = document.createElement('div');
  modal.className = 'modal-overlay active';
  modal.style.zIndex = '3500';
  modal.innerHTML = `
    <div class="modal" style="max-width:450px">
      <div class="modal-header">
        <h3>🖼️ ${title}</h3>
        <button class="modal-close" onclick="this.closest('.modal-overlay').remove()">×</button>
      </div>
      <div class="modal-body text-center" style="padding: 1.5rem;">
        <img src="${url}" style="max-width:100%; max-height: 350px; object-fit: contain; border-radius:var(--radius-lg); box-shadow:var(--shadow-md)" alt="${title}">
      </div>
      <div class="modal-footer">
        <button class="btn btn-primary btn-block" onclick="this.closest('.modal-overlay').remove()">ปิดหน้าต่าง</button>
      </div>
    </div>
  `;
  modal.addEventListener('click', (e) => { if (e.target === modal) modal.remove(); });
  document.body.appendChild(modal);
}
