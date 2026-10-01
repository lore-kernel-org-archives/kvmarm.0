Received: from mta0.migadu.com (out-112.mta0.migadu.com [91.218.175.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BB5251123A
	for <kvmarm@lists.linux.dev>; Thu,  1 Oct 2026 13:58:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.112
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790863123; cv=none; b=KII3VVGXiYU6HQHzOLhJKoRcv+I48HTrKdGd2iOBmUNKzj3B/6TAX1jSVxzYa5YMuV7l8LNrNY3R0kwlr6bnLUgVp3ZK9c8b2EG77SHqvsy3ttplxhXkH8mMTSiyfwDKt8J8+JMGalxtMsqQZ9Qav7TgUNOWklCir5Y3xRAbMJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790863123; c=relaxed/simple;
	bh=3MZsDT2RhV7G3If6imBYIeMQm2J+pMtLupEbMCk37dk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=hkz3k7jOXbqXVDjKu5ghdMicy0YcPFjl1L+3fMqhHHDLz16+IA+1CRFvtY+Kw+vn9yk+S/20FQ2hcbgTs3AsTR7aL6VUwQxYK/eQNb9+flKq9vVuIbIjpvAZP29WKLhJ/zB3TNb5k7Z8Rc7SR3LGlI4Mu6Jlt47/m9/e1tqcyrA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=hDlGwVQH; arc=none smtp.client-ip=91.218.175.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="hDlGwVQH"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=3MZsDT2RhV7G3If6imBYIeMQm2J+pMtLupEbMCk37dk=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790863119; v=1; x=1791467919;
 b=hDlGwVQHDvJkm9ZHew+pdR4NulpxO57IWXWfmf6tTwczwO2sUmHHOQMJMyFeEqkuXru2U/eL
 D/N+qCid83a9JpH53m1UkVi+rFT76U68SvE2yR1/Ew28Qc3Urjj2nAKoctOcW+nhtaxMfPJDtRw
 qztdGG5sPIb0/18KtPjcT048=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 2266a5c850c12bc9;
	Thu, 01 Oct 2026 13:58:38 +0000
X-Mizu-Trace-ID: 2266a5c850c12bc9
X-Migadu-Flow: FLOW_OUT
From: Fuad Tabba <fuad.tabba@linux.dev>
To: maz@kernel.org,
	oupton@kernel.org,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Cc: catalin.marinas@arm.com,
	will@kernel.org,
	joey.gouly@arm.com,
	seiden@linux.ibm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	mark.rutland@arm.com,
	steven.price@arm.com,
	vdonnefort@google.com,
	qperret@google.com,
	tabba@google.com
Subject: [PATCH v4 10/18] KVM: arm64: Handle PSCI calls for protected VMs at EL2
Date: Thu,  1 Oct 2026 14:57:03 +0100
Message-Id: <20261001135711.1640520-11-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20261001135711.1640520-1-fuad.tabba@linux.dev>
References: <20261001135711.1640520-1-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

EL2 implements PSCI 1.1 for protected VMs: CPU_ON, CPU_OFF,
PSCI_VERSION and PSCI_FEATURES are resolved at EL2 (CPU_ON and CPU_OFF
still exit to the host, which only schedules the target or stops
scheduling it), AFFINITY_INFO, CPU_SUSPEND and the platform power
operations are forwarded to the host, and anything else returns
NOT_SUPPORTED, including the TRNG calls and the functions above 1.1,
SYSTEM_OFF2 among them, that the host handled for a protected guest
until now. TRNG for protected guests is a follow-up. AFFINITY_INFO
stays with the host, which returns OFF only once it has stopped
scheduling the target: the host is what a guest polls to see a CPU_OFF
complete before it issues the next CPU_ON, as Linux does on hotplug.

Three consequences follow:

  - A protected VM has one primary vCPU, the first whose hyp vCPU is
    created with mp_state RUNNABLE. A second one, or an mp_state other
    than RUNNABLE or STOPPED, fails that vCPU's first KVM_RUN with
    -EINVAL.

  - CPU_ON finds its target among the hyp vCPUs, which exist from the
    target's first KVM_RUN; before that the guest gets
    INVALID_PARAMETERS.

  - A vCPU EL2 holds powered off doesn't run: handle___kvm_vcpu_run()
    returns ARM_EXCEPTION_IL, reported as KVM_EXIT_FAIL_ENTRY. Its
    existing bail-outs return the same code, for every hyp vCPU, instead
    of an -EINVAL whose bit 31 the host read as a pending SError.

Non-protected VMs keep power_state ON and accept any mp_state.

Each protected vCPU is OFF, ON_PENDING or ON. CPU_ON moves the target
to ON_PENDING, and the target's next run resets it and moves it to ON.
The racing transitions are cmpxchg, and the reset state is published
with a release/acquire pair, documented at each site. CPU_OFF clears
the reset flag and stores OFF with a release, and CPU_ON's writes are
control dependent on its cmpxchg reading OFF, so the target's accesses
to reset_state are ordered before the winner's writes. Rolling a CPU_ON
the host failed back to OFF requires the host's return value, which
the per-EC marshalling patch delivers along with the rollback. Until
then such a target stays ON_PENDING, and the reset has no observable
effect: flush_hyp_vcpu() copies the host's context in on every entry
until that patch removes the copy, so the target enters on the host's
values rather than the ones EL2 reset.

Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 arch/arm64/kvm/hyp/include/nvhe/pkvm.h |  14 ++
 arch/arm64/kvm/hyp/nvhe/hyp-main.c     |  25 ++-
 arch/arm64/kvm/hyp/nvhe/pkvm.c         | 293 ++++++++++++++++++++++++-
 3 files changed, 321 insertions(+), 11 deletions(-)

diff --git a/arch/arm64/kvm/hyp/include/nvhe/pkvm.h b/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
index fcb13d8b4cb69..0623ec9d3a931 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
@@ -29,6 +29,12 @@ struct pkvm_hyp_vcpu {
 
 	/* The previous exit's ARM_EXCEPTION_* code. */
 	u32 exit_code;
+
+	/*
+	 * PSCI_0_2_AFFINITY_LEVEL_{OFF, ON_PENDING, ON}. A non-protected
+	 * vCPU is always ON.
+	 */
+	int power_state;
 };
 
 /*
@@ -46,6 +52,12 @@ struct pkvm_hyp_vm {
 	struct hyp_pool pool;
 	hyp_spinlock_t lock;
 
+	/*
+	 * The vCPU initialised RUNNABLE: claimed under vm_table_lock,
+	 * released only if its own init fails.
+	 */
+	struct pkvm_hyp_vcpu *primary_vcpu;
+
 	/* Array of the hyp vCPU structures for this VM. */
 	struct pkvm_hyp_vcpu *vcpus[];
 };
@@ -100,4 +112,6 @@ void kvm_init_pvm_id_regs(struct kvm_vcpu *vcpu);
 void kvm_reset_pvm_sys_regs(struct kvm_vcpu *vcpu);
 int kvm_check_pvm_sysreg_table(void);
 
+int pkvm_reset_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu);
+struct pkvm_hyp_vcpu *pkvm_mpidr_to_hyp_vcpu(struct pkvm_hyp_vm *vm, unsigned long mpidr);
 #endif /* __ARM64_KVM_NVHE_PKVM_H__ */
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index 6f068d0f78d25..00038a162d09b 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -8,6 +8,7 @@
 #include <hyp/switch.h>
 
 #include <linux/irqchip/arm-gic-v3.h>
