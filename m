From: Alexandru Elisei <alexandru.elisei@arm.com>
Subject: [kvm-unit-tests PATCH 1/7] lib: arm: Discover ns16550a UART
Date: Thu, 24 Jan 2019 11:16:28 +0000
Message-ID: <20190124111634.4727-2-alexandru.elisei@arm.com>
References: <20190124111634.4727-1-alexandru.elisei@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 227894A39D
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Jan 2019 06:17:02 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id bs7PiIuCCpDg for <kvmarm@lists.cs.columbia.edu>;
 Thu, 24 Jan 2019 06:17:00 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D99BB4A3A1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Jan 2019 06:17:00 -0500 (EST)
In-Reply-To: <20190124111634.4727-1-alexandru.elisei@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvm@vger.kernel.org
Cc: andre.przywara@arm.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Add support for discovering the ns16550a UART from the device tree. This
particular UART model is emulated by kvmtool.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 lib/arm/io.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/lib/arm/io.c b/lib/arm/io.c
index d2c1a07c19ee..35fc05aeb4db 100644
--- a/lib/arm/io.c
+++ b/lib/arm/io.c
@@ -32,22 +32,26 @@ static volatile u8 *uart0_base = (u8 *)UART_EARLY_BASE;
 
 static void uart0_init(void)
 {
-	const char *compatible = "arm,pl011";
+	const char *compatible[] = {"arm,pl011", "ns16550a"};
 	struct dt_pbus_reg base;
-	int ret;
+	int i, ret;
 
 	ret = dt_get_default_console_node();
 	assert(ret >= 0 || ret == -FDT_ERR_NOTFOUND);
 
 	if (ret == -FDT_ERR_NOTFOUND) {
 
-		ret = dt_pbus_get_base_compatible(compatible, &base);
-		assert(ret == 0 || ret == -FDT_ERR_NOTFOUND);
+		for (i = 0; i < ARRAY_SIZE(compatible); i++) {
+			ret = dt_pbus_get_base_compatible(compatible[i], &base);
+			assert(ret == 0 || ret == -FDT_ERR_NOTFOUND);
+
+			if (ret == 0)
+				break;
+		}
 
 		if (ret) {
-			printf("%s: %s not found in the device tree, "
-				"aborting...\n",
-				__func__, compatible);
+			printf("%s: Compatible UART not found in the device tree, "
+				"aborting...\n", __func__);
 			abort();
 		}
 
-- 
2.17.0
