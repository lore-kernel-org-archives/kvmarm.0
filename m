From: Shanker Donthineni <shankerd@codeaurora.org>
Subject: [PATCH] arm64: Add missing Falkor part number for branch predictor hardening
Date: Sun, 11 Feb 2018 19:16:15 -0600
Message-ID: <1518398175-28378-1-git-send-email-shankerd@codeaurora.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Will Deacon <will.deacon@arm.com>, Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>, linux-kernel <linux-kernel@vger.kernel.org>, linux-arm-kernel <linux-arm-kernel@lists.infradead.org>, kvmarm <kvmarm@lists.cs.columbia.edu>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Catalin Marinas <catalin.marinas@arm.com>, Vikram Sethi <vikrams@codeaurora.org>, Sean Campbell <scampbel@codeaurora.org>, Thomas Speier <tspeier@codeaurora.org>, Shanker Donthineni <shankerd@codeaurora.org>
List-Id: kvmarm@lists.cs.columbia.edu

References to CPU part number MIDR_QCOM_FALKOR were dropped from the
mailing list patch due to mainline/arm64 branch dependency. So this
patch adds the missing part number.

Fixes: ec82b567a74f ("arm64: Implement branch predictor hardening for Falkor")
Signed-off-by: Shanker Donthineni <shankerd@codeaurora.org>
---
 arch/arm64/kernel/cpu_errata.c | 9 +++++++++
 arch/arm64/kvm/hyp/switch.c    | 4 +++-
 2 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kernel/cpu_errata.c
index 0782359..52f15cd 100644
--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -408,6 +408,15 @@ static int qcom_enable_link_stack_sanitization(void *data)
 	},
 	{
 		.capability = ARM64_HARDEN_BRANCH_PREDICTOR,
+		MIDR_ALL_VERSIONS(MIDR_QCOM_FALKOR),
+		.enable = qcom_enable_link_stack_sanitization,
+	},
+	{
+		.capability = ARM64_HARDEN_BP_POST_GUEST_EXIT,
+		MIDR_ALL_VERSIONS(MIDR_QCOM_FALKOR),
+	},
+	{
+		.capability = ARM64_HARDEN_BRANCH_PREDICTOR,
 		MIDR_ALL_VERSIONS(MIDR_BRCM_VULCAN),
 		.enable = enable_smccc_arch_workaround_1,
 	},
diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
index 116252a8..870f4b1 100644
--- a/arch/arm64/kvm/hyp/switch.c
+++ b/arch/arm64/kvm/hyp/switch.c
@@ -407,8 +407,10 @@ int __hyp_text __kvm_vcpu_run(struct kvm_vcpu *vcpu)
 		u32 midr = read_cpuid_id();
 
 		/* Apply BTAC predictors mitigation to all Falkor chips */
-		if ((midr & MIDR_CPU_MODEL_MASK) == MIDR_QCOM_FALKOR_V1)
+		if (((midr & MIDR_CPU_MODEL_MASK) == MIDR_QCOM_FALKOR) ||
+		    ((midr & MIDR_CPU_MODEL_MASK) == MIDR_QCOM_FALKOR_V1)) {
 			__qcom_hyp_sanitize_btac_predictors();
+		}
 	}
 
 	fp_enabled = __fpsimd_enabled();
-- 
Qualcomm Datacenter Technologies, Inc. on behalf of the Qualcomm Technologies, Inc.
Qualcomm Technologies, Inc. is a member of the Code Aurora Forum, a Linux Foundation Collaborative Project.
