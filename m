From: James Morse <james.morse@arm.com>
Subject: [PATCH v7 14/25] arm64: KVM/mm: Move SEA handling behind a single
 'claim' interface
Date: Mon,  3 Dec 2018 18:06:02 +0000
Message-ID: <20181203180613.228133-15-james.morse@arm.com>
References: <20181203180613.228133-1-james.morse@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BD65E4A214
 for <kvmarm@lists.cs.columbia.edu>; Mon,  3 Dec 2018 13:07:29 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Oo9f0F3U-jQ3 for <kvmarm@lists.cs.columbia.edu>;
 Mon,  3 Dec 2018 13:07:28 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C151C4A332
 for <kvmarm@lists.cs.columbia.edu>; Mon,  3 Dec 2018 13:07:27 -0500 (EST)
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

To split up APEIs in_nmi() path, the caller needs to always be
in_nmi(). Add a helper to do the work and claim the notification.

When KVM or the arch code takes an exception that might be a RAS
notification, it asks the APEI firmware-first code whether it wants
to claim the exception. A future kernel-first mechanism may be queried
afterwards, and claim the notification, otherwise we fall through
to the existing default behaviour.

The NOTIFY_SEA code was merged before considering multiple, possibly
interacting, NMI-like notifications and the need to consider kernel
first in the future. Make the 'claiming' behaviour explicit.

Restructuring the APEI code to allow multiple NMI-like notifications
means any notification that might interrupt interrupts-masked
code must always be wrapped in nmi_enter()/nmi_exit(). This will
allow APEI to use in_nmi() to use the right fixmap entries.

Mask SError over this window to prevent an asynchronous RAS error
arriving and tripping 'nmi_enter()'s BUG_ON(in_nmi()).

Signed-off-by: James Morse <james.morse@arm.com>
Acked-by: Marc Zyngier <marc.zyngier@arm.com>
Tested-by: Tyler Baicar <tbaicar@codeaurora.org>

---
Why does apei_claim_sea() take a pt_regs? This gets used later to take
APEI by the hand through NMI->IRQ context, depending on what we
interrupted.

Changes since v6:
 * Moved the voice of the commit message.
 * moved arch_local_save_flags() below the !IS_ENABLED drop-out
 * Moved the dummy declaration into the if-ACPI part of the header instead
   of if-APEI.

Changes since v4:
 * Made irqs-unmasked comment a lockdep assert.

Changes since v3:
 * Removed spurious whitespace change
 * Updated comment in acpi.c to cover SError masking

Changes since v2:
 * Added dummy definition for !ACPI and culled IS_ENABLED() checks.
---
 arch/arm64/include/asm/acpi.h      |  4 +++-
 arch/arm64/include/asm/daifflags.h |  1 +
 arch/arm64/include/asm/kvm_ras.h   | 16 ++++++++++++++-
 arch/arm64/kernel/acpi.c           | 31 ++++++++++++++++++++++++++++++
 arch/arm64/mm/fault.c              | 24 +++++------------------
 5 files changed, 55 insertions(+), 21 deletions(-)

diff --git a/arch/arm64/include/asm/acpi.h b/arch/arm64/include/asm/acpi.h
index 709208dfdc8b..4ed19b26ec1a 100644
--- a/arch/arm64/include/asm/acpi.h
+++ b/arch/arm64/include/asm/acpi.h
@@ -18,6 +18,7 @@
 
 #include <asm/cputype.h>
 #include <asm/io.h>
+#include <asm/ptrace.h>
 #include <asm/smp_plat.h>
 #include <asm/tlbflush.h>
 
@@ -99,9 +100,10 @@ static inline u32 get_acpi_id_for_cpu(unsigned int cpu)
 
 static inline void arch_fix_phys_package_id(int num, u32 slot) { }
 void __init acpi_init_cpus(void);
-
+int apei_claim_sea(struct pt_regs *regs);
 #else
 static inline void acpi_init_cpus(void) { }
+static inline int apei_claim_sea(struct pt_regs *regs) { return -ENOENT; }
 #endif /* CONFIG_ACPI */
 
 #ifdef CONFIG_ARM64_ACPI_PARKING_PROTOCOL
diff --git a/arch/arm64/include/asm/daifflags.h b/arch/arm64/include/asm/daifflags.h
index 8d91f2233135..fa90779fc752 100644
--- a/arch/arm64/include/asm/daifflags.h
+++ b/arch/arm64/include/asm/daifflags.h
@@ -20,6 +20,7 @@
 
 #define DAIF_PROCCTX		0
 #define DAIF_PROCCTX_NOIRQ	PSR_I_BIT
+#define DAIF_ERRCTX		(PSR_I_BIT | PSR_A_BIT)
 
 /* mask/save/unmask/restore all exceptions, including interrupts. */
 static inline void local_daif_mask(void)
