Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 611715C90C
	for <kvmarm@lists.linux.dev>; Tue,  5 Dec 2023 13:32:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="j/jiAL5f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA139C433C7;
	Tue,  5 Dec 2023 13:32:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701783123;
	bh=79erg+ivVAJQfNzaa/ZIzZSVizeido0ujlqtWYJMB5g=;
	h=From:To:Cc:Subject:Date:From;
	b=j/jiAL5faAROOjCa8igS8Kiog+0IoUaWiyUJYtbjji46Us0mTV8wCqmOU1wf0K2E1
	 y2loR3AFlkLC2PuVzzHljdkUko4qVkD98S1/obat9/eItGnnHvLQDt5V6xf22zi1RB
	 j3lj0SVtpb40xOJfCY9/QZdWceDWcje8Z/vrpLJWFfnzpzQn8fglMv0uSkXIyzj6em
	 atXFjt+L0IaVLQgg2jBcA7RwFAOidmq6enLK5RtH5hKb9+o/f6Z7fIt9zoyYV3EH8X
	 RO2BJlB4rz7G+QcP1Yl63dgjjNJjIuO8NeBrXdHySmhq2R0UyD023hrF4bBFWrvErc
	 eihaZlsRNY2fQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1rAVWr-001ZHW-F2;
	Tue, 05 Dec 2023 13:32:01 +0000
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Cc: Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH] arm64: Make icache detection a cpu capability
Date: Tue,  5 Dec 2023 13:31:48 +0000
Message-Id: <20231205133148.2011836-1-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, will@kernel.org, catalin.marinas@arm.com, mark.rutland@arm.com, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Now that we only have two icache policies, we are in a good position
to make the whole detection business more robust.

Let's replace __icache_flags by a single capability (ICACHE_PIPT),
and use this if all CPUs are indeed PIPT. It means we can rely on
existing logic to mandate that a VIPT CPU coming up late will be
denied booting, which is the safe thing to do.

This also leads to some nice cleanups in pKVM. Additionally,
cache_is_aliasing() is made __always_inline in order to avoid
surprisees in the nVHE hypervisor object.

Suggested-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---

Notes:
    Applies on top of my previous VPIPT removal series.

 arch/arm64/include/asm/cache.h   | 11 +++-------
 arch/arm64/include/asm/kvm_hyp.h |  1 -
 arch/arm64/kernel/cpufeature.c   | 36 +++++++++++++++++++-------------
 arch/arm64/kernel/cpuinfo.c      | 34 ------------------------------
 arch/arm64/kvm/arm.c             |  1 -
 arch/arm64/kvm/hyp/nvhe/pkvm.c   |  3 ---
 arch/arm64/tools/cpucaps         |  1 +
 7 files changed, 25 insertions(+), 62 deletions(-)

diff --git a/arch/arm64/include/asm/cache.h b/arch/arm64/include/asm/cache.h
index 06a4670bdb0b..70bd32600e5e 100644
--- a/arch/arm64/include/asm/cache.h
+++ b/arch/arm64/include/asm/cache.h
@@ -37,9 +37,9 @@
 
 #ifndef __ASSEMBLY__
 
-#include <linux/bitops.h>
 #include <linux/kasan-enabled.h>
 
+#include <asm/cpufeature.h>
 #include <asm/cputype.h>
 #include <asm/mte-def.h>
 #include <asm/sysreg.h>
@@ -55,18 +55,13 @@ static inline unsigned int arch_slab_minalign(void)
 #define arch_slab_minalign() arch_slab_minalign()
 #endif
 
-#define CTR_L1IP(ctr)		SYS_FIELD_GET(CTR_EL0, L1Ip, ctr)
-
-#define ICACHEF_ALIASING	0
-extern unsigned long __icache_flags;
-
 /*
  * Whilst the D-side always behaves as PIPT on AArch64, aliasing is
  * permitted in the I-cache.
  */
