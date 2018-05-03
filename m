From: Mark Rutland <mark.rutland@arm.com>
Subject: [PATCHv4 06/10] arm64: add basic pointer authentication support
Date: Thu,  3 May 2018 14:20:27 +0100
Message-ID: <20180503132031.25705-7-mark.rutland@arm.com>
References: <20180503132031.25705-1-mark.rutland@arm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180503132031.25705-1-mark.rutland@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu, catalin.marinas@arm.com, christoffer.dall@arm.com, drjones@redhat.com, marc.zyngier@arm.com, mark.rutland@arm.com, ramana.radhakrishnan@arm.com, suzuki.poulose@arm.com, will.deacon@arm.com, awallis@codeaurora.org
List-Id: kvmarm@lists.cs.columbia.edu

This patch adds basic support for pointer authentication, allowing
userspace to make use of APIAKey. The kernel maintains an APIAKey value
for each process (shared by all threads within), which is initialised to
a random value at exec() time.

To describe that address authentication instructions are available, the
ID_AA64ISAR0.{APA,API} fields are exposed to userspace. A new hwcap,
APIA, is added to describe that the kernel manages APIAKey.

Instructions using other keys (APIBKey, APDAKey, APDBKey) are disabled,
and will behave as NOPs. These may be made use of in future patches.

No support is added for the generic key (APGAKey), though this cannot be
trapped or made to behave as a NOP. Its presence is not advertised with
a hwcap.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Ramana Radhakrishnan <ramana.radhakrishnan@arm.com>
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
---
 arch/arm64/include/asm/mmu.h          |  5 +++
 arch/arm64/include/asm/mmu_context.h  | 11 ++++-
 arch/arm64/include/asm/pointer_auth.h | 75 +++++++++++++++++++++++++++++++++++
 arch/arm64/include/uapi/asm/hwcap.h   |  1 +
 arch/arm64/kernel/cpufeature.c        |  9 +++++
 arch/arm64/kernel/cpuinfo.c           |  1 +
 6 files changed, 101 insertions(+), 1 deletion(-)
 create mode 100644 arch/arm64/include/asm/pointer_auth.h

diff --git a/arch/arm64/include/asm/mmu.h b/arch/arm64/include/asm/mmu.h
index dd320df0d026..f6480ea7b0d5 100644
--- a/arch/arm64/include/asm/mmu.h
+++ b/arch/arm64/include/asm/mmu.h
@@ -25,10 +25,15 @@
 
 #ifndef __ASSEMBLY__
 
