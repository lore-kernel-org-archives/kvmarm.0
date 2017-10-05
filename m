From: James Morse <james.morse@arm.com>
Subject: [PATCH v3 14/20] arm64: kernel: Prepare for a DISR user
Date: Thu,  5 Oct 2017 20:18:06 +0100
Message-ID: <20171005191812.5678-15-james.morse@arm.com>
References: <20171005191812.5678-1-james.morse@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9DDD949D10
 for <kvmarm@lists.cs.columbia.edu>; Thu,  5 Oct 2017 15:20:18 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id iXF+T6Zoh2zr for <kvmarm@lists.cs.columbia.edu>;
 Thu,  5 Oct 2017 15:20:17 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 401CA49C3E
 for <kvmarm@lists.cs.columbia.edu>; Thu,  5 Oct 2017 15:20:17 -0400 (EDT)
In-Reply-To: <20171005191812.5678-1-james.morse@arm.com>
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
Cc: Jonathan.Zhang@cavium.com, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, wangxiongfeng2@huawei.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

KVM would like to consume any pending SError (or RAS error) after guest
exit. Today it has to unmask SError and use dsb+isb to synchronise the
CPU. With the RAS extensions we can use ESB to synchronise any pending
SError.

Add the necessary macros to allow DISR to be read and converted to an
ESR.

We clear the DISR register when we enable the RAS cpufeature. While the
kernel has issued ESB instructions before this point it has only done so
with SError unmasked, any value we find in DISR must have belonged to
firmware. Executing an ESB instruction is the only way to update DISR,
so we can expect firmware to have handled any deferred SError. By the
same logic we clear DISR in the idle path.

Signed-off-by: James Morse <james.morse@arm.com>
---
 arch/arm64/include/asm/assembler.h |  7 +++++++
 arch/arm64/include/asm/esr.h       |  7 +++++++
 arch/arm64/include/asm/exception.h | 14 ++++++++++++++
 arch/arm64/include/asm/processor.h |  1 +
 arch/arm64/include/asm/sysreg.h    |  1 +
 arch/arm64/kernel/cpufeature.c     |  9 +++++++++
 arch/arm64/mm/proc.S               |  5 +++++
 7 files changed, 44 insertions(+)

diff --git a/arch/arm64/include/asm/assembler.h b/arch/arm64/include/asm/assembler.h
index 7ffb2a629dc9..d4c0adf792ee 100644
--- a/arch/arm64/include/asm/assembler.h
+++ b/arch/arm64/include/asm/assembler.h
@@ -108,6 +108,13 @@
 	.endm
 
 /*
+ * RAS Error Synchronization barrier
+ */
+	.macro  esb
+	hint    #16
+	.endm
+
+/*
  * NOP sequence
  */
 	.macro	nops, num
diff --git a/arch/arm64/include/asm/esr.h b/arch/arm64/include/asm/esr.h
index 8ea52f15bf1c..b3f17fd18b14 100644
--- a/arch/arm64/include/asm/esr.h
+++ b/arch/arm64/include/asm/esr.h
@@ -136,6 +136,13 @@
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
index 6b72ddc33d06..9de3f839be8a 100644
--- a/arch/arm64/include/asm/processor.h
+++ b/arch/arm64/include/asm/processor.h
@@ -194,5 +194,6 @@ static inline void spin_lock_prefetch(const void *ptr)
 int cpu_enable_pan(void *__unused);
 int cpu_enable_cache_maint_trap(void *__unused);
 int cpu_enable_iesb(void *__unused);
+int cpu_clear_disr(void *__unused);
 
 #endif /* __ASM_PROCESSOR_H */
diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index 4500a70c6a57..427c36bc5dd6 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -179,6 +179,7 @@
 #define SYS_AMAIR_EL1			sys_reg(3, 0, 10, 3, 0)
 
 #define SYS_VBAR_EL1			sys_reg(3, 0, 12, 0, 0)
+#define SYS_DISR_EL1			sys_reg(3, 0, 12, 1,  1)
 
 #define SYS_ICC_IAR0_EL1		sys_reg(3, 0, 12, 8, 0)
 #define SYS_ICC_EOIR0_EL1		sys_reg(3, 0, 12, 8, 1)
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 626539995316..da8fd37c0984 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -911,6 +911,7 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
 		.sign = FTR_UNSIGNED,
 		.field_pos = ID_AA64PFR0_RAS_SHIFT,
 		.min_field_value = ID_AA64PFR0_RAS_V1,
+		.enable = cpu_clear_disr,
 	},
 #ifdef CONFIG_ARM64_IESB
 	{
@@ -1342,3 +1343,11 @@ int cpu_enable_iesb(void *__unused)
 
 	return 0;
 }
+
+int cpu_clear_disr(void *__unused)
+{
+	/* Firmware may have left a deferred SError in this register. */
+	write_sysreg_s(0, SYS_DISR_EL1);
+
+	return 0;
+}
diff --git a/arch/arm64/mm/proc.S b/arch/arm64/mm/proc.S
index 95233dfc4c39..ac571223672d 100644
--- a/arch/arm64/mm/proc.S
+++ b/arch/arm64/mm/proc.S
@@ -124,6 +124,11 @@ ENTRY(cpu_do_resume)
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
2.13.3
