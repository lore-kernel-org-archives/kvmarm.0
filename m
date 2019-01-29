From: James Morse <james.morse@arm.com>
Subject: [PATCH v8 15/26] ACPI / APEI: Move locking to the notification helper
Date: Tue, 29 Jan 2019 18:48:51 +0000
Message-ID: <20190129184902.102850-16-james.morse@arm.com>
References: <20190129184902.102850-1-james.morse@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 433DF4A36B
 for <kvmarm@lists.cs.columbia.edu>; Tue, 29 Jan 2019 13:50:24 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ucboRSNNJzZd for <kvmarm@lists.cs.columbia.edu>;
 Tue, 29 Jan 2019 13:50:22 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CEE964A3C6
 for <kvmarm@lists.cs.columbia.edu>; Tue, 29 Jan 2019 13:50:22 -0500 (EST)
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

ghes_copy_tofrom_phys() takes different locks depending on in_nmi().
This doesn't work if there are multiple NMI-like notifications, that
can interrupt each other.

Now that NOTIFY_SEA is always called in the same context, move the
lock-taking to the notification helper. The helper will always know
which lock to take. This avoids ghes_copy_tofrom_phys() taking a guess
based on in_nmi().

This splits NOTIFY_NMI and NOTIFY_SEA to use different locks. All
the other notifications use ghes_proc(), and are called in process
or IRQ context. Move the spin_lock_irqsave() around their ghes_proc()
calls.

Signed-off-by: James Morse <james.morse@arm.com>
Reviewed-by: Borislav Petkov <bp@suse.de>
---

Changes since v7:
 * Moved the locks into the function that uses them to make it clearer this
   is only use in_nmi().

Changes since v6:
 * Tinkered with the commit message
 * Lock definitions have moved due to the #ifdefs
---
 drivers/acpi/apei/ghes.c | 34 +++++++++++++++++++++++++---------
 1 file changed, 25 insertions(+), 9 deletions(-)

diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
index ab794ab29554..c6bc73281d6a 100644
--- a/drivers/acpi/apei/ghes.c
+++ b/drivers/acpi/apei/ghes.c
@@ -114,11 +114,10 @@ static DEFINE_MUTEX(ghes_list_mutex);
  * handler, but general ioremap can not be used in atomic context, so
  * the fixmap is used instead.
  *
- * These 2 spinlocks are used to prevent the fixmap entries from being used
+ * This spinlock is used to prevent the fixmap entry from being used
  * simultaneously.
  */
-static DEFINE_RAW_SPINLOCK(ghes_ioremap_lock_nmi);
-static DEFINE_SPINLOCK(ghes_ioremap_lock_irq);
+static DEFINE_SPINLOCK(ghes_notify_lock_irq);
 
 static struct gen_pool *ghes_estatus_pool;
 static unsigned long ghes_estatus_pool_size_request;