-static inline int icache_is_aliasing(void)
+static __always_inline int icache_is_aliasing(void)
 {
-	return test_bit(ICACHEF_ALIASING, &__icache_flags);
+	return !alternative_has_cap_likely(ARM64_ICACHE_PIPT);
 }
 
 static inline u32 cache_type_cwg(void)
diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
index 145ce73fc16c..7ad70f9865fd 100644
--- a/arch/arm64/include/asm/kvm_hyp.h
+++ b/arch/arm64/include/asm/kvm_hyp.h
@@ -140,7 +140,6 @@ extern u64 kvm_nvhe_sym(id_aa64mmfr1_el1_sys_val);
 extern u64 kvm_nvhe_sym(id_aa64mmfr2_el1_sys_val);
 extern u64 kvm_nvhe_sym(id_aa64smfr0_el1_sys_val);
 
-extern unsigned long kvm_nvhe_sym(__icache_flags);
 extern unsigned int kvm_nvhe_sym(kvm_arm_vmid_bits);
 
 #endif /* __ARM64_KVM_HYP_H__ */
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 646591c67e7a..1ee844dd7529 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -1594,17 +1594,18 @@ static bool has_no_hw_prefetch(const struct arm64_cpu_capabilities *entry, int _
 		MIDR_CPU_VAR_REV(1, MIDR_REVISION_MASK));
 }
 
-static bool has_cache_idc(const struct arm64_cpu_capabilities *entry,
-			  int scope)
+static u64 get_scoped_ctr_el0(int scope)
 {
-	u64 ctr;
-
 	if (scope == SCOPE_SYSTEM)
-		ctr = arm64_ftr_reg_ctrel0.sys_val;
-	else
-		ctr = read_cpuid_effective_cachetype();
+		return arm64_ftr_reg_ctrel0.sys_val;
 
-	return ctr & BIT(CTR_EL0_IDC_SHIFT);
+	return read_cpuid_effective_cachetype();
+}
+
+static bool has_cache_idc(const struct arm64_cpu_capabilities *entry,
+			  int scope)
+{
+	return get_scoped_ctr_el0(scope) & BIT(CTR_EL0_IDC_SHIFT);
 }
 
 static void cpu_emulate_effective_ctr(const struct arm64_cpu_capabilities *__unused)
@@ -1622,14 +1623,13 @@ static void cpu_emulate_effective_ctr(const struct arm64_cpu_capabilities *__unu
 static bool has_cache_dic(const struct arm64_cpu_capabilities *entry,
 			  int scope)
 {
-	u64 ctr;
-
-	if (scope == SCOPE_SYSTEM)
-		ctr = arm64_ftr_reg_ctrel0.sys_val;
-	else
-		ctr = read_cpuid_cachetype();
+	return get_scoped_ctr_el0(scope) & BIT(CTR_EL0_DIC_SHIFT);
+}
 
-	return ctr & BIT(CTR_EL0_DIC_SHIFT);
+static bool has_pipt_icache(const struct arm64_cpu_capabilities *entry,
+			    int scope)
+{
+	return FIELD_GET(CTR_EL0_L1Ip_MASK, get_scoped_ctr_el0(scope)) == CTR_EL0_L1Ip_PIPT;
 }
 
 static bool __maybe_unused
@@ -2272,6 +2272,12 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
 		.type = ARM64_CPUCAP_SYSTEM_FEATURE,
 		.matches = has_always,
 	},