diff --git a/arch/arm64/include/asm/kvm_ras.h b/arch/arm64/include/asm/kvm_ras.h
index 6096f0251812..8ac6ee77437c 100644
--- a/arch/arm64/include/asm/kvm_ras.h
+++ b/arch/arm64/include/asm/kvm_ras.h
@@ -4,8 +4,22 @@
 #ifndef __ARM64_KVM_RAS_H__
 #define __ARM64_KVM_RAS_H__
 
+#include <linux/acpi.h>
+#include <linux/errno.h>
 #include <linux/types.h>
 
-int kvm_handle_guest_sea(phys_addr_t addr, unsigned int esr);
+#include <asm/acpi.h>
+
+/*
+ * Was this synchronous external abort a RAS notification?
+ * Returns '0' for errors handled by some RAS subsystem, or -ENOENT.
+ */
+static inline int kvm_handle_guest_sea(phys_addr_t addr, unsigned int esr)
+{
+	/* apei_claim_sea(NULL) expects to mask interrupts itself */
+	lockdep_assert_irqs_enabled();
+
+	return apei_claim_sea(NULL);
+}
 
 #endif /* __ARM64_KVM_RAS_H__ */
diff --git a/arch/arm64/kernel/acpi.c b/arch/arm64/kernel/acpi.c
index 44e3c351e1ea..803f0494dd3e 100644
--- a/arch/arm64/kernel/acpi.c
+++ b/arch/arm64/kernel/acpi.c
@@ -27,8 +27,10 @@
 #include <linux/smp.h>
 #include <linux/serial_core.h>
 
+#include <acpi/ghes.h>
 #include <asm/cputype.h>
 #include <asm/cpu_ops.h>
+#include <asm/daifflags.h>
 #include <asm/pgtable.h>
 #include <asm/smp_plat.h>
 
@@ -256,3 +258,32 @@ pgprot_t __acpi_get_mem_attribute(phys_addr_t addr)
 		return __pgprot(PROT_NORMAL_NC);
 	return __pgprot(PROT_DEVICE_nGnRnE);
 }
+
+/*
+ * Claim Synchronous External Aborts as a firmware first notification.
+ *
+ * Used by KVM and the arch do_sea handler.
+ * @regs may be NULL when called from process context.
+ */
+int apei_claim_sea(struct pt_regs *regs)
+{
+	int err = -ENOENT;
+	unsigned long current_flags;
+
+	if (!IS_ENABLED(CONFIG_ACPI_APEI_GHES))
+		return err;
+
+	current_flags = arch_local_save_flags();
+
+	/*
+	 * SEA can interrupt SError, mask it and describe this as an NMI so
+	 * that APEI defers the handling.
+	 */
+	local_daif_restore(DAIF_ERRCTX);
+	nmi_enter();
+	err = ghes_notify_sea();
+	nmi_exit();
+	local_daif_restore(current_flags);
+
+	return err;
+}
diff --git a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c
index eeeb576b33d7..956afc7d932a 100644
--- a/arch/arm64/mm/fault.c
+++ b/arch/arm64/mm/fault.c
@@ -18,6 +18,7 @@
  * along with this program.  If not, see <http://www.gnu.org/licenses/>.
  */
 
+#include <linux/acpi.h>
 #include <linux/extable.h>
 #include <linux/signal.h>
 #include <linux/mm.h>
@@ -33,6 +34,7 @@
 #include <linux/preempt.h>
 #include <linux/hugetlb.h>
 
+#include <asm/acpi.h>
 #include <asm/bug.h>
 #include <asm/cmpxchg.h>
 #include <asm/cpufeature.h>
@@ -46,8 +48,6 @@
 #include <asm/tlbflush.h>
 #include <asm/traps.h>
 
-#include <acpi/ghes.h>
-
 struct fault_info {
 	int	(*fn)(unsigned long addr, unsigned int esr,
 		      struct pt_regs *regs);
@@ -630,19 +630,10 @@ static int do_sea(unsigned long addr, unsigned int esr, struct pt_regs *regs)
 	inf = esr_to_fault_info(esr);
 
 	/*
-	 * Synchronous aborts may interrupt code which had interrupts masked.
-	 * Before calling out into the wider kernel tell the interested
-	 * subsystems.
+	 * Return value ignored as we rely on signal merging.
+	 * Future patches will make this more robust.
 	 */
-	if (IS_ENABLED(CONFIG_ACPI_APEI_SEA)) {
-		if (interrupts_enabled(regs))
-			nmi_enter();
-
-		ghes_notify_sea();
-
-		if (interrupts_enabled(regs))
-			nmi_exit();
-	}
+	apei_claim_sea(regs);
 
 	if (esr & ESR_ELx_FnV)
 		siaddr = NULL;
@@ -720,11 +711,6 @@ static const struct fault_info fault_info[] = {
 	{ do_bad,		SIGKILL, SI_KERNEL,	"unknown 63"			},
 };
 
-int kvm_handle_guest_sea(phys_addr_t addr, unsigned int esr)
-{
-	return ghes_notify_sea();
-}
-
 asmlinkage void __exception do_mem_abort(unsigned long addr, unsigned int esr,
 					 struct pt_regs *regs)
 {
-- 
2.19.2
