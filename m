From: James Morse <james.morse@arm.com>
Subject: [PATCH v8 24/26] arm64: acpi: Make apei_claim_sea() synchronise with
 APEI's irq work
Date: Tue, 29 Jan 2019 18:49:00 +0000
Message-ID: <20190129184902.102850-25-james.morse@arm.com>
References: <20190129184902.102850-1-james.morse@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A23684A330
 for <kvmarm@lists.cs.columbia.edu>; Tue, 29 Jan 2019 13:50:50 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id wGbHNoMFAoT3 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 29 Jan 2019 13:50:49 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 454174A2E7
 for <kvmarm@lists.cs.columbia.edu>; Tue, 29 Jan 2019 13:50:49 -0500 (EST)
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

APEI is unable to do all of its error handling work in nmi-context, so
it defers non-fatal work onto the irq_work queue. arch_irq_work_raise()
sends an IPI to the calling cpu, but this is not guaranteed to be taken
before returning to user-space.

Unless the exception interrupted a context with irqs-masked,
irq_work_run() can run immediately. Otherwise return -EINPROGRESS to
indicate ghes_notify_sea() found some work to do, but it hasn't
finished yet.

With this apei_claim_sea() returning '0' means this external-abort was
also notification of a firmware-first RAS error, and that APEI has
processed the CPER records.

Signed-off-by: James Morse <james.morse@arm.com>
Reviewed-by: Punit Agrawal <punit.agrawal@arm.com>
Tested-by: Tyler Baicar <tbaicar@codeaurora.org>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
CC: Xie XiuQi <xiexiuqi@huawei.com>
CC: gengdongjiu <gengdongjiu@huawei.com>

---
Changes since v7:
 * Added Catalin's ack, then:
 * Added __irq_enter()/exit() calls so if we interrupted preemptible code, the
   preempt count matches what other irq-work expects.
 * Changed the 'if (!arch_irqs_disabled_flags(interrupted_flags))' test to be
   safe before/after Julien's PMR series.

Changes since v6:
 * Added pr_warn() for the EINPROGRESS case so panic-tracebacks show
   'APEI was here'.
 * Tinkered with the commit message

Changes since v2:
 * Removed IS_ENABLED() check, done by the caller unless we have a dummy
   definition.
---
 arch/arm64/kernel/acpi.c | 23 +++++++++++++++++++++++
 arch/arm64/mm/fault.c    |  9 ++++-----
 2 files changed, 27 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/kernel/acpi.c b/arch/arm64/kernel/acpi.c
index 803f0494dd3e..8288ae0c8f3b 100644
--- a/arch/arm64/kernel/acpi.c
+++ b/arch/arm64/kernel/acpi.c
@@ -22,6 +22,7 @@
 #include <linux/init.h>
 #include <linux/irq.h>
 #include <linux/irqdomain.h>
+#include <linux/irq_work.h>
 #include <linux/memblock.h>
 #include <linux/of_fdt.h>
 #include <linux/smp.h>
@@ -268,12 +269,17 @@ pgprot_t __acpi_get_mem_attribute(phys_addr_t addr)
 int apei_claim_sea(struct pt_regs *regs)
 {
 	int err = -ENOENT;
+	bool return_to_irqs_enabled;
 	unsigned long current_flags;
 
 	if (!IS_ENABLED(CONFIG_ACPI_APEI_GHES))
 		return err;
 
 	current_flags = arch_local_save_flags();
+	return_to_irqs_enabled = !irqs_disabled_flags(current_flags);
+
+	if (regs)
+		return_to_irqs_enabled = interrupts_enabled(regs);
 
 	/*
 	 * SEA can interrupt SError, mask it and describe this as an NMI so
@@ -283,6 +289,23 @@ int apei_claim_sea(struct pt_regs *regs)
 	nmi_enter();
 	err = ghes_notify_sea();
 	nmi_exit();
+
+	/*
+	 * APEI NMI-like notifications are deferred to irq_work. Unless
+	 * we interrupted irqs-masked code, we can do that now.
+	 */
+	if (!err) {
+		if (return_to_irqs_enabled) {
+			local_daif_restore(DAIF_PROCCTX_NOIRQ);
+			__irq_enter();
+			irq_work_run();
+			__irq_exit();
+		} else {
+			pr_warn("APEI work queued but not completed");
+			err = -EINPROGRESS;
+		}
+	}
+
 	local_daif_restore(current_flags);
 
 	return err;
diff --git a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c
index e1c84c2e1cab..1611714f8333 100644
--- a/arch/arm64/mm/fault.c
+++ b/arch/arm64/mm/fault.c
@@ -642,11 +642,10 @@ static int do_sea(unsigned long addr, unsigned int esr, struct pt_regs *regs)
 
 	inf = esr_to_fault_info(esr);
 
-	/*
-	 * Return value ignored as we rely on signal merging.
-	 * Future patches will make this more robust.
-	 */
-	apei_claim_sea(regs);
+	if (apei_claim_sea(regs) == 0) {
+		/* APEI claimed this as a firmware-first notification */
+		return 0;
+	}
 
 	if (esr & ESR_ELx_FnV)
 		siaddr = NULL;
-- 
2.20.1
