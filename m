From: Kristina Martsenko <kristina.martsenko@arm.com>
Subject: [PATCH v5 08/17] arm64: expose user PAC bit positions via ptrace
Date: Fri,  5 Oct 2018 09:47:45 +0100
Message-ID: <20181005084754.20950-9-kristina.martsenko@arm.com>
References: <20181005084754.20950-1-kristina.martsenko@arm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181005084754.20950-1-kristina.martsenko@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-arm-kernel@lists.infradead.org
Cc: Adam Wallis <awallis@codeaurora.org>, Amit Kachhap <Amit.Kachhap@arm.com>, Andrew Jones <drjones@redhat.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Arnd Bergmann <arnd@arndb.de>, Catalin Marinas <catalin.marinas@arm.com>, Christoffer Dall <christoffer.dall@arm.com>, Dave P Martin <Dave.Martin@arm.com>, Jacob Bramley <jacob.bramley@arm.com>, Kees Cook <keescook@chromium.org>, Marc Zyngier <marc.zyngier@arm.com>, Mark Rutland <mark.rutland@arm.com>, Ramana Radhakrishnan <ramana.radhakrishnan@arm.com>, "Suzuki K . Poulose" <suzuki.poulose@arm.com>, Will Deacon <will.deacon@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Mark Rutland <mark.rutland@arm.com>

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
[kristina: cpus_have_cap -> cpus_have_const_cap]
Signed-off-by: Kristina Martsenko <kristina.martsenko@arm.com>
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
index 2aefedc31d9e..15486079e9ec 100644
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
@@ -49,6 +51,12 @@ static inline void ptrauth_keys_switch(struct ptrauth_keys *keys)
 	__ptrauth_key_install(APIA, keys->apia);
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
index 6219486fa25f..cb8246f8c603 100644
--- a/arch/arm64/kernel/ptrace.c
+++ b/arch/arm64/kernel/ptrace.c
@@ -46,6 +46,7 @@
 #include <asm/debug-monitors.h>
 #include <asm/fpsimd.h>
 #include <asm/pgtable.h>
+#include <asm/pointer_auth.h>
 #include <asm/stacktrace.h>
 #include <asm/syscall.h>
 #include <asm/traps.h>
@@ -958,6 +959,30 @@ static int sve_set(struct task_struct *target,
 
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
+	if (!cpus_have_const_cap(ARM64_HAS_ADDRESS_AUTH))
+		return -EINVAL;
+
+	return user_regset_copyout(&pos, &count, &kbuf, &ubuf, &uregs, 0, -1);
+}
+#endif /* CONFIG_ARM64_PTR_AUTH */
+
 enum aarch64_regset {
 	REGSET_GPR,
 	REGSET_FPR,
@@ -970,6 +995,9 @@ enum aarch64_regset {
 #ifdef CONFIG_ARM64_SVE
 	REGSET_SVE,
 #endif
+#ifdef CONFIG_ARM64_PTR_AUTH
+	REGSET_PAC_MASK,
+#endif
 };
 
 static const struct user_regset aarch64_regsets[] = {
@@ -1039,6 +1067,16 @@ static const struct user_regset aarch64_regsets[] = {
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
index c5358e0ae7c5..3f23273d690c 100644
--- a/include/uapi/linux/elf.h
+++ b/include/uapi/linux/elf.h
@@ -420,6 +420,7 @@ typedef struct elf64_shdr {
 #define NT_ARM_HW_WATCH	0x403		/* ARM hardware watchpoint registers */
 #define NT_ARM_SYSTEM_CALL	0x404	/* ARM system call number */
 #define NT_ARM_SVE	0x405		/* ARM Scalable Vector Extension registers */
+#define NT_ARM_PAC_MASK		0x406	/* ARM pointer authentication code masks */
 #define NT_ARC_V2	0x600		/* ARCv2 accumulator/extra registers */
 #define NT_VMCOREDD	0x700		/* Vmcore Device Dump Note */
 #define NT_MIPS_DSP	0x800		/* MIPS DSP ASE registers */
-- 
2.11.0
