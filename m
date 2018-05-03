From: Mark Rutland <mark.rutland@arm.com>
Subject: [PATCHv4 07/10] arm64: expose user PAC bit positions via ptrace
Date: Thu,  3 May 2018 14:20:28 +0100
Message-ID: <20180503132031.25705-8-mark.rutland@arm.com>
References: <20180503132031.25705-1-mark.rutland@arm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180503132031.25705-1-mark.rutland@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu, catalin.marinas@arm.com, christoffer.dall@arm.com, drjones@redhat.com, marc.zyngier@arm.com, mark.rutland@arm.com, ramana.radhakrishnan@arm.com, suzuki.poulose@arm.com, will.deacon@arm.com, awallis@codeaurora.org
List-Id: kvmarm@lists.cs.columbia.edu

When pointer authentication is in use, data/instruction pointers have a
number of PAC bits inserted into them. The number and position of these
bits depends on the configured TCR_ELx.TxSZ and whether tagging is
enabled. ARMv8.3 allows tagging to differ for instruction and data
pointers.

For userspace debuggers to unwind the stack and/or to follow pointer
chains, they need to be able to remove the PAC bits before attempting to
use a pointer.

This patch adds a new structure with masks describing the location of
the PAC bits in userspace instruction and data pointers (i.e. those
addressable via TTBR0), which userspace can query via PTRACE_GETREGSET.
By clearing these bits from pointers (and replacing them with the value
of bit 55), userspace can acquire the PAC-less versions.

This new regset is exposed when the kernel is built with (user) pointer
authentication support, and the feature is enabled. Otherwise, it is
hidden.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Ramana Radhakrishnan <ramana.radhakrishnan@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
---
 arch/arm64/include/asm/pointer_auth.h |  8 ++++++++
 arch/arm64/include/uapi/asm/ptrace.h  |  7 +++++++
 arch/arm64/kernel/ptrace.c            | 38 +++++++++++++++++++++++++++++++++++
 include/uapi/linux/elf.h              |  1 +
 4 files changed, 54 insertions(+)

diff --git a/arch/arm64/include/asm/pointer_auth.h b/arch/arm64/include/asm/pointer_auth.h
index 034877ee28bc..0263b87f95f7 100644
--- a/arch/arm64/include/asm/pointer_auth.h
+++ b/arch/arm64/include/asm/pointer_auth.h
@@ -2,9 +2,11 @@
 #ifndef __ASM_POINTER_AUTH_H
 #define __ASM_POINTER_AUTH_H
 
+#include <linux/bitops.h>
 #include <linux/random.h>
 
 #include <asm/cpufeature.h>
+#include <asm/memory.h>
 #include <asm/sysreg.h>
 
 #ifdef CONFIG_ARM64_PTR_AUTH
@@ -57,6 +59,12 @@ static inline void ptrauth_keys_dup(struct ptrauth_keys *old,
 	*new = *old;
 }
 
+/*
+ * The EL0 pointer bits used by a pointer authentication code.
+ * This is dependent on TBI0 being enabled, or bits 63:56 would also apply.
+ */
+#define ptrauth_pac_mask() 	GENMASK(54, VA_BITS)
+
 #define mm_ctx_ptrauth_init(ctx) \
 	ptrauth_keys_init(&(ctx)->ptrauth_keys)
 
diff --git a/arch/arm64/include/uapi/asm/ptrace.h b/arch/arm64/include/uapi/asm/ptrace.h
index 98c4ce55d9c3..4994d718771a 100644
--- a/arch/arm64/include/uapi/asm/ptrace.h
+++ b/arch/arm64/include/uapi/asm/ptrace.h
@@ -228,6 +228,13 @@ struct user_sve_header {
 		  SVE_PT_SVE_OFFSET + SVE_PT_SVE_SIZE(vq, flags)	\
 		: SVE_PT_FPSIMD_OFFSET + SVE_PT_FPSIMD_SIZE(vq, flags))
 
