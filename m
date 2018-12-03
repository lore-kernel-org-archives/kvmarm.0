From: James Morse <james.morse@arm.com>
Subject: [PATCH v7 04/25] ACPI / APEI: Make hest.c manage the estatus memory
 pool
Date: Mon,  3 Dec 2018 18:05:52 +0000
Message-ID: <20181203180613.228133-5-james.morse@arm.com>
References: <20181203180613.228133-1-james.morse@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CDC0F4A2E6
 for <kvmarm@lists.cs.columbia.edu>; Mon,  3 Dec 2018 13:06:51 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Oy50tVUGGpD2 for <kvmarm@lists.cs.columbia.edu>;
 Mon,  3 Dec 2018 13:06:50 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9150D4A2BD
 for <kvmarm@lists.cs.columbia.edu>; Mon,  3 Dec 2018 13:06:50 -0500 (EST)
In-Reply-To: <20181203180613.228133-1-james.morse@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-acpi@vger.kernel.org
Cc: Rafael Wysocki <rjw@rjwysocki.net>, Tony Luck <tony.luck@intel.com>, Fan Wu <wufan@codeaurora.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Dongjiu Geng <gengdongjiu@huawei.com>, linux-mm@kvack.org, Borislav Petkov <bp@alien8.de>, Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, Len Brown <lenb@kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

ghes.c has a memory pool it uses for the estatus cache and the estatus
queue. The cache is initialised when registering the platform driver.
For the queue, an NMI-like notification has to grow/shrink the pool
as it is registered and unregistered.

This is all pretty noisy when adding new NMI-like notifications, it
would be better to replace this with a static pool size based on the
number of users.

As a precursor, move the call that creates the pool from ghes_init(),
into hest.c. Later this will take the number of ghes entries and
consolidate the queue allocations.
Remove ghes_estatus_pool_exit() as hest.c doesn't have anywhere to put
this.

The pool is now initialised as part of ACPI's subsys_initcall():
(acpi_init(), acpi_scan_init(), acpi_pci_root_init(), acpi_hest_init())
Before this patch it happened later as a GHES specific device_initcall().

Signed-off-by: James Morse <james.morse@arm.com>
---
 drivers/acpi/apei/ghes.c | 33 ++++++---------------------------
 drivers/acpi/apei/hest.c |  5 +++++
 include/acpi/ghes.h      |  2 ++
 3 files changed, 13 insertions(+), 27 deletions(-)

diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
index c15264f2dc4b..78058adb2574 100644
--- a/drivers/acpi/apei/ghes.c
+++ b/drivers/acpi/apei/ghes.c
@@ -162,26 +162,16 @@ static void ghes_iounmap_irq(void)
 	clear_fixmap(FIX_APEI_GHES_IRQ);
 }
 
-static int ghes_estatus_pool_init(void)
+static int ghes_estatus_pool_expand(unsigned long len); //temporary
+
+int ghes_estatus_pool_init(void)
 {
 	ghes_estatus_pool = gen_pool_create(GHES_ESTATUS_POOL_MIN_ALLOC_ORDER, -1);
 	if (!ghes_estatus_pool)
 		return -ENOMEM;
-	return 0;
-}
 
-static void ghes_estatus_pool_free_chunk(struct gen_pool *pool,
-					      struct gen_pool_chunk *chunk,
-					      void *data)
-{
-	vfree((void *)chunk->start_addr);
-}
-
-static void ghes_estatus_pool_exit(void)
-{
-	gen_pool_for_each_chunk(ghes_estatus_pool,
-				ghes_estatus_pool_free_chunk, NULL);
-	gen_pool_destroy(ghes_estatus_pool);
+	return ghes_estatus_pool_expand(GHES_ESTATUS_CACHE_AVG_SIZE *
+					GHES_ESTATUS_CACHE_ALLOCED_MAX);
 }
 
 static int ghes_estatus_pool_expand(unsigned long len)
@@ -1225,18 +1215,9 @@ static int __init ghes_init(void)
 
 	ghes_nmi_init_cxt();
 
-	rc = ghes_estatus_pool_init();
-	if (rc)
-		goto err;
-
-	rc = ghes_estatus_pool_expand(GHES_ESTATUS_CACHE_AVG_SIZE *
-				      GHES_ESTATUS_CACHE_ALLOCED_MAX);
-	if (rc)
-		goto err_pool_exit;
-
 	rc = platform_driver_register(&ghes_platform_driver);
 	if (rc)
-		goto err_pool_exit;
+		goto err;
 
 	rc = apei_osc_setup();
 	if (rc == 0 && osc_sb_apei_support_acked)
@@ -1249,8 +1230,6 @@ static int __init ghes_init(void)
 		pr_info(GHES_PFX "Failed to enable APEI firmware first mode.\n");
 
 	return 0;
-err_pool_exit:
-	ghes_estatus_pool_exit();
 err:
 	return rc;
 }
diff --git a/drivers/acpi/apei/hest.c b/drivers/acpi/apei/hest.c
index b1e9f81ebeea..da5fabaeb48f 100644
--- a/drivers/acpi/apei/hest.c
+++ b/drivers/acpi/apei/hest.c
@@ -32,6 +32,7 @@
 #include <linux/io.h>
 #include <linux/platform_device.h>
 #include <acpi/apei.h>
+#include <acpi/ghes.h>
 
 #include "apei-internal.h"
 
@@ -200,6 +201,10 @@ static int __init hest_ghes_dev_register(unsigned int ghes_count)
 	if (!ghes_arr.ghes_devs)
 		return -ENOMEM;
 
+	rc = ghes_estatus_pool_init();
+	if (rc)
+		goto out;
+
 	rc = apei_hest_parse(hest_parse_ghes, &ghes_arr);
 	if (rc)
 		goto err;
diff --git a/include/acpi/ghes.h b/include/acpi/ghes.h
index 82cb4eb225a4..46ef5566e052 100644
--- a/include/acpi/ghes.h
+++ b/include/acpi/ghes.h
@@ -52,6 +52,8 @@ enum {
 	GHES_SEV_PANIC = 0x3,
 };
 
+int ghes_estatus_pool_init(void);
+
 /* From drivers/edac/ghes_edac.c */
 
 #ifdef CONFIG_EDAC_GHES
-- 
2.19.2