+#include <uapi/linux/psci.h>
 
 #include <asm/pgtable-types.h>
 #include <asm/kvm_asm.h>
@@ -458,14 +459,12 @@ static void handle___kvm_vcpu_run(struct kvm_cpu_context *host_ctxt)
 {
 	struct pkvm_hyp_vcpu *hyp_vcpu;
 	struct kvm_vcpu *host_vcpu;
-	int ret;
+	int ret = ARM_EXCEPTION_IL;
 
 	host_vcpu = get_host_hyp_vcpus(host_ctxt, 1, &hyp_vcpu);
 
-	if (!host_vcpu) {
-		ret = -EINVAL;
+	if (!host_vcpu)
 		goto out;
-	}
 
 	if (unlikely(hyp_vcpu)) {
 		/*
@@ -474,8 +473,22 @@ static void handle___kvm_vcpu_run(struct kvm_cpu_context *host_ctxt)
 		 * loading a vcpu. Therefore, if SME features enabled the host
 		 * is misbehaving.
 		 */
-		if (unlikely(system_supports_sme() && read_sysreg_s(SYS_SVCR))) {
-			ret = -EINVAL;
+		if (unlikely(system_supports_sme() && read_sysreg_s(SYS_SVCR)))
+			goto out;
+
+		/*
+		 * ON has a single writer, pkvm_reset_vcpu() on this CPU, so
+		 * READ_ONCE suffices. ON_PENDING takes the reset; -ECANCELED
+		 * is a rollback that raced it.
+		 */
+		switch (READ_ONCE(hyp_vcpu->power_state)) {
+		case PSCI_0_2_AFFINITY_LEVEL_ON:
+			break;
+		case PSCI_0_2_AFFINITY_LEVEL_ON_PENDING:
+			if (pkvm_reset_vcpu(hyp_vcpu))
+				goto out;
+			break;
+		default:
 			goto out;
 		}
 
diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index 10ff2ba6c6c1b..dcc1db6201f14 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -5,6 +5,7 @@
  */
 
 #include <kvm/arm_hypercalls.h>
+#include <kvm/arm_psci.h>
 
 #include <linux/kvm_host.h>
 #include <linux/mm.h>
@@ -431,6 +432,40 @@ static void pkvm_init_features_from_host(struct pkvm_hyp_vm *hyp_vm, const struc
 		   allowed_features, KVM_VCPU_MAX_FEATURES);
 }
 
+static int pkvm_vcpu_init_psci(struct pkvm_hyp_vcpu *hyp_vcpu, u32 mp_state)
+{
+	struct vcpu_reset_state *reset_state = &hyp_vcpu->vcpu.arch.reset_state;
+	struct pkvm_hyp_vm *hyp_vm = pkvm_hyp_vcpu_to_hyp_vm(hyp_vcpu);
+	struct kvm_vcpu *host_vcpu;
+
+	if (!pkvm_hyp_vcpu_is_protected(hyp_vcpu)) {
+		/* The host manages a non-protected vCPU: always ON at EL2. */
+		hyp_vcpu->power_state = PSCI_0_2_AFFINITY_LEVEL_ON;
+		return 0;
+	}
+
+	if (mp_state != KVM_MP_STATE_RUNNABLE && mp_state != KVM_MP_STATE_STOPPED)
+		return -EINVAL;
+
+	if (mp_state == KVM_MP_STATE_STOPPED) {
+		reset_state->reset = false;
+		hyp_vcpu->power_state = PSCI_0_2_AFFINITY_LEVEL_OFF;
+		return 0;
+	}
+
+	hyp_assert_lock_held(&vm_table_lock);
+	if (hyp_vm->primary_vcpu)
+		return -EINVAL;
+	hyp_vm->primary_vcpu = hyp_vcpu;
+
+	host_vcpu = hyp_vcpu->host_vcpu;
+	reset_state->pc = READ_ONCE(*vcpu_pc(host_vcpu));
+	reset_state->r0 = READ_ONCE(vcpu_gp_regs(host_vcpu)->regs[0]);
+	reset_state->reset = true;
+	hyp_vcpu->power_state = PSCI_0_2_AFFINITY_LEVEL_ON_PENDING;
+	return 0;
+}
+
 static void unpin_host_vcpu(struct kvm_vcpu *host_vcpu)
 {
 	if (host_vcpu)
@@ -445,6 +480,9 @@ static void unpin_host_sve_state(struct pkvm_hyp_vcpu *hyp_vcpu)
 		return;
 
 	sve_state = hyp_vcpu->vcpu.arch.sve_state;
+	if (!sve_state)
+		return;
+
 	hyp_unpin_shared_mem(sve_state,
 			     sve_state + vcpu_sve_state_size(&hyp_vcpu->vcpu));
 }
@@ -557,10 +595,12 @@ static int init_pkvm_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu,
 			      struct kvm_vcpu *host_vcpu)
 {
 	int ret = 0;
+	u32 mp_state;
 
 	if (hyp_pin_shared_mem(host_vcpu, host_vcpu + 1))
 		return -EBUSY;
 
+	mp_state = READ_ONCE(host_vcpu->arch.mp_state.mp_state);
 	hyp_vcpu->host_vcpu = host_vcpu;
 
 	hyp_vcpu->vcpu.kvm = &hyp_vm->kvm;
@@ -569,7 +609,6 @@ static int init_pkvm_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu,
 
 	hyp_vcpu->vcpu.arch.hw_mmu = &hyp_vm->kvm.arch.mmu;
 	hyp_vcpu->vcpu.arch.cflags = READ_ONCE(host_vcpu->arch.cflags);
-	hyp_vcpu->vcpu.arch.mp_state.mp_state = KVM_MP_STATE_STOPPED;
 
 	if (!pkvm_hyp_vcpu_is_protected(hyp_vcpu)) {
 		/*
@@ -599,9 +638,12 @@ static int init_pkvm_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu,
 
 	if (pkvm_hyp_vcpu_is_protected(hyp_vcpu))
 		kvm_reset_pvm_sys_regs(&hyp_vcpu->vcpu);
+	ret = pkvm_vcpu_init_psci(hyp_vcpu, mp_state);
 done:
-	if (ret)
+	if (ret) {
 		unpin_host_vcpu(host_vcpu);
+		unpin_host_sve_state(hyp_vcpu);
+	}
 	return ret;
 }
 
@@ -978,13 +1020,22 @@ int __pkvm_init_vcpu(pkvm_handle_t handle, struct kvm_vcpu *host_vcpu,
 
 	ret = init_pkvm_hyp_vcpu(hyp_vcpu, hyp_vm, host_vcpu);
 	if (ret)
-		goto unlock;
+		goto unclaim;
 
 	ret = register_hyp_vcpu(hyp_vm, hyp_vcpu);
 	if (ret) {
 		unpin_host_vcpu(host_vcpu);
 		unpin_host_sve_state(hyp_vcpu);
+		goto unclaim;
 	}
+	goto unlock;
+unclaim:
+	/*
+	 * Under vm_table_lock, so no other claim can have landed: undo
+	 * this one.
+	 */
+	if (hyp_vm->primary_vcpu == hyp_vcpu)
+		hyp_vm->primary_vcpu = NULL;
 unlock:
 	hyp_spin_unlock(&vm_table_lock);
 
@@ -1176,6 +1227,238 @@ static void pkvm_memunshare_call(u64 *ret, struct kvm_vcpu *vcpu)
 		ret[0] = SMCCC_RET_SUCCESS;
 }
 
+/*
+ * Reset the vCPU to its power-on state and commit ON_PENDING -> ON, on the
+ * target's own CPU. Returns -ECANCELED, with no side effects, if a rollback
+ * raced the reset.
+ *
+ * The requestor's PSCI CPU_ON, in pvm_psci_vcpu_on():
+ *
+ *	cmpxchg_relaxed(power_state): OFF -> ON_PENDING
+ *	<ctrl>
+ *	write_reset_state();
+ *	smp_store_release(reset_state->reset, true);
+ *
+ * The target coming online here, running, then its PSCI CPU_OFF in
+ * pvm_psci_vcpu_off():
+ *
+ *	smp_load_acquire(reset_state->reset) == true;
+ *	cmpxchg_relaxed(power_state): ON_PENDING -> ON;
+ *	read_reset_state();
+ *
+ *	<run guest>
+ *
+ *	WRITE_ONCE(reset_state->reset, false);
+ *	smp_store_release(power_state, OFF);
+ */
+int pkvm_reset_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu)
+{
+	struct vcpu_reset_state *reset_state = &hyp_vcpu->vcpu.arch.reset_state;
+
+	/*
+	 * Pairs with smp_store_release(&reset_state->reset, true) in
+	 * pvm_psci_vcpu_on(). The acquire must precede the cmpxchg: reversed, a
+	 * winning cmpxchg with a false acquire would leave power_state == ON
+	 * with the reset skipped.
+	 */
+	if (!smp_load_acquire(&reset_state->reset))
+		return -ECANCELED;
+
+	if (cmpxchg_relaxed(&hyp_vcpu->power_state, PSCI_0_2_AFFINITY_LEVEL_ON_PENDING,
+			    PSCI_0_2_AFFINITY_LEVEL_ON) != PSCI_0_2_AFFINITY_LEVEL_ON_PENDING)
+		return -ECANCELED;
+
+	kvm_reset_vcpu_core(&hyp_vcpu->vcpu);
+	kvm_reset_pvm_sys_regs(&hyp_vcpu->vcpu);
+
+	/* Must be done after resetting sys registers. */
+	kvm_reset_vcpu_psci(&hyp_vcpu->vcpu, reset_state);
+
+	hyp_vcpu->exit_code = 0;
+	return 0;
+}
+
+struct pkvm_hyp_vcpu *pkvm_mpidr_to_hyp_vcpu(struct pkvm_hyp_vm *hyp_vm, unsigned long mpidr)
+{
+	struct pkvm_hyp_vcpu *hyp_vcpu;
+	int i;
+
+	mpidr &= MPIDR_HWID_BITMASK;
+
+	for (i = 0; i < hyp_vm->kvm.created_vcpus; i++) {
+		/* Pairs with smp_store_release() in register_hyp_vcpu(). */
+		hyp_vcpu = smp_load_acquire(&hyp_vm->vcpus[i]);
+
+		if (!hyp_vcpu)
+			continue;
+
+		if (mpidr == kvm_vcpu_get_mpidr_aff(&hyp_vcpu->vcpu))
+			return hyp_vcpu;
+	}
+
+	return NULL;
+}
+
+/*
+ * Returns true when handled at EL2, false when the host must wake the target
+ * vCPU.
+ */
+static bool pvm_psci_vcpu_on(struct pkvm_hyp_vcpu *hyp_vcpu)
+{
+	struct pkvm_hyp_vm *hyp_vm = pkvm_hyp_vcpu_to_hyp_vm(hyp_vcpu);
+	struct vcpu_reset_state *reset_state;
+	struct pkvm_hyp_vcpu *target;
+	unsigned long cpu_id, ret;
+	int power_state;
+
+	cpu_id = smccc_get_arg1(&hyp_vcpu->vcpu);
+	if (!kvm_psci_valid_affinity(&hyp_vcpu->vcpu, cpu_id)) {
+		ret = PSCI_RET_INVALID_PARAMS;
+		goto error;
+	}
+
+	target = pkvm_mpidr_to_hyp_vcpu(hyp_vm, cpu_id);
+	if (!target) {
+		ret = PSCI_RET_INVALID_PARAMS;
+		goto error;
+	}
+
+	/*
+	 * vCPUs race to power on the same target. The writes below depend on
+	 * the cmpxchg reading OFF, and that control dependency with the release
+	 * of OFF in pvm_psci_vcpu_off() orders them after the target's accesses
+	 * to reset_state, so relaxed suffices.
+	 */
+	power_state = cmpxchg_relaxed(&target->power_state,
+				      PSCI_0_2_AFFINITY_LEVEL_OFF,
+				      PSCI_0_2_AFFINITY_LEVEL_ON_PENDING);
+	switch (power_state) {
+	case PSCI_0_2_AFFINITY_LEVEL_ON_PENDING:
+		ret = PSCI_RET_ON_PENDING;
+		goto error;
+	case PSCI_0_2_AFFINITY_LEVEL_ON:
+		ret = PSCI_RET_ALREADY_ON;
+		goto error;
+	case PSCI_0_2_AFFINITY_LEVEL_OFF:
+		break;
+	default:
+		ret = PSCI_RET_INTERNAL_FAILURE;
+		goto error;
+	}
+
+	reset_state = &target->vcpu.arch.reset_state;
+	WRITE_ONCE(reset_state->pc, smccc_get_arg2(&hyp_vcpu->vcpu));
+	WRITE_ONCE(reset_state->r0, smccc_get_arg3(&hyp_vcpu->vcpu));
+	WRITE_ONCE(reset_state->be, kvm_vcpu_is_be(&hyp_vcpu->vcpu));
+	/*
+	 * Publish reset_state.{pc, r0, be} to the target vCPU. Pairs with
+	 * smp_load_acquire(&reset_state->reset) in pkvm_reset_vcpu().
+	 */
+	smp_store_release(&reset_state->reset, true);
+
+	/* The host requests KVM_REQ_VCPU_RESET and wakes the target. */
+	return false;
+
+error:
+	smccc_set_retval(&hyp_vcpu->vcpu, ret, 0, 0, 0);
+	return true;
+}
+
+/*
+ * Returns true when handled at EL2, false when the host must stop scheduling
+ * the vCPU.
+ */
+static bool pvm_psci_vcpu_off(struct pkvm_hyp_vcpu *hyp_vcpu)
+{
+	/* No other writer runs while this vCPU is ON and executing. */
+	WARN_ON(READ_ONCE(hyp_vcpu->power_state) != PSCI_0_2_AFFINITY_LEVEL_ON);
+
+	WRITE_ONCE(hyp_vcpu->vcpu.arch.reset_state.reset, false);
+
+	/*
+	 * Orders pkvm_reset_vcpu()'s accesses to reset_state, and the clear
+	 * above, before OFF. Pairs with the control dependency in
+	 * pvm_psci_vcpu_on().
+	 */
+	smp_store_release(&hyp_vcpu->power_state, PSCI_0_2_AFFINITY_LEVEL_OFF);
+
+	/* Return to the host so that it can finish powering off the vcpu. */
+	return false;
+}
+
+static bool pvm_psci_version(struct pkvm_hyp_vcpu *hyp_vcpu)
+{
+	/* Nothing to be handled by the host. Go back to the guest. */
+	smccc_set_retval(&hyp_vcpu->vcpu, KVM_ARM_PSCI_1_1, 0, 0, 0);
+	return true;
+}
+
+static bool pvm_psci_features(struct pkvm_hyp_vcpu *hyp_vcpu)
+{
+	struct kvm_vcpu *vcpu = &hyp_vcpu->vcpu;
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
+static bool pkvm_handle_psci(struct pkvm_hyp_vcpu *hyp_vcpu)
+{
+	struct kvm_vcpu *vcpu = &hyp_vcpu->vcpu;
+	u32 psci_fn = smccc_get_function(vcpu);
+
+	switch (psci_fn) {
+	case PSCI_0_2_FN_CPU_ON:
+		kvm_psci_narrow_to_32bit(vcpu);
+		fallthrough;
+	case PSCI_0_2_FN64_CPU_ON:
+		return pvm_psci_vcpu_on(hyp_vcpu);
+	case PSCI_0_2_FN_CPU_OFF:
+		return pvm_psci_vcpu_off(hyp_vcpu);
+	case PSCI_0_2_FN_PSCI_VERSION:
+		return pvm_psci_version(hyp_vcpu);
+	case PSCI_1_0_FN_PSCI_FEATURES:
+		return pvm_psci_features(hyp_vcpu);
+	case PSCI_0_2_FN_AFFINITY_INFO:
+	case PSCI_0_2_FN64_AFFINITY_INFO:
+	case PSCI_0_2_FN_SYSTEM_RESET:
+	case PSCI_0_2_FN_CPU_SUSPEND:
+	case PSCI_0_2_FN64_CPU_SUSPEND:
+	case PSCI_0_2_FN_SYSTEM_OFF:
+	case PSCI_1_1_FN_SYSTEM_RESET2:
+	case PSCI_1_1_FN64_SYSTEM_RESET2:
+		return false; /* Handled by the host. */
+	default:
+		/* Unknown PSCI calls are handled here, not forwarded. */
+		smccc_set_retval(vcpu, PSCI_RET_NOT_SUPPORTED, 0, 0, 0);
+		return true;
+	}
+}
+
 /*
  * Handler for protected VM HVC calls.
  *
@@ -1185,6 +1468,7 @@ static void pkvm_memunshare_call(u64 *ret, struct kvm_vcpu *vcpu)
  */
 bool kvm_handle_pvm_hvc64(struct kvm_vcpu *vcpu, u64 *exit_code)
 {
+	struct pkvm_hyp_vcpu *hyp_vcpu = container_of(vcpu, struct pkvm_hyp_vcpu, vcpu);
 	u64 val[4] = { SMCCC_RET_INVALID_PARAMETER };
 	bool handled = true;
 	u32 feature;
@@ -1283,8 +1567,7 @@ bool kvm_handle_pvm_hvc64(struct kvm_vcpu *vcpu, u64 *exit_code)
 		pkvm_memunshare_call(val, vcpu);
 		break;
 	default:
-		/* Punt everything else back to the host, for now. */
-		handled = false;
+		return pkvm_handle_psci(hyp_vcpu);
 	}
 
 	if (handled)
-- 
2.39.5

