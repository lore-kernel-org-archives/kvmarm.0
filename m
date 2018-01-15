From: James Morse <james.morse@arm.com>
Subject: [PATCH v6 04/13] arm64: kernel: Survive corrected RAS errors notified
 by SError
Date: Mon, 15 Jan 2018 19:38:57 +0000
Message-ID: <20180115193906.30053-5-james.morse@arm.com>
References: <20180115193906.30053-1-james.morse@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 95F2549E1D
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Jan 2018 14:36:45 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 9pXr0ehKBPAm for <kvmarm@lists.cs.columbia.edu>;
 Mon, 15 Jan 2018 14:36:44 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5043A49E15
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Jan 2018 14:36:44 -0500 (EST)
In-Reply-To: <20180115193906.30053-1-james.morse@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-arm-kernel@lists.infradead.org
Cc: Jonathan.Zhang@cavium.com, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Dongjiu Geng <gengdongjiu@huawei.com>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Prior to v8.2, SError is an uncontainable fatal exception. The v8.2 RAS
extensions use SError to notify software about RAS errors, these can be
contained by the Error Syncronization Barrier.

An ACPI system with firmware-first may use SError as its 'SEI'
notification. Future patches may add code to 'claim' this SError as a
notification.

Other systems can distinguish these RAS errors from the SError ESR and
use the AET bits and additional data from RAS-Error registers to handle
the error. Future patches may add this kernel-first handling.

Without support for either of these we will panic(), even if we received
a corrected error. Add code to decode the severity of RAS errors. We can
safely ignore contained errors where the CPU can continue to make
progress. For all other errors we continue to panic().

Signed-off-by: James Morse <james.morse@arm.com>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
---
Changes since v4:
 * Reworded 'blocking' to 'fatal'.
 * Added AET_SHIFT define
 * Check local CPU caps to allow survivable contained SError on systems where
   some CPUs have RAS support and some don't.
 * Clarified where we are merging uncategorized and uncontained. Mostly
   comments and swapping '0' for a macro defined as 0.
   Note: These two share an encoding on aarch32.
 * Removed preempt bodge, KVM now calls this from a non-preemtible location.

(all of which I think are minor)


 arch/arm64/include/asm/esr.h   | 13 ++++++++++
 arch/arm64/include/asm/traps.h | 54 ++++++++++++++++++++++++++++++++++++++++++
 arch/arm64/kernel/traps.c      | 51 +++++++++++++++++++++++++++++++++++----
 3 files changed, 113 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/include/asm/esr.h b/arch/arm64/include/asm/esr.h
index 014d7d8edcf9..c367838700fa 100644
--- a/arch/arm64/include/asm/esr.h
+++ b/arch/arm64/include/asm/esr.h
@@ -86,6 +86,18 @@
 #define ESR_ELx_WNR_SHIFT	(6)
 #define ESR_ELx_WNR		(UL(1) << ESR_ELx_WNR_SHIFT)
 
+/* Asynchronous Error Type */
+#define ESR_ELx_IDS_SHIFT	(24)
+#define ESR_ELx_IDS		(UL(1) << ESR_ELx_IDS_SHIFT)
+#define ESR_ELx_AET_SHIFT	(10)
+#define ESR_ELx_AET		(UL(0x7) << ESR_ELx_AET_SHIFT)
+
+#define ESR_ELx_AET_UC		(UL(0) << ESR_ELx_AET_SHIFT)
+#define ESR_ELx_AET_UEU		(UL(1) << ESR_ELx_AET_SHIFT)
+#define ESR_ELx_AET_UEO		(UL(2) << ESR_ELx_AET_SHIFT)
+#define ESR_ELx_AET_UER		(UL(3) << ESR_ELx_AET_SHIFT)
+#define ESR_ELx_AET_CE		(UL(6) << ESR_ELx_AET_SHIFT)
+
 /* Shared ISS field definitions for Data/Instruction aborts */
 #define ESR_ELx_SET_SHIFT	(11)
 #define ESR_ELx_SET_MASK	(UL(3) << ESR_ELx_SET_SHIFT)
@@ -100,6 +112,7 @@
 #define ESR_ELx_FSC		(0x3F)
 #define ESR_ELx_FSC_TYPE	(0x3C)
 #define ESR_ELx_FSC_EXTABT	(0x10)
+#define ESR_ELx_FSC_SERROR	(0x11)
 #define ESR_ELx_FSC_ACCESS	(0x08)
 #define ESR_ELx_FSC_FAULT	(0x04)
 #define ESR_ELx_FSC_PERM	(0x0C)
diff --git a/arch/arm64/include/asm/traps.h b/arch/arm64/include/asm/traps.h
index 1696f9de9359..178e338d2889 100644
--- a/arch/arm64/include/asm/traps.h
+++ b/arch/arm64/include/asm/traps.h
@@ -19,6 +19,7 @@
 #define __ASM_TRAP_H
 
 #include <linux/list.h>
