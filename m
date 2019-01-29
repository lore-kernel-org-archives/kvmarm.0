From: James Morse <james.morse@arm.com>
Subject: [PATCH v8 11/26] ACPI / APEI: Move NOTIFY_SEA between the
 estatus-queue and NOTIFY_NMI
Date: Tue, 29 Jan 2019 18:48:47 +0000
Message-ID: <20190129184902.102850-12-james.morse@arm.com>
References: <20190129184902.102850-1-james.morse@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AF4E349E3E
 for <kvmarm@lists.cs.columbia.edu>; Tue, 29 Jan 2019 13:50:12 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 7fcEQ+9Tybxy for <kvmarm@lists.cs.columbia.edu>;
 Tue, 29 Jan 2019 13:50:11 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2A4DC4A369
 for <kvmarm@lists.cs.columbia.edu>; Tue, 29 Jan 2019 13:50:11 -0500 (EST)
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

The estatus-queue code is currently hidden by the NOTIFY_NMI #ifdefs.
Once NOTIFY_SEA starts using the estatus-queue we can stop hiding
it as each architecture has a user that can't be turned off.

Split the existing CONFIG_HAVE_ACPI_APEI_NMI block in two, and move
the SEA code into the gap.

Move the code around ... and changes the stale comment describing
why the status queue is necessary: printk() is no longer the issue,
its the helpers like memory_failure_queue() that aren't nmi safe.

Signed-off-by: James Morse <james.morse@arm.com>
---
 drivers/acpi/apei/ghes.c | 113 ++++++++++++++++++++-------------------
 1 file changed, 59 insertions(+), 54 deletions(-)

diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
index bd58749d31bb..576dce29159d 100644
--- a/drivers/acpi/apei/ghes.c
+++ b/drivers/acpi/apei/ghes.c
@@ -767,66 +767,21 @@ static struct notifier_block ghes_notifier_hed = {
 	.notifier_call = ghes_notify_hed,
 };
 
-#ifdef CONFIG_ACPI_APEI_SEA
-static LIST_HEAD(ghes_sea);
-
-/*
- * Return 0 only if one of the SEA error sources successfully reported an error
- * record sent from the firmware.
- */
-int ghes_notify_sea(void)
-{
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
-}
-
-static void ghes_sea_add(struct ghes *ghes)
-{
-	mutex_lock(&ghes_list_mutex);
-	list_add_rcu(&ghes->list, &ghes_sea);
-	mutex_unlock(&ghes_list_mutex);
-}
-
-static void ghes_sea_remove(struct ghes *ghes)
-{
-	mutex_lock(&ghes_list_mutex);
-	list_del_rcu(&ghes->list);
-	mutex_unlock(&ghes_list_mutex);
-	synchronize_rcu();
-}
-#else /* CONFIG_ACPI_APEI_SEA */
-static inline void ghes_sea_add(struct ghes *ghes) { }
-static inline void ghes_sea_remove(struct ghes *ghes) { }
-#endif /* CONFIG_ACPI_APEI_SEA */
-
 #ifdef CONFIG_HAVE_ACPI_APEI_NMI
 /*
- * printk is not safe in NMI context.  So in NMI handler, we allocate
- * required memory from lock-less memory allocator
- * (ghes_estatus_pool), save estatus into it, put them into lock-less
- * list (ghes_estatus_llist), then delay printk into IRQ context via
- * irq_work (ghes_proc_irq_work).  ghes_estatus_size_request record
- * required pool size by all NMI error source.
+ * Handlers for CPER records may not be NMI safe. For example,
+ * memory_failure_queue() takes spinlocks and calls schedule_work_on().
+ * In any NMI-like handler, memory from ghes_estatus_pool is used to save
+ * estatus, and added to the ghes_estatus_llist. irq_work_queue() causes
+ * ghes_proc_in_irq() to run in IRQ context where each estatus in
+ * ghes_estatus_llist is processed.
+ *
+ * Memory from the ghes_estatus_pool is also used with the ghes_estatus_cache
+ * to suppress frequent messages.
  */
 static struct llist_head ghes_estatus_llist;
 static struct irq_work ghes_proc_irq_work;
 
-/*
- * NMI may be triggered on any CPU, so ghes_in_nmi is used for
- * having only one concurrent reader.
- */
-static atomic_t ghes_in_nmi = ATOMIC_INIT(0);
-
-static LIST_HEAD(ghes_nmi);
-
 static void ghes_proc_in_irq(struct irq_work *irq_work)
 {
 	struct llist_node *llnode, *next;
@@ -949,6 +904,56 @@ static int ghes_in_nmi_spool_from_list(struct list_head *rcu_list)
 
 	return ret;
 }
+#endif /* CONFIG_HAVE_ACPI_APEI_NMI */
+
+#ifdef CONFIG_ACPI_APEI_SEA
+static LIST_HEAD(ghes_sea);
+
+/*
+ * Return 0 only if one of the SEA error sources successfully reported an error
+ * record sent from the firmware.
+ */
+int ghes_notify_sea(void)
+{
+	struct ghes *ghes;
+	int ret = -ENOENT;
+
+	rcu_read_lock();
+	list_for_each_entry_rcu(ghes, &ghes_sea, list) {
+		if (!ghes_proc(ghes))
+			ret = 0;
+	}
+	rcu_read_unlock();
+	return ret;
+}
+
+static void ghes_sea_add(struct ghes *ghes)
+{
+	mutex_lock(&ghes_list_mutex);
+	list_add_rcu(&ghes->list, &ghes_sea);
+	mutex_unlock(&ghes_list_mutex);
+}
+
+static void ghes_sea_remove(struct ghes *ghes)
+{
+	mutex_lock(&ghes_list_mutex);
+	list_del_rcu(&ghes->list);
+	mutex_unlock(&ghes_list_mutex);
+	synchronize_rcu();
+}
+#else /* CONFIG_ACPI_APEI_SEA */
+static inline void ghes_sea_add(struct ghes *ghes) { }
+static inline void ghes_sea_remove(struct ghes *ghes) { }
+#endif /* CONFIG_ACPI_APEI_SEA */
+
+#ifdef CONFIG_HAVE_ACPI_APEI_NMI
+/*
+ * NMI may be triggered on any CPU, so ghes_in_nmi is used for
+ * having only one concurrent reader.
+ */
+static atomic_t ghes_in_nmi = ATOMIC_INIT(0);
+
+static LIST_HEAD(ghes_nmi);
 
 static int ghes_notify_nmi(unsigned int cmd, struct pt_regs *regs)
 {
-- 
2.20.1
