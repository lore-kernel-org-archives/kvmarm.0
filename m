From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 84/85] Revert "arm64: KVM: Use SMCCC_ARCH_WORKAROUND_1 for
 Falkor BP hardening"
Date: Wed, 28 Mar 2018 13:52:53 +0100
Message-ID: <20180328125254.31380-85-marc.zyngier@arm.com>
References: <20180328125254.31380-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CC6534A047
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Mar 2018 09:03:27 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id XziqXQ2iinIc for <kvmarm@lists.cs.columbia.edu>;
 Wed, 28 Mar 2018 09:03:04 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 683304A085
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Mar 2018 08:50:42 -0400 (EDT)
In-Reply-To: <20180328125254.31380-1-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
Cc: Christoffer Dall <cdall@cs.columbia.edu>, Shunyong Yang <shunyong.yang@hxt-semitech.com>, Julien Thierry <julien.thierry@arm.com>, Andre Przywara <andre.przywara@arm.com>, Will Deacon <will.deacon@arm.com>, Shih-Wei Li <shihwei@cs.columbia.edu>, Catalin Marinas <catalin.marinas@arm.com>, Dave Martin <Dave.Martin@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

Creates far too many conflicts with arm64/for-next/core, to be
resent post -rc1.

This reverts commit f9f5dc19509bbef6f5e675346f1a7d7b846bdb12.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/include/asm/cpucaps.h |  2 +-
 arch/arm64/include/asm/kvm_asm.h |  2 ++
 arch/arm64/kernel/bpi.S          |  8 ++++++
 arch/arm64/kernel/cpu_errata.c   | 55 ++++++++++++++++++++++++++--------------
 arch/arm64/kvm/hyp/entry.S       | 12 +++++++++
 arch/arm64/kvm/hyp/switch.c      | 10 ++++++++
 6 files changed, 69 insertions(+), 20 deletions(-)

diff --git a/arch/arm64/include/asm/cpucaps.h b/arch/arm64/include/asm/cpucaps.h
index c7dfe68fbcc7..d4cc54ed0656 100644
--- a/arch/arm64/include/asm/cpucaps.h
+++ b/arch/arm64/include/asm/cpucaps.h
@@ -43,7 +43,7 @@
 #define ARM64_SVE				22
 #define ARM64_UNMAP_KERNEL_AT_EL0		23
 #define ARM64_HARDEN_BRANCH_PREDICTOR		24
-/* #define ARM64_UNUSED_CAP_TO_BE_REMOVED	25 */
+#define ARM64_HARDEN_BP_POST_GUEST_EXIT		25
 #define ARM64_HAS_RAS_EXTN			26
 
 #define ARM64_NCAPS				27
diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index f6648a3e4152..d53d40704416 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -71,6 +71,8 @@ extern u32 __kvm_get_mdcr_el2(void);
 
 extern u32 __init_stage2_translation(void);
 
+extern void __qcom_hyp_sanitize_btac_predictors(void);
+
 #else /* __ASSEMBLY__ */
 
 .macro get_host_ctxt reg, tmp
diff --git a/arch/arm64/kernel/bpi.S b/arch/arm64/kernel/bpi.S
index 9404f6aecda7..bb0b67722e86 100644
--- a/arch/arm64/kernel/bpi.S
+++ b/arch/arm64/kernel/bpi.S
@@ -74,6 +74,14 @@ ENTRY(__bp_harden_hyp_vecs_end)
 
 	.popsection
 
+ENTRY(__qcom_hyp_sanitize_link_stack_start)
+	stp     x29, x30, [sp, #-16]!
+	.rept	16
+	bl	. + 4
+	.endr
+	ldp	x29, x30, [sp], #16
+ENTRY(__qcom_hyp_sanitize_link_stack_end)
+
 .macro smccc_workaround_1 inst
 	sub	sp, sp, #(8 * 4)
 	stp	x2, x3, [sp, #(8 * 0)]
diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kernel/cpu_errata.c
index caa73af7d26e..aacdc118c4c9 100644
--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -69,6 +69,8 @@ atomic_t arm64_el2_vector_last_slot = ATOMIC_INIT(-1);
 DEFINE_PER_CPU_READ_MOSTLY(struct bp_hardening_data, bp_hardening_data);
 
 #ifdef CONFIG_KVM
+extern char __qcom_hyp_sanitize_link_stack_start[];
+extern char __qcom_hyp_sanitize_link_stack_end[];
 extern char __smccc_workaround_1_smc_start[];
 extern char __smccc_workaround_1_smc_end[];
 extern char __smccc_workaround_1_hvc_start[];
@@ -112,6 +114,8 @@ static void __install_bp_hardening_cb(bp_hardening_cb_t fn,
 	spin_unlock(&bp_lock);
 }
 #else
+#define __qcom_hyp_sanitize_link_stack_start	NULL
+#define __qcom_hyp_sanitize_link_stack_end	NULL
 #define __smccc_workaround_1_smc_start		NULL
 #define __smccc_workaround_1_smc_end		NULL
 #define __smccc_workaround_1_hvc_start		NULL
@@ -156,25 +160,12 @@ static void call_hvc_arch_workaround_1(void)
 	arm_smccc_1_1_hvc(ARM_SMCCC_ARCH_WORKAROUND_1, NULL);
 }
 
-static void qcom_link_stack_sanitization(void)
-{
-	u64 tmp;
-
-	asm volatile("mov	%0, x30		\n"
-		     ".rept	16		\n"
-		     "bl	. + 4		\n"
-		     ".endr			\n"
-		     "mov	x30, %0		\n"
-		     : "=&r" (tmp));
-}
-
 static int enable_smccc_arch_workaround_1(void *data)
 {
 	const struct arm64_cpu_capabilities *entry = data;
 	bp_hardening_cb_t cb;
 	void *smccc_start, *smccc_end;
 	struct arm_smccc_res res;
-	u32 midr = read_cpuid_id();
 
 	if (!entry->matches(entry, SCOPE_LOCAL_CPU))
 		return 0;
@@ -207,15 +198,33 @@ static int enable_smccc_arch_workaround_1(void *data)
 		return 0;
 	}
 
-	if (((midr & MIDR_CPU_MODEL_MASK) == MIDR_QCOM_FALKOR) ||
-	    ((midr & MIDR_CPU_MODEL_MASK) == MIDR_QCOM_FALKOR_V1))
-		cb = qcom_link_stack_sanitization;
-
 	install_bp_hardening_cb(entry, cb, smccc_start, smccc_end);
 
 	return 0;
 }
 