+/* pointer authentication masks (NT_ARM_PAC_MASK) */
+
+struct user_pac_mask {
+	__u64		data_mask;
+	__u64		insn_mask;
+};
+
 #endif /* __ASSEMBLY__ */
 
 #endif /* _UAPI__ASM_PTRACE_H */
diff --git a/arch/arm64/kernel/ptrace.c b/arch/arm64/kernel/ptrace.c
index 71d99af24ef2..f395649f755e 100644
--- a/arch/arm64/kernel/ptrace.c
+++ b/arch/arm64/kernel/ptrace.c
@@ -44,6 +44,7 @@
 #include <asm/cpufeature.h>
 #include <asm/debug-monitors.h>
 #include <asm/pgtable.h>
+#include <asm/pointer_auth.h>
 #include <asm/stacktrace.h>
 #include <asm/syscall.h>
 #include <asm/traps.h>
@@ -951,6 +952,30 @@ static int sve_set(struct task_struct *target,
 
 #endif /* CONFIG_ARM64_SVE */
 
+#ifdef CONFIG_ARM64_PTR_AUTH
+static int pac_mask_get(struct task_struct *target,
+			const struct user_regset *regset,
+			unsigned int pos, unsigned int count,
+			void *kbuf, void __user *ubuf)
+{
+	/*
+	 * The PAC bits can differ across data and instruction pointers
+	 * depending on TCR_EL1.TBID*, which we may make use of in future, so
+	 * we expose separate masks.
+	 */
+	unsigned long mask = ptrauth_pac_mask();
+	struct user_pac_mask uregs = {
+		.data_mask = mask,
+		.insn_mask = mask,
+	};
+
+	if (!cpus_have_cap(ARM64_HAS_ADDRESS_AUTH))
+		return -EINVAL;
+
+	return user_regset_copyout(&pos, &count, &kbuf, &ubuf, &uregs, 0, -1);
+}
+#endif /* CONFIG_ARM64_PTR_AUTH */
+
 enum aarch64_regset {
 	REGSET_GPR,
 	REGSET_FPR,
@@ -963,6 +988,9 @@ enum aarch64_regset {
 #ifdef CONFIG_ARM64_SVE
 	REGSET_SVE,
 #endif
+#ifdef CONFIG_ARM64_PTR_AUTH
+	REGSET_PAC_MASK,
+#endif
 };
 
 static const struct user_regset aarch64_regsets[] = {
@@ -1032,6 +1060,16 @@ static const struct user_regset aarch64_regsets[] = {
 		.get_size = sve_get_size,
 	},
 #endif
+#ifdef CONFIG_ARM64_PTR_AUTH
+	[REGSET_PAC_MASK] = {
+		.core_note_type = NT_ARM_PAC_MASK,
+		.n = sizeof(struct user_pac_mask) / sizeof(u64),
+		.size = sizeof(u64),
+		.align = sizeof(u64),
+		.get = pac_mask_get,
+		/* this cannot be set dynamically */
+	},
+#endif
 };
 
 static const struct user_regset_view user_aarch64_view = {
diff --git a/include/uapi/linux/elf.h b/include/uapi/linux/elf.h
index e2535d6dcec7..070c28121979 100644
--- a/include/uapi/linux/elf.h
+++ b/include/uapi/linux/elf.h
@@ -420,6 +420,7 @@ typedef struct elf64_shdr {
 #define NT_ARM_HW_WATCH	0x403		/* ARM hardware watchpoint registers */
 #define NT_ARM_SYSTEM_CALL	0x404	/* ARM system call number */
 #define NT_ARM_SVE	0x405		/* ARM Scalable Vector Extension registers */
+#define NT_ARM_PAC_MASK		0x406	/* ARM pointer authentication code masks */
 #define NT_ARC_V2	0x600		/* ARCv2 accumulator/extra registers */
 
 /* Note header in a PT_NOTE section */
-- 
2.11.0
