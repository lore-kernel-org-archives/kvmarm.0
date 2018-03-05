From: Shanker Donthineni <shankerd@codeaurora.org>
Subject: [PATCH v2] arm64: KVM: Use SMCCC_ARCH_WORKAROUND_1 for Falkor BP
 hardening
Date: Mon,  5 Mar 2018 11:06:43 -0600
Message-ID: <1520269603-2900-1-git-send-email-shankerd@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Marc Zyngier <marc.zyngier@arm.com>, Will Deacon <will.deacon@arm.com>, linux-kernel <linux-kernel@vger.kernel.org>, linux-arm-kernel <linux-arm-kernel@lists.infradead.org>, Catalin Marinas <catalin.marinas@arm.com>, kvmarm <kvmarm@lists.cs.columbia.edu>
Cc: Thomas Speier <tspeier@codeaurora.org>, Shanker Donthineni <shankerd@codeaurora.org>, Christoffer Dall <cdall@kernel.org>, Vikram Sethi <vikrams@codeaurora.org>, Sean Campbell <scampbel@codeaurora.org>
List-Id: kvmarm@lists.cs.columbia.edu

The function SMCCC_ARCH_WORKAROUND_1 was introduced as part of SMC
V1.1 Calling Convention to mitigate CVE-2017-5715. This patch uses
the standard call SMCCC_ARCH_WORKAROUND_1 for Falkor chips instead
of Silicon provider service ID 0xC2001700.

Signed-off-by: Shanker Donthineni <shankerd@codeaurora.org>
---
Chnages since v1:
  - Trivial change in cpucaps.h (refresh after removing ARM64_HARDEN_BP_POST_GUEST_EXIT)

 arch/arm64/include/asm/cpucaps.h |  5 ++--
 arch/arm64/include/asm/kvm_asm.h |  2 --
 arch/arm64/kernel/bpi.S          |  8 ------
 arch/arm64/kernel/cpu_errata.c   | 55 ++++++++++++++--------------------------
 arch/arm64/kvm/hyp/entry.S       | 12 ---------
 arch/arm64/kvm/hyp/switch.c      | 10 --------
 6 files changed, 21 insertions(+), 71 deletions(-)

diff --git a/arch/arm64/include/asm/cpucaps.h b/arch/arm64/include/asm/cpucaps.h
index bb26382..324c85e 100644
--- a/arch/arm64/include/asm/cpucaps.h
+++ b/arch/arm64/include/asm/cpucaps.h
@@ -43,9 +43,8 @@
 #define ARM64_SVE				22
 #define ARM64_UNMAP_KERNEL_AT_EL0		23
 #define ARM64_HARDEN_BRANCH_PREDICTOR		24
-#define ARM64_HARDEN_BP_POST_GUEST_EXIT		25
-#define ARM64_HAS_RAS_EXTN			26
+#define ARM64_HAS_RAS_EXTN			25
 
-#define ARM64_NCAPS				27
+#define ARM64_NCAPS				26
 
 #endif /* __ASM_CPUCAPS_H */
diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index 24961b7..ab4d0a9 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -68,8 +68,6 @@
 
 extern u32 __init_stage2_translation(void);
 
-extern void __qcom_hyp_sanitize_btac_predictors(void);
-
 #endif
 
 #endif /* __ARM_KVM_ASM_H__ */
diff --git a/arch/arm64/kernel/bpi.S b/arch/arm64/kernel/bpi.S
index e5de335..dc4eb15 100644
--- a/arch/arm64/kernel/bpi.S
+++ b/arch/arm64/kernel/bpi.S
@@ -55,14 +55,6 @@ ENTRY(__bp_harden_hyp_vecs_start)
 	.endr
 ENTRY(__bp_harden_hyp_vecs_end)
 