+#include <asm/pointer_auth.h>
+
 typedef struct {
 	atomic64_t	id;
 	void		*vdso;
 	unsigned long	flags;
+#ifdef CONFIG_ARM64_PTR_AUTH
+	struct ptrauth_keys	ptrauth_keys;
+#endif
 } mm_context_t;
 
 /*
diff --git a/arch/arm64/include/asm/mmu_context.h b/arch/arm64/include/asm/mmu_context.h
index 39ec0b8a689e..83eadbc6b946 100644
--- a/arch/arm64/include/asm/mmu_context.h
+++ b/arch/arm64/include/asm/mmu_context.h
@@ -168,7 +168,14 @@ static inline void cpu_replace_ttbr1(pgd_t *pgdp)
 #define destroy_context(mm)		do { } while(0)
 void check_and_switch_context(struct mm_struct *mm, unsigned int cpu);
 
-#define init_new_context(tsk,mm)	({ atomic64_set(&(mm)->context.id, 0); 0; })
+static inline int init_new_context(struct task_struct *tsk,
+				   struct mm_struct *mm)
+{
+	atomic64_set(&mm->context.id, 0);
+	mm_ctx_ptrauth_init(&mm->context);
+
+	return 0;
+}
 
 #ifdef CONFIG_ARM64_SW_TTBR0_PAN
 static inline void update_saved_ttbr0(struct task_struct *tsk,
@@ -216,6 +223,8 @@ static inline void __switch_mm(struct mm_struct *next)
 		return;
 	}
 
+	mm_ctx_ptrauth_switch(&next->context);
+
 	check_and_switch_context(next, cpu);
 }
 
diff --git a/arch/arm64/include/asm/pointer_auth.h b/arch/arm64/include/asm/pointer_auth.h
new file mode 100644
index 000000000000..034877ee28bc
--- /dev/null
+++ b/arch/arm64/include/asm/pointer_auth.h
@@ -0,0 +1,75 @@
+// SPDX-License-Identifier: GPL-2.0
+#ifndef __ASM_POINTER_AUTH_H
+#define __ASM_POINTER_AUTH_H
+
+#include <linux/random.h>
+
+#include <asm/cpufeature.h>
+#include <asm/sysreg.h>
+
+#ifdef CONFIG_ARM64_PTR_AUTH
+/*
+ * Each key is a 128-bit quantity which is split accross a pair of 64-bit
+ * registers (Lo and Hi).
+ */
+struct ptrauth_key {
+	unsigned long lo, hi;
+};
+
+/*
+ * We give each process its own instruction A key (APIAKey), which is shared by
+ * all threads. This is inherited upon fork(), and reinitialised upon exec*().
+ * All other keys are currently unused, with APIBKey, APDAKey, and APBAKey
+ * instructions behaving as NOPs.
+ */
+struct ptrauth_keys {
+	struct ptrauth_key apia;
+};
+
+static inline void ptrauth_keys_init(struct ptrauth_keys *keys)
+{
+	if (!cpus_have_const_cap(ARM64_HAS_ADDRESS_AUTH))
+		return;
+
+	get_random_bytes(keys, sizeof(*keys));
+}
+
+#define __ptrauth_key_install(k, v)			\
+do {							\
+	write_sysreg_s(v.lo, SYS_ ## k ## KEYLO_EL1);	\
+	write_sysreg_s(v.hi, SYS_ ## k ## KEYHI_EL1);	\
+} while (0)
+
+static inline void ptrauth_keys_switch(struct ptrauth_keys *keys)
+{
+	if (!cpus_have_const_cap(ARM64_HAS_ADDRESS_AUTH))
+		return;
+
+	__ptrauth_key_install(APIA, keys->apia);
+}
+
+static inline void ptrauth_keys_dup(struct ptrauth_keys *old,
+				    struct ptrauth_keys *new)
+{
+	if (!cpus_have_const_cap(ARM64_HAS_ADDRESS_AUTH))
+		return;
+
+	*new = *old;
+}
+
+#define mm_ctx_ptrauth_init(ctx) \
+	ptrauth_keys_init(&(ctx)->ptrauth_keys)
+
+#define mm_ctx_ptrauth_switch(ctx) \
+	ptrauth_keys_switch(&(ctx)->ptrauth_keys)
+
+#define mm_ctx_ptrauth_dup(oldctx, newctx) \
+	ptrauth_keys_dup(&(oldctx)->ptrauth_keys, &(newctx)->ptrauth_keys)
+
+#else
+#define mm_ctx_ptrauth_init(ctx)
+#define mm_ctx_ptrauth_switch(ctx)
+#define mm_ctx_ptrauth_dup(oldctx, newctx)
+#endif
+
+#endif /* __ASM_POINTER_AUTH_H */
diff --git a/arch/arm64/include/uapi/asm/hwcap.h b/arch/arm64/include/uapi/asm/hwcap.h
index 17c65c8f33cb..01f02ac500ae 100644
--- a/arch/arm64/include/uapi/asm/hwcap.h
+++ b/arch/arm64/include/uapi/asm/hwcap.h
@@ -48,5 +48,6 @@
 #define HWCAP_USCAT		(1 << 25)
 #define HWCAP_ILRCPC		(1 << 26)
 #define HWCAP_FLAGM		(1 << 27)
+#define HWCAP_APIA		(1 << 28)
 
 #endif /* _UAPI__ASM_HWCAP_H */
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 01b1a7e7d70f..f418d4cb6691 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -1030,6 +1030,11 @@ static void cpu_copy_el2regs(const struct arm64_cpu_capabilities *__unused)
 #endif
 
 #ifdef CONFIG_ARM64_PTR_AUTH
+static void cpu_enable_address_auth(struct arm64_cpu_capabilities const *cap)
+{
+	config_sctlr_el1(0, SCTLR_ELx_ENIA);
+}
+
 static bool has_address_auth(const struct arm64_cpu_capabilities *entry,
 			     int __unused)
 {
@@ -1246,6 +1251,7 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
 		.capability = ARM64_HAS_ADDRESS_AUTH,
 		.type = ARM64_CPUCAP_SYSTEM_FEATURE,
 		.matches = has_address_auth,
+		.cpu_enable = cpu_enable_address_auth,
 	},
 #endif /* CONFIG_ARM64_PTR_AUTH */
 	{},
@@ -1293,6 +1299,9 @@ static const struct arm64_cpu_capabilities arm64_elf_hwcaps[] = {
 #ifdef CONFIG_ARM64_SVE
 	HWCAP_CAP(SYS_ID_AA64PFR0_EL1, ID_AA64PFR0_SVE_SHIFT, FTR_UNSIGNED, ID_AA64PFR0_SVE, CAP_HWCAP, HWCAP_SVE),
 #endif
+#ifdef CONFIG_ARM64_PNTR_AUTH
+	HWCAP_CAP(SYS_ID_AA64ISAR1_EL1, ID_AA64ISAR1_APA_SHIFT, FTR_UNSIGNED, 1, CAP_HWCAP, HWCAP_APIA),
+#endif
 	{},
 };
 
diff --git a/arch/arm64/kernel/cpuinfo.c b/arch/arm64/kernel/cpuinfo.c
index e9ab7b3ed317..608411e3aaff 100644
--- a/arch/arm64/kernel/cpuinfo.c
+++ b/arch/arm64/kernel/cpuinfo.c
@@ -81,6 +81,7 @@ static const char *const hwcap_str[] = {
 	"uscat",
 	"ilrcpc",
 	"flagm",
+	"apia",
 	NULL
 };
 
-- 
2.11.0
