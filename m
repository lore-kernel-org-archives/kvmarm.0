Received: from mta1.migadu.com (out-22.mta1.migadu.com [95.215.58.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DD3741836E
	for <kvmarm@lists.linux.dev>; Mon,  7 Sep 2026 07:01:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.22
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788764507; cv=none; b=lZF7cYFly6g/EYfyksv5qjAp3jTRCL3GNqVJJeIYYOINj368Am1/XVEI4HAfApuYbpQCz8S5q3In1q8UPObf1FIgdCCpF3Bydi+7XWu3MhzAVrV51d0bvK5ej8SVAI+1XwNURBXv0Nvw3Kf2haar0dVTAYbLpycSQ/UygoM3fn0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788764507; c=relaxed/simple;
	bh=D0OxaTL+5XlfPkhDVBGUez61YtJ+uO2qx0Pe/7GzXrA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=VRk3Fw9rJavXLql1WeQPq6gYcHzfLY3isjgUrtW1Ne8xxB7dam8YSMz5wcy0PkAyKxiFM7uauGqx6cmA826hcfh/LrzjpdpqcGh9b96ircJikkjxDdXpHn2c685U1nTu6UNKGIGMnHdXVewbUB5pdFAhMTAiVwT7dk8qe9HEUf4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=HSGH80aj; arc=none smtp.client-ip=95.215.58.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="HSGH80aj"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=D0OxaTL+5XlfPkhDVBGUez61YtJ+uO2qx0Pe/7GzXrA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788764492; v=1; x=1789369292;
 b=HSGH80aj3ucCUiKdyvCOCu5aBriRkLBcRtCI1tBQKrKQTZkE0WqE/Gp3TEun3QQiEmmiLlfG
 D9EEOVeoXuq1DK8ewRyT3sMA/mWzveR47gv6ATPpyu61/jfTRZdBnUQzmGsPGJQ6GwwFe7BobGl
 u41iqq+nkYduxa9zStiJ6NA4=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 4bca238482b7d3d6;
	Mon, 07 Sep 2026 07:01:32 +0000
X-Mizu-Trace-ID: 4bca238482b7d3d6
X-Migadu-Flow: FLOW_OUT
From: Fuad Tabba <fuad.tabba@linux.dev>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Quentin Perret <qperret@google.com>,
	Fuad Tabba <tabba@google.com>
Subject: [PATCH v2 12/17] KVM: arm64: Add per-EC entry/exit state marshalling for protected guests
Date: Mon,  7 Sep 2026 07:59:57 +0100
Message-Id: <20260907070002.3333525-13-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260907070002.3333525-1-fuad.tabba@linux.dev>
References: <20260907070002.3333525-1-fuad.tabba@linux.dev>
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
each handler copies out only what its class needs, and on re-entry
only what the host may have changed, once the host has completed the
access (INCREMENT_PC). entry_hyp_vm_handlers[] is removed: a
non-protected vCPU's iflags are copied wholesale.

The host's fault view is EL2's own syndrome with the guest register
index withheld, plus the addresses each class needs. The value of a
written register is passed in r0. MMIO data is clamped to the access
width and, for a load, sign-extended at EL2 from EL2's syndrome.
Endianness stays with the host.

Neither dispatch runs for a trap taken with an SError pending: EL2
doesn't handle it, and the guest replays it once the host has
injected the SError. The exit handlers would otherwise marshal a trap
EL2 never handled, and handle_pvm_exit_hvc64() would panic on an
unfiltered function id.

For HVC64, only the PSCI calls EL2 forwards reach the host: the exit
handler passes the function id and the arguments each call needs, and
the entry handler returns the host's result, rolling a CPU_ON the host
failed back to OFF unless the target already reached ON.

Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 arch/arm64/kvm/hyp/nvhe/hyp-main.c | 412 +++++++++++++++++++++++++++--
 1 file changed, 387 insertions(+), 25 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index 1a3f23e90e563..2015bf5ce6287 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -4,6 +4,8 @@
  * Author: Andrew Scull <ascull@google.com>
  */
 
+#include <kvm/arm_hypercalls.h>
+
 #include <hyp/adjust_pc.h>
 #include <hyp/switch.h>
 
@@ -25,6 +27,8 @@
 #include <nvhe/trace.h>
 #include <nvhe/trap_handler.h>
 
+#include "../../sys_regs.h"
+
 DEFINE_PER_CPU(struct kvm_nvhe_init_params, kvm_init_params);
 
 /* Number of implemented GICv3 LRs. Used by flush_hyp_vcpu(). */
@@ -34,13 +38,342 @@ void __kvm_hyp_host_forward_smc(struct kvm_cpu_context *host_ctxt);
 
 typedef void (*hyp_entry_exit_handler_fn)(struct pkvm_hyp_vcpu *);
 
-static void handle_vm_entry_generic(struct pkvm_hyp_vcpu *hyp_vcpu)
+static void handle_pvm_entry_wfx(struct pkvm_hyp_vcpu *hyp_vcpu)
 {
-	vcpu_copy_flag(&hyp_vcpu->vcpu, hyp_vcpu->host_vcpu, PC_UPDATE_REQ);
+	if (vcpu_get_flag(hyp_vcpu->host_vcpu, INCREMENT_PC)) {
+		vcpu_clear_flag(&hyp_vcpu->vcpu, PC_UPDATE_REQ);
+		kvm_incr_pc(&hyp_vcpu->vcpu);
+	}
 }
 
-static const hyp_entry_exit_handler_fn entry_hyp_vm_handlers[] = {
-	[0 ... ESR_ELx_EC_MAX]		= handle_vm_entry_generic,
+static void handle_pvm_entry_sys64(struct pkvm_hyp_vcpu *hyp_vcpu)
+{
+	struct kvm_vcpu *host_vcpu = hyp_vcpu->host_vcpu;
+	bool pc_update;
+
+	/* Exceptions have priority over anything else */
+	if (vcpu_get_flag(host_vcpu, PENDING_EXCEPTION)) {
+		/* A host-requested exception on SYS64 is always an UNDEF. */
+		u32 esr = (ESR_ELx_EC_UNKNOWN << ESR_ELx_EC_SHIFT) | ESR_ELx_IL;
+
+		__vcpu_assign_sys_reg(&hyp_vcpu->vcpu, ESR_EL1, esr);
+		kvm_pend_exception(&hyp_vcpu->vcpu, EXCEPT_AA64_EL1_SYNC);
+		return;
+	}
+
+	/* Handle PC increment on a host-emulated access */
+	pc_update = vcpu_get_flag(host_vcpu, INCREMENT_PC);
+	if (pc_update) {
+		vcpu_clear_flag(&hyp_vcpu->vcpu, PC_UPDATE_REQ);
+		kvm_incr_pc(&hyp_vcpu->vcpu);
+	}
+
+	/* If the host emulated a read access, update the register */
+	if (pc_update &&
+	    !esr_sys64_to_params(hyp_vcpu->vcpu.arch.fault.esr_el2).is_write) {
+		/* r0 as transfer register between the guest and the host. */
+		u64 rt_val = READ_ONCE(host_vcpu->arch.ctxt.regs.regs[0]);
+		int rt = kvm_vcpu_sys_get_rt(&hyp_vcpu->vcpu);
+
+		vcpu_set_reg(&hyp_vcpu->vcpu, rt, rt_val);
+	}
+}
+
+static void handle_pvm_entry_iabt(struct pkvm_hyp_vcpu *hyp_vcpu)
+{
+	unsigned long cpsr = *vcpu_cpsr(&hyp_vcpu->vcpu);
+	u32 esr = ESR_ELx_IL;
+
+	if (!vcpu_get_flag(hyp_vcpu->host_vcpu, PENDING_EXCEPTION))
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
+	__vcpu_assign_sys_reg(&hyp_vcpu->vcpu, ESR_EL1, esr);
+	__vcpu_assign_sys_reg(&hyp_vcpu->vcpu, FAR_EL1,
+			      kvm_vcpu_get_hfar(&hyp_vcpu->vcpu));
+
+	/* Injected by __kvm_adjust_pc() on entry. */
+	kvm_pend_exception(&hyp_vcpu->vcpu, EXCEPT_AA64_EL1_SYNC);
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
+	bool pc_update;
+
+	/* Exceptions have priority over anything else */
+	if (vcpu_get_flag(host_vcpu, PENDING_EXCEPTION)) {
+		unsigned long cpsr = *vcpu_cpsr(&hyp_vcpu->vcpu);
+		u32 esr = ESR_ELx_IL;
+
+		if ((cpsr & PSR_MODE_MASK) == PSR_MODE_EL0t)
+			esr |= (ESR_ELx_EC_DABT_LOW << ESR_ELx_EC_SHIFT);
+		else
+			esr |= (ESR_ELx_EC_DABT_CUR << ESR_ELx_EC_SHIFT);
+
+		esr |= ESR_ELx_FSC_EXTABT;
+
+		__vcpu_assign_sys_reg(&hyp_vcpu->vcpu, ESR_EL1, esr);
+		__vcpu_assign_sys_reg(&hyp_vcpu->vcpu, FAR_EL1,
+				      kvm_vcpu_get_hfar(&hyp_vcpu->vcpu));
+
+		/* Injected by __kvm_adjust_pc() on entry. */
+		kvm_pend_exception(&hyp_vcpu->vcpu, EXCEPT_AA64_EL1_SYNC);
+
+		/* Cancel any in-flight MMIO */
+		hyp_vcpu->vcpu.mmio_needed = false;
+		return;
+	}
+
+	/* Handle PC increment on MMIO */
+	pc_update = (hyp_vcpu->vcpu.mmio_needed &&
+		     vcpu_get_flag(host_vcpu, INCREMENT_PC));
+	if (pc_update) {
+		vcpu_clear_flag(&hyp_vcpu->vcpu, PC_UPDATE_REQ);
+		kvm_incr_pc(&hyp_vcpu->vcpu);
+	}
+
+	/* If the host emulated an MMIO read, update the register */
+	if (pc_update && !kvm_vcpu_dabt_iswrite(&hyp_vcpu->vcpu)) {
+		/* r0 as transfer register between the guest and the host. */
+		u64 rd_val = READ_ONCE(host_vcpu->arch.ctxt.regs.regs[0]);
+		int rd = kvm_vcpu_dabt_get_rd(&hyp_vcpu->vcpu);
+
+		rd_val = kvm_mmio_read_data(&hyp_vcpu->vcpu, rd_val);
+		vcpu_set_reg(&hyp_vcpu->vcpu, rd, rd_val);
+	}
+
+	hyp_vcpu->vcpu.mmio_needed = false;
+}
+
+static void handle_pvm_entry_hvc64(struct pkvm_hyp_vcpu *hyp_vcpu)
+{
+	u64 ret = READ_ONCE(hyp_vcpu->host_vcpu->arch.ctxt.regs.regs[0]);
+	u32 psci_fn = smccc_get_function(&hyp_vcpu->vcpu);
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
+			unsigned long cpu_id = smccc_get_arg1(&hyp_vcpu->vcpu);
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
+			 */
+			if (WARN_ON(!target_vcpu)) {
+				ret = PSCI_RET_INTERNAL_FAILURE;
+				break;
+			}
+
+			prev = cmpxchg_relaxed(&target_vcpu->power_state,
+					       PSCI_0_2_AFFINITY_LEVEL_ON_PENDING,
+					       PSCI_0_2_AFFINITY_LEVEL_OFF);
+			switch (prev) {
+			case PSCI_0_2_AFFINITY_LEVEL_ON_PENDING:
+				/*
+				 * Leave reset_state.reset set: clearing it
+				 * races a concurrent CPU_ON's re-publish and
+				 * wedges the target at ON_PENDING. The stale
+				 * pc/r0/be are the guest's own.
+				 */
+				ret = PSCI_RET_INTERNAL_FAILURE;
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
+	vcpu_set_reg(&hyp_vcpu->vcpu, 0, ret);
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
+static void handle_pvm_exit_wfx(struct pkvm_hyp_vcpu *hyp_vcpu)
+{
+	hyp_vcpu->host_vcpu->arch.ctxt.regs.pstate =
+		hyp_vcpu->vcpu.arch.ctxt.regs.pstate & PSR_MODE_MASK;
+}
+
+static void handle_pvm_exit_sys64(struct pkvm_hyp_vcpu *hyp_vcpu)
+{
+	struct kvm_vcpu *host_vcpu = hyp_vcpu->host_vcpu;
+	u32 esr_el2 = hyp_vcpu->vcpu.arch.fault.esr_el2;
+
+	/* The mode is required for the host to emulate some sysregs */
+	host_vcpu->arch.ctxt.regs.pstate =
+		hyp_vcpu->vcpu.arch.ctxt.regs.pstate & PSR_MODE_MASK;
+
+	/* r0 as transfer register between the guest and the host. */
+	if (esr_sys64_to_params(esr_el2).is_write) {
+		int rt = kvm_vcpu_sys_get_rt(&hyp_vcpu->vcpu);
+		u64 rt_val = vcpu_get_reg(&hyp_vcpu->vcpu, rt);
+
+		host_vcpu->arch.ctxt.regs.regs[0] = rt_val;
+	}
+}
+
+static void handle_pvm_exit_iabt(struct pkvm_hyp_vcpu *hyp_vcpu)
+{
+	hyp_vcpu->host_vcpu->arch.fault.hpfar_el2 =
+		hyp_vcpu->vcpu.arch.fault.hpfar_el2;
+}
+
+static void handle_pvm_exit_dabt(struct pkvm_hyp_vcpu *hyp_vcpu)
+{
+	struct kvm_vcpu *host_vcpu = hyp_vcpu->host_vcpu;
+
+	/*
+	 * EL2 has no memslot view: a decodable data abort is prepared as MMIO
+	 * for the host to resolve. One with ISV clear (LDP/STP, atomics) on
+	 * unbacked memory gets an SEA from the host; EL2 does not decode it.
+	 */
+	hyp_vcpu->vcpu.mmio_needed = kvm_vcpu_dabt_isvalid(&hyp_vcpu->vcpu);
+
+	/* r0 as transfer register between the guest and the host. */
+	if (hyp_vcpu->vcpu.mmio_needed &&
+	    kvm_vcpu_dabt_iswrite(&hyp_vcpu->vcpu)) {
+		int rt = kvm_vcpu_dabt_get_rd(&hyp_vcpu->vcpu);
+		u64 rt_val = vcpu_get_reg(&hyp_vcpu->vcpu, rt);
+
+		rt_val = kvm_mmio_clamp_data(&hyp_vcpu->vcpu, rt_val);
+		host_vcpu->arch.ctxt.regs.regs[0] = rt_val;
+	}
+
+	host_vcpu->arch.ctxt.regs.pstate =
+		hyp_vcpu->vcpu.arch.ctxt.regs.pstate & PSR_MODE_MASK;
+	host_vcpu->arch.fault.far_el2 =
+		hyp_vcpu->vcpu.arch.fault.far_el2 & GENMASK(11, 0);
+	host_vcpu->arch.fault.hpfar_el2 = hyp_vcpu->vcpu.arch.fault.hpfar_el2;
+	__vcpu_assign_sys_reg(host_vcpu, SCTLR_EL1,
+			      __vcpu_sys_reg(&hyp_vcpu->vcpu, SCTLR_EL1) &
+			      (SCTLR_ELx_EE | SCTLR_EL1_E0E));
+}
+
+static void handle_pvm_exit_hvc64(struct pkvm_hyp_vcpu *hyp_vcpu)
+{
+	struct kvm_vcpu *host_vcpu = hyp_vcpu->host_vcpu;
+	int n, i;
+
+	switch (smccc_get_function(&hyp_vcpu->vcpu)) {
+	/* CPU_ON: the host needs only the target MPIDR (x1). */
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
+	/* Unreachable: kvm_handle_pvm_hvc64() forwards only the calls above. */
+	default:
+		hyp_panic();
+	}
+
+	/* Pass the HVC function id (r0) and its arguments. */
+	for (i = 0; i < n; i++) {
+		host_vcpu->arch.ctxt.regs.regs[i] =
+			vcpu_get_reg(&hyp_vcpu->vcpu, i);
+	}
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
@@ -282,18 +615,6 @@ static void flush_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu)
 
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
@@ -318,10 +639,16 @@ static void flush_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu)
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
@@ -333,13 +660,29 @@ static void flush_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu)
 static void sync_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu, u32 exit_reason)
 {
 	struct kvm_vcpu *host_vcpu = hyp_vcpu->host_vcpu;
+	hyp_entry_exit_handler_fn ec_handler;
+	u8 esr_ec;
 
 	fpsimd_sve_sync(&hyp_vcpu->vcpu);
 	sync_debug_state(hyp_vcpu);
 
+	sync_hyp_vgic_state(hyp_vcpu);
+	sync_hyp_timer_state(hyp_vcpu);
+
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
@@ -348,16 +691,35 @@ static void sync_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu, u32 exit_reason)
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
 	host_vcpu->arch.hcr_el2 |= hyp_vcpu->vcpu.arch.hcr_el2 & HCR_VSE;
 
-	sync_hyp_vgic_state(hyp_vcpu);
-	sync_hyp_timer_state(hyp_vcpu);
+	if (pkvm_hyp_vcpu_is_protected(hyp_vcpu))
+		vcpu_clear_flag(host_vcpu, PC_UPDATE_REQ);
 
 	hyp_vcpu->exit_code = exit_reason;
 }
-- 
2.39.5

