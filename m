Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A53F32B111
	for <kvmarm@lists.linux.dev>; Mon,  6 Jul 2026 10:00:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783332027; cv=none; b=J1rm5FzDSu43Ye+CdihtLA6eWIH5e0kZLiXn3zGOaJEd/EEvfy0isrwYbN3xHsR4niuNimU5OPETKSo618jYJHuLnpPSBsqHcus6rruszDeBPSANHQPHlFbEcYSkgNwmwLSJOPv8uIXVd3gVeQb6WDRnbghZASFCfphFtGktMhE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783332027; c=relaxed/simple;
	bh=vViB5U9zIQB23IFbFslkFLNdvBXJnIVm3RmXDg2gpCc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=jY5v7u9FeBllxQ3iGkok8Uh6pyvtx1Tg7KjGle/b5Im7DgiY3bKI+dD3RYxQCYatWDFzbMKz/9UmVSs0s7qrgKfeIcg7w5xdk+MJVonkajEpXxvL/YDpGnpEBgnIEFehya0jEiqZRrFOaZUGRcIJX6B5ecrES4F/kyWLcmFPJ6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=iuobw5QS; arc=none smtp.client-ip=91.218.175.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="iuobw5QS"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783332024;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zStigLhV4Yy76Iea0IqvLSUMMxu60sak2zphCm7EfOk=;
	b=iuobw5QS4Xtp45eR4Rh5O0Bx+kMpy8ANDVhYw0pqwm+PC4kChkVbRgoCqRx2hmuabplV65
	o/BKe8hubzpkety+mZEJm+aAXRfs5qeWSXUCpLc5rkz797Ec58I3P5SUO+SQZZlbsFuKJ2
	nW+cuDxS3yL+qbbn1WXvkUajBNgOmfs=
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
	Sebastian Ene <sebastianene@google.com>,
	Hyunwoo Kim <imv4bel@gmail.com>,
	Fuad Tabba <tabba@google.com>
Subject: [PATCH v4 8/8] KVM: arm64: Implement lazy vCPU state sync for non-protected guests
Date: Mon,  6 Jul 2026 10:59:27 +0100
Message-Id: <20260706095927.560795-9-fuad.tabba@linux.dev>
In-Reply-To: <20260706095927.560795-1-fuad.tabba@linux.dev>
References: <20260706095927.560795-1-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

pKVM copies a non-protected guest's register context between the host
and the hypervisor on every world switch, even when the host never
inspects it. Defer the copy: on entry, flush the host context into the
hyp vCPU only when the host marked it dirty (PKVM_HOST_STATE_DIRTY); on
exit, leave it in the hyp vCPU and copy it back only when the host needs
it, via a __pkvm_vcpu_sync_state hypercall or at vcpu put. A protected
guest's context is copied as before, since lazy sync only helps where
the host is trusted to see the guest's registers.

PC and PSTATE are the exception: they are copied back on every exit so
the kvm_exit tracepoint reports the guest's real exit PC, and the run
loop's vcpu_mode_is_bad_32bit() and SError-masking checks evaluate the
guest's current PSTATE rather than the value left by the previous sync.

The host needs the full context when it is about to read it (trap
handling) or write it (the SError injection that writes ESR_EL1). Sync
both from handle_exit_early(), which runs non-preemptible so the loaded
hyp vCPU is stable without a preempt guard.

