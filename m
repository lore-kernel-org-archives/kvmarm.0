From: Steven Price <steven.price@arm.com>
Subject: [PATCH 04/12] arm/arm64: Make use of the SMCCC 1.1 wrapper
Date: Wed, 28 Nov 2018 14:45:19 +0000
Message-ID: <20181128144527.44710-5-steven.price@arm.com>
References: <20181128144527.44710-1-steven.price@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 395144A36E
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Nov 2018 09:46:38 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id EGf9E3LqcD1p for <kvmarm@lists.cs.columbia.edu>;
 Wed, 28 Nov 2018 09:46:37 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BDADE4A348
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Nov 2018 09:46:35 -0500 (EST)
In-Reply-To: <20181128144527.44710-1-steven.price@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Steven Price <steven.price@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

Rather than directly choosing which function to use based on
psci_ops.conduit, use the new arm_smccc_1_1 wrapper instead.

In some cases we still need to do some operations based on the
conduit, but the code duplication is removed.

Signed-off-by: Steven Price <steven.price@arm.com>
---
 arch/arm/mm/proc-v7-bugs.c     | 46 +++++++++++++++------------------
 arch/arm64/kernel/cpu_errata.c | 47 +++++++++-------------------------
 2 files changed, 32 insertions(+), 61 deletions(-)

