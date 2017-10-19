From: James Morse <james.morse@arm.com>
Subject: [PATCH v4 12/21] arm64: kernel: Survive corrected RAS errors notified
 by SError
Date: Thu, 19 Oct 2017 15:57:58 +0100
Message-ID: <20171019145807.23251-13-james.morse@arm.com>
References: <20171019145807.23251-1-james.morse@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5333949D2B
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Oct 2017 10:59:28 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id RPOvFAlbkjrf for <kvmarm@lists.cs.columbia.edu>;
 Thu, 19 Oct 2017 10:59:21 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CB96140A74
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Oct 2017 10:59:21 -0400 (EDT)
In-Reply-To: <20171019145807.23251-1-james.morse@arm.com>
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
Cc: Jonathan.Zhang@cavium.com, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Julien Thierry <julien.thierry@arm.com>, Will Deacon <will.deacon@arm.com>, wangxiongfeng2@huawei.com, Dongjiu Geng <gengdongjiu@huawei.com>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Prior to v8.2, SError is an uncontainable fatal exception. The v8.2 RAS
extensions use SError to notify software about RAS errors, these can be
contained by the ESB instruction.

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
I couldn't come up with a concise way to capture 'can continue to make
progress', so opted for 'blocking' instead.

 arch/arm64/include/asm/esr.h   | 10 ++++++++
 arch/arm64/include/asm/traps.h | 36 ++++++++++++++++++++++++++
 arch/arm64/kernel/traps.c      | 58 ++++++++++++++++++++++++++++++++++++++----
 3 files changed, 99 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/include/asm/esr.h b/arch/arm64/include/asm/esr.h
index 66ed8b6b9976..8ea52f15bf1c 100644
--- a/arch/arm64/include/asm/esr.h
+++ b/arch/arm64/include/asm/esr.h
@@ -85,6 +85,15 @@
 #define ESR_ELx_WNR_SHIFT	(6)
 #define ESR_ELx_WNR		(UL(1) << ESR_ELx_WNR_SHIFT)
 
+/* Asynchronous Error Type */
+#define ESR_ELx_AET		(UL(0x7) << 10)
+
+#define ESR_ELx_AET_UC		(UL(0) << 10)	/* Uncontainable */
+#define ESR_ELx_AET_UEU		(UL(1) << 10)	/* Uncorrected Unrecoverable */
+#define ESR_ELx_AET_UEO		(UL(2) << 10)	/* Uncorrected Restartable */
+#define ESR_ELx_AET_UER		(UL(3) << 10)	/* Uncorrected Recoverable */
+#define ESR_ELx_AET_CE		(UL(6) << 10)	/* Corrected */
+
 /* Shared ISS field definitions for Data/Instruction aborts */
 #define ESR_ELx_SET_SHIFT	(11)
 #define ESR_ELx_SET_MASK	(UL(3) << ESR_ELx_SET_SHIFT)
@@ -99,6 +108,7 @@
 #define ESR_ELx_FSC		(0x3F)
 #define ESR_ELx_FSC_TYPE	(0x3C)
 #define ESR_ELx_FSC_EXTABT	(0x10)
+#define ESR_ELx_FSC_SERROR	(0x11)
 #define ESR_ELx_FSC_ACCESS	(0x08)
 #define ESR_ELx_FSC_FAULT	(0x04)
 #define ESR_ELx_FSC_PERM	(0x0C)
diff --git a/arch/arm64/include/asm/traps.h b/arch/arm64/include/asm/traps.h
index d131501c6222..8d2a1fff5c6b 100644
--- a/arch/arm64/include/asm/traps.h
+++ b/arch/arm64/include/asm/traps.h
@@ -19,6 +19,7 @@
 #define __ASM_TRAP_H
 
 #include <linux/list.h>
+#include <asm/esr.h>
 #include <asm/sections.h>
 
 struct pt_regs;
@@ -58,4 +59,39 @@ static inline int in_entry_text(unsigned long ptr)
 	return ptr >= (unsigned long)&__entry_text_start &&
 	       ptr < (unsigned long)&__entry_text_end;
 }
+
+static inline bool arm64_is_ras_serror(u32 esr)
+{
+	bool impdef = esr & ESR_ELx_ISV; /* aka IDS */
+
+	if (cpus_have_const_cap(ARM64_HAS_RAS_EXTN))
+		return !impdef;
+
+	return false;
+}
+
+/* Return the AET bits of an SError ESR, or 0/uncontainable/uncategorized */
+static inline u32 arm64_ras_serror_get_severity(u32 esr)
+{
+	u32 aet = esr & ESR_ELx_AET;
+
+	if (!arm64_is_ras_serror(esr)) {
+		/* Not a RAS error, we can't interpret the ESR */
+		return 0;
+	}
+
+	/*
+	 * AET is RES0 if 'the value returned in the DFSC field is not
+	 * [ESR_ELx_FSC_SERROR]'
+	 */
+	if ((esr & ESR_ELx_FSC) != ESR_ELx_FSC_SERROR) {
+		/* No severity information */
+		return 0;
+	}
+
+	return aet;
+}
+
+bool arm64_blocking_ras_serror(struct pt_regs *regs, unsigned int esr);
+void __noreturn arm64_serror_panic(struct pt_regs *regs, u32 esr);
 #endif
diff --git a/arch/arm64/kernel/traps.c b/arch/arm64/kernel/traps.c
index 773aae69c376..53aeb25158b0 100644
--- a/arch/arm64/kernel/traps.c
+++ b/arch/arm64/kernel/traps.c
@@ -709,17 +709,65 @@ asmlinkage void handle_bad_stack(struct pt_regs *regs)
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
+	/* KVM may call this this from a preemptible context */
+	preempt_disable();
+
+	/*
+	 * panic() unmasks interrupts, which unmasks SError. Use nmi_panic()
+	 * to avoid re-entering panic.
+	 */
+	nmi_panic(regs, "Asynchronous SError Interrupt");
+
+	cpu_park_loop();
+	unreachable();
+}
+
+bool arm64_blocking_ras_serror(struct pt_regs *regs, unsigned int esr)
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
+	case ESR_ELx_AET_UC:	/* Uncontainable error */
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
+	if (!arm64_is_ras_serror(esr) || arm64_blocking_ras_serror(regs, esr))
+		arm64_serror_panic(regs, esr);
 
-	panic("Asynchronous SError Interrupt");
+	nmi_exit();
 }
 
 void __pte_error(const char *file, int line, unsigned long val)
-- 
2.13.3
