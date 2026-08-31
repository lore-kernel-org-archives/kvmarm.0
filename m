Received: from mta0.migadu.com (out-118.mta0.migadu.com [91.218.175.118])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92CDA4A013A
	for <kvmarm@lists.linux.dev>; Mon, 31 Aug 2026 16:35:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.118
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788194104; cv=none; b=ZFze1mp/vm24D2BHC4yoOkRFfXDKDfgEq+QG8hXoEPFdpG5zcPKmUtc96lfH1BC+Dy9uf7IsVMgNx/rxYbmvklCj00sgMCD6b8uqN/oYdhrqHJzDONriZsj8yWCf5QBdtcaO/H/+/FrxXTuvqiNe23WUaTLM4e26GyYN7WLjPsA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788194104; c=relaxed/simple;
	bh=CvLk9in57xEsMKc3gnjbpOS1/KTEk+yWedbRcBv+bDs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=mgC5c6tIR99auTwF7sg3VtXRuyfpZmMmRUlv246Nww6dT4v35s6gWc+bfLbLBee17jEy07TIoK2nGfLzw/p2yeU+gerR4LV0JnXYTNlzUs90oxYf+Dcf19iEmaihPrpA3JqqB1Rsel9Qnpe9yVed7sNW3kQTVopdH/cHaaaMeCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=IwuV/s+m; arc=none smtp.client-ip=91.218.175.118
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="IwuV/s+m"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=CvLk9in57xEsMKc3gnjbpOS1/KTEk+yWedbRcBv+bDs=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788194099; v=1; x=1788798899;
 b=IwuV/s+mTkKp8OCRBVKS678SqRp40mB/EE87sYilaOtCMQPkhdOhzDL1K4AnMr8+XZls+rCa
 TBt8GWVm5FAxz7IGd5ktAZDC70MiQPIMYpTllr0dHQsyi8iZTPxQMycPNmEPHW4yWKhiy5k/J2E
 etXMu7K/JSHMVn3VZjUTQkaU=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 758e6ee73ae13ed4;
	Mon, 31 Aug 2026 16:34:59 +0000
X-Mizu-Trace-ID: 758e6ee73ae13ed4
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
Subject: [PATCH 13/17] KVM: arm64: Add per-EC entry/exit state marshalling for protected guests
Date: Mon, 31 Aug 2026 17:34:17 +0100
Message-Id: <20260831163421.272420-14-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260831163421.272420-1-fuad.tabba@linux.dev>
References: <20260831163421.272420-1-fuad.tabba@linux.dev>
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
does not handle it, and the guest replays it once the host has
injected the SError. The exit handlers would otherwise marshal a trap
EL2 never handled, and handle_pvm_exit_hvc64() would panic on an
unfiltered function id.

Wire in the HVC64 entry and exit handlers added earlier in the series.

Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 arch/arm64/kvm/hyp/nvhe/hyp-main.c | 319 ++++++++++++++++++++++++++---
 1 file changed, 290 insertions(+), 29 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index 5925d35abba8c..461e15cab1b92 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -38,7 +38,7 @@ void __kvm_hyp_host_forward_smc(struct kvm_cpu_context *host_ctxt);
 
 typedef void (*hyp_entry_exit_handler_fn)(struct pkvm_hyp_vcpu *);
 
-static void __maybe_unused handle_pvm_entry_hvc64(struct pkvm_hyp_vcpu *hyp_vcpu)
+static void handle_pvm_entry_psci(struct pkvm_hyp_vcpu *hyp_vcpu)
 {
 	u64 ret = READ_ONCE(hyp_vcpu->host_vcpu->arch.ctxt.regs.regs[0]);
 	u32 psci_fn = smccc_get_function(&hyp_vcpu->vcpu);
@@ -101,7 +101,12 @@ static void __maybe_unused handle_pvm_entry_hvc64(struct pkvm_hyp_vcpu *hyp_vcpu
 	vcpu_set_reg(&hyp_vcpu->vcpu, 0, ret);
 }
 
-static void __maybe_unused handle_pvm_exit_hvc64(struct pkvm_hyp_vcpu *hyp_vcpu)
+static void handle_pvm_entry_hvc64(struct pkvm_hyp_vcpu *hyp_vcpu)
+{
+	handle_pvm_entry_psci(hyp_vcpu);
+}
+
+static void handle_pvm_exit_hvc64(struct pkvm_hyp_vcpu *hyp_vcpu)
 {
 	struct kvm_vcpu *host_vcpu = hyp_vcpu->host_vcpu;
 	int n, i;
@@ -131,8 +136,6 @@ static void __maybe_unused handle_pvm_exit_hvc64(struct pkvm_hyp_vcpu *hyp_vcpu)
 		hyp_panic();
 	}
 
-	host_vcpu->arch.fault.esr_el2 = hyp_vcpu->vcpu.arch.fault.esr_el2;
-
 	/* Pass the HVC function id (r0) and its arguments. */
 	for (i = 0; i < n; i++) {
 		host_vcpu->arch.ctxt.regs.regs[i] =
@@ -140,13 +143,242 @@ static void __maybe_unused handle_pvm_exit_hvc64(struct pkvm_hyp_vcpu *hyp_vcpu)
 	}
 }
 
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
@@ -382,18 +614,6 @@ static void flush_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu)
 		hyp_vcpu->vcpu.arch.mdcr_el2 = host_vcpu->arch.mdcr_el2;
 		hyp_vcpu->vcpu.arch.iflags = host_vcpu->arch.iflags;
 		flush_debug_state(hyp_vcpu);
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
@@ -418,10 +638,16 @@ static void flush_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu)
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
@@ -433,14 +659,30 @@ static void flush_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu)
 static void sync_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu, u32 exit_reason)
 {
 	struct kvm_vcpu *host_vcpu = hyp_vcpu->host_vcpu;
+	hyp_entry_exit_handler_fn ec_handler;
+	u8 esr_ec;
 
 	fpsimd_sve_sync(&hyp_vcpu->vcpu);
 	if (!pkvm_hyp_vcpu_is_protected(hyp_vcpu))
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
@@ -449,16 +691,35 @@ static void sync_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu, u32 exit_reason)
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