+	{
+		.desc = "PIPT I-cache policy",
+		.capability = ARM64_ICACHE_PIPT,
+		.type = ARM64_CPUCAP_SYSTEM_FEATURE,
+		.matches = has_pipt_icache,
+	},
 	{
 		.desc = "GIC system register CPU interface",
 		.capability = ARM64_HAS_GIC_CPUIF_SYSREGS,
diff --git a/arch/arm64/kernel/cpuinfo.c b/arch/arm64/kernel/cpuinfo.c
index 47043c0d95ec..a4ea331fb6d4 100644
--- a/arch/arm64/kernel/cpuinfo.c
+++ b/arch/arm64/kernel/cpuinfo.c
@@ -33,20 +33,6 @@
 DEFINE_PER_CPU(struct cpuinfo_arm64, cpu_data);
 static struct cpuinfo_arm64 boot_cpu_data;
 
-static inline const char *icache_policy_str(int l1ip)
-{
-	switch (l1ip) {
-	case CTR_EL0_L1Ip_VIPT:
-		return "VIPT";
-	case CTR_EL0_L1Ip_PIPT:
-		return "PIPT";
-	default:
-		return "RESERVED/UNKNOWN";
-	}
-}
-
-unsigned long __icache_flags;
-
 static const char *const hwcap_str[] = {
 	[KERNEL_HWCAP_FP]		= "fp",
 	[KERNEL_HWCAP_ASIMD]		= "asimd",
@@ -378,24 +364,6 @@ static int __init cpuinfo_regs_init(void)
 }
 device_initcall(cpuinfo_regs_init);
 
-static void cpuinfo_detect_icache_policy(struct cpuinfo_arm64 *info)
-{
-	unsigned int cpu = smp_processor_id();
-	u32 l1ip = CTR_L1IP(info->reg_ctr);
-
-	switch (l1ip) {
-	case CTR_EL0_L1Ip_PIPT:
-		break;
-	case CTR_EL0_L1Ip_VIPT:
-	default:
-		/* Assume aliasing */
-		set_bit(ICACHEF_ALIASING, &__icache_flags);
-		break;
-	}
-
-	pr_info("Detected %s I-cache on CPU%d\n", icache_policy_str(l1ip), cpu);
-}
-
 static void __cpuinfo_store_cpu_32bit(struct cpuinfo_32bit *info)
 {
 	info->reg_id_dfr0 = read_cpuid(ID_DFR0_EL1);
@@ -457,8 +425,6 @@ static void __cpuinfo_store_cpu(struct cpuinfo_arm64 *info)
 
 	if (id_aa64pfr0_32bit_el0(info->reg_id_aa64pfr0))
 		__cpuinfo_store_cpu_32bit(&info->aarch32);
-
-	cpuinfo_detect_icache_policy(info);
 }
 
 void cpuinfo_store_cpu(void)
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index e5f75f1f1085..a5f71165cd5c 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -2242,7 +2242,6 @@ static void kvm_hyp_init_symbols(void)
 	kvm_nvhe_sym(id_aa64mmfr1_el1_sys_val) = read_sanitised_ftr_reg(SYS_ID_AA64MMFR1_EL1);
 	kvm_nvhe_sym(id_aa64mmfr2_el1_sys_val) = read_sanitised_ftr_reg(SYS_ID_AA64MMFR2_EL1);
 	kvm_nvhe_sym(id_aa64smfr0_el1_sys_val) = read_sanitised_ftr_reg(SYS_ID_AA64SMFR0_EL1);
-	kvm_nvhe_sym(__icache_flags) = __icache_flags;
 	kvm_nvhe_sym(kvm_arm_vmid_bits) = kvm_arm_vmid_bits;
 }
 
diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index b29f15418c0a..187ce5720697 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -12,9 +12,6 @@
 #include <nvhe/pkvm.h>
 #include <nvhe/trap_handler.h>
 
-/* Used by icache_is_aliasing(). */
-unsigned long __icache_flags;
-
 /* Used by kvm_get_vttbr(). */
 unsigned int kvm_arm_vmid_bits;
 
diff --git a/arch/arm64/tools/cpucaps b/arch/arm64/tools/cpucaps
index b98c38288a9d..9c6313cd6f5e 100644
--- a/arch/arm64/tools/cpucaps
+++ b/arch/arm64/tools/cpucaps
@@ -53,6 +53,7 @@ HAS_TLB_RANGE
 HAS_VIRT_HOST_EXTN
 HAS_WFXT
 HW_DBM
+ICACHE_PIPT
 KVM_HVHE
 KVM_PROTECTED_MODE
 MISMATCHED_CACHE_TYPE
-- 
2.39.2