Reviewed-by: Vincent Donnefort <vdonnefort@google.com>
Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 arch/arm64/include/asm/kvm_asm.h   |  1 +
 arch/arm64/include/asm/kvm_host.h  |  2 +
 arch/arm64/kvm/arm.c               |  7 +++
 arch/arm64/kvm/handle_exit.c       | 23 ++++++++
 arch/arm64/kvm/hyp/nvhe/hyp-main.c | 86 ++++++++++++++++++++++++++++--
 5 files changed, 114 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index 043495f7fc78b..6e1135b3ded44 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -113,6 +113,7 @@ enum __kvm_host_smccc_func {
 	__KVM_HOST_SMCCC_FUNC___pkvm_finalize_teardown_vm,
 	__KVM_HOST_SMCCC_FUNC___pkvm_vcpu_load,
 	__KVM_HOST_SMCCC_FUNC___pkvm_vcpu_put,
+	__KVM_HOST_SMCCC_FUNC___pkvm_vcpu_sync_state,
 	__KVM_HOST_SMCCC_FUNC___pkvm_tlb_flush_vmid,
 
 	MARKER(__KVM_HOST_SMCCC_FUNC_MAX)
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index bae2c4f92ef5c..86d45bc8f4959 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -1051,6 +1051,8 @@ struct kvm_vcpu_arch {
 #define INCREMENT_PC		__vcpu_single_flag(iflags, BIT(1))
 /* Target EL/MODE (not a single flag, but let's abuse the macro) */
 #define EXCEPT_MASK		__vcpu_single_flag(iflags, GENMASK(3, 1))
+/* Host-set: the hyp flushes the non-protected vCPU state in on entry */
+#define PKVM_HOST_STATE_DIRTY	__vcpu_single_flag(iflags, BIT(4))
 
 /* Helpers to encode exceptions with minimum fuss */
 #define __EXCEPT_MASK_VAL	unpack_vcpu_flag(EXCEPT_MASK)
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 50adfff75be82..ace7b67fe1cc8 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -735,6 +735,10 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
 	if (is_protected_kvm_enabled()) {
 		kvm_call_hyp(__vgic_v3_save_aprs, &vcpu->arch.vgic_cpu.vgic_v3);
 		kvm_call_hyp_nvhe(__pkvm_vcpu_put);
+
+		/* __pkvm_vcpu_put implies a sync of the state */
+		if (!kvm_vm_is_protected(vcpu->kvm))
+			vcpu_set_flag(vcpu, PKVM_HOST_STATE_DIRTY);
 	}
 
 	kvm_vcpu_put_debug(vcpu);
@@ -966,6 +970,9 @@ int kvm_arch_vcpu_run_pid_change(struct kvm_vcpu *vcpu)
 		return ret;
 
 	if (is_protected_kvm_enabled()) {
+		/* Start with the vcpu in a dirty state */
+		if (!kvm_vm_is_protected(vcpu->kvm))
+			vcpu_set_flag(vcpu, PKVM_HOST_STATE_DIRTY);
 		ret = pkvm_create_hyp_vm(kvm);
 		if (ret)
 			return ret;
diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
index 54aedf93c78b6..29108e5c0206e 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -486,9 +486,32 @@ int handle_exit(struct kvm_vcpu *vcpu, int exception_index)
 	}
 }
 
+static void handle_exit_pkvm_state(struct kvm_vcpu *vcpu, int exception_index)
+{
+	int exception_code = ARM_EXCEPTION_CODE(exception_index);
+
+	if (!is_protected_kvm_enabled() || kvm_vm_is_protected(vcpu->kvm))
+		return;
+
+	/*
+	 * Sync the context back when the host will read (trap) or write
+	 * (SError) it. Preempt-off here, so the loaded hyp vCPU is stable.
+	 */
+	if (exception_code == ARM_EXCEPTION_TRAP ||
+	    exception_code == ARM_EXCEPTION_EL1_SERROR ||
+	    ARM_SERROR_PENDING(exception_index)) {
+		kvm_call_hyp_nvhe(__pkvm_vcpu_sync_state);
+		vcpu_set_flag(vcpu, PKVM_HOST_STATE_DIRTY);
+	} else {
+		vcpu_clear_flag(vcpu, PKVM_HOST_STATE_DIRTY);
+	}
+}
+
 /* For exit types that need handling before we can be preempted */
 void handle_exit_early(struct kvm_vcpu *vcpu, int exception_index)
 {
+	handle_exit_pkvm_state(vcpu, exception_index);
+
 	if (ARM_SERROR_PENDING(exception_index)) {
 		if (this_cpu_has_cap(ARM64_HAS_RAS_EXTN)) {
 			u64 disr = kvm_vcpu_get_disr(vcpu);
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index 2db56146ec493..4a8445b636e60 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -143,6 +143,48 @@ static void sync_hyp_vgic_state(struct pkvm_hyp_vcpu *hyp_vcpu)
 		host_cpu_if->vgic_lr[i] = hyp_cpu_if->vgic_lr[i];
 }
 
+static void __copy_vcpu_state(const struct kvm_vcpu *from_vcpu,
+			      struct kvm_vcpu *to_vcpu)
+{
+	int i;
+
+	to_vcpu->arch.ctxt.regs		= from_vcpu->arch.ctxt.regs;
+	to_vcpu->arch.ctxt.spsr_abt	= from_vcpu->arch.ctxt.spsr_abt;
+	to_vcpu->arch.ctxt.spsr_und	= from_vcpu->arch.ctxt.spsr_und;
+	to_vcpu->arch.ctxt.spsr_irq	= from_vcpu->arch.ctxt.spsr_irq;
+	to_vcpu->arch.ctxt.spsr_fiq	= from_vcpu->arch.ctxt.spsr_fiq;
+	to_vcpu->arch.ctxt.fp_regs	= from_vcpu->arch.ctxt.fp_regs;
+
+	/*
+	 * Copy the sysregs, but don't mess with the timer state which
+	 * is directly handled by EL1 and is expected to be preserved.
+	 * enum vcpu_sysreg is sparse: VNCR-mapped registers take values
+	 * derived from their VNCR page offset, so the timer registers do
+	 * not form a contiguous numeric range and must be skipped by name.
+	 */
+	for (i = 1; i < NR_SYS_REGS; i++) {
+		switch (i) {
+		case CNTVOFF_EL2:
+		case CNTV_CVAL_EL0:
+		case CNTV_CTL_EL0:
+		case CNTP_CVAL_EL0:
+		case CNTP_CTL_EL0:
+			continue;
+		}
+		to_vcpu->arch.ctxt.sys_regs[i] = from_vcpu->arch.ctxt.sys_regs[i];
+	}
+}
+
+static void sync_hyp_vcpu_state(struct pkvm_hyp_vcpu *hyp_vcpu)
+{
+	__copy_vcpu_state(&hyp_vcpu->vcpu, hyp_vcpu->host_vcpu);
+}
+
+static void flush_hyp_vcpu_state(struct pkvm_hyp_vcpu *hyp_vcpu)
+{
+	__copy_vcpu_state(hyp_vcpu->host_vcpu, &hyp_vcpu->vcpu);
+}
+
 static void flush_debug_state(struct pkvm_hyp_vcpu *hyp_vcpu)
 {
 	struct kvm_vcpu *host_vcpu = hyp_vcpu->host_vcpu;
@@ -172,7 +214,17 @@ static void flush_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu)
 	fpsimd_sve_flush();
 	flush_debug_state(hyp_vcpu);
 
-	hyp_vcpu->vcpu.arch.ctxt	= host_vcpu->arch.ctxt;
+	/*
+	 * If we deal with a non-protected guest and the state is potentially
+	 * dirty (from a host perspective), copy the state back into the hyp
+	 * vcpu.
+	 */
+	if (!pkvm_hyp_vcpu_is_protected(hyp_vcpu)) {
+		if (vcpu_get_flag(host_vcpu, PKVM_HOST_STATE_DIRTY))
+			flush_hyp_vcpu_state(hyp_vcpu);
+	} else {
+		hyp_vcpu->vcpu.arch.ctxt = host_vcpu->arch.ctxt;
+	}
 
 	/* __hyp_running_vcpu must be NULL in a guest context. */
 	hyp_vcpu->vcpu.arch.ctxt.__hyp_running_vcpu = NULL;
@@ -203,9 +255,13 @@ static void sync_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu)
 	fpsimd_sve_sync(&hyp_vcpu->vcpu);
 	sync_debug_state(hyp_vcpu);
 
-	host_vcpu->arch.ctxt		= hyp_vcpu->vcpu.arch.ctxt;
-
-	host_vcpu->arch.hcr_el2		= hyp_vcpu->vcpu.arch.hcr_el2;
+	if (pkvm_hyp_vcpu_is_protected(hyp_vcpu)) {
+		host_vcpu->arch.ctxt = hyp_vcpu->vcpu.arch.ctxt;
+	} else {
+		/* Keep PC (tracepoint) and PSTATE (vcpu_mode_is_bad_32bit) current. */
+		host_vcpu->arch.ctxt.regs.pc = hyp_vcpu->vcpu.arch.ctxt.regs.pc;
+		host_vcpu->arch.ctxt.regs.pstate = hyp_vcpu->vcpu.arch.ctxt.regs.pstate;
+	}
 
 	host_vcpu->arch.fault		= hyp_vcpu->vcpu.arch.fault;
 
@@ -239,8 +295,27 @@ static void handle___pkvm_vcpu_put(struct kvm_cpu_context *host_ctxt)
 {
 	struct pkvm_hyp_vcpu *hyp_vcpu = pkvm_get_loaded_hyp_vcpu();
 
-	if (hyp_vcpu)
+	if (hyp_vcpu) {
+		struct kvm_vcpu *host_vcpu = hyp_vcpu->host_vcpu;
+
+		if (!pkvm_hyp_vcpu_is_protected(hyp_vcpu) &&
+		    !vcpu_get_flag(host_vcpu, PKVM_HOST_STATE_DIRTY)) {
+			sync_hyp_vcpu_state(hyp_vcpu);
+		}
+
 		pkvm_put_hyp_vcpu(hyp_vcpu);
+	}
+}
+
+static void handle___pkvm_vcpu_sync_state(struct kvm_cpu_context *host_ctxt)
+{
+	struct pkvm_hyp_vcpu *hyp_vcpu;
+
+	hyp_vcpu = pkvm_get_loaded_hyp_vcpu();
+	if (!hyp_vcpu || pkvm_hyp_vcpu_is_protected(hyp_vcpu))
+		return;
+
+	sync_hyp_vcpu_state(hyp_vcpu);
 }
 
 static struct kvm_vcpu *__get_host_hyp_vcpus(struct kvm_vcpu *arg,
@@ -871,6 +946,7 @@ static const hcall_t host_hcall[] = {
 	HANDLE_FUNC(__pkvm_finalize_teardown_vm),
 	HANDLE_FUNC(__pkvm_vcpu_load),
 	HANDLE_FUNC(__pkvm_vcpu_put),
+	HANDLE_FUNC(__pkvm_vcpu_sync_state),
 	HANDLE_FUNC(__pkvm_tlb_flush_vmid),
 };
 
-- 
2.39.5

