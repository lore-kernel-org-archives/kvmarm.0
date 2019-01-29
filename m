From: James Morse <james.morse@arm.com>
Subject: [PATCH v8 05/26] ACPI / APEI: Make estatus pool allocation a static
 size
Date: Tue, 29 Jan 2019 18:48:41 +0000
Message-ID: <20190129184902.102850-6-james.morse@arm.com>
References: <20190129184902.102850-1-james.morse@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 415C34A3C6
 for <kvmarm@lists.cs.columbia.edu>; Tue, 29 Jan 2019 13:49:55 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id F+Xis32bKAhh for <kvmarm@lists.cs.columbia.edu>;
 Tue, 29 Jan 2019 13:49:54 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AFD354A3A5
 for <kvmarm@lists.cs.columbia.edu>; Tue, 29 Jan 2019 13:49:53 -0500 (EST)
In-Reply-To: <20190129184902.102850-1-james.morse@arm.com>
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
Cc: Rafael Wysocki <rjw@rjwysocki.net>, Tony Luck <tony.luck@intel.com>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Dongjiu Geng <gengdongjiu@huawei.com>, linux-mm@kvack.org, Borislav Petkov <bp@alien8.de>, Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, Len Brown <lenb@kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

Adding new NMI-like notifications duplicates the calls that grow
and shrink the estatus pool. This is all pretty pointless, as the
size is capped to 64K. Allocate this for each ghes and drop
the code that grows and shrinks the pool.

Suggested-by: Borislav Petkov <bp@suse.de>
Signed-off-by: James Morse <james.morse@arm.com>
Reviewed-by: Borislav Petkov <bp@suse.de>
---
 drivers/acpi/apei/ghes.c | 49 +++++-----------------------------------
 drivers/acpi/apei/hest.c |  2 +-
 include/acpi/ghes.h      |  2 +-
 3 files changed, 8 insertions(+), 45 deletions(-)

diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
index 4150c72c78cb..33144ab0661a 100644
--- a/drivers/acpi/apei/ghes.c
+++ b/drivers/acpi/apei/ghes.c
@@ -162,27 +162,18 @@ static void ghes_iounmap_irq(void)
 	clear_fixmap(FIX_APEI_GHES_IRQ);
 }
 
-static int ghes_estatus_pool_expand(unsigned long len); //temporary
-
-int ghes_estatus_pool_init(void)
+int ghes_estatus_pool_init(int num_ghes)
 {
+	unsigned long addr, len;
+
 	ghes_estatus_pool = gen_pool_create(GHES_ESTATUS_POOL_MIN_ALLOC_ORDER, -1);
 	if (!ghes_estatus_pool)
 		return -ENOMEM;
 
-	return ghes_estatus_pool_expand(GHES_ESTATUS_CACHE_AVG_SIZE *
-					GHES_ESTATUS_CACHE_ALLOCED_MAX);
-}
-
-static int ghes_estatus_pool_expand(unsigned long len)
-{
-	unsigned long size, addr;
-
-	ghes_estatus_pool_size_request += PAGE_ALIGN(len);
-	size = gen_pool_size(ghes_estatus_pool);
-	if (size >= ghes_estatus_pool_size_request)
-		return 0;
+	len = GHES_ESTATUS_CACHE_AVG_SIZE * GHES_ESTATUS_CACHE_ALLOCED_MAX;
+	len += (num_ghes * GHES_ESOURCE_PREALLOC_MAX_SIZE);
 
+	ghes_estatus_pool_size_request = PAGE_ALIGN(len);
 	addr = (unsigned long)vmalloc(PAGE_ALIGN(len));
 	if (!addr)
 		return -ENOMEM;
@@ -956,32 +947,8 @@ static int ghes_notify_nmi(unsigned int cmd, struct pt_regs *regs)
 	return ret;
 }
 
-static unsigned long ghes_esource_prealloc_size(
-	const struct acpi_hest_generic *generic)
-{
-	unsigned long block_length, prealloc_records, prealloc_size;
-
-	block_length = min_t(unsigned long, generic->error_block_length,
-			     GHES_ESTATUS_MAX_SIZE);
-	prealloc_records = max_t(unsigned long,
-				 generic->records_to_preallocate, 1);
-	prealloc_size = min_t(unsigned long, block_length * prealloc_records,
-			      GHES_ESOURCE_PREALLOC_MAX_SIZE);
-
-	return prealloc_size;
-}
-
-static void ghes_estatus_pool_shrink(unsigned long len)
-{
-	ghes_estatus_pool_size_request -= PAGE_ALIGN(len);
-}
-
 static void ghes_nmi_add(struct ghes *ghes)
 {
-	unsigned long len;
-
-	len = ghes_esource_prealloc_size(ghes->generic);
-	ghes_estatus_pool_expand(len);
 	mutex_lock(&ghes_list_mutex);
 	if (list_empty(&ghes_nmi))
 		register_nmi_handler(NMI_LOCAL, ghes_notify_nmi, 0, "ghes");
@@ -991,8 +958,6 @@ static void ghes_nmi_add(struct ghes *ghes)
 
 static void ghes_nmi_remove(struct ghes *ghes)
 {
-	unsigned long len;
-
 	mutex_lock(&ghes_list_mutex);
 	list_del_rcu(&ghes->list);
 	if (list_empty(&ghes_nmi))
@@ -1003,8 +968,6 @@ static void ghes_nmi_remove(struct ghes *ghes)
 	 * freed after NMI handler finishes.
 	 */
 	synchronize_rcu();
-	len = ghes_esource_prealloc_size(ghes->generic);
-	ghes_estatus_pool_shrink(len);
 }
 
 static void ghes_nmi_init_cxt(void)
diff --git a/drivers/acpi/apei/hest.c b/drivers/acpi/apei/hest.c
index 097ba07a657b..fcc8cc1e4f3d 100644
--- a/drivers/acpi/apei/hest.c
+++ b/drivers/acpi/apei/hest.c
@@ -205,7 +205,7 @@ static int __init hest_ghes_dev_register(unsigned int ghes_count)
 	if (rc)
 		goto err;
 
-	rc = ghes_estatus_pool_init();
+	rc = ghes_estatus_pool_init(ghes_count);
 	if (rc)
 		goto err;
 
diff --git a/include/acpi/ghes.h b/include/acpi/ghes.h
index 46ef5566e052..cd9ee507d860 100644
--- a/include/acpi/ghes.h
+++ b/include/acpi/ghes.h
@@ -52,7 +52,7 @@ enum {
 	GHES_SEV_PANIC = 0x3,
 };
 
-int ghes_estatus_pool_init(void);
+int ghes_estatus_pool_init(int num_ghes);
 
 /* From drivers/edac/ghes_edac.c */
 
-- 
2.20.1
