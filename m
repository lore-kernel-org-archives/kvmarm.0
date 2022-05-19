Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D568C433EF
	for <kvmarm@archiver.kernel.org>; Thu, 19 May 2022 13:47:37 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 444794B49E;
	Thu, 19 May 2022 09:47:37 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id WKd8rI8Eq+dV; Thu, 19 May 2022 09:47:35 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 93F444B4A5;
	Thu, 19 May 2022 09:47:35 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B490E4B434
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 May 2022 09:47:34 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id wMTJDoX6up0e for <kvmarm@lists.cs.columbia.edu>;
 Thu, 19 May 2022 09:47:33 -0400 (EDT)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DB3364B49A
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 May 2022 09:47:32 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id CF51AB824AB;
 Thu, 19 May 2022 13:47:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AD1BC36AE3;
 Thu, 19 May 2022 13:47:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1652968050;
 bh=yJrQN8Oq2UaIQqo3+D40sbnBWd1Yq9zyT101cMoDx48=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=MdJABmMLeaRIbp33zhCd792e6IPsLObJopxudR25r36kxBkDuHE3EiIqXohaVmRgZ
 vXp6Fp9uykpEPfFnSg8qjoeWRLhIDpmmGP/YhLHLFStsaNdvtZoAisgIncCOal5wiY
 P4e7S1EiOW1iV4duBltN70LTqN5LNMol2Q+STbkbXXrx9brGNDZnXUzK8rDfrgcAPw
 bXWQ4zIBxmMkR45d92oLwgxaYOPMkSqPMaypyQ7hSv7lhK2RE0MZGLXzp120sQbw9p
 OL5S2zDwwQFHFXYv5XrEqY4RSNtyArs8SmH2OfuAG1nf5t0wp88hnO+ZVbP8BXFiTs
 hkrCoAFG/GRyQ==
From: Will Deacon <will@kernel.org>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH 77/89] KVM: arm64: Handle PSCI for protected VMs in EL2
Date: Thu, 19 May 2022 14:41:52 +0100
Message-Id: <20220519134204.5379-78-will@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20220519134204.5379-1-will@kernel.org>
References: <20220519134204.5379-1-will@kernel.org>
MIME-Version: 1.0
Cc: Marc Zyngier <maz@kernel.org>, kernel-team@android.com, kvm@vger.kernel.org,
 Andy Lutomirski <luto@amacapital.net>, linux-arm-kernel@lists.infradead.org,
 Michael Roth <michael.roth@amd.com>, Catalin Marinas <catalin.marinas@arm.com>,
 Chao Peng <chao.p.peng@linux.intel.com>, Will Deacon <will@kernel.org>
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

From: Fuad Tabba <tabba@google.com>

Add PSCI 1.1 support for protected VMs at EL2.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/hyp/include/nvhe/pkvm.h |  13 +
 arch/arm64/kvm/hyp/nvhe/hyp-main.c     |  69 +++++-
 arch/arm64/kvm/hyp/nvhe/pkvm.c         | 320 ++++++++++++++++++++++++-
 3 files changed, 399 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/hyp/include/nvhe/pkvm.h b/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