+#include <asm/esr.h>
 #include <asm/sections.h>
 
 struct pt_regs;
@@ -66,4 +67,57 @@ static inline int in_entry_text(unsigned long ptr)
 	return ptr >= (unsigned long)&__entry_text_start &&
 	       ptr < (unsigned long)&__entry_text_end;
 }
+
+/*
+ * CPUs with the RAS extensions have an Implementation-Defined-Syndrome bit
+ * to indicate whether this ESR has a RAS encoding. CPUs without this feature
+ * have a ISS-Valid bit in the same position.
+ * If this bit is set, we know its not a RAS SError.
+ * If its clear, we need to know if the CPU supports RAS. Uncategorized RAS
+ * errors share the same encoding as an all-zeros encoding from a CPU that
+ * doesn't support RAS.
+ */
+static inline bool arm64_is_ras_serror(u32 esr)
+{
+	WARN_ON(preemptible());
+
+	if (esr & ESR_ELx_IDS)
+		return false;
+
+	if (this_cpu_has_cap(ARM64_HAS_RAS_EXTN))
+		return true;
+	else
+		return false;
+}
+
+/*
+ * Return the AET bits from a RAS SError's ESR.
+ *
+ * It is implementation defined whether Uncategorized errors are containable.
+ * We treat them as Uncontainable.
+ * Non-RAS SError's are reported as Uncontained/Uncategorized.
+ */
+static inline u32 arm64_ras_serror_get_severity(u32 esr)
+{
+	u32 aet = esr & ESR_ELx_AET;
+
+	if (!arm64_is_ras_serror(esr)) {
+		/* Not a RAS error, we can't interpret the ESR. */
+		return ESR_ELx_AET_UC;
+	}
+
+	/*
+	 * AET is RES0 if 'the value returned in the DFSC field is not
+	 * [ESR_ELx_FSC_SERROR]'
+	 */
+	if ((esr & ESR_ELx_FSC) != ESR_ELx_FSC_SERROR) {
+		/* No severity information : Uncategorized */
+		return ESR_ELx_AET_UC;
+	}
+
+	return aet;
+}
+
+bool arm64_is_fatal_ras_serror(struct pt_regs *regs, unsigned int esr);
+void __noreturn arm64_serror_panic(struct pt_regs *regs, u32 esr);
 #endif
diff --git a/arch/arm64/kernel/traps.c b/arch/arm64/kernel/traps.c
index 3d3588fcd1c7..bbb0fde2780e 100644
--- a/arch/arm64/kernel/traps.c
+++ b/arch/arm64/kernel/traps.c
@@ -662,17 +662,58 @@ asmlinkage void handle_bad_stack(struct pt_regs *regs)
 }
 #endif
 
-asmlinkage void do_serror(struct pt_regs *regs, unsigned int esr)
+void __noreturn arm64_serror_panic(struct pt_regs *regs, u32 esr)
 {
-	nmi_enter();
-
 	console_verbose();
 
 	pr_crit("SError Interrupt on CPU%d, code 0x%08x -- %s\n",
 		smp_processor_id(), esr, esr_get_class_string(esr));
-	__show_regs(regs);
+	if (regs)
+		__show_regs(regs);
+
+	nmi_panic(regs, "Asynchronous SError Interrupt");
+
+	cpu_park_loop();
+	unreachable();
+}
+
+bool arm64_is_fatal_ras_serror(struct pt_regs *regs, unsigned int esr)
+{
+	u32 aet = arm64_ras_serror_get_severity(esr);
+
+	switch (aet) {
+	case ESR_ELx_AET_CE:	/* corrected error */
+	case ESR_ELx_AET_UEO:	/* restartable, not yet consumed */
+		/*
+		 * The CPU can make progress. We may take UEO again as
+		 * a more severe error.
+		 */
+		return false;
+
+	case ESR_ELx_AET_UEU:	/* Uncorrected Unrecoverable */
+	case ESR_ELx_AET_UER:	/* Uncorrected Recoverable */
+		/*
+		 * The CPU can't make progress. The exception may have
+		 * been imprecise.
+		 */
+		return true;
+
+	case ESR_ELx_AET_UC:	/* Uncontainable or Uncategorized error */
+	default:
+		/* Error has been silently propagated */
+		arm64_serror_panic(regs, esr);
+	}
+}
+
+asmlinkage void do_serror(struct pt_regs *regs, unsigned int esr)
+{
+	nmi_enter();
+
+	/* non-RAS errors are not containable */
+	if (!arm64_is_ras_serror(esr) || arm64_is_fatal_ras_serror(regs, esr))
+		arm64_serror_panic(regs, esr);
 
-	panic("Asynchronous SError Interrupt");
+	nmi_exit();
 }
 
 void __pte_error(const char *file, int line, unsigned long val)
-- 
2.15.1
