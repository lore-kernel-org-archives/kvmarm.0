From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 07/13] watchdog: kempld: fix gcc-4.3 build
Date: Fri, 16 Dec 2016 11:56:28 +0100
Message-ID: <20161216105634.235457-8-arnd@arndb.de>
References: <20161216105634.235457-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0F01E405D6
 for <kvmarm@lists.cs.columbia.edu>; Fri, 16 Dec 2016 05:55:41 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id nD2SCYrW9oBV for <kvmarm@lists.cs.columbia.edu>;
 Fri, 16 Dec 2016 05:55:40 -0500 (EST)
Received: from mout.kundenserver.de (mout.kundenserver.de [217.72.192.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B4066405E6
 for <kvmarm@lists.cs.columbia.edu>; Fri, 16 Dec 2016 05:55:39 -0500 (EST)
In-Reply-To: <20161216105634.235457-1-arnd@arndb.de>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-arch@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, kernel-build-reports@lists.linaro.org, linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org, Russell King <rmk+kernel@armlinux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

gcc-4.3 can't decide whether the constant value in
kempld_prescaler[PRESCALER_21] is built-time constant or
not, and gets confused by the logic in do_div():

drivers/watchdog/kempld_wdt.o: In function `kempld_wdt_set_stage_timeout':
kempld_wdt.c:(.text.kempld_wdt_set_stage_timeout+0x130): undefined reference to `__aeabi_uldivmod'

This adds a call to ACCESS_ONCE() to force it to not consider
it to be constant, and leaves the more efficient normal case
in place for modern compilers, using an #ifdef to annotate
why we do this hack.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/watchdog/kempld_wdt.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/watchdog/kempld_wdt.c b/drivers/watchdog/kempld_wdt.c
index 8e302d0e346c..3efa295ac627 100644
--- a/drivers/watchdog/kempld_wdt.c
+++ b/drivers/watchdog/kempld_wdt.c
@@ -140,12 +140,19 @@ static int kempld_wdt_set_stage_timeout(struct kempld_wdt_data *wdt_data,
 					unsigned int timeout)
 {
 	struct kempld_device_data *pld = wdt_data->pld;
-	u32 prescaler = kempld_prescaler[PRESCALER_21];
+	u32 prescaler;
 	u64 stage_timeout64;
 	u32 stage_timeout;
 	u32 remainder;
 	u8 stage_cfg;
 
+#if GCC_VERSION < 40400
+	/* work around a bug compiling do_div() */
+	prescaler = READ_ONCE(kempld_prescaler[PRESCALER_21]);
+#else
+	prescaler = kempld_prescaler[PRESCALER_21];
+#endif
+
 	if (!stage)
 		return -EINVAL;
 
-- 
2.9.0
