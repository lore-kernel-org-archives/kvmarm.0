Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4412C3D966A
	for <kvmarm@lists.linux.dev>; Fri, 12 Jun 2026 06:59:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781247584; cv=none; b=Sh4tREdURepvYpNU0/Hi+DHZehG02vLbpB01S1X9YeovVg2j+tKVNQPgP6doLNbfZkyuyxIp1UEkA8HB72o21KhlfvSphhR9QIuBU3i1FcVUczjTSxMLsRVHPY1bgHzGvW3PXVnzIDOGmovE/3YoJSer+jRT98cOa4wAKLHnMO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781247584; c=relaxed/simple;
	bh=bye8nd/QNV44tiU0PhzJB9r9DA6Q0Ug13E8Lsno86/8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=F2jYuybC1Cs099FJtRRJ+W1EERRa5i5GbLAsh3juMULAX4KuzfZp60dWOK1r2sItYtmBgCOx57ce5GEK9IaI7K9ksqXYqcHDxX7hI8RzzCGlH1y0/KXcQUhDJVxK+w89PXkDgZu6jN7zaLsPoSJl5koUjaZbc1GAckGYyrVosNY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=MaiQTIXy; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="MaiQTIXy"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-490ab3f6e55so3410595e9.0
        for <kvmarm@lists.linux.dev>; Thu, 11 Jun 2026 23:59:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781247579; x=1781852379; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Q37dujmcv40LywWyg6EwCNTlgdLzHM44RSz9WVrB3kg=;
        b=MaiQTIXyte1E+kvJbGEbwATcYb3kQjjSPJ0DCqGrxQr/E5TLQ2ZF2CnWU9xqRwvGe7
         2Vz1XuZ9B62BjjvkcYU4FiclLJ9QebqbWcRGPoZVsiBLh+Nsyo7rnnUoqiRccCk1gNZI
         giq7/IctQZAdKcUA8undmxwoaT4UK9x2g1d/0U2oMp6jMKsmPVUmgM/hS3/09xNWfsUX
         5jbP6+qXnAL1Ly4Y/poX2b01G4ICjTfNZCoJ/0AidRkl5X9DgADHNc79pQnsO9eH3prc
         d0AJKQwaAR5LdzJbDEksQTzSQCQSFMklS6p3AlCkKd7SBVp0rKwJHSYK70L0MOLP28Kj
         Yoqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781247579; x=1781852379;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Q37dujmcv40LywWyg6EwCNTlgdLzHM44RSz9WVrB3kg=;
        b=j+6gqbPG3/Izs6I94q9hctVmMtvPElV0Waq6ZaxABQJLKrU6R9U5N5S+P5y3dYeNv6
         ZEPvF4TT53cYZbZdgiZrSZ0vvMg9VLpi25zlRZbsGa/wt0Wy3+0cNmmOEkSfUVx3UfoS
         9+VdNwtd/6peC8th5TmEz2m0t9inuzwlAIahqwgmccH+9tCr31SFiXhMQU+ws9jwRzJf
         +TIeWV13h+1LroWMTeUq2qBUgapIWitcH3QvmV32X/r3BzvFdZ+N1zMl0ySN5ieKiSrn
         ui1lJDRVKMHdzV/B17llUA7lGr9qEF8GW/1O+RKlK1Caz8OJZiSNT5Y3OyPazec36+JD
         F+Hg==
X-Forwarded-Encrypted: i=1; AFNElJ+nztZAPSrncOzr01L8/82wHAvw30NCj5eq5cuOsKu561d03rb9FqZ5Rkx69cwbSP1lWcWrbbU=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy2um40AN2Lagmf6Vmk+UwZM1SNcRECoj3CIXQ/C26ZpAhJfRY4
	9xCedBovOXGXutYT3sTUoFYXWR6Coh64p/CG/WkwuqbQyr8gLmFqMa4UmbqSEbmIrIzh3dY5slS
	Adg==
X-Received: from wmom24.prod.google.com ([2002:a05:600c:4618:b0:490:addd:1d76])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:2d84:b0:490:c2a3:1781
 with SMTP id 5b1f17b1804b1-490ec50a93dmr8358995e9.34.1781247578382; Thu, 11
 Jun 2026 23:59:38 -0700 (PDT)
Date: Fri, 12 Jun 2026 07:59:25 +0100
In-Reply-To: <20260612065925.755562-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260612065925.755562-1-tabba@google.com>
X-Mailer: git-send-email 2.54.0.1136.gdb2ca164c4-goog
Message-ID: <20260612065925.755562-12-tabba@google.com>
Subject: [PATCH v1 11/11] KVM: arm64: Implement lazy vCPU state sync for
 non-protected guests
