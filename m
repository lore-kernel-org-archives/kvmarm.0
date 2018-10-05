From: Kristina Martsenko <kristina.martsenko@arm.com>
Subject: [PATCH v5 07/17] arm64: add basic pointer authentication support
Date: Fri,  5 Oct 2018 09:47:44 +0100
Message-ID: <20181005084754.20950-8-kristina.martsenko@arm.com>
References: <20181005084754.20950-1-kristina.martsenko@arm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181005084754.20950-1-kristina.martsenko@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-arm-kernel@lists.infradead.org
Cc: Adam Wallis <awallis@codeaurora.org>, Amit Kachhap <Amit.Kachhap@arm.com>, Andrew Jones <drjones@redhat.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Arnd Bergmann <arnd@arndb.de>, Catalin Marinas <catalin.marinas@arm.com>, Christoffer Dall <christoffer.dall@arm.com>, Dave P Martin <Dave.Martin@arm.com>, Jacob Bramley <jacob.bramley@arm.com>, Kees Cook <keescook@chromium.org>, Marc Zyngier <marc.zyngier@arm.com>, Mark Rutland <mark.rutland@arm.com>, Ramana Radhakrishnan <ramana.radhakrishnan@arm.com>, "Suzuki K . Poulose" <suzuki.poulose@arm.com>, Will Deacon <will.deacon@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Mark Rutland <mark.rutland@arm.com>

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
[kristina: init keys in arch_bprm_mm_init; add AA64ISAR1.API HWCAP_CAP; use sysreg_clear_set]
Signed-off-by: Kristina Martsenko <kristina.martsenko@arm.com>
Tested-by: Adam Wallis <awallis@codeaurora.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Ramana Radhakrishnan <ramana.radhakrishnan@arm.com>
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
---
 arch/arm64/include/asm/mmu.h          |  5 +++
 arch/arm64/include/asm/mmu_context.h  | 16 ++++++++-
 arch/arm64/include/asm/pointer_auth.h | 63 +++++++++++++++++++++++++++++++++++
 arch/arm64/include/uapi/asm/hwcap.h   |  1 +
 arch/arm64/kernel/cpufeature.c        | 10 ++++++
 arch/arm64/kernel/cpuinfo.c           |  1 +
 6 files changed, 95 insertions(+), 1 deletion(-)
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
index 39ec0b8a689e..983f80925566 100644
--- a/arch/arm64/include/asm/mmu_context.h
+++ b/arch/arm64/include/asm/mmu_context.h
@@ -29,7 +29,6 @@
 #include <asm/cacheflush.h>
 #include <asm/cpufeature.h>
 #include <asm/proc-fns.h>
-#include <asm-generic/mm_hooks.h>
 #include <asm/cputype.h>
 #include <asm/pgtable.h>
 #include <asm/sysreg.h>
@@ -216,6 +215,8 @@ static inline void __switch_mm(struct mm_struct *next)
 		return;
 	}
 
+	mm_ctx_ptrauth_switch(&next->context);
+
 	check_and_switch_context(next, cpu);
 }
 
@@ -241,6 +242,19 @@ switch_mm(struct mm_struct *prev, struct mm_struct *next,
 void verify_cpu_asid_bits(void);
 void post_ttbr_update_workaround(void);
 
+static inline void arch_bprm_mm_init(struct mm_struct *mm,
+				     struct vm_area_struct *vma)
+{
+	mm_ctx_ptrauth_init(&mm->context);
+}
+#define arch_bprm_mm_init arch_bprm_mm_init
+
+/*
+ * We need to override arch_bprm_mm_init before including the generic hooks,
+ * which are otherwise sufficient for us.
+ */
+#include <asm-generic/mm_hooks.h>
+
 #endif /* !__ASSEMBLY__ */
 
 #endif /* !__ASM_MMU_CONTEXT_H */
diff --git a/arch/arm64/include/asm/pointer_auth.h b/arch/arm64/include/asm/pointer_auth.h
new file mode 100644
index 000000000000..2aefedc31d9e
--- /dev/null
+++ b/arch/arm64/include/asm/pointer_auth.h
@@ -0,0 +1,63 @@
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
+ * Each key is a 128-bit quantity which is split across a pair of 64-bit
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
+#define __ptrauth_key_install(k, v)				\
+do {								\
+	struct ptrauth_key __pki_v = (v);			\
+	write_sysreg_s(__pki_v.lo, SYS_ ## k ## KEYLO_EL1);	\
+	write_sysreg_s(__pki_v.hi, SYS_ ## k ## KEYHI_EL1);	\
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
+#define mm_ctx_ptrauth_init(ctx) \
+	ptrauth_keys_init(&(ctx)->ptrauth_keys)
+
+#define mm_ctx_ptrauth_switch(ctx) \
+	ptrauth_keys_switch(&(ctx)->ptrauth_keys)
+
+#else /* CONFIG_ARM64_PTR_AUTH */
+#define mm_ctx_ptrauth_init(ctx)
+#define mm_ctx_ptrauth_switch(ctx)
+#endif /* CONFIG_ARM64_PTR_AUTH */
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
index 0dd171c7d71e..3157685aa56a 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -1040,6 +1040,11 @@ static void cpu_has_fwb(const struct arm64_cpu_capabilities *__unused)
 }
 
 #ifdef CONFIG_ARM64_PTR_AUTH
+static void cpu_enable_address_auth(struct arm64_cpu_capabilities const *cap)
+{
+	sysreg_clear_set(sctlr_el1, 0, SCTLR_ELx_ENIA);
+}
+
 static bool has_address_auth(const struct arm64_cpu_capabilities *entry,
 			     int __unused)
 {
@@ -1267,6 +1272,7 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
 		.capability = ARM64_HAS_ADDRESS_AUTH,
 		.type = ARM64_CPUCAP_SYSTEM_FEATURE,
 		.matches = has_address_auth,
+		.cpu_enable = cpu_enable_address_auth,
 	},
 #endif /* CONFIG_ARM64_PTR_AUTH */
 	{},
@@ -1314,6 +1320,10 @@ static const struct arm64_cpu_capabilities arm64_elf_hwcaps[] = {
 #ifdef CONFIG_ARM64_SVE
 	HWCAP_CAP(SYS_ID_AA64PFR0_EL1, ID_AA64PFR0_SVE_SHIFT, FTR_UNSIGNED, ID_AA64PFR0_SVE, CAP_HWCAP, HWCAP_SVE),
 #endif
+#ifdef CONFIG_ARM64_PTR_AUTH
+	HWCAP_CAP(SYS_ID_AA64ISAR1_EL1, ID_AA64ISAR1_APA_SHIFT, FTR_UNSIGNED, 1, CAP_HWCAP, HWCAP_APIA),
+	HWCAP_CAP(SYS_ID_AA64ISAR1_EL1, ID_AA64ISAR1_API_SHIFT, FTR_UNSIGNED, 1, CAP_HWCAP, HWCAP_APIA),
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
