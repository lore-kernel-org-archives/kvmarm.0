Received: from mail-ej1-f73.google.com (mail-ej1-f73.google.com [209.85.218.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DC0435F611
	for <kvmarm@lists.linux.dev>; Fri, 19 Jun 2026 07:07:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781852854; cv=none; b=uU6kYIl9xRPMX7hE9i9aCiERAokE+M4MEiNQFAvFgPbCbRCpYMQKJw0xYJOC9uVR/O0jGjFIq6VKO1guwmWqcTkCfLe0xlF6VXIIHgu0F+k5ZSMSYs4POg7A3re7xUiycyGWTbiOq5Fi9dhGXYFXF6oDLd1GGIjBwM8bAK6TzG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781852854; c=relaxed/simple;
	bh=rCZNUD0gCJigk1x42ZGHefT1/KNaI1BInw8ZqAxS56M=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Q7gD46tXO4sAtpUFSkpc12SIqPUc1cGHsLRCgCHTyFcNRJF87WJ0u/ffp+OSijU1c0J3jOu5T+63DYOxXjrqDFR2EibIKq9uZB0i4c7tnp9LeVBQX0lw+vMNn2qhhT4X32sjnpds1Fz+FXu+wf0dNasMdGYry63wfokmLUTLHcc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=LFc3hUdv; arc=none smtp.client-ip=209.85.218.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="LFc3hUdv"
Received: by mail-ej1-f73.google.com with SMTP id a640c23a62f3a-c08306ae1c3so102520966b.1
        for <kvmarm@lists.linux.dev>; Fri, 19 Jun 2026 00:07:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781852851; x=1782457651; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=qpP3LSoonJ9EorTtHKWd2w6u9bjj7j9N3BPO/k2UNOg=;
        b=LFc3hUdvCmoxNJRzutEGfMIhNfcqrH15LUyxj/P8VAiEUF55K8LrH0QBpKTBXhd10Y
         Sb5LpnmHYVgXV8HWheQxwhi8Z03orA/amnsdGgqfQJNjx2HoKlgKXRfYkAUJFBGqnqsn
         rfhBDjxLk70N+dJOWrB3uzjxc2a4sjSRPO7EN2cJc199535Y4cnCmNWQX8YPy9f38UEq
         5sjKp5DB0C/5/HiCMhEK+J/L4/nvhHJCt6ITBQnrEmykh6Si/BmeoFU3rEB8Uj0YmJUl
         rs6L9NqQ2klJGyDA3FNwEgUQwVKhN1xi+t21SgKZE9LrODzl+nedV3uJNka3xBJn9C2D
         9jog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781852851; x=1782457651;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qpP3LSoonJ9EorTtHKWd2w6u9bjj7j9N3BPO/k2UNOg=;
        b=IagngsbI0+lHzlxBCzLyqz8DGuzHxGgJmS/5UIX9SeLH3/7XoOv3f6Ui561mQnVbs9
         VfcrQ6XdaYe74gVE3dum1tKa0ywoiDVEw+eoTqCNQorN9DpgCv8JWn4O48Wp048P7EHn
         kJLrs/i3wDDMELgjJOLcA7rVy4mP9+Z+CyFvbX4uWd4niqM1F/nqEFNThPBRnXUpcpbK
         DJ+7fbeQOEWt3Pu2B8q4TCinI/+EPW1eiu+ovVvI41RmUcGI6we7HoyKjPd3h6v8eAHK
         RiDJA5Zja9Om3mwqaJP3TXafBX4xQTY0uL5P0lFZtIL+lOjKwvkXxPUZO1h1AfH5s8pV
         vNJg==
X-Forwarded-Encrypted: i=1; AFNElJ8RYtAQ4LrlHQ4sJh8HvlBKQWs22R0DL8pYvhwbhxD4kbuJVl+roM/DIF0Oms50nx4z1n0c3ZI=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx4rA3M6hCGxaEPk4Ke0xViwE+iqLABHm1SwYbcYZaW7MMdBEWg
	OnNye1vcwfpPxQsps350H8iQdox1maojXgfVsgeiTt0zq89d9yL2JR/lT+RXtySA9abIshfJAUn
	f4w==
X-Received: from edqi16.prod.google.com ([2002:aa7:c710:0:b0:695:df88:ec81])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6402:5107:b0:689:b30c:4205
 with SMTP id 4fb4d7f45d1cf-696dccb7f5emr1274202a12.0.1781852850666; Fri, 19
 Jun 2026 00:07:30 -0700 (PDT)
Date: Fri, 19 Jun 2026 08:07:19 +0100
In-Reply-To: <20260619070719.812227-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260619070719.812227-1-tabba@google.com>
X-Mailer: git-send-email 2.55.0.rc0.738.g0c8ab3ebcc-goog
Message-ID: <20260619070719.812227-9-tabba@google.com>
Subject: [PATCH v2 8/8] KVM: arm64: Implement lazy vCPU state sync for
 non-protected guests
From: Fuad Tabba <tabba@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Joey Gouly <joey.gouly@arm.com>, Steffen Eiden <seiden@linux.ibm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Vincent Donnefort <vdonnefort@google.com>, Quentin Perret <qperret@google.com>, 
	Sebastian Ene <sebastianene@google.com>, Hyunwoo Kim <imv4bel@gmail.com>, 
	Fuad Tabba <tabba@google.com>
Content-Type: text/plain; charset="UTF-8"

pKVM copies a non-protected guest's register context between the host
and the hypervisor on every world switch, even when the host never
inspects it. Defer the copy: on entry, flush the host context into the
hyp vCPU only when the host marked it dirty (PKVM_HOST_STATE_DIRTY); on
exit, leave it in the hyp vCPU and copy it back only when the host needs
it, via a __pkvm_vcpu_sync_state hypercall on trap handling or at vcpu
put. A protected guest's context is copied as before, since lazy sync
only helps where the host is trusted to see the guest's registers.

PC and PSTATE are the exception: they are copied back on every exit so
the kvm_exit tracepoint reports the guest's real exit PC, and the run
loop's vcpu_mode_is_bad_32bit() and SError-masking checks evaluate the
guest's current PSTATE rather than the value left by the previous sync.

handle_exit_early() can also inject an SError, which writes the guest
context (ESR_EL1) outside the trap-handling path. For a non-protected
guest it therefore syncs the context from the hyp vCPU and marks it
dirty, as handle_trap_exceptions() does, so the injection reaches the
hyp vCPU on re-entry rather than being dropped.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/include/asm/kvm_asm.h   |  1 +
 arch/arm64/include/asm/kvm_host.h  |  2 +
 arch/arm64/kvm/arm.c               |  7 +++
 arch/arm64/kvm/handle_exit.c       | 30 +++++++++++
 arch/arm64/kvm/hyp/nvhe/hyp-main.c | 86 ++++++++++++++++++++++++++++--
 5 files changed, 121 insertions(+), 5 deletions(-)

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
index 2faa60df847d..caa39ee5125f 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -1068,6 +1068,8 @@ struct kvm_vcpu_arch {
 #define INCREMENT_PC		__vcpu_single_flag(iflags, BIT(1))
 /* Target EL/MODE (not a single flag, but let's abuse the macro) */
 #define EXCEPT_MASK		__vcpu_single_flag(iflags, GENMASK(3, 1))
+/* Host-set: the hyp flushes the non-protected vCPU state in on entry */
+#define PKVM_HOST_STATE_DIRTY	__vcpu_single_flag(iflags, BIT(4))
 
 /* Helpers to encode exceptions with minimum fuss */
 #define __EXCEPT_MASK_VAL	unpack_vcpu_flag(EXCEPT_MASK)
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 3732ee9eb0d4..4e89558d8027 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -733,6 +733,10 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
 	if (is_protected_kvm_enabled()) {
 		kvm_call_hyp(__vgic_v3_save_aprs, &vcpu->arch.vgic_cpu.vgic_v3);
 		kvm_call_hyp_nvhe(__pkvm_vcpu_put);
+
+		/* __pkvm_vcpu_put implies a sync of the state */
+		if (!kvm_vm_is_protected(vcpu->kvm))
+			vcpu_set_flag(vcpu, PKVM_HOST_STATE_DIRTY);
 	}
 
 	kvm_vcpu_put_debug(vcpu);
@@ -964,6 +968,9 @@ int kvm_arch_vcpu_run_pid_change(struct kvm_vcpu *vcpu)
 		return ret;
 
 	if (is_protected_kvm_enabled()) {
+		/* Start with the vcpu in a dirty state */
+		if (!kvm_vm_is_protected(vcpu->kvm))
+			vcpu_set_flag(vcpu, PKVM_HOST_STATE_DIRTY);
 		ret = pkvm_create_hyp_vm(kvm);
 		if (ret)
 			return ret;
diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
index 54aedf93c78b..8963621bcdd1 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -422,6 +422,20 @@ static int handle_trap_exceptions(struct kvm_vcpu *vcpu)
 {
 	int handled;
 
+	/*
+	 * If we run a non-protected VM when protection is enabled
+	 * system-wide, resync the state from the hypervisor and mark
+	 * it as dirty on the host side if it wasn't dirty already
+	 * (which could happen if preemption has taken place).
+	 */
+	if (is_protected_kvm_enabled() && !kvm_vm_is_protected(vcpu->kvm)) {
+		guard(preempt)();
+		if (!(vcpu_get_flag(vcpu, PKVM_HOST_STATE_DIRTY))) {
+			kvm_call_hyp_nvhe(__pkvm_vcpu_sync_state);
+			vcpu_set_flag(vcpu, PKVM_HOST_STATE_DIRTY);
+		}
+	}
+
 	/*
 	 * See ARM ARM B1.14.1: "Hyp traps on instructions
 	 * that fail their condition code check"
@@ -489,6 +503,22 @@ int handle_exit(struct kvm_vcpu *vcpu, int exception_index)
 /* For exit types that need handling before we can be preempted */
 void handle_exit_early(struct kvm_vcpu *vcpu, int exception_index)
 {
+	bool inject_serror = ARM_SERROR_PENDING(exception_index) ||
+		ARM_EXCEPTION_CODE(exception_index) == ARM_EXCEPTION_EL1_SERROR;
+
+	/*
+	 * An SError injected below writes the host ctxt; for a non-protected
+	 * guest, sync from the hyp vCPU and keep it dirty so it isn't dropped.
+	 */
+	if (is_protected_kvm_enabled()) {
+		vcpu_clear_flag(vcpu, PKVM_HOST_STATE_DIRTY);
+
+		if (inject_serror && !kvm_vm_is_protected(vcpu->kvm)) {
+			kvm_call_hyp_nvhe(__pkvm_vcpu_sync_state);
+			vcpu_set_flag(vcpu, PKVM_HOST_STATE_DIRTY);
+		}
+	}
+
 	if (ARM_SERROR_PENDING(exception_index)) {
 		if (this_cpu_has_cap(ARM64_HAS_RAS_EXTN)) {
 			u64 disr = kvm_vcpu_get_disr(vcpu);
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index 0194965930e6..acf53aae4fe4 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -141,6 +141,48 @@ static void sync_hyp_vgic_state(struct pkvm_hyp_vcpu *hyp_vcpu)
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
@@ -170,7 +212,17 @@ static void flush_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu)
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
@@ -201,9 +253,13 @@ static void sync_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu)
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
 
@@ -237,8 +293,27 @@ static void handle___pkvm_vcpu_put(struct kvm_cpu_context *host_ctxt)
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
@@ -869,6 +944,7 @@ static const hcall_t host_hcall[] = {
 	HANDLE_FUNC(__pkvm_finalize_teardown_vm),
 	HANDLE_FUNC(__pkvm_vcpu_load),
 	HANDLE_FUNC(__pkvm_vcpu_put),
+	HANDLE_FUNC(__pkvm_vcpu_sync_state),
 	HANDLE_FUNC(__pkvm_tlb_flush_vmid),
 };
 
-- 
2.55.0.rc0.738.g0c8ab3ebcc-goog

