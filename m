Received: from mta1.migadu.com (out-81.mta1.migadu.com [95.215.58.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00ED5515968
	for <kvmarm@lists.linux.dev>; Thu,  1 Oct 2026 13:58:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790863136; cv=none; b=GbkLFTfNZsqECouvHOMt4An+ssUoCc2+fOgkXeuVwvwFxxXUGN+PYzOX/5/g7mTSGQxk/mLLw33zS+1IUHPu2nn5wAXYgEBUVDgK0x5A73ZBRuihJBoI4BTZtISKlgN3EVsTEppsD9DtieofxJKsUymUI+dry5rZ0TKwASf8B60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790863136; c=relaxed/simple;
	bh=yBeurC8IOhyLNl5PXbupKusxC2D1U/BP8DNP4Yc7RGM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=qx/BU9jMAxgTNNWIVnlzqGvBS2x9xm9OhlIUMWRxsX4bO3O+kpbO5llNas+x08xEXfMdCe9Mrel76w57t7YHwW1EPmZhG7yOXQjDmDqMLYqQN/9eos5oaOckYogYs50foSqvRsryeNUuHirwmBSXkrqJoFhYTFzP5EGuRvvkIcg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=L+NtBwJ+; arc=none smtp.client-ip=95.215.58.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="L+NtBwJ+"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=yBeurC8IOhyLNl5PXbupKusxC2D1U/BP8DNP4Yc7RGM=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790863132; v=1; x=1791467932;
 b=L+NtBwJ+g9gfjD7eZNBauYewt/XCmmIVv+9c39g8dMTzohaDxg2y8p9AzeLl24yrtFqI0VGb
 jHdQ1JHfVY/lJHC1bPvYyH2xtiYGGkrXGP5MJZ9/Zb5LsvvFUTqTmMqRyN2Nv6jek0z4NOoSX1F
 CoUw6UqVEnA2yry76UY8vzJM=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 651c1bb7d97f3270;
	Thu, 01 Oct 2026 13:58:52 +0000
X-Mizu-Trace-ID: 651c1bb7d97f3270
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
Subject: [PATCH v4 14/18] KVM: arm64: Add per-EC entry/exit state marshalling for protected guests
Date: Thu,  1 Oct 2026 14:57:07 +0100
Message-Id: <20261001135711.1640520-15-fuad.tabba@linux.dev>
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

Move a protected guest's state between the hyp vCPU and the host per
exception class instead of copying the whole context. Add
entry_hyp_pvm_handlers[] and exit_hyp_pvm_handlers[] for WFx, SYS64,
IABT, DABT and HVC64, and route protected guests through them: on exit
each handler copies out only what its class requires, and on re-entry
only what the host may have changed: the PC update or exception it
requested (PC_UPDATE_REQ), the value of a read it emulated, and a
forwarded PSCI call's return value. entry_hyp_vm_handlers[] is
removed: a non-protected vCPU's iflags are copied wholesale.

The host's fault view is EL2's own syndrome with the guest register
index withheld, the deferred SError syndrome (DISR_EL1), and the
addresses each class requires. The value of a written register is
passed in r0. MMIO data is clamped to the access width and, for a load,
sign-extended at EL2 from EL2's syndrome. Endianness stays with the
host. A data abort's PC update is taken for a completed MMIO access,
and for a cache maintenance operation the host skips on unbacked
memory, as it does for any guest.

The host's copy of a protected vCPU's PSTATE is a view the guest never
runs from: its reset value has PSTATE.A set, and EL2 sets PSTATE.A in
the mode it copies out regardless of the guest's, so, unless the VMM
wrote the host copy's PSTATE or SCTLR2_EL1 before the first run,
serror_is_masked() is true and kvm_inject_serror_esr() pends a
host-injected SError through HCR_EL2.VSE, masked by the guest's own
PSTATE.A, instead of emulating the entry on that copy.

Neither dispatch runs for a trap taken with an SError pending: EL2
doesn't handle it, and the guest replays it once the host has
injected the SError. The exit handlers would otherwise marshal a trap
EL2 never handled, and handle_pvm_exit_hvc64() would panic on an
unfiltered function id.

For HVC64, only the PSCI calls EL2 forwards reach the host: the exit
handler passes the function id and the arguments each call takes, and
the entry handler returns the host's result. A CPU_ON the host failed
is rolled back to OFF and returned as INTERNAL_FAILURE, or as
ALREADY_ON when that's what the host returned: PSCI defines it as the
retry signal for a CPU_ON that reaches the implementation before the
target's CPU_OFF has been processed (DEN0022 section 6.6), which a
guest that doesn't poll AFFINITY_INFO first can do. A target that
already ran returns SUCCESS. The rollback leaves the published reset
state in place: clearing it races a fresh CPU_ON's publication and
leaves the target stuck at ON_PENDING, and the entry point left behind
is one the guest supplied. The rollback stores OFF with a release, as
CPU_OFF does, so this vCPU's writes to the reset state are ordered
before the next winner's. The rollback's cmpxchg carries no generation,
so one that lands after a later CPU_ON has republished ON_PENDING
cancels that cycle too. The target is then OFF at EL2 while the host
has it runnable, and its CPU_ONs return ALREADY_ON until the VMM stops
it again.

Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 arch/arm64/kvm/hyp/nvhe/hyp-main.c | 435 +++++++++++++++++++++++++++--
 1 file changed, 412 insertions(+), 23 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index 2fcd3f8cc8fc4..eb73374bbf87b 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -4,6 +4,8 @@
  * Author: Andrew Scull <ascull@google.com>
  */
 
+#include <kvm/arm_hypercalls.h>
+
 #include <hyp/adjust_pc.h>
 #include <hyp/switch.h>
 
@@ -34,13 +36,371 @@ void __kvm_hyp_host_forward_smc(struct kvm_cpu_context *host_ctxt);
 
 typedef void (*hyp_entry_exit_handler_fn)(struct pkvm_hyp_vcpu *);
 
-static void handle_vm_entry_generic(struct pkvm_hyp_vcpu *hyp_vcpu)
+static bool pvm_sys64_is_write(u64 esr)
 {
-	vcpu_copy_flag(&hyp_vcpu->vcpu, hyp_vcpu->host_vcpu, PC_UPDATE_REQ);
+	return (esr & ESR_ELx_SYS64_ISS_DIR_MASK) == ESR_ELx_SYS64_ISS_DIR_WRITE;
 }
 
-static const hyp_entry_exit_handler_fn entry_hyp_vm_handlers[] = {
-	[0 ... ESR_ELx_EC_MAX]		= handle_vm_entry_generic,
+static void handle_pvm_entry_wfx(struct pkvm_hyp_vcpu *hyp_vcpu)
+{
+	struct kvm_vcpu *host_vcpu = hyp_vcpu->host_vcpu;
+	struct kvm_vcpu *vcpu = &hyp_vcpu->vcpu;
+
+	/* Exceptions have priority; the host injects none on WFx. */
+	if (vcpu_get_flag(host_vcpu, PENDING_EXCEPTION))
+		return;
+
+	if (vcpu_get_flag(host_vcpu, INCREMENT_PC)) {
+		vcpu_clear_flag(vcpu, PC_UPDATE_REQ);
+		kvm_incr_pc(vcpu);
+	}
+}
+
+static void handle_pvm_entry_sys64(struct pkvm_hyp_vcpu *hyp_vcpu)
+{
+	struct kvm_vcpu *host_vcpu = hyp_vcpu->host_vcpu;
+	struct kvm_vcpu *vcpu = &hyp_vcpu->vcpu;
+	bool pc_update;
+
+	/* Exceptions have priority over anything else */
+	if (vcpu_get_flag(host_vcpu, PENDING_EXCEPTION)) {
+		/* A host-requested exception on SYS64 is always an UNDEF. */
+		u32 esr = (ESR_ELx_EC_UNKNOWN << ESR_ELx_EC_SHIFT) | ESR_ELx_IL;
+
+		__vcpu_assign_sys_reg(vcpu, ESR_EL1, esr);
+		kvm_pend_exception(vcpu, EXCEPT_AA64_EL1_SYNC);
+		return;
+	}
+
+	/* Handle PC increment on a host-emulated access */
+	pc_update = vcpu_get_flag(host_vcpu, INCREMENT_PC);
+	if (pc_update) {
+		vcpu_clear_flag(vcpu, PC_UPDATE_REQ);
+		kvm_incr_pc(vcpu);
+	}
+
+	/* If the host emulated a read access, update the register */
+	if (pc_update && !pvm_sys64_is_write(kvm_vcpu_get_esr(vcpu))) {
+		/* r0 as transfer register between the guest and the host. */
+		u64 rt_val = READ_ONCE(vcpu_gp_regs(host_vcpu)->regs[0]);
+		int rt = kvm_vcpu_sys_get_rt(vcpu);
+
+		vcpu_set_reg(vcpu, rt, rt_val);
+	}
+}
+
+static void handle_pvm_entry_iabt(struct pkvm_hyp_vcpu *hyp_vcpu)
+{
+	struct kvm_vcpu *host_vcpu = hyp_vcpu->host_vcpu;
+	struct kvm_vcpu *vcpu = &hyp_vcpu->vcpu;
+	unsigned long cpsr = *vcpu_cpsr(vcpu);
+	u32 esr = ESR_ELx_IL;
+
+	if (!vcpu_get_flag(host_vcpu, PENDING_EXCEPTION))
+		return;
+
+	/* The host's only IABT injection: an external abort. */
+	if ((cpsr & PSR_MODE_MASK) == PSR_MODE_EL0t)
+		esr |= (ESR_ELx_EC_IABT_LOW << ESR_ELx_EC_SHIFT);
+	else
+		esr |= (ESR_ELx_EC_IABT_CUR << ESR_ELx_EC_SHIFT);
+
+	esr |= ESR_ELx_FSC_EXTABT;
+
+	__vcpu_assign_sys_reg(vcpu, ESR_EL1, esr);
+	__vcpu_assign_sys_reg(vcpu, FAR_EL1, kvm_vcpu_get_hfar(vcpu));
+
+	/* Injected by __kvm_adjust_pc() on entry. */
+	kvm_pend_exception(vcpu, EXCEPT_AA64_EL1_SYNC);
+}
+
+/*
+ * Clamp MMIO data to the access width, so a write does not leak the
+ * register's upper bits and a read takes no bits beyond the load. The
+ * host applies endianness.
+ */
+static inline u64 kvm_mmio_clamp_data(struct kvm_vcpu *vcpu, u64 val)
+{
+	unsigned int len = kvm_vcpu_dabt_get_as(vcpu);
+
+	return val & GENMASK_U64(len * 8 - 1, 0);
+}
+
+/*
+ * Complete an MMIO load: sign-extend from EL2's own syndrome, as the
+ * architecture does.
+ */
+static inline u64 kvm_mmio_read_data(struct kvm_vcpu *vcpu, u64 val)
+{
+	val = kvm_mmio_clamp_data(vcpu, val);
+
+	if (kvm_vcpu_dabt_issext(vcpu))
+		val = sign_extend64(val, kvm_vcpu_dabt_get_as(vcpu) * 8 - 1);
+
+	if (!kvm_vcpu_dabt_issf(vcpu))
+		val &= GENMASK_U64(31, 0);
+
+	return val;
+}
+
+static void handle_pvm_entry_dabt(struct pkvm_hyp_vcpu *hyp_vcpu)
+{
+	struct kvm_vcpu *host_vcpu = hyp_vcpu->host_vcpu;
+	struct kvm_vcpu *vcpu = &hyp_vcpu->vcpu;
+	bool pc_update;
+
+	/* Exceptions have priority over anything else */
+	if (vcpu_get_flag(host_vcpu, PENDING_EXCEPTION)) {
+		unsigned long cpsr = *vcpu_cpsr(vcpu);
+		u32 esr = ESR_ELx_IL;
+
+		if ((cpsr & PSR_MODE_MASK) == PSR_MODE_EL0t)
+			esr |= (ESR_ELx_EC_DABT_LOW << ESR_ELx_EC_SHIFT);
+		else
+			esr |= (ESR_ELx_EC_DABT_CUR << ESR_ELx_EC_SHIFT);
+
+		esr |= ESR_ELx_FSC_EXTABT;
+
+		__vcpu_assign_sys_reg(vcpu, ESR_EL1, esr);
+		__vcpu_assign_sys_reg(vcpu, FAR_EL1, kvm_vcpu_get_hfar(vcpu));
+
+		/* Injected by __kvm_adjust_pc() on entry. */
+		kvm_pend_exception(vcpu, EXCEPT_AA64_EL1_SYNC);
+
+		/* Cancel any in-flight MMIO */
+		vcpu->mmio_needed = false;
+		return;
+	}
+
+	/* Handle PC increment on MMIO, or on a CMO the host skipped */
+	pc_update = vcpu_get_flag(host_vcpu, INCREMENT_PC) &&
+		    (vcpu->mmio_needed || kvm_vcpu_dabt_is_cm(vcpu));
+	if (pc_update) {
+		vcpu_clear_flag(vcpu, PC_UPDATE_REQ);
+		kvm_incr_pc(vcpu);
+	}
+
+	/* If the host emulated an MMIO read, update the register */
+	if (pc_update && vcpu->mmio_needed && !kvm_vcpu_dabt_iswrite(vcpu)) {
+		/* r0 as transfer register between the guest and the host. */
+		u64 rd_val = READ_ONCE(vcpu_gp_regs(host_vcpu)->regs[0]);
+		int rd = kvm_vcpu_dabt_get_rd(vcpu);
+
+		rd_val = kvm_mmio_read_data(vcpu, rd_val);
+		vcpu_set_reg(vcpu, rd, rd_val);
+	}
+
+	vcpu->mmio_needed = false;
+}
+
+static void handle_pvm_entry_hvc64(struct pkvm_hyp_vcpu *hyp_vcpu)
+{
+	struct kvm_vcpu *host_vcpu = hyp_vcpu->host_vcpu;
+	struct kvm_vcpu *vcpu = &hyp_vcpu->vcpu;
+	u64 ret = READ_ONCE(vcpu_gp_regs(host_vcpu)->regs[0]);
+	u32 psci_fn = smccc_get_function(vcpu);
+
+	switch (psci_fn) {
+	case PSCI_0_2_FN_CPU_ON:
+	case PSCI_0_2_FN64_CPU_ON:
+		/*
+		 * Roll back a CPU_ON the host failed, unless the target
+		 * already reached ON: it is running, and the guest sees
+		 * SUCCESS.
+		 */
+		if (ret != PSCI_RET_SUCCESS) {
+			unsigned long cpu_id = smccc_get_arg1(vcpu);
+			struct pkvm_hyp_vcpu *target_vcpu;
+			struct pkvm_hyp_vm *hyp_vm;
+			int prev;
+
+			hyp_vm = pkvm_hyp_vcpu_to_hyp_vm(hyp_vcpu);
+			target_vcpu = pkvm_mpidr_to_hyp_vcpu(hyp_vm, cpu_id);
+
+			/*
+			 * pvm_psci_vcpu_on() resolved this MPIDR and vcpus[]
+			 * entries are never removed, so the lookup cannot miss.
+			 * The release orders this vCPU's reset_state writes
+			 * before OFF, for the next CPU_ON.
+			 */
+			prev = cmpxchg_release(&target_vcpu->power_state,
+					       PSCI_0_2_AFFINITY_LEVEL_ON_PENDING,
+					       PSCI_0_2_AFFINITY_LEVEL_OFF);
+			switch (prev) {
+			case PSCI_0_2_AFFINITY_LEVEL_ON_PENDING:
+				/*
+				 * Leave reset_state.reset set: a clear races a
+				 * fresh CPU_ON's publish. The stale pc/r0/be are
+				 * the guest's own. ALREADY_ON is PSCI's retry
+				 * signal for a CPU_ON that raced the CPU_OFF.
+				 */
+				if (ret != PSCI_RET_ALREADY_ON)
+					ret = PSCI_RET_INTERNAL_FAILURE;
+				break;
+			case PSCI_0_2_AFFINITY_LEVEL_ON:
+			case PSCI_0_2_AFFINITY_LEVEL_OFF:
+				/* Target already ran (and may have stopped). */
+				ret = PSCI_RET_SUCCESS;
+				break;
+			default:
+				ret = PSCI_RET_INTERNAL_FAILURE;
+				break;
+			}
+		}
+
+		break;
+	default:
+		break;
+	}
+
+	vcpu_set_reg(vcpu, 0, ret);
+}
+
+/* The host's view of a syndrome: the guest register index is withheld. */
+static u64 pvm_host_esr(u64 esr)
+{
+	switch (ESR_ELx_EC(esr)) {
+	case ESR_ELx_EC_WFx:
+		return esr & ~ESR_ELx_WFx_ISS_RN;
+	case ESR_ELx_EC_SYS64:
+		return esr & ~ESR_ELx_SYS64_ISS_RT_MASK;
+	case ESR_ELx_EC_DABT_LOW:
+		return esr & ~ESR_ELx_SRT_MASK;
+	default:
+		return esr;
+	}
+}
+
+/*
+ * The host's view of PSTATE: the mode, with SErrors masked so that the host
+ * pends an SError through HCR_EL2.VSE rather than emulating the entry.
+ */
+static unsigned long pvm_host_pstate(unsigned long pstate)
+{
+	return (pstate & PSR_MODE_MASK) | PSR_A_BIT;
+}
+
+static void handle_pvm_exit_wfx(struct pkvm_hyp_vcpu *hyp_vcpu)
+{
+	struct kvm_vcpu *host_vcpu = hyp_vcpu->host_vcpu;
+	struct kvm_vcpu *vcpu = &hyp_vcpu->vcpu;
+
+	*vcpu_cpsr(host_vcpu) = pvm_host_pstate(*vcpu_cpsr(vcpu));
+}
+
+static void handle_pvm_exit_sys64(struct pkvm_hyp_vcpu *hyp_vcpu)
+{
+	struct kvm_vcpu *host_vcpu = hyp_vcpu->host_vcpu;
+	struct kvm_vcpu *vcpu = &hyp_vcpu->vcpu;
+	u64 esr = kvm_vcpu_get_esr(vcpu);
+
+	/* The mode is required for the host to emulate some sysregs */
+	*vcpu_cpsr(host_vcpu) = pvm_host_pstate(*vcpu_cpsr(vcpu));
+
+	/* r0 as transfer register between the guest and the host. */
+	if (pvm_sys64_is_write(esr)) {
+		int rt = kvm_vcpu_sys_get_rt(vcpu);
+		u64 rt_val = vcpu_get_reg(vcpu, rt);
+
+		vcpu_set_reg(host_vcpu, 0, rt_val);
+	}
+}
+
+static void handle_pvm_exit_iabt(struct pkvm_hyp_vcpu *hyp_vcpu)
+{
+	struct kvm_vcpu *host_vcpu = hyp_vcpu->host_vcpu;
+	struct kvm_vcpu *vcpu = &hyp_vcpu->vcpu;
+
+	host_vcpu->arch.fault.hpfar_el2 = vcpu->arch.fault.hpfar_el2;
+}
+
+static void handle_pvm_exit_dabt(struct pkvm_hyp_vcpu *hyp_vcpu)
+{
+	struct kvm_vcpu *host_vcpu = hyp_vcpu->host_vcpu;
+	struct kvm_vcpu *vcpu = &hyp_vcpu->vcpu;
+	u64 sctlr;
+
+	/*
+	 * EL2 has no memslot view: a decodable data abort is prepared as MMIO
+	 * for the host to resolve. On unbacked memory the host injects an SEA
+	 * for one with ISV clear (LDP/STP, atomics), which EL2 does not
+	 * decode, and skips a cache maintenance operation, as for any guest.
+	 */
+	vcpu->mmio_needed = kvm_vcpu_dabt_isvalid(vcpu);
+
+	/* r0 as transfer register between the guest and the host. */
+	if (vcpu->mmio_needed && kvm_vcpu_dabt_iswrite(vcpu)) {
+		int rt = kvm_vcpu_dabt_get_rd(vcpu);
+		u64 rt_val = vcpu_get_reg(vcpu, rt);
+
+		rt_val = kvm_mmio_clamp_data(vcpu, rt_val);
+		vcpu_set_reg(host_vcpu, 0, rt_val);
+	}
+
+	*vcpu_cpsr(host_vcpu) = pvm_host_pstate(*vcpu_cpsr(vcpu));
+	host_vcpu->arch.fault.far_el2 = vcpu->arch.fault.far_el2 & GENMASK(11, 0);
+	host_vcpu->arch.fault.hpfar_el2 = vcpu->arch.fault.hpfar_el2;
+	sctlr = __vcpu_sys_reg(vcpu, SCTLR_EL1) & (SCTLR_ELx_EE | SCTLR_EL1_E0E);
+	__vcpu_assign_sys_reg(host_vcpu, SCTLR_EL1, sctlr);
+}
+
+static void handle_pvm_exit_hvc64(struct pkvm_hyp_vcpu *hyp_vcpu)
+{
+	struct kvm_vcpu *host_vcpu = hyp_vcpu->host_vcpu;
+	struct kvm_vcpu *vcpu = &hyp_vcpu->vcpu;
+	int n, i;
+
+	switch (smccc_get_function(vcpu)) {
+	/*
+	 * CPU_ON: the host uses only the target MPIDR (x1). EL2 resets the
+	 * target from its own copy of the entry point and context id.
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
+	case PSCI_0_2_FN_AFFINITY_INFO:
+	case PSCI_0_2_FN64_AFFINITY_INFO:
+	case PSCI_1_1_FN_SYSTEM_RESET2:
+	case PSCI_1_1_FN64_SYSTEM_RESET2:
+		n = 3;
+		break;
+
+	/* Unreachable: kvm_handle_pvm_hvc64() forwards only the calls above. */
+	default:
+		hyp_panic();
+	}
+
+	/* Pass the HVC function id (r0) and its arguments. */
+	for (i = 0; i < n; i++)
+		vcpu_set_reg(host_vcpu, i, vcpu_get_reg(vcpu, i));
+}
+
+static const hyp_entry_exit_handler_fn entry_hyp_pvm_handlers[] = {
+	[0 ... ESR_ELx_EC_MAX]		= NULL,
+	[ESR_ELx_EC_WFx]		= handle_pvm_entry_wfx,
+	[ESR_ELx_EC_SYS64]		= handle_pvm_entry_sys64,
+	[ESR_ELx_EC_IABT_LOW]		= handle_pvm_entry_iabt,
+	[ESR_ELx_EC_DABT_LOW]		= handle_pvm_entry_dabt,
+	[ESR_ELx_EC_HVC64]		= handle_pvm_entry_hvc64,
+};
+
+static const hyp_entry_exit_handler_fn exit_hyp_pvm_handlers[] = {
+	[0 ... ESR_ELx_EC_MAX]		= NULL,
+	[ESR_ELx_EC_WFx]		= handle_pvm_exit_wfx,
+	[ESR_ELx_EC_SYS64]		= handle_pvm_exit_sys64,
+	[ESR_ELx_EC_IABT_LOW]		= handle_pvm_exit_iabt,
+	[ESR_ELx_EC_DABT_LOW]		= handle_pvm_exit_dabt,
+	[ESR_ELx_EC_HVC64]		= handle_pvm_exit_hvc64,
 };
 
 static void __hyp_sve_save_guest(struct kvm_vcpu *vcpu)
@@ -284,18 +644,6 @@ static void flush_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu)
 
 		hyp_vcpu->vcpu.arch.mdcr_el2 = host_vcpu->arch.mdcr_el2;
 		hyp_vcpu->vcpu.arch.iflags = host_vcpu->arch.iflags;
-	} else {
-		u64 v_cval = hyp_vcpu->vcpu.arch.ctxt.sys_regs[CNTV_CVAL_EL0];
-		u64 v_ctl = hyp_vcpu->vcpu.arch.ctxt.sys_regs[CNTV_CTL_EL0];
-		u64 p_cval = hyp_vcpu->vcpu.arch.ctxt.sys_regs[CNTP_CVAL_EL0];
-		u64 p_ctl = hyp_vcpu->vcpu.arch.ctxt.sys_regs[CNTP_CTL_EL0];
-
-		hyp_vcpu->vcpu.arch.ctxt = host_vcpu->arch.ctxt;
-
-		hyp_vcpu->vcpu.arch.ctxt.sys_regs[CNTV_CVAL_EL0] = v_cval;
-		hyp_vcpu->vcpu.arch.ctxt.sys_regs[CNTV_CTL_EL0] = v_ctl;
-		hyp_vcpu->vcpu.arch.ctxt.sys_regs[CNTP_CVAL_EL0] = p_cval;
-		hyp_vcpu->vcpu.arch.ctxt.sys_regs[CNTP_CTL_EL0] = p_ctl;
 	}
 
 	/* __hyp_running_vcpu must be NULL in a guest context. */
@@ -320,10 +668,16 @@ static void flush_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu)
 	case ARM_EXCEPTION_IL:
 		break;
 	case ARM_EXCEPTION_TRAP:
-		esr_ec = ESR_ELx_EC(kvm_vcpu_get_esr(&hyp_vcpu->vcpu));
-		ec_handler = entry_hyp_vm_handlers[esr_ec];
-		if (ec_handler)
-			ec_handler(hyp_vcpu);
+		/* Nothing was marshalled for this trap, see sync_hyp_vcpu(). */
+		if (ARM_SERROR_PENDING(hyp_vcpu->exit_code))
+			break;
+
+		if (pkvm_hyp_vcpu_is_protected(hyp_vcpu)) {
+			esr_ec = ESR_ELx_EC(kvm_vcpu_get_esr(&hyp_vcpu->vcpu));
+			ec_handler = entry_hyp_pvm_handlers[esr_ec];
+			if (ec_handler)
+				ec_handler(hyp_vcpu);
+		}
 		break;
 	default:
 		BUG();
@@ -335,13 +689,26 @@ static void flush_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu)
 static void sync_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu, u32 exit_reason)
 {
 	struct kvm_vcpu *host_vcpu = hyp_vcpu->host_vcpu;
+	hyp_entry_exit_handler_fn ec_handler;
+	u8 esr_ec;
 
 	fpsimd_sve_sync(&hyp_vcpu->vcpu);
 	sync_debug_state(hyp_vcpu);
 
 	if (pkvm_hyp_vcpu_is_protected(hyp_vcpu)) {
-		host_vcpu->arch.ctxt = hyp_vcpu->vcpu.arch.ctxt;
+		/*
+		 * Protected: the host sees ESR_EL2 as EL2 took it, register
+		 * index withheld; the fault addresses stay withheld unless the
+		 * EC handler below adds them.
+		 */
+		host_vcpu->arch.fault = (struct kvm_vcpu_fault_info) {
+			.esr_el2 = pvm_host_esr(hyp_vcpu->vcpu.arch.fault.esr_el2),
+			.disr_el1 = hyp_vcpu->vcpu.arch.fault.disr_el1,
+		};
 	} else {
+		/* Non-protected: the host gets the full fault. */
+		host_vcpu->arch.fault = hyp_vcpu->vcpu.arch.fault;
+		host_vcpu->arch.iflags = hyp_vcpu->vcpu.arch.iflags;
 		/*
 		 * PC feeds trace_kvm_exit(), PSTATE.SS the host software-step
 		 * machine, and both run before the next on-demand ctxt sync.
@@ -350,9 +717,28 @@ static void sync_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu, u32 exit_reason)
 		host_vcpu->arch.ctxt.regs.pstate = hyp_vcpu->vcpu.arch.ctxt.regs.pstate;
 	}
 
-	host_vcpu->arch.fault		= hyp_vcpu->vcpu.arch.fault;
+	switch (ARM_EXCEPTION_CODE(exit_reason)) {
+	case ARM_EXCEPTION_IRQ:
+		break;
+	case ARM_EXCEPTION_TRAP:
+		/* SError pending: not handled at EL2, the guest replays it. */
+		if (ARM_SERROR_PENDING(exit_reason))
+			break;
 
-	host_vcpu->arch.iflags		= hyp_vcpu->vcpu.arch.iflags;
+		/* Per-EC marshalling is for protected guests only. */
+		if (pkvm_hyp_vcpu_is_protected(hyp_vcpu)) {
+			esr_ec = ESR_ELx_EC(kvm_vcpu_get_esr(&hyp_vcpu->vcpu));
+			ec_handler = exit_hyp_pvm_handlers[esr_ec];
+			if (ec_handler)
+				ec_handler(hyp_vcpu);
+		}
+		break;
+	case ARM_EXCEPTION_EL1_SERROR:
+	case ARM_EXCEPTION_IL:
+		break;
+	default:
+		BUG();
+	}
 
 	/* Cleared by hardware once the guest takes the vSError. */
 	host_vcpu->arch.hcr_el2 &= ~HCR_VSE;
@@ -361,6 +747,9 @@ static void sync_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu, u32 exit_reason)
 	sync_hyp_vgic_state(hyp_vcpu);
 	sync_hyp_timer_state(hyp_vcpu);
 
+	if (pkvm_hyp_vcpu_is_protected(hyp_vcpu))
+		vcpu_clear_flag(host_vcpu, PC_UPDATE_REQ);
+
 	hyp_vcpu->exit_code = exit_reason;
 }
 
-- 
2.39.5

