From: James Morse <james.morse@arm.com>
Subject: [PATCH v6 06/13] arm64: kernel: Prepare for a DISR user
Date: Mon, 15 Jan 2018 19:38:59 +0000
Message-ID: <20180115193906.30053-7-james.morse@arm.com>
References: <20180115193906.30053-1-james.morse@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AD83749DFA
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Jan 2018 14:36:50 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id CCZdJ1eON2Sh for <kvmarm@lists.cs.columbia.edu>;
 Mon, 15 Jan 2018 14:36:49 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6540449DFD
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Jan 2018 14:36:49 -0500 (EST)
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

KVM would like to consume any pending SError (or RAS error) after guest
exit. Today it has to unmask SError and use dsb+isb to synchronise the
CPU. With the RAS extensions we can use ESB to synchronise any pending
SError.

Add the necessary macros to allow DISR to be read and converted to an
ESR.

We clear the DISR register when we enable the RAS cpufeature, and the
kernel has not executed any ESB instructions. Any value we find in DISR
must have belonged to firmware. Executing an ESB instruction is the
only way to update DISR, so we can expect firmware to have handled
any deferred SError. By the same logic we clear DISR in the idle path.

Signed-off-by: James Morse <james.morse@arm.com>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
---
Changes since v4:
 * Corrected 'we ran ESB()' in the commit message.

 arch/arm64/include/asm/assembler.h |  7 +++++++
 arch/arm64/include/asm/esr.h       |  7 +++++++
 arch/arm64/include/asm/exception.h | 14 ++++++++++++++
 arch/arm64/include/asm/processor.h |  1 +
 arch/arm64/include/asm/sysreg.h    |  1 +
 arch/arm64/kernel/cpufeature.c     |  9 +++++++++
 arch/arm64/mm/proc.S               |  5 +++++
 7 files changed, 44 insertions(+)

diff --git a/arch/arm64/include/asm/assembler.h b/arch/arm64/include/asm/assembler.h
index 5dc4856f3bb9..40e506b32cb6 100644
--- a/arch/arm64/include/asm/assembler.h
+++ b/arch/arm64/include/asm/assembler.h
@@ -108,6 +108,13 @@
 	dmb	\opt
 	.endm
 
+/*
+ * RAS Error Synchronization barrier
+ */
+	.macro  esb
+	hint    #16
+	.endm
+
 /*
  * NOP sequence
  */
diff --git a/arch/arm64/include/asm/esr.h b/arch/arm64/include/asm/esr.h
index c367838700fa..803443d74926 100644
--- a/arch/arm64/include/asm/esr.h
+++ b/arch/arm64/include/asm/esr.h
@@ -140,6 +140,13 @@
 #define ESR_ELx_WFx_ISS_WFE	(UL(1) << 0)
 #define ESR_ELx_xVC_IMM_MASK	((1UL << 16) - 1)
 
+#define DISR_EL1_IDS		(UL(1) << 24)
+/*
+ * DISR_EL1 and ESR_ELx share the bottom 13 bits, but the RES0 bits may mean
+ * different things in the future...
+ */
+#define DISR_EL1_ESR_MASK	(ESR_ELx_AET | ESR_ELx_EA | ESR_ELx_FSC)
+
 /* ESR value templates for specific events */
 
 /* BRK instruction trap from AArch64 state */
diff --git a/arch/arm64/include/asm/exception.h b/arch/arm64/include/asm/exception.h
index 0c2eec490abf..bc30429d8e91 100644
--- a/arch/arm64/include/asm/exception.h
+++ b/arch/arm64/include/asm/exception.h
@@ -18,6 +18,8 @@
 #ifndef __ASM_EXCEPTION_H
 #define __ASM_EXCEPTION_H
 
+#include <asm/esr.h>
+
 #include <linux/interrupt.h>
 
 #define __exception	__attribute__((section(".exception.text")))
@@ -27,4 +29,16 @@
 #define __exception_irq_entry	__exception
 #endif
 
+static inline u32 disr_to_esr(u64 disr)
+{
+	unsigned int esr = ESR_ELx_EC_SERROR << ESR_ELx_EC_SHIFT;
+
+	if ((disr & DISR_EL1_IDS) == 0)
+		esr |= (disr & DISR_EL1_ESR_MASK);
+	else
+		esr |= (disr & ESR_ELx_ISS_MASK);
+
+	return esr;
+}
+
 #endif	/* __ASM_EXCEPTION_H */
diff --git a/arch/arm64/include/asm/processor.h b/arch/arm64/include/asm/processor.h
index 023cacb946c3..cee4ae25a5d1 100644
--- a/arch/arm64/include/asm/processor.h
+++ b/arch/arm64/include/asm/processor.h
@@ -216,6 +216,7 @@ static inline void spin_lock_prefetch(const void *ptr)
 
 int cpu_enable_pan(void *__unused);
 int cpu_enable_cache_maint_trap(void *__unused);
+int cpu_clear_disr(void *__unused);
 
 /* Userspace interface for PR_SVE_{SET,GET}_VL prctl()s: */
 #define SVE_SET_VL(arg)	sve_set_current_vl(arg)
diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index 1281bc8263c2..115b89aeec00 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -279,6 +279,7 @@
 #define SYS_AMAIR_EL1			sys_reg(3, 0, 10, 3, 0)
 
 #define SYS_VBAR_EL1			sys_reg(3, 0, 12, 0, 0)
+#define SYS_DISR_EL1			sys_reg(3, 0, 12, 1,  1)
 
 #define SYS_ICC_IAR0_EL1		sys_reg(3, 0, 12, 8, 0)
 #define SYS_ICC_EOIR0_EL1		sys_reg(3, 0, 12, 8, 1)
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 0c0af18121e1..ae5433005504 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -1039,6 +1039,7 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
 		.sign = FTR_UNSIGNED,
 		.field_pos = ID_AA64PFR0_RAS_SHIFT,
 		.min_field_value = ID_AA64PFR0_RAS_V1,
+		.enable = cpu_clear_disr,
 	},
 #endif /* CONFIG_ARM64_RAS_EXTN */
 	{},
@@ -1466,3 +1467,11 @@ static int __init enable_mrs_emulation(void)
 }
 
 core_initcall(enable_mrs_emulation);
+
+int cpu_clear_disr(void *__unused)
+{
+	/* Firmware may have left a deferred SError in this register. */
+	write_sysreg_s(0, SYS_DISR_EL1);
+
+	return 0;
+}
diff --git a/arch/arm64/mm/proc.S b/arch/arm64/mm/proc.S
index ec4c3d82b4d6..05e4ae934b23 100644
--- a/arch/arm64/mm/proc.S
+++ b/arch/arm64/mm/proc.S
@@ -132,6 +132,11 @@ alternative_endif
 	ubfx	x11, x11, #1, #1
 	msr	oslar_el1, x11
 	reset_pmuserenr_el0 x0			// Disable PMU access from EL0
+
+alternative_if ARM64_HAS_RAS_EXTN
+	msr_s	SYS_DISR_EL1, xzr
+alternative_else_nop_endif
+
 	isb
 	ret
 ENDPROC(cpu_do_resume)
-- 
2.15.1