@@ -287,7 +286,6 @@ static void ghes_copy_tofrom_phys(void *buffer, u64 paddr, u32 len,
 				  int from_phys)
 {
 	void __iomem *vaddr;
-	unsigned long flags = 0;
 	int in_nmi = in_nmi();
 	u64 offset;
 	u32 trunk;
@@ -295,10 +293,8 @@ static void ghes_copy_tofrom_phys(void *buffer, u64 paddr, u32 len,
 	while (len > 0) {
 		offset = paddr - (paddr & PAGE_MASK);
 		if (in_nmi) {
-			raw_spin_lock(&ghes_ioremap_lock_nmi);
 			vaddr = ghes_ioremap_pfn_nmi(paddr >> PAGE_SHIFT);
 		} else {
-			spin_lock_irqsave(&ghes_ioremap_lock_irq, flags);
 			vaddr = ghes_ioremap_pfn_irq(paddr >> PAGE_SHIFT);
 		}
 		trunk = PAGE_SIZE - offset;
@@ -312,10 +308,8 @@ static void ghes_copy_tofrom_phys(void *buffer, u64 paddr, u32 len,
 		buffer += trunk;
 		if (in_nmi) {
 			ghes_iounmap_nmi();
-			raw_spin_unlock(&ghes_ioremap_lock_nmi);
 		} else {
 			ghes_iounmap_irq();
-			spin_unlock_irqrestore(&ghes_ioremap_lock_irq, flags);
 		}
 	}
 }
@@ -729,8 +723,11 @@ static void ghes_add_timer(struct ghes *ghes)
 static void ghes_poll_func(struct timer_list *t)
 {
 	struct ghes *ghes = from_timer(ghes, t, timer);
+	unsigned long flags;
 
+	spin_lock_irqsave(&ghes_notify_lock_irq, flags);
 	ghes_proc(ghes);
+	spin_unlock_irqrestore(&ghes_notify_lock_irq, flags);
 	if (!(ghes->flags & GHES_EXITING))
 		ghes_add_timer(ghes);
 }
@@ -738,9 +735,12 @@ static void ghes_poll_func(struct timer_list *t)
 static irqreturn_t ghes_irq_func(int irq, void *data)
 {
 	struct ghes *ghes = data;
+	unsigned long flags;
 	int rc;
 
+	spin_lock_irqsave(&ghes_notify_lock_irq, flags);
 	rc = ghes_proc(ghes);
+	spin_unlock_irqrestore(&ghes_notify_lock_irq, flags);
 	if (rc)
 		return IRQ_NONE;
 
@@ -751,14 +751,17 @@ static int ghes_notify_hed(struct notifier_block *this, unsigned long event,
 			   void *data)
 {
 	struct ghes *ghes;
+	unsigned long flags;
 	int ret = NOTIFY_DONE;
 
+	spin_lock_irqsave(&ghes_notify_lock_irq, flags);
 	rcu_read_lock();
 	list_for_each_entry_rcu(ghes, &ghes_hed, list) {
 		if (!ghes_proc(ghes))
 			ret = NOTIFY_OK;
 	}
 	rcu_read_unlock();
+	spin_unlock_irqrestore(&ghes_notify_lock_irq, flags);
 
 	return ret;
 }
@@ -913,7 +916,14 @@ static LIST_HEAD(ghes_sea);
  */
 int ghes_notify_sea(void)
 {
-	return ghes_in_nmi_spool_from_list(&ghes_sea);
+	static DEFINE_RAW_SPINLOCK(ghes_notify_lock_sea);
+	int rv;
+
+	raw_spin_lock(&ghes_notify_lock_sea);
+	rv = ghes_in_nmi_spool_from_list(&ghes_sea);
+	raw_spin_unlock(&ghes_notify_lock_sea);
+
+	return rv;
 }
 
 static void ghes_sea_add(struct ghes *ghes)
@@ -946,14 +956,17 @@ static LIST_HEAD(ghes_nmi);
 
 static int ghes_notify_nmi(unsigned int cmd, struct pt_regs *regs)
 {
+	static DEFINE_RAW_SPINLOCK(ghes_notify_lock_nmi);
 	int err, ret = NMI_DONE;
 
 	if (!atomic_add_unless(&ghes_in_nmi, 1, 1))
 		return ret;
 
+	raw_spin_lock(&ghes_notify_lock_nmi);
 	err = ghes_in_nmi_spool_from_list(&ghes_nmi);
 	if (!err)
 		ret = NMI_HANDLED;
+	raw_spin_unlock(&ghes_notify_lock_nmi);
 
 	atomic_dec(&ghes_in_nmi);
 	return ret;
@@ -995,6 +1008,7 @@ static int ghes_probe(struct platform_device *ghes_dev)
 {
 	struct acpi_hest_generic *generic;
 	struct ghes *ghes = NULL;
+	unsigned long flags;
 
 	int rc = -EINVAL;
 
@@ -1097,7 +1111,9 @@ static int ghes_probe(struct platform_device *ghes_dev)
 	ghes_edac_register(ghes, &ghes_dev->dev);
 
 	/* Handle any pending errors right away */
+	spin_lock_irqsave(&ghes_notify_lock_irq, flags);
 	ghes_proc(ghes);
+	spin_unlock_irqrestore(&ghes_notify_lock_irq, flags);
 
 	return 0;
 
-- 
2.20.1