+static void qcom_link_stack_sanitization(void)
+{
+	u64 tmp;
+
+	asm volatile("mov	%0, x30		\n"
+		     ".rept	16		\n"
+		     "bl	. + 4		\n"
+		     ".endr			\n"
+		     "mov	x30, %0		\n"
+		     : "=&r" (tmp));
+}
+
+static int qcom_enable_link_stack_sanitization(void *data)
+{
+	const struct arm64_cpu_capabilities *entry = data;
+
+	install_bp_hardening_cb(entry, qcom_link_stack_sanitization,
+				__qcom_hyp_sanitize_link_stack_start,
+				__qcom_hyp_sanitize_link_stack_end);
+
+	return 0;
+}
 #endif	/* CONFIG_HARDEN_BRANCH_PREDICTOR */
 
 #define MIDR_RANGE(model, min, max) \
@@ -390,12 +399,20 @@ const struct arm64_cpu_capabilities arm64_errata[] = {
 	{
 		.capability = ARM64_HARDEN_BRANCH_PREDICTOR,
 		MIDR_ALL_VERSIONS(MIDR_QCOM_FALKOR_V1),
-		.enable = enable_smccc_arch_workaround_1,
+		.enable = qcom_enable_link_stack_sanitization,
+	},
+	{
+		.capability = ARM64_HARDEN_BP_POST_GUEST_EXIT,
+		MIDR_ALL_VERSIONS(MIDR_QCOM_FALKOR_V1),
 	},
 	{
 		.capability = ARM64_HARDEN_BRANCH_PREDICTOR,
 		MIDR_ALL_VERSIONS(MIDR_QCOM_FALKOR),
-		.enable = enable_smccc_arch_workaround_1,
+		.enable = qcom_enable_link_stack_sanitization,
+	},
+	{
+		.capability = ARM64_HARDEN_BP_POST_GUEST_EXIT,
+		MIDR_ALL_VERSIONS(MIDR_QCOM_FALKOR),
 	},
 	{
 		.capability = ARM64_HARDEN_BRANCH_PREDICTOR,
diff --git a/arch/arm64/kvm/hyp/entry.S b/arch/arm64/kvm/hyp/entry.S
index e41a161d313a..1f458f7c3b44 100644
--- a/arch/arm64/kvm/hyp/entry.S
+++ b/arch/arm64/kvm/hyp/entry.S
@@ -209,3 +209,15 @@ alternative_endif
 
 	eret
 ENDPROC(__fpsimd_guest_restore)
+
+ENTRY(__qcom_hyp_sanitize_btac_predictors)
+	/**
+	 * Call SMC64 with Silicon provider serviceID 23<<8 (0xc2001700)
+	 * 0xC2000000-0xC200FFFF: assigned to SiP Service Calls
+	 * b15-b0: contains SiP functionID
+	 */
+	movz    x0, #0x1700
+	movk    x0, #0xc200, lsl #16
+	smc     #0
+	ret
+ENDPROC(__qcom_hyp_sanitize_btac_predictors)
diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
index d9645236e474..07b572173265 100644
--- a/arch/arm64/kvm/hyp/switch.c
+++ b/arch/arm64/kvm/hyp/switch.c
@@ -472,6 +472,16 @@ int __hyp_text __kvm_vcpu_run_nvhe(struct kvm_vcpu *vcpu)
 		/* And we're baaack! */
 	} while (fixup_guest_exit(vcpu, &exit_code));
 
+	if (cpus_have_const_cap(ARM64_HARDEN_BP_POST_GUEST_EXIT)) {
+		u32 midr = read_cpuid_id();
+
+		/* Apply BTAC predictors mitigation to all Falkor chips */
+		if (((midr & MIDR_CPU_MODEL_MASK) == MIDR_QCOM_FALKOR) ||
+		    ((midr & MIDR_CPU_MODEL_MASK) == MIDR_QCOM_FALKOR_V1)) {
+			__qcom_hyp_sanitize_btac_predictors();
+		}
+	}
+
 	fp_enabled = __fpsimd_enabled_nvhe();
 
 	__sysreg_save_state_nvhe(guest_ctxt);
-- 
2.14.2