diff --git a/arch/arm/mm/proc-v7-bugs.c b/arch/arm/mm/proc-v7-bugs.c
index 5544b82a2e7a..c24d32d3589d 100644
--- a/arch/arm/mm/proc-v7-bugs.c
+++ b/arch/arm/mm/proc-v7-bugs.c
@@ -78,39 +78,33 @@ static void cpu_v7_spectre_init(void)
 	case ARM_CPU_PART_CORTEX_A57:
 	case ARM_CPU_PART_CORTEX_A72: {
 		struct arm_smccc_res res;
+		int conduit;
 
 		if (psci_ops.smccc_version == SMCCC_VERSION_1_0)
 			break;
 
-		switch (psci_ops.conduit) {
-		case PSCI_CONDUIT_HVC:
-			arm_smccc_1_1_hvc(ARM_SMCCC_ARCH_FEATURES_FUNC_ID,
-					  ARM_SMCCC_ARCH_WORKAROUND_1, &res);
-			if ((int)res.a0 != 0)
-				break;
+		conduit = arm_smccc_1_1(ARM_SMCCC_ARCH_FEATURES_FUNC_ID,
+					ARM_SMCCC_ARCH_WORKAROUND_1, &res);
+
+		if ((int)res.a0 == 0) {
 			if (processor.switch_mm != cpu_v7_hvc_switch_mm && cpu)
 				goto bl_error;
-			per_cpu(harden_branch_predictor_fn, cpu) =
-				call_hvc_arch_workaround_1;
-			processor.switch_mm = cpu_v7_hvc_switch_mm;
-			spectre_v2_method = "hypervisor";
-			break;
-
-		case PSCI_CONDUIT_SMC:
-			arm_smccc_1_1_smc(ARM_SMCCC_ARCH_FEATURES_FUNC_ID,
-					  ARM_SMCCC_ARCH_WORKAROUND_1, &res);
-			if ((int)res.a0 != 0)
+			switch (conduit) {
+			case PSCI_CONDUIT_HVC:
+				per_cpu(harden_branch_predictor_fn, cpu) =
+					call_hvc_arch_workaround_1;
+				processor.switch_mm = cpu_v7_hvc_switch_mm;
+				spectre_v2_method = "hypervisor";
 				break;
-			if (processor.switch_mm != cpu_v7_smc_switch_mm && cpu)
-				goto bl_error;
-			per_cpu(harden_branch_predictor_fn, cpu) =
-				call_smc_arch_workaround_1;
-			processor.switch_mm = cpu_v7_smc_switch_mm;
-			spectre_v2_method = "firmware";
-			break;
-
-		default:
-			break;
+			case PSCI_CONDUIT_SMC:
+				per_cpu(harden_branch_predictor_fn, cpu) =
+					call_smc_arch_workaround_1;
+				processor.switch_mm = cpu_v7_smc_switch_mm;
+				spectre_v2_method = "firmware";
+				break;
+			default:
+				break;
+			}
 		}
 	}
 #endif
diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kernel/cpu_errata.c
index a509e35132d2..6266284cc801 100644
--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -234,12 +234,14 @@ enable_smccc_arch_workaround_1(const struct arm64_cpu_capabilities *entry)
 	if (psci_ops.smccc_version == SMCCC_VERSION_1_0)
 		return;
 
+	arm_smccc_1_1(ARM_SMCCC_ARCH_FEATURES_FUNC_ID,
+				ARM_SMCCC_ARCH_WORKAROUND_1, &res);
+
+	if ((int)res.a0 < 0)
+		return;
+
 	switch (psci_ops.conduit) {
 	case PSCI_CONDUIT_HVC:
-		arm_smccc_1_1_hvc(ARM_SMCCC_ARCH_FEATURES_FUNC_ID,
-				  ARM_SMCCC_ARCH_WORKAROUND_1, &res);
-		if ((int)res.a0 < 0)
-			return;
 		cb = call_hvc_arch_workaround_1;
 		/* This is a guest, no need to patch KVM vectors */
 		smccc_start = NULL;
@@ -247,10 +249,6 @@ enable_smccc_arch_workaround_1(const struct arm64_cpu_capabilities *entry)
 		break;
 
 	case PSCI_CONDUIT_SMC:
-		arm_smccc_1_1_smc(ARM_SMCCC_ARCH_FEATURES_FUNC_ID,
-				  ARM_SMCCC_ARCH_WORKAROUND_1, &res);
-		if ((int)res.a0 < 0)
-			return;
 		cb = call_smc_arch_workaround_1;
 		smccc_start = __smccc_workaround_1_smc_start;
 		smccc_end = __smccc_workaround_1_smc_end;
@@ -343,6 +341,8 @@ void __init arm64_enable_wa2_handling(struct alt_instr *alt,
 
 void arm64_set_ssbd_mitigation(bool state)
 {
+	int conduit;
+
 	if (this_cpu_has_cap(ARM64_SSBS)) {
 		if (state)
 			asm volatile(SET_PSTATE_SSBS(0));
@@ -351,19 +351,9 @@ void arm64_set_ssbd_mitigation(bool state)
 		return;
 	}
 
-	switch (psci_ops.conduit) {
-	case PSCI_CONDUIT_HVC:
-		arm_smccc_1_1_hvc(ARM_SMCCC_ARCH_WORKAROUND_2, state, NULL);
-		break;
-
-	case PSCI_CONDUIT_SMC:
-		arm_smccc_1_1_smc(ARM_SMCCC_ARCH_WORKAROUND_2, state, NULL);
-		break;
+	conduit = arm_smccc_1_1(ARM_SMCCC_ARCH_WORKAROUND_2, state, NULL);
 
-	default:
-		WARN_ON_ONCE(1);
-		break;
-	}
+	WARN_ON_ONCE(conduit == PSCI_CONDUIT_NONE);
 }
 
 static bool has_ssbd_mitigation(const struct arm64_cpu_capabilities *entry,
@@ -385,21 +375,8 @@ static bool has_ssbd_mitigation(const struct arm64_cpu_capabilities *entry,
 		return false;
 	}
 
-	switch (psci_ops.conduit) {
-	case PSCI_CONDUIT_HVC:
-		arm_smccc_1_1_hvc(ARM_SMCCC_ARCH_FEATURES_FUNC_ID,
-				  ARM_SMCCC_ARCH_WORKAROUND_2, &res);
-		break;
-
-	case PSCI_CONDUIT_SMC:
-		arm_smccc_1_1_smc(ARM_SMCCC_ARCH_FEATURES_FUNC_ID,
-				  ARM_SMCCC_ARCH_WORKAROUND_2, &res);
-		break;
-
-	default:
-		ssbd_state = ARM64_SSBD_UNKNOWN;
-		return false;
-	}
+	arm_smccc_1_1(ARM_SMCCC_ARCH_FEATURES_FUNC_ID,
+		      ARM_SMCCC_ARCH_WORKAROUND_2, &res);
 
 	val = (s32)res.a0;
 
-- 
2.19.2
