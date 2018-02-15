From: James Morse <james.morse@arm.com>
Subject: [PATCH 03/11] ACPI / APEI: Switch NOTIFY_SEA to use the estatus queue
Date: Thu, 15 Feb 2018 18:55:58 +0000
Message-ID: <20180215185606.26736-4-james.morse@arm.com>
References: <20180215185606.26736-1-james.morse@arm.com>
Return-path: <linux-acpi-owner@vger.kernel.org>
In-Reply-To: <20180215185606.26736-1-james.morse@arm.com>
Sender: linux-acpi-owner@vger.kernel.org
To: linux-acpi@vger.kernel.org
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org, Borislav Petkov <bp@alien8.de>, Christoffer Dall <christoffer.dall@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>, Rafael Wysocki <rjw@rjwysocki.net>, Len Brown <lenb@kernel.org>, Tony Luck <tony.luck@intel.com>, Tyler Baicar <tbaicar@codeaurora.org>, Dongjiu Geng <gengdongjiu@huawei.com>, Xie XiuQi <xiexiuqi@huawei.com>, Punit Agrawal <punit.agrawal@arm.com>, James Morse <james.morse@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

Now that the estatus queue can be used by more than one notification
method, we can move notifications that have NMI-like behaviour over to
it, and start abstracting GHES's single in_nmi() path.

Switch NOTIFY_SEA over to use the estatus queue. This makes it behave
in the same way as x86's NOTIFY_NMI.

Signed-off-by: James Morse <james.morse@arm.com>
CC: Tyler Baicar <tbaicar@codeaurora.org>
---
 drivers/acpi/apei/ghes.c | 23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
index d3cc5bd5b496..7b2504aa23b1 100644
--- a/drivers/acpi/apei/ghes.c
+++ b/drivers/acpi/apei/ghes.c
@@ -59,6 +59,10 @@
 
 #define GHES_PFX	"GHES: "
 
+#if defined(CONFIG_HAVE_ACPI_APEI_NMI) || defined(CONFIG_ACPI_APEI_SEA)
+#define WANT_NMI_ESTATUS_QUEUE	1
+#endif
+
 #define GHES_ESTATUS_MAX_SIZE		65536
 #define GHES_ESOURCE_PREALLOC_MAX_SIZE	65536
 
@@ -682,7 +686,7 @@ static void ghes_estatus_cache_add(
 	rcu_read_unlock();
 }
 
-#ifdef CONFIG_HAVE_ACPI_APEI_NMI
+#ifdef WANT_NMI_ESTATUS_QUEUE
 /*
  * While printk() now has an in_nmi() path, the handling for CPER records
  * does not. For example, memory_failure_queue() takes spinlocks and calls
@@ -870,7 +874,7 @@ static void ghes_nmi_init_cxt(void)
 
 #else
 static inline void ghes_nmi_init_cxt(void) { }
-#endif /* CONFIG_HAVE_ACPI_APEI_NMI */
+#endif /* WANT_NMI_ESTATUS_QUEUE */
 
 static int ghes_ack_error(struct acpi_hest_generic_v2 *gv2)
 {
@@ -986,20 +990,13 @@ static LIST_HEAD(ghes_sea);
  */
 int ghes_notify_sea(void)
 {
-	struct ghes *ghes;
-	int ret = -ENOENT;
-
-	rcu_read_lock();
-	list_for_each_entry_rcu(ghes, &ghes_sea, list) {
-		if (!ghes_proc(ghes))
-			ret = 0;
-	}
-	rcu_read_unlock();
-	return ret;
+	return ghes_estatus_queue_notified(&ghes_sea);
 }
 
 static void ghes_sea_add(struct ghes *ghes)
 {
+	ghes_estatus_queue_grow_pool(ghes);
+
 	mutex_lock(&ghes_list_mutex);
 	list_add_rcu(&ghes->list, &ghes_sea);
 	mutex_unlock(&ghes_list_mutex);
@@ -1011,6 +1008,8 @@ static void ghes_sea_remove(struct ghes *ghes)
 	list_del_rcu(&ghes->list);
 	mutex_unlock(&ghes_list_mutex);
 	synchronize_rcu();
+
+	ghes_estatus_queue_shrink_pool(ghes);
 }
 #else /* CONFIG_ACPI_APEI_SEA */
 static inline void ghes_sea_add(struct ghes *ghes) { }
-- 
2.15.1