index 33d34cc639ea..c1987115b217 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
@@ -28,6 +28,15 @@ struct kvm_shadow_vcpu_state {
 	/* Tracks exit code for the protected guest. */
 	u32 exit_code;
 
+	/*
+	 * Track the power state transition of a protected vcpu.
+	 * Can be in one of three states:
+	 * PSCI_0_2_AFFINITY_LEVEL_ON
+	 * PSCI_0_2_AFFINITY_LEVEL_OFF
+	 * PSCI_0_2_AFFINITY_LEVEL_PENDING
+	 */
+	int power_state;
+
 	/*
 	 * Points to the per-cpu pointer of the cpu where it's loaded, or NULL
 	 * if not loaded.
@@ -101,6 +110,10 @@ bool kvm_handle_pvm_restricted(struct kvm_vcpu *vcpu, u64 *exit_code);
 void kvm_reset_pvm_sys_regs(struct kvm_vcpu *vcpu);
 int kvm_check_pvm_sysreg_table(void);
 
+void pkvm_reset_vcpu(struct kvm_shadow_vcpu_state *shadow_state);
+
 bool kvm_handle_pvm_hvc64(struct kvm_vcpu *vcpu, u64 *exit_code);
 
+struct kvm_shadow_vcpu_state *pkvm_mpidr_to_vcpu_state(struct kvm_shadow_vm *vm, unsigned long mpidr);
+
 #endif /* __ARM64_KVM_NVHE_PKVM_H__ */
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index 26c8709f5494..c4778c7d8c4b 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -21,6 +21,7 @@
 #include <nvhe/trap_handler.h>
 
 #include <linux/irqchip/arm-gic-v3.h>
+#include <uapi/linux/psci.h>
 
 #include "../../sys_regs.h"
 
@@ -46,8 +47,37 @@ static void handle_pvm_entry_wfx(struct kvm_vcpu *host_vcpu, struct kvm_vcpu *sh
 
 static void handle_pvm_entry_hvc64(struct kvm_vcpu *host_vcpu, struct kvm_vcpu *shadow_vcpu)
 {
+	u32 psci_fn = smccc_get_function(shadow_vcpu);
 	u64 ret = READ_ONCE(host_vcpu->arch.ctxt.regs.regs[0]);
 
+	switch (psci_fn) {
+	case PSCI_0_2_FN_CPU_ON:
+	case PSCI_0_2_FN64_CPU_ON:
+		/*
+		 * Check whether the cpu_on request to the host was successful.
+		 * If not, reset the vcpu state from ON_PENDING to OFF.
+		 * This could happen if this vcpu attempted to turn on the other
+		 * vcpu while the other one is in the process of turning itself
+		 * off.
+		 */
+		if (ret != PSCI_RET_SUCCESS) {
+			unsigned long cpu_id = smccc_get_arg1(shadow_vcpu);
+			struct kvm_shadow_vm *shadow_vm;
+			struct kvm_shadow_vcpu_state *target_vcpu_state;
+
+			shadow_vm = get_shadow_vm(shadow_vcpu);
+			target_vcpu_state = pkvm_mpidr_to_vcpu_state(shadow_vm, cpu_id);
+
+			if (target_vcpu_state && READ_ONCE(target_vcpu_state->power_state) == PSCI_0_2_AFFINITY_LEVEL_ON_PENDING)
+				WRITE_ONCE(target_vcpu_state->power_state, PSCI_0_2_AFFINITY_LEVEL_OFF);
+
+			ret = PSCI_RET_INTERNAL_FAILURE;
+		}
+		break;
+	default:
+		break;
+	}
+
 	vcpu_set_reg(shadow_vcpu, 0, ret);
 }
 
@@ -206,13 +236,45 @@ static void handle_pvm_exit_sys64(struct kvm_vcpu *host_vcpu, struct kvm_vcpu *s
 
 static void handle_pvm_exit_hvc64(struct kvm_vcpu *host_vcpu, struct kvm_vcpu *shadow_vcpu)
 {
-	int i;
+	int n, i;
+
+	switch (smccc_get_function(shadow_vcpu)) {
+	/*
+	 * CPU_ON takes 3 arguments, however, to wake up the target vcpu the
+	 * host only needs to know the target's cpu_id, which is passed as the
+	 * first argument. The processing of the reset state is done at hyp.
+	 */
+	case PSCI_0_2_FN_CPU_ON:
+	case PSCI_0_2_FN64_CPU_ON:
+		n = 2;
+		break;
+
+	case PSCI_0_2_FN_CPU_OFF:
+	case PSCI_0_2_FN_SYSTEM_OFF:
+	case PSCI_0_2_FN_SYSTEM_RESET:
+	case PSCI_0_2_FN_CPU_SUSPEND:
+	case PSCI_0_2_FN64_CPU_SUSPEND:
+		n = 1;
+		break;
+
+	case PSCI_1_1_FN_SYSTEM_RESET2:
+	case PSCI_1_1_FN64_SYSTEM_RESET2:
+		n = 3;
+		break;
+
+	/*
+	 * The rest are either blocked or handled by HYP, so we should
+	 * really never be here.
+	 */
+	default:
+		BUG();
+	}
 
 	WRITE_ONCE(host_vcpu->arch.fault.esr_el2,
 		   shadow_vcpu->arch.fault.esr_el2);
 
 	/* Pass the hvc function id (r0) as well as any potential arguments. */
-	for (i = 0; i < 8; i++)
+	for (i = 0; i < n; i++)
 		WRITE_ONCE(host_vcpu->arch.ctxt.regs.regs[i],
 			   vcpu_get_reg(shadow_vcpu, i));
 }
@@ -430,6 +492,9 @@ static void flush_shadow_state(struct kvm_shadow_vcpu_state *shadow_state)
 	shadow_entry_exit_handler_fn ec_handler;
 	u8 esr_ec;
 
+	if (READ_ONCE(shadow_state->power_state) == PSCI_0_2_AFFINITY_LEVEL_ON_PENDING)
+		pkvm_reset_vcpu(shadow_state);
+
 	/*
 	 * If we deal with a non-protected guest and the state is potentially
 	 * dirty (from a host perspective), copy the state back into the shadow.
diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index 92e60ebeced5..d44f524c936b 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -8,6 +8,7 @@
 #include <linux/mm.h>
 
 #include <kvm/arm_hypercalls.h>
+#include <kvm/arm_psci.h>
 
 #include <asm/kvm_emulate.h>
 
@@ -425,6 +426,27 @@ static int init_ptrauth(struct kvm_vcpu *shadow_vcpu)
 	return ret;
 }
 
+static int init_shadow_psci(struct kvm_shadow_vm *vm,
+			    struct kvm_shadow_vcpu_state *shadow_vcpu_state,
+			    struct kvm_vcpu *host_vcpu)
+{
+	struct kvm_vcpu *shadow_vcpu = &shadow_vcpu_state->shadow_vcpu;
+	struct vcpu_reset_state *reset_state = &shadow_vcpu->arch.reset_state;
+
+	if (test_bit(KVM_ARM_VCPU_POWER_OFF, shadow_vcpu->arch.features)) {
+		reset_state->reset = false;
+		shadow_vcpu_state->power_state = PSCI_0_2_AFFINITY_LEVEL_OFF;
+		return 0;
+	}
+
+	reset_state->pc = READ_ONCE(host_vcpu->arch.ctxt.regs.pc);
+	reset_state->r0 = READ_ONCE(host_vcpu->arch.ctxt.regs.regs[0]);
+	reset_state->reset = true;
+	shadow_vcpu_state->power_state = PSCI_0_2_AFFINITY_LEVEL_ON_PENDING;
+
+	return 0;
+}
+
 static int init_shadow_structs(struct kvm *kvm, struct kvm_shadow_vm *vm,
 			       struct kvm_vcpu **vcpu_array,
 			       int *last_ran,
@@ -485,6 +507,11 @@ static int init_shadow_structs(struct kvm *kvm, struct kvm_shadow_vm *vm,
 
 		pkvm_vcpu_init_traps(shadow_vcpu, host_vcpu);
 		kvm_reset_pvm_sys_regs(shadow_vcpu);
+
+		/* Must be done after reseting sys registers. */
+		ret = init_shadow_psci(vm, shadow_vcpu_state, host_vcpu);
+		if (ret)
+			return ret;
 	}
 
 	return 0;
@@ -800,6 +827,297 @@ int __pkvm_teardown_shadow(unsigned int shadow_handle)
 	return err;
 }
 
+/*
+ * This function sets the registers on the vcpu to their architecturally defined
+ * reset values.
+ *
+ * Note: Can only be called by the vcpu on itself, after it has been turned on.
+ */
+void pkvm_reset_vcpu(struct kvm_shadow_vcpu_state *shadow_state)
+{
+	struct kvm_vcpu *vcpu = &shadow_state->shadow_vcpu;
+	struct vcpu_reset_state *reset_state = &vcpu->arch.reset_state;
+
+	WARN_ON(!reset_state->reset);
+
+	init_ptrauth(vcpu);
+
+	kvm_reset_vcpu_core(vcpu);
+	kvm_reset_pvm_sys_regs(vcpu);
+
+	/* Must be done after reseting sys registers. */
+	kvm_reset_vcpu_psci(vcpu, reset_state);
+
+	reset_state->reset = false;
+
+	shadow_state->exit_code = 0;
+
+	WARN_ON(shadow_state->power_state != PSCI_0_2_AFFINITY_LEVEL_ON_PENDING);
+	WRITE_ONCE(vcpu->arch.power_off, false);
+	WRITE_ONCE(shadow_state->power_state, PSCI_0_2_AFFINITY_LEVEL_ON);
+}
+
+struct kvm_shadow_vcpu_state *pkvm_mpidr_to_vcpu_state(struct kvm_shadow_vm *vm, unsigned long mpidr)
+{
+	struct kvm_vcpu *vcpu;
+	int i;
+
+	mpidr &= MPIDR_HWID_BITMASK;
+
+	for (i = 0; i < vm->kvm.created_vcpus; i++) {
+		vcpu = &vm->shadow_vcpu_states[i].shadow_vcpu;
+
+		if (mpidr == kvm_vcpu_get_mpidr_aff(vcpu))
+			return &vm->shadow_vcpu_states[i];
+	}
+
+	return NULL;
+}
+
+/*
+ * Returns true if the hypervisor has handled the PSCI call, and control should
+ * go back to the guest, or false if the host needs to do some additional work
+ * (i.e., wake up the vcpu).
+ */
+static bool pvm_psci_vcpu_on(struct kvm_vcpu *source_vcpu)
+{
+	struct kvm_shadow_vcpu_state *target_vcpu_state;
+	struct kvm_shadow_vm *vm;
+	struct vcpu_reset_state *reset_state;
+	unsigned long cpu_id;
+	unsigned long hvc_ret_val;
+	int power_state;
+
+	cpu_id = smccc_get_arg1(source_vcpu);
+	if (!kvm_psci_valid_affinity(source_vcpu, cpu_id)) {
+		hvc_ret_val = PSCI_RET_INVALID_PARAMS;
+		goto error;
+	}
+
+	vm = get_shadow_vm(source_vcpu);
+	target_vcpu_state = pkvm_mpidr_to_vcpu_state(vm, cpu_id);
+
+	/* Make sure the caller requested a valid vcpu. */
+	if (!target_vcpu_state) {
+		hvc_ret_val = PSCI_RET_INVALID_PARAMS;
+		goto error;
+	}
+
+	/*
+	 * Make sure the requested vcpu is not on to begin with.
+	 * Atomic to avoid race between vcpus trying to power on the same vcpu.
+	 */
+	power_state = cmpxchg(&target_vcpu_state->power_state,
+		PSCI_0_2_AFFINITY_LEVEL_OFF,
+		PSCI_0_2_AFFINITY_LEVEL_ON_PENDING);
+	switch (power_state) {
+	case PSCI_0_2_AFFINITY_LEVEL_ON_PENDING:
+		hvc_ret_val = PSCI_RET_ON_PENDING;
+		goto error;
+	case PSCI_0_2_AFFINITY_LEVEL_ON:
+		hvc_ret_val = PSCI_RET_ALREADY_ON;
+		goto error;
+	case PSCI_0_2_AFFINITY_LEVEL_OFF:
+		break;
+	default:
+		hvc_ret_val = PSCI_RET_INTERNAL_FAILURE;
+		goto error;
+	}
+
+	reset_state = &target_vcpu_state->shadow_vcpu.arch.reset_state;
+
+	reset_state->pc = smccc_get_arg2(source_vcpu);
+	reset_state->r0 = smccc_get_arg3(source_vcpu);
+
+	/* Propagate caller endianness */
+	reset_state->be = kvm_vcpu_is_be(source_vcpu);
+
+	reset_state->reset = true;
+
+	/*
+	 * Return to the host, which should make the KVM_REQ_VCPU_RESET request
+	 * as well as kvm_vcpu_wake_up() to schedule the vcpu.
+	 */
+	return false;
+
+error:
+	/* If there's an error go back straight to the guest. */
+	smccc_set_retval(source_vcpu, hvc_ret_val, 0, 0, 0);
+	return true;
+}
+
+static bool pvm_psci_vcpu_affinity_info(struct kvm_vcpu *vcpu)
+{
+	int i, matching_cpus = 0;
+	unsigned long mpidr;
+	unsigned long target_affinity;
+	unsigned long target_affinity_mask;
+	unsigned long lowest_affinity_level;
+	struct kvm_shadow_vm *vm;
+	unsigned long hvc_ret_val;
+
+	target_affinity = smccc_get_arg1(vcpu);
+	lowest_affinity_level = smccc_get_arg2(vcpu);
+
+	if (!kvm_psci_valid_affinity(vcpu, target_affinity)) {
+		hvc_ret_val = PSCI_RET_INVALID_PARAMS;
+		goto done;
+	}
+
+	/* Determine target affinity mask */
+	target_affinity_mask = psci_affinity_mask(lowest_affinity_level);
+	if (!target_affinity_mask) {
+		hvc_ret_val = PSCI_RET_INVALID_PARAMS;
+		goto done;
+	}
+
+	vm = get_shadow_vm(vcpu);
+
+	/* Ignore other bits of target affinity */
+	target_affinity &= target_affinity_mask;
+
+	hvc_ret_val = PSCI_0_2_AFFINITY_LEVEL_OFF;
+
+	/*
+	 * If at least one vcpu matching target affinity is ON then return ON,
+	 * then if at least one is PENDING_ON then return PENDING_ON.
+	 * Otherwise, return OFF.
+	 */
+	for (i = 0; i < vm->kvm.created_vcpus; i++) {
+		struct kvm_shadow_vcpu_state *tmp = &vm->shadow_vcpu_states[i];
+
+		mpidr = kvm_vcpu_get_mpidr_aff(&tmp->shadow_vcpu);
+
+		if ((mpidr & target_affinity_mask) == target_affinity) {
+			int power_state;
+
+			matching_cpus++;
+			power_state = READ_ONCE(tmp->power_state);
+			switch (power_state) {
+			case PSCI_0_2_AFFINITY_LEVEL_ON_PENDING:
+				hvc_ret_val = PSCI_0_2_AFFINITY_LEVEL_ON_PENDING;
+				break;
+			case PSCI_0_2_AFFINITY_LEVEL_ON:
+				hvc_ret_val = PSCI_0_2_AFFINITY_LEVEL_ON;
+				goto done;
+			case PSCI_0_2_AFFINITY_LEVEL_OFF:
+				break;
+			default:
+				hvc_ret_val = PSCI_RET_INTERNAL_FAILURE;
+				goto done;
+			}
+		}
+	}
+
+	if (!matching_cpus)
+		hvc_ret_val = PSCI_RET_INVALID_PARAMS;
+
+done:
+	/* Nothing to be handled by the host. Go back to the guest. */
+	smccc_set_retval(vcpu, hvc_ret_val, 0, 0, 0);
+	return true;
+}
+
+/*
+ * Returns true if the hypervisor has handled the PSCI call, and control should
+ * go back to the guest, or false if the host needs to do some additional work
+ * (e.g., turn off and update vcpu scheduling status).
+ */
+static bool pvm_psci_vcpu_off(struct kvm_vcpu *vcpu)
+{
+	struct kvm_shadow_vcpu_state *vcpu_state = get_shadow_state(vcpu);
+
+	WARN_ON(vcpu->arch.power_off);
+	WARN_ON(vcpu_state->power_state != PSCI_0_2_AFFINITY_LEVEL_ON);
+
+	WRITE_ONCE(vcpu->arch.power_off, true);
+	WRITE_ONCE(vcpu_state->power_state, PSCI_0_2_AFFINITY_LEVEL_OFF);
+
+	/* Return to the host so that it can finish powering off the vcpu. */
+	return false;
+}
+
+static bool pvm_psci_version(struct kvm_vcpu *vcpu)
+{
+	/* Nothing to be handled by the host. Go back to the guest. */
+	smccc_set_retval(vcpu, KVM_ARM_PSCI_1_1, 0, 0, 0);
+	return true;
+}
+
+static bool pvm_psci_not_supported(struct kvm_vcpu *vcpu)
+{
+	/* Nothing to be handled by the host. Go back to the guest. */
+	smccc_set_retval(vcpu, PSCI_RET_NOT_SUPPORTED, 0, 0, 0);
+	return true;
+}
+
+static bool pvm_psci_features(struct kvm_vcpu *vcpu)
+{
+	u32 feature = smccc_get_arg1(vcpu);
+	unsigned long val;
+
+	switch (feature) {
+	case PSCI_0_2_FN_PSCI_VERSION:
+	case PSCI_0_2_FN_CPU_SUSPEND:
+	case PSCI_0_2_FN64_CPU_SUSPEND:
+	case PSCI_0_2_FN_CPU_OFF:
+	case PSCI_0_2_FN_CPU_ON:
+	case PSCI_0_2_FN64_CPU_ON:
+	case PSCI_0_2_FN_AFFINITY_INFO:
+	case PSCI_0_2_FN64_AFFINITY_INFO:
+	case PSCI_0_2_FN_SYSTEM_OFF:
+	case PSCI_0_2_FN_SYSTEM_RESET:
+	case PSCI_1_0_FN_PSCI_FEATURES:
+	case PSCI_1_1_FN_SYSTEM_RESET2:
+	case PSCI_1_1_FN64_SYSTEM_RESET2:
+	case ARM_SMCCC_VERSION_FUNC_ID:
+		val = PSCI_RET_SUCCESS;
+		break;
+	default:
+		val = PSCI_RET_NOT_SUPPORTED;
+		break;
+	}
+
+	/* Nothing to be handled by the host. Go back to the guest. */
+	smccc_set_retval(vcpu, val, 0, 0, 0);
+	return true;
+}
+
+static bool pkvm_handle_psci(struct kvm_vcpu *vcpu)
+{
+	u32 psci_fn = smccc_get_function(vcpu);
+
+	switch (psci_fn) {
+	case PSCI_0_2_FN_CPU_ON:
+		kvm_psci_narrow_to_32bit(vcpu);
+		fallthrough;
+	case PSCI_0_2_FN64_CPU_ON:
+		return pvm_psci_vcpu_on(vcpu);
+	case PSCI_0_2_FN_CPU_OFF:
+		return pvm_psci_vcpu_off(vcpu);
+	case PSCI_0_2_FN_AFFINITY_INFO:
+		kvm_psci_narrow_to_32bit(vcpu);
+		fallthrough;
+	case PSCI_0_2_FN64_AFFINITY_INFO:
+		return pvm_psci_vcpu_affinity_info(vcpu);
+	case PSCI_0_2_FN_PSCI_VERSION:
+		return pvm_psci_version(vcpu);
+	case PSCI_1_0_FN_PSCI_FEATURES:
+		return pvm_psci_features(vcpu);
+	case PSCI_0_2_FN_SYSTEM_RESET:
+	case PSCI_0_2_FN_CPU_SUSPEND:
+	case PSCI_0_2_FN64_CPU_SUSPEND:
+	case PSCI_0_2_FN_SYSTEM_OFF:
+	case PSCI_1_1_FN_SYSTEM_RESET2:
+	case PSCI_1_1_FN64_SYSTEM_RESET2:
+		return false; /* Handled by the host. */
+	default:
+		break;
+	}
+
+	return pvm_psci_not_supported(vcpu);
+}
+
 /*
  * Handler for protected VM HVC calls.
  *
@@ -816,6 +1134,6 @@ bool kvm_handle_pvm_hvc64(struct kvm_vcpu *vcpu, u64 *exit_code)
 		smccc_set_retval(vcpu, ARM_SMCCC_VERSION_1_1, 0, 0, 0);
 		return true;
 	default:
-		return false;
+		return pkvm_handle_psci(vcpu);
 	}
 }
-- 
2.36.1.124.g0e6072fb45-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