From: tabba@google.com
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>
Cc: Fuad Tabba <tabba@google.com>, Will Deacon <will@kernel.org>, 
	Catalin Marinas <catalin.marinas@arm.com>, Quentin Perret <qperret@google.com>, 
	Vincent Donnefort <vdonnefort@google.com>, Sebastian Ene <sebastianene@google.com>, 
	Per Larsen <perlarsen@google.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Joey Gouly <joey.gouly@arm.com>, 
	Steffen Eiden <seiden@linux.ibm.com>, Mark Rutland <mark.rutland@arm.com>, 
	Jonathan Cameron <jonathan.cameron@huawei.com>, Hyunwoo Kim <imv4bel@gmail.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

pKVM copies a non-protected guest's register context between the host
and the hypervisor on every world switch, even when the host never
inspects it. Defer the copy: on entry, flush the host context into the
hyp vCPU only when the host marked it dirty (PKVM_HOST_STATE_DIRTY); on
exit, leave it in the hyp vCPU and copy it back only when the host needs
it, via a __pkvm_vcpu_sync_state hypercall on trap handling or at vcpu
put. A protected guest's context is copied as before, since lazy sync
only helps where the host is trusted to see the guest's registers.

The PC is the exception: it is copied back on every exit so the
kvm_exit tracepoint reports the guest's real exit PC rather than the
value left by the previous sync.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/include/asm/kvm_asm.h   |  1 +
 arch/arm64/include/asm/kvm_host.h  |  2 +
 arch/arm64/kvm/arm.c               |  7 +++
 arch/arm64/kvm/handle_exit.c       | 22 ++++++++
 arch/arm64/kvm/hyp/nvhe/hyp-main.c | 88 ++++++++++++++++++++++++++++--
 5 files changed, 115 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index 043495f7fc78..6e1135b3ded4 100644
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
index a49042bfa801..1ef660774adc 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -1113,6 +1113,8 @@ struct kvm_vcpu_arch {
 /* SError pending for nested guest */
 #define NESTED_SERROR_PENDING	__vcpu_single_flag(sflags, BIT(8))
 
+/* pKVM host vcpu state is dirty, needs resync (nVHE-only) */
+#define PKVM_HOST_STATE_DIRTY	__vcpu_single_flag(iflags, BIT(4))
 
 /* Pointer to the vcpu's SVE FFR for sve_{save,load}_state() */
 #define vcpu_sve_pffr(vcpu) (kern_hyp_va((vcpu)->arch.sve_state) +	\
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index c9f36932c980..a5c54e37778b 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -734,6 +734,10 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
 	if (is_protected_kvm_enabled()) {
 		kvm_call_hyp(__vgic_v3_save_aprs, &vcpu->arch.vgic_cpu.vgic_v3);
 		kvm_call_hyp_nvhe(__pkvm_vcpu_put);
+
+		/* __pkvm_vcpu_put implies a sync of the state */
+		if (!kvm_vm_is_protected(vcpu->kvm))
+			vcpu_set_flag(vcpu, PKVM_HOST_STATE_DIRTY);
 	}
 
 	kvm_vcpu_put_debug(vcpu);
@@ -961,6 +965,9 @@ int kvm_arch_vcpu_run_pid_change(struct kvm_vcpu *vcpu)
 		return ret;
 
 	if (is_protected_kvm_enabled()) {
+		/* Start with the vcpu in a dirty state */
+		if (!kvm_vm_is_protected(vcpu->kvm))
+			vcpu_set_flag(vcpu, PKVM_HOST_STATE_DIRTY);
 		ret = pkvm_create_hyp_vm(kvm);
 		if (ret)
 			return ret;
diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
index 54aedf93c78b..dccc3786548b 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -422,6 +422,21 @@ static int handle_trap_exceptions(struct kvm_vcpu *vcpu)
 {
 	int handled;
 
+	/*
+	 * If we run a non-protected VM when protection is enabled
+	 * system-wide, resync the state from the hypervisor and mark
+	 * it as dirty on the host side if it wasn't dirty already
+	 * (which could happen if preemption has taken place).
+	 */
+	if (is_protected_kvm_enabled() && !kvm_vm_is_protected(vcpu->kvm)) {
+		preempt_disable();
+		if (!(vcpu_get_flag(vcpu, PKVM_HOST_STATE_DIRTY))) {
+			kvm_call_hyp_nvhe(__pkvm_vcpu_sync_state);
+			vcpu_set_flag(vcpu, PKVM_HOST_STATE_DIRTY);
+		}
+		preempt_enable();
+	}
+
 	/*
 	 * See ARM ARM B1.14.1: "Hyp traps on instructions
 	 * that fail their condition code check"
@@ -489,6 +504,13 @@ int handle_exit(struct kvm_vcpu *vcpu, int exception_index)
 /* For exit types that need handling before we can be preempted */
 void handle_exit_early(struct kvm_vcpu *vcpu, int exception_index)
 {
+	/*
+	 * We just exited, so the state is clean from a hypervisor
+	 * perspective.
+	 */
+	if (is_protected_kvm_enabled())
+		vcpu_clear_flag(vcpu, PKVM_HOST_STATE_DIRTY);
+
 	if (ARM_SERROR_PENDING(exception_index)) {
 		if (this_cpu_has_cap(ARM64_HAS_RAS_EXTN)) {
 			u64 disr = kvm_vcpu_get_disr(vcpu);
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index 23e644c24a03..02383b372258 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -139,6 +139,49 @@ static void sync_hyp_vgic_state(struct pkvm_hyp_vcpu *hyp_vcpu)
 		host_cpu_if->vgic_lr[i] = hyp_cpu_if->vgic_lr[i];
 }
 
+
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
+static void __sync_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu)
+{
+	__copy_vcpu_state(&hyp_vcpu->vcpu, hyp_vcpu->host_vcpu);
+}
+
+static void __flush_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu)
+{
+	__copy_vcpu_state(hyp_vcpu->host_vcpu, &hyp_vcpu->vcpu);
+}
+
 static void flush_debug_state(struct pkvm_hyp_vcpu *hyp_vcpu)
 {
 	struct kvm_vcpu *host_vcpu = hyp_vcpu->host_vcpu;
@@ -168,7 +211,17 @@ static void flush_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu)
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
+			__flush_hyp_vcpu(hyp_vcpu);
+	} else {
+		hyp_vcpu->vcpu.arch.ctxt = host_vcpu->arch.ctxt;
+	}
 
 	hyp_vcpu->vcpu.arch.mdcr_el2	= host_vcpu->arch.mdcr_el2;
 	hyp_vcpu->vcpu.arch.hcr_el2 &= ~(HCR_TWI | HCR_TWE);
@@ -191,9 +244,11 @@ static void sync_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu)
 	fpsimd_sve_sync(&hyp_vcpu->vcpu);
 	sync_debug_state(hyp_vcpu);
 
-	host_vcpu->arch.ctxt		= hyp_vcpu->vcpu.arch.ctxt;
-
-	host_vcpu->arch.hcr_el2		= hyp_vcpu->vcpu.arch.hcr_el2;
+	if (pkvm_hyp_vcpu_is_protected(hyp_vcpu))
+		host_vcpu->arch.ctxt = hyp_vcpu->vcpu.arch.ctxt;
+	else
+		/* Keep the PC current for the kvm_exit tracepoint (lazy ctxt sync). */
+		host_vcpu->arch.ctxt.regs.pc = hyp_vcpu->vcpu.arch.ctxt.regs.pc;
 
 	host_vcpu->arch.fault		= hyp_vcpu->vcpu.arch.fault;
 
@@ -227,8 +282,30 @@ static void handle___pkvm_vcpu_put(struct kvm_cpu_context *host_ctxt)
 {
 	struct pkvm_hyp_vcpu *hyp_vcpu = pkvm_get_loaded_hyp_vcpu();
 
-	if (hyp_vcpu)
+	if (hyp_vcpu) {
+		struct kvm_vcpu *host_vcpu = hyp_vcpu->host_vcpu;
+
+		if (!pkvm_hyp_vcpu_is_protected(hyp_vcpu) &&
+		    !vcpu_get_flag(host_vcpu, PKVM_HOST_STATE_DIRTY)) {
+			__sync_hyp_vcpu(hyp_vcpu);
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
+	if (!is_protected_kvm_enabled())
+		return;
+
+	hyp_vcpu = pkvm_get_loaded_hyp_vcpu();
+	if (!hyp_vcpu || pkvm_hyp_vcpu_is_protected(hyp_vcpu))
+		return;
+
+	__sync_hyp_vcpu(hyp_vcpu);
 }
 
 static struct kvm_vcpu *__get_host_hyp_vcpus(struct kvm_vcpu *arg,
@@ -859,6 +936,7 @@ static const hcall_t host_hcall[] = {
 	HANDLE_FUNC(__pkvm_finalize_teardown_vm),
 	HANDLE_FUNC(__pkvm_vcpu_load),
 	HANDLE_FUNC(__pkvm_vcpu_put),
+	HANDLE_FUNC(__pkvm_vcpu_sync_state),
 	HANDLE_FUNC(__pkvm_tlb_flush_vmid),
 };
 
-- 
2.54.0.1136.gdb2ca164c4-goog

