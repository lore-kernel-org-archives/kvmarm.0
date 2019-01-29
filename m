From: James Morse <james.morse@arm.com>
Subject: [PATCH v8 09/26] ACPI / APEI: Generalise the estatus queue's notify
 code
Date: Tue, 29 Jan 2019 18:48:45 +0000
Message-ID: <20190129184902.102850-10-james.morse@arm.com>
References: <20190129184902.102850-1-james.morse@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B4C8F4A2D3
 for <kvmarm@lists.cs.columbia.edu>; Tue, 29 Jan 2019 13:50:06 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id viQv2oVmP06R for <kvmarm@lists.cs.columbia.edu>;
 Tue, 29 Jan 2019 13:50:05 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 590A949E3E
 for <kvmarm@lists.cs.columbia.edu>; Tue, 29 Jan 2019 13:50:05 -0500 (EST)
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

Refactor the estatus queue's pool notification routine from
NOTIFY_NMI's handlers. This will allow another notification
method to use the estatus queue without duplicating this code.

Add rcu_read_lock()/rcu_read_unlock() around the list
list_for_each_entry_rcu() walker. These aren't strictly necessary as
the whole nmi_enter/nmi_exit() window is a spooky RCU read-side
critical section.

in_nmi_queue_one_entry() is separate from the rcu-list walker for a
later caller that doesn't need to walk a list.

Signed-off-by: James Morse <james.morse@arm.com>
Reviewed-by: Punit Agrawal <punit.agrawal@arm.com>
Tested-by: Tyler Baicar <tbaicar@codeaurora.org>

---
Changes since v7:
 * Moved err= onto a separate line to make this more readable
 * Dropped ghes_ prefix on new static functions
 * Renamed stuff, 'notify' has an overloaded meaning,

Changes since v6:
 * Removed pool grow/remove code as this is no longer necessary.

Changes since v3:
 * Removed duplicate or redundant paragraphs in commit message.
 * Fixed the style of a zero check.
Changes since v1:
   * Tidied up _in_nmi_notify_one().
---
 drivers/acpi/apei/ghes.c | 65 ++++++++++++++++++++++++++--------------
 1 file changed, 43 insertions(+), 22 deletions(-)

diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
index af3c10f47f20..cb3d88de711f 100644
--- a/drivers/acpi/apei/ghes.c
+++ b/drivers/acpi/apei/ghes.c
@@ -912,37 +912,58 @@ static void __process_error(struct ghes *ghes)
 #endif
 }
 
-static int ghes_notify_nmi(unsigned int cmd, struct pt_regs *regs)
+static int ghes_in_nmi_queue_one_entry(struct ghes *ghes)
 {
 	u64 buf_paddr;
-	struct ghes *ghes;
-	int sev, ret = NMI_DONE;
+	int sev;
 
-	if (!atomic_add_unless(&ghes_in_nmi, 1, 1))
-		return ret;
+	if (ghes_read_estatus(ghes, &buf_paddr)) {
+		ghes_clear_estatus(ghes, buf_paddr);
+		return -ENOENT;
+	}
 
-	list_for_each_entry_rcu(ghes, &ghes_nmi, list) {
-		if (ghes_read_estatus(ghes, &buf_paddr)) {
-			ghes_clear_estatus(ghes, buf_paddr);
-			continue;
-		} else {
-			ret = NMI_HANDLED;
-		}
+	sev = ghes_severity(ghes->estatus->error_severity);
+	if (sev >= GHES_SEV_PANIC) {
+		ghes_print_queued_estatus();
+		__ghes_panic(ghes, buf_paddr);
+	}
 
-		sev = ghes_severity(ghes->estatus->error_severity);
-		if (sev >= GHES_SEV_PANIC) {
-			ghes_print_queued_estatus();
-			__ghes_panic(ghes, buf_paddr);
-		}
+	__process_error(ghes);
+	ghes_clear_estatus(ghes, buf_paddr);
 
-		__process_error(ghes);
-		ghes_clear_estatus(ghes, buf_paddr);
+	return 0;
+}
+
+static int ghes_in_nmi_spool_from_list(struct list_head *rcu_list)
+{
+	int err, ret = -ENOENT;
+	struct ghes *ghes;
+
+	rcu_read_lock();
+	list_for_each_entry_rcu(ghes, rcu_list, list) {
+		err = ghes_in_nmi_queue_one_entry(ghes);
+		if (!err)
+			ret = 0;
 	}
+	rcu_read_unlock();
 
-#ifdef CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG
-	if (ret == NMI_HANDLED)
+	if (IS_ENABLED(CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG) && !ret)
 		irq_work_queue(&ghes_proc_irq_work);
-#endif
+
+	return ret;
+}
+
+static int ghes_notify_nmi(unsigned int cmd, struct pt_regs *regs)
+{
+	int err, ret = NMI_DONE;
+
+	if (!atomic_add_unless(&ghes_in_nmi, 1, 1))
+		return ret;
+
+	err = ghes_in_nmi_spool_from_list(&ghes_nmi);
+	if (!err)
+		ret = NMI_HANDLED;
+
 	atomic_dec(&ghes_in_nmi);
 	return ret;
 }
-- 
2.20.1
