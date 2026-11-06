// Підключення до Chrome, запущеного `flutter run -d chrome`, через CDP:
// натискання кнопки і знімок сторінки. Використовувався для скриншотів у docs/.
const { chromium } = require('playwright-core');
module.exports = async function cdp(port, steps) {
  const browser = await chromium.connectOverCDP(`http://127.0.0.1:${port}`);
  const page = browser.contexts()[0].pages().find(p => p.url().startsWith('http://localhost'));
  const log = [];
  for (const s of steps) {
    if (s.click) {
      // Flutter web малює на canvas, тому клікаємо за координатами кнопки з семантики.
      await page.evaluate(() => document.querySelector('flt-semantics-placeholder')?.click());
      const btn = page.getByRole('button', { name: s.click });
      await btn.click();
      await page.waitForTimeout(600);
      log.push('clicked ' + s.click);
    }
    if (s.shot) { await page.waitForTimeout(400); await page.screenshot({ path: s.shot }); log.push('shot ' + s.shot); }
  }
  log.push('url ' + page.url());
  await browser.close().catch(() => {});
  return log;
};