-ENTRY(__qcom_hyp_sanitize_link_stack_start)
-	stp     x29, x30, [sp, #-16]!
-	.rept	16
-	bl	. + 4
-	.endr
-	ldp	x29, x30, [sp], #16
-ENTRY(__qcom_hyp_sanitize_link_stack_end)
-
 .macro smccc_workaround_1 inst
 	sub	sp, sp, #(8 * 4)
 	stp	x2, x3, [sp, #(8 * 0)]
diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kernel/cpu_errata.c
index 52f15cd..d779ffd4 100644
--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -67,8 +67,6 @@ static int cpu_enable_trap_ctr_access(void *__unused)
 DEFINE_PER_CPU_READ_MOSTLY(struct bp_hardening_data, bp_hardening_data);
 
 #ifdef CONFIG_KVM
-extern char __qcom_hyp_sanitize_link_stack_start[];
-extern char __qcom_hyp_sanitize_link_stack_end[];
 extern char __smccc_workaround_1_smc_start[];
 extern char __smccc_workaround_1_smc_end[];
 extern char __smccc_workaround_1_hvc_start[];
@@ -115,8 +113,6 @@ static void __install_bp_hardening_cb(bp_hardening_cb_t fn,
 	spin_unlock(&bp_lock);
 }
 #else
-#define __qcom_hyp_sanitize_link_stack_start	NULL
-#define __qcom_hyp_sanitize_link_stack_end	NULL
 #define __smccc_workaround_1_smc_start		NULL
 #define __smccc_workaround_1_smc_end		NULL
 #define __smccc_workaround_1_hvc_start		NULL
@@ -161,12 +157,25 @@ static void call_hvc_arch_workaround_1(void)
 	arm_smccc_1_1_hvc(ARM_SMCCC_ARCH_WORKAROUND_1, NULL);
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
 static int enable_smccc_arch_workaround_1(void *data)
 {
 	const struct arm64_cpu_capabilities *entry = data;
 	bp_hardening_cb_t cb;
 	void *smccc_start, *smccc_end;
 	struct arm_smccc_res res;
+	u32 midr = read_cpuid_id();
 
 	if (!entry->matches(entry, SCOPE_LOCAL_CPU))
 		return 0;
@@ -199,33 +208,15 @@ static int enable_smccc_arch_workaround_1(void *data)
 		return 0;
 	}
 
+	if (((midr & MIDR_CPU_MODEL_MASK) == MIDR_QCOM_FALKOR) ||
+	    ((midr & MIDR_CPU_MODEL_MASK) == MIDR_QCOM_FALKOR_V1))
+		cb = qcom_link_stack_sanitization;
+
 	install_bp_hardening_cb(entry, cb, smccc_start, smccc_end);
 
 	return 0;
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
-static int qcom_enable_link_stack_sanitization(void *data)
-{
-	const struct arm64_cpu_capabilities *entry = data;
-
-	install_bp_hardening_cb(entry, qcom_link_stack_sanitization,
-				__qcom_hyp_sanitize_link_stack_start,
-				__qcom_hyp_sanitize_link_stack_end);
-
-	return 0;
-}
 #endif	/* CONFIG_HARDEN_BRANCH_PREDICTOR */
 
 #define MIDR_RANGE(model, min, max) \
@@ -400,20 +391,12 @@ static int qcom_enable_link_stack_sanitization(void *data)
 	{
 		.capability = ARM64_HARDEN_BRANCH_PREDICTOR,
 		MIDR_ALL_VERSIONS(MIDR_QCOM_FALKOR_V1),
-		.enable = qcom_enable_link_stack_sanitization,
-	},
-	{
-		.capability = ARM64_HARDEN_BP_POST_GUEST_EXIT,
-		MIDR_ALL_VERSIONS(MIDR_QCOM_FALKOR_V1),
+		.enable = enable_smccc_arch_workaround_1,
 	},
 	{
 		.capability = ARM64_HARDEN_BRANCH_PREDICTOR,
 		MIDR_ALL_VERSIONS(MIDR_QCOM_FALKOR),
-		.enable = qcom_enable_link_stack_sanitization,
-	},
-	{
-		.capability = ARM64_HARDEN_BP_POST_GUEST_EXIT,
-		MIDR_ALL_VERSIONS(MIDR_QCOM_FALKOR),
+		.enable = enable_smccc_arch_workaround_1,
 	},
 	{
 		.capability = ARM64_HARDEN_BRANCH_PREDICTOR,
diff --git a/arch/arm64/kvm/hyp/entry.S b/arch/arm64/kvm/hyp/entry.S
index fdd1068..56fc2bb 100644
--- a/arch/arm64/kvm/hyp/entry.S
+++ b/arch/arm64/kvm/hyp/entry.S
@@ -213,15 +213,3 @@ alternative_endif
 
 	eret
 ENDPROC(__fpsimd_guest_restore)
-
-ENTRY(__qcom_hyp_sanitize_btac_predictors)
-	/**
-	 * Call SMC64 with Silicon provider serviceID 23<<8 (0xc2001700)
-	 * 0xC2000000-0xC200FFFF: assigned to SiP Service Calls
-	 * b15-b0: contains SiP functionID
-	 */
-	movz    x0, #0x1700
-	movk    x0, #0xc200, lsl #16
-	smc     #0
-	ret
-ENDPROC(__qcom_hyp_sanitize_btac_predictors)
diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
index 870f4b1..d4a336e 100644
--- a/arch/arm64/kvm/hyp/switch.c
+++ b/arch/arm64/kvm/hyp/switch.c
@@ -403,16 +403,6 @@ int __hyp_text __kvm_vcpu_run(struct kvm_vcpu *vcpu)
 		/* 0 falls through to be handled out of EL2 */
 	}
 
-	if (cpus_have_const_cap(ARM64_HARDEN_BP_POST_GUEST_EXIT)) {
-		u32 midr = read_cpuid_id();
-
-		/* Apply BTAC predictors mitigation to all Falkor chips */
-		if (((midr & MIDR_CPU_MODEL_MASK) == MIDR_QCOM_FALKOR) ||
-		    ((midr & MIDR_CPU_MODEL_MASK) == MIDR_QCOM_FALKOR_V1)) {
-			__qcom_hyp_sanitize_btac_predictors();
-		}
-	}
-
 	fp_enabled = __fpsimd_enabled();
 
 	__sysreg_save_guest_state(guest_ctxt);
-- 
Qualcomm Datacenter Technologies, Inc. on behalf of the Qualcomm Technologies, Inc.
Qualcomm Technologies, Inc. is a member of the Code Aurora Forum, a Linux Foundation Collaborative Project.
