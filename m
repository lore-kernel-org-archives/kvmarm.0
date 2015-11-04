From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PULL 15/21] arm/arm64: KVM: Improve kvm_exit tracepoint
Date: Wed,  4 Nov 2015 15:49:54 +0100
Message-ID: <1446648600-27297-16-git-send-email-christoffer.dall@linaro.org>
References: <1446648600-27297-1-git-send-email-christoffer.dall@linaro.org>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1446648600-27297-1-git-send-email-christoffer.dall@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>, Wei Huang <wei@redhat.com>
List-Id: kvmarm@lists.cs.columbia.edu

The ARM architecture only saves the exit class to the HSR (ESR_EL2 for
arm64) on synchronous exceptions, not on asynchronous exceptions like an
IRQ.  However, we only report the exception class on kvm_exit, which is
confusing because an IRQ looks like it exited at some PC with the same
reason as the previous exit.  Add a lookup table for the exception index
and prepend the kvm_exit tracepoint text with the exception type to
clarify this situation.

Also resolve the exception class (EC) to a human-friendly text version
so the trace output becomes immediately usable for debugging this code.

Cc: Wei Huang <wei@redhat.com>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 arch/arm/include/asm/kvm_arm.h   | 20 ++++++++++++++++++++
 arch/arm/kvm/arm.c               |  2 +-
 arch/arm/kvm/trace.h             | 10 +++++++---
 arch/arm64/include/asm/kvm_arm.h | 16 ++++++++++++++++
 4 files changed, 44 insertions(+), 4 deletions(-)

diff --git a/arch/arm/include/asm/kvm_arm.h b/arch/arm/include/asm/kvm_arm.h
index d995821..dc641dd 100644
--- a/arch/arm/include/asm/kvm_arm.h
+++ b/arch/arm/include/asm/kvm_arm.h
@@ -218,4 +218,24 @@
 #define HSR_DABT_CM		(1U << 8)
 #define HSR_DABT_EA		(1U << 9)
 
+#define kvm_arm_exception_type	\
+	{0, "RESET" }, 		\
+	{1, "UNDEFINED" },	\
+	{2, "SOFTWARE" },	\
+	{3, "PREF_ABORT" },	\
+	{4, "DATA_ABORT" },	\
+	{5, "IRQ" },		\
+	{6, "FIQ" },		\
+	{7, "HVC" }
+
+#define HSRECN(x) { HSR_EC_##x, #x }
+
+#define kvm_arm_exception_class \
+	HSRECN(UNKNOWN), HSRECN(WFI), HSRECN(CP15_32), HSRECN(CP15_64), \
+	HSRECN(CP14_MR), HSRECN(CP14_LS), HSRECN(CP_0_13), HSRECN(CP10_ID), \
+	HSRECN(JAZELLE), HSRECN(BXJ), HSRECN(CP14_64), HSRECN(SVC_HYP), \
+	HSRECN(HVC), HSRECN(SMC), HSRECN(IABT), HSRECN(IABT_HYP), \
+	HSRECN(DABT), HSRECN(DABT_HYP)
+
+
 #endif /* __ARM_KVM_ARM_H__ */
diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
index ed15747..eab83b2 100644
--- a/arch/arm/kvm/arm.c
+++ b/arch/arm/kvm/arm.c
@@ -635,7 +635,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
 		 * guest time.
 		 */
 		kvm_guest_exit();
-		trace_kvm_exit(kvm_vcpu_trap_get_class(vcpu), *vcpu_pc(vcpu));
+		trace_kvm_exit(ret, kvm_vcpu_trap_get_class(vcpu), *vcpu_pc(vcpu));
 
 		/*
 		 * We must sync the timer state before the vgic state so that
diff --git a/arch/arm/kvm/trace.h b/arch/arm/kvm/trace.h
index 0ec3539..c25a885 100644
--- a/arch/arm/kvm/trace.h
+++ b/arch/arm/kvm/trace.h
@@ -25,21 +25,25 @@ TRACE_EVENT(kvm_entry,
 );
 
 TRACE_EVENT(kvm_exit,
-	TP_PROTO(unsigned int exit_reason, unsigned long vcpu_pc),
-	TP_ARGS(exit_reason, vcpu_pc),
+	TP_PROTO(int idx, unsigned int exit_reason, unsigned long vcpu_pc),
+	TP_ARGS(idx, exit_reason, vcpu_pc),
 
 	TP_STRUCT__entry(
+		__field(	int,		idx		)
 		__field(	unsigned int,	exit_reason	)
 		__field(	unsigned long,	vcpu_pc		)
 	),
 
 	TP_fast_assign(
+		__entry->idx			= idx;
 		__entry->exit_reason		= exit_reason;
 		__entry->vcpu_pc		= vcpu_pc;
 	),
 
-	TP_printk("HSR_EC: 0x%04x, PC: 0x%08lx",
+	TP_printk("%s: HSR_EC: 0x%04x (%s), PC: 0x%08lx",
+		  __print_symbolic(__entry->idx, kvm_arm_exception_type),
 		  __entry->exit_reason,
+		  __print_symbolic(__entry->exit_reason, kvm_arm_exception_class),
 		  __entry->vcpu_pc)
 );
 
diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
index 9694f26..5e6857b 100644
--- a/arch/arm64/include/asm/kvm_arm.h
+++ b/arch/arm64/include/asm/kvm_arm.h
@@ -200,4 +200,20 @@
 /* Hyp Prefetch Fault Address Register (HPFAR/HDFAR) */
 #define HPFAR_MASK	(~UL(0xf))
 
+#define kvm_arm_exception_type	\
+	{0, "IRQ" }, 		\
+	{1, "TRAP" }
+
+#define ECN(x) { ESR_ELx_EC_##x, #x }
+
+#define kvm_arm_exception_class \
+	ECN(UNKNOWN), ECN(WFx), ECN(CP15_32), ECN(CP15_64), ECN(CP14_MR), \
+	ECN(CP14_LS), ECN(FP_ASIMD), ECN(CP10_ID), ECN(CP14_64), ECN(SVC64), \
+	ECN(HVC64), ECN(SMC64), ECN(SYS64), ECN(IMP_DEF), ECN(IABT_LOW), \
+	ECN(IABT_CUR), ECN(PC_ALIGN), ECN(DABT_LOW), ECN(DABT_CUR), \
+	ECN(SP_ALIGN), ECN(FP_EXC32), ECN(FP_EXC64), ECN(SERROR), \
+	ECN(BREAKPT_LOW), ECN(BREAKPT_CUR), ECN(SOFTSTP_LOW), \
+	ECN(SOFTSTP_CUR), ECN(WATCHPT_LOW), ECN(WATCHPT_CUR), \
+	ECN(BKPT32), ECN(VECTOR32), ECN(BRK64)
+
 #endif /* __ARM64_KVM_ARM_H__ */
-- 
2.1.2.330.g565301e.dirty

