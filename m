Received: from mail-ed1-f73.google.com (mail-ed1-f73.google.com [209.85.208.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 382021E379E
	for <kvmarm@lists.linux.dev>; Tue,  3 Dec 2024 10:37:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733222280; cv=none; b=cWSq+zuC3PQ7miJABs82eiEJEPZrv573PeviXNvX7XutfkObp4VS5KbBgK2LnPVniw858bMlm3aJ/gm+QGnt0IDYCaX4Xj0PbsTAe5LGVXp328j/UT7GJVigfz+RtLA+o1ToxZ7R2nf7ILCcb7+xvwNEvOIr6IpxPwJc1WwdF7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733222280; c=relaxed/simple;
	bh=7YKVrS93aRzAci0Nod9Up6L+eal94x7rqy0hP/5E3S0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=asapaQywPZvX51zwRosNrUsJcnP86dirrpsaWvF3JftaI6/bM11J2XKlqYWGXLH7nIpJhVL7S1EO/bx0Lau4XoQsKxk+DdjunyTMiEVqTes6cuf+xOsOdXyVXRMUnL8CmgXJH79NvXEIGKZoyLMTfMNtmEOPj1g8NQftCe7zJyo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--qperret.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=JHkMkME1; arc=none smtp.client-ip=209.85.208.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--qperret.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="JHkMkME1"
Received: by mail-ed1-f73.google.com with SMTP id 4fb4d7f45d1cf-5d0d186962fso2045881a12.0
        for <kvmarm@lists.linux.dev>; Tue, 03 Dec 2024 02:37:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1733222276; x=1733827076; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=mj964gODKbD1zmug2lj/VjWmQYe+AokCkWiMCuawBn0=;
        b=JHkMkME1HCKvzV39zL6mPbN21hk/7WZrkHBnPwQA7Rtpf3mrecLbOtPnHE8kRNbIup
         xU+BPLy8k1GRW3EWlTq2IUx4zvr9fAufbhAE54wWyLfEx6eWk2dJsMw9UITeVwkLvdDk
         cU6rp6IZK8mp200d3MqrhAyduP5dQnpljqIXB4hRkLYeS14C6kk3pvVe1ksazQCKU6cD
         H8uOiyuNPyGN1oDHaerBVVvPum68P4nh1tPSlvAF1Vvx57RABPH22CcYPnLbP3XswfKp
         rIF3TVyuaxVeneoYdbW54tcyQhEjXV6GdZIicOX11sJaq1WbpxUnnILNLkwkPI7rz/VY
         Tovw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733222276; x=1733827076;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mj964gODKbD1zmug2lj/VjWmQYe+AokCkWiMCuawBn0=;
        b=t2rGNHYkeaiaxsochNDYYWSpYRzUL06Td3LsmQ3K6i/fNsR+57NDHM/Jd+cqEoz2UY
         dxjPybsdfGqsRIDYsyz7/qkwFiUnzhy5a2opJ9+HO9sliNipaMCKR6/9S9B5hVz0DhPD
         wXEqxqvHuf+VAG17YdOU/rxdvisdCwpBJuGz+4TrkuDJCzZZTM050m5A6i5BUXXnfiGH
         X5ZfEMINVu9Wka92W4jXQ9Zrj7UFzo+rsM4qdtd3wP47RSm9XqMSmD4iBYvxGAr2b8Br
         4Xk6ODzJTcKfpVxIIEsNIwses+D9hRpSOv+QIYMMO28nM6+YgrtwppC8r1b5pUlASKr3
         hC9g==
X-Forwarded-Encrypted: i=1; AJvYcCVt6gMIPApbrxwciIvBW8TKG6HbAK9pnlD8fhcCZ2slGVdchlknki4HTJHpf1YfnXXSx0/Nu+M=@lists.linux.dev
X-Gm-Message-State: AOJu0YwJTC1Ic4kFcn57FlGTSvZCONW4YfDPsHA2BQoZBUuAual7DVXp
	nXl/kC/vVg0oLWlHizrbTBr/CmrNmBA/4/scJyPgs4JzQ7lMpbtMDfAiiSKAVnT5TI6TumRWoVS
	XWgetQg==
X-Google-Smtp-Source: AGHT+IHECbRMhTPqXhWhH0wYQw1eGtqOW5b56Fqo9wtWWLwVEFicyz6TFa+3iZqVf11rifTnBDtDiet5fpCW
X-Received: from edsd12.prod.google.com ([2002:aa7:d5cc:0:b0:5cf:dcd3:49a1])
 (user=qperret job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6402:27c9:b0:5d0:b925:a8a
 with SMTP id 4fb4d7f45d1cf-5d10cb5b909mr1775921a12.16.1733222276629; Tue, 03
 Dec 2024 02:37:56 -0800 (PST)
Date: Tue,  3 Dec 2024 10:37:26 +0000
In-Reply-To: <20241203103735.2267589-1-qperret@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241203103735.2267589-1-qperret@google.com>
X-Mailer: git-send-email 2.47.0.338.g60cca15819-goog
Message-ID: <20241203103735.2267589-10-qperret@google.com>
Subject: [PATCH v2 09/18] KVM: arm64: Introduce __pkvm_vcpu_{load,put}()
From: Quentin Perret <qperret@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>
Cc: Fuad Tabba <tabba@google.com>, Vincent Donnefort <vdonnefort@google.com>, 
	Sebastian Ene <sebastianene@google.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

From: Marc Zyngier <maz@kernel.org>

Rather than look-up the hyp vCPU on every run hypercall at EL2,
introduce a per-CPU 'loaded_hyp_vcpu' tracking variable which is updated
by a pair of load/put hypercalls called directly from
kvm_arch_vcpu_{load,put}() when pKVM is enabled.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_asm.h       |  2 ++
 arch/arm64/kvm/arm.c                   | 14 ++++++++
 arch/arm64/kvm/hyp/include/nvhe/pkvm.h |  7 ++++
 arch/arm64/kvm/hyp/nvhe/hyp-main.c     | 47 ++++++++++++++++++++------
 arch/arm64/kvm/hyp/nvhe/pkvm.c         | 29 ++++++++++++++++
 arch/arm64/kvm/vgic/vgic-v3.c          |  6 ++--
 6 files changed, 93 insertions(+), 12 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index ca2590344313..89c0fac69551 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -79,6 +79,8 @@ enum __kvm_host_smccc_func {
 	__KVM_HOST_SMCCC_FUNC___pkvm_init_vm,
 	__KVM_HOST_SMCCC_FUNC___pkvm_init_vcpu,
 	__KVM_HOST_SMCCC_FUNC___pkvm_teardown_vm,
+	__KVM_HOST_SMCCC_FUNC___pkvm_vcpu_load,
+	__KVM_HOST_SMCCC_FUNC___pkvm_vcpu_put,
 };
 
 #define DECLARE_KVM_VHE_SYM(sym)	extern char sym[]
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index a102c3aebdbc..55cc62b2f469 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -619,12 +619,26 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 
 	kvm_arch_vcpu_load_debug_state_flags(vcpu);
 
+	if (is_protected_kvm_enabled()) {
+		kvm_call_hyp_nvhe(__pkvm_vcpu_load,
+				  vcpu->kvm->arch.pkvm.handle,
+				  vcpu->vcpu_idx, vcpu->arch.hcr_el2);
+		kvm_call_hyp(__vgic_v3_restore_vmcr_aprs,
+			     &vcpu->arch.vgic_cpu.vgic_v3);
+	}
+
 	if (!cpumask_test_cpu(cpu, vcpu->kvm->arch.supported_cpus))
 		vcpu_set_on_unsupported_cpu(vcpu);
 }
 
 void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
 {
+	if (is_protected_kvm_enabled()) {
+		kvm_call_hyp(__vgic_v3_save_vmcr_aprs,
+			     &vcpu->arch.vgic_cpu.vgic_v3);
+		kvm_call_hyp_nvhe(__pkvm_vcpu_put);
+	}
+
 	kvm_arch_vcpu_put_debug_state_flags(vcpu);
 	kvm_arch_vcpu_put_fp(vcpu);
 	if (has_vhe())
diff --git a/arch/arm64/kvm/hyp/include/nvhe/pkvm.h b/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
index f361d8b91930..be52c5b15e21 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
@@ -20,6 +20,12 @@ struct pkvm_hyp_vcpu {
 
 	/* Backpointer to the host's (untrusted) vCPU instance. */
 	struct kvm_vcpu *host_vcpu;
+
+	/*
+	 * If this hyp vCPU is loaded, then this is a backpointer to the
+	 * per-cpu pointer tracking us. Otherwise, NULL if not loaded.
+	 */
+	struct pkvm_hyp_vcpu **loaded_hyp_vcpu;
 };
 
 /*
@@ -69,6 +75,7 @@ int __pkvm_teardown_vm(pkvm_handle_t handle);
 struct pkvm_hyp_vcpu *pkvm_load_hyp_vcpu(pkvm_handle_t handle,
 					 unsigned int vcpu_idx);
 void pkvm_put_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu);
+struct pkvm_hyp_vcpu *pkvm_get_loaded_hyp_vcpu(void);
 
 struct pkvm_hyp_vm *get_pkvm_hyp_vm(pkvm_handle_t handle);
 void put_pkvm_hyp_vm(struct pkvm_hyp_vm *hyp_vm);
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index 6aa0b13d86e5..95d78db315b3 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -141,16 +141,46 @@ static void sync_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu)
 		host_cpu_if->vgic_lr[i] = hyp_cpu_if->vgic_lr[i];
 }
 
+static void handle___pkvm_vcpu_load(struct kvm_cpu_context *host_ctxt)
+{
+	DECLARE_REG(pkvm_handle_t, handle, host_ctxt, 1);
+	DECLARE_REG(unsigned int, vcpu_idx, host_ctxt, 2);
+	DECLARE_REG(u64, hcr_el2, host_ctxt, 3);
+	struct pkvm_hyp_vcpu *hyp_vcpu;
+
+	if (!is_protected_kvm_enabled())
+		return;
+
+	hyp_vcpu = pkvm_load_hyp_vcpu(handle, vcpu_idx);
+	if (!hyp_vcpu)
+		return;
+
+	if (pkvm_hyp_vcpu_is_protected(hyp_vcpu)) {
+		/* Propagate WFx trapping flags */
+		hyp_vcpu->vcpu.arch.hcr_el2 &= ~(HCR_TWE | HCR_TWI);
+		hyp_vcpu->vcpu.arch.hcr_el2 |= hcr_el2 & (HCR_TWE | HCR_TWI);
+	}
+}
+
+static void handle___pkvm_vcpu_put(struct kvm_cpu_context *host_ctxt)
+{
+	struct pkvm_hyp_vcpu *hyp_vcpu;
+
+	if (!is_protected_kvm_enabled())
+		return;
+
+	hyp_vcpu = pkvm_get_loaded_hyp_vcpu();
+	if (hyp_vcpu)
+		pkvm_put_hyp_vcpu(hyp_vcpu);
+}
+
 static void handle___kvm_vcpu_run(struct kvm_cpu_context *host_ctxt)
 {
 	DECLARE_REG(struct kvm_vcpu *, host_vcpu, host_ctxt, 1);
 	int ret;
 
-	host_vcpu = kern_hyp_va(host_vcpu);
-
 	if (unlikely(is_protected_kvm_enabled())) {
-		struct pkvm_hyp_vcpu *hyp_vcpu;
-		struct kvm *host_kvm;
+		struct pkvm_hyp_vcpu *hyp_vcpu = pkvm_get_loaded_hyp_vcpu();
 
 		/*
 		 * KVM (and pKVM) doesn't support SME guests for now, and
@@ -163,9 +193,6 @@ static void handle___kvm_vcpu_run(struct kvm_cpu_context *host_ctxt)
 			goto out;
 		}
 
-		host_kvm = kern_hyp_va(host_vcpu->kvm);
-		hyp_vcpu = pkvm_load_hyp_vcpu(host_kvm->arch.pkvm.handle,
-					      host_vcpu->vcpu_idx);
 		if (!hyp_vcpu) {
 			ret = -EINVAL;
 			goto out;
@@ -176,12 +203,10 @@ static void handle___kvm_vcpu_run(struct kvm_cpu_context *host_ctxt)
 		ret = __kvm_vcpu_run(&hyp_vcpu->vcpu);
 
 		sync_hyp_vcpu(hyp_vcpu);
-		pkvm_put_hyp_vcpu(hyp_vcpu);
 	} else {
 		/* The host is fully trusted, run its vCPU directly. */
-		ret = __kvm_vcpu_run(host_vcpu);
+		ret = __kvm_vcpu_run(kern_hyp_va(host_vcpu));
 	}
-
 out:
 	cpu_reg(host_ctxt, 1) =  ret;
 }
@@ -409,6 +434,8 @@ static const hcall_t host_hcall[] = {
 	HANDLE_FUNC(__pkvm_init_vm),
 	HANDLE_FUNC(__pkvm_init_vcpu),
 	HANDLE_FUNC(__pkvm_teardown_vm),
+	HANDLE_FUNC(__pkvm_vcpu_load),
+	HANDLE_FUNC(__pkvm_vcpu_put),
 };
 
 static void handle_host_hcall(struct kvm_cpu_context *host_ctxt)
diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index 4db88bedf8d5..d5c23449a64c 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -23,6 +23,12 @@ unsigned int kvm_arm_vmid_bits;
 
 unsigned int kvm_host_sve_max_vl;
 
+/*
+ * The currently loaded hyp vCPU for each physical CPU. Used only when
+ * protected KVM is enabled, but for both protected and non-protected VMs.
+ */
+static DEFINE_PER_CPU(struct pkvm_hyp_vcpu *, loaded_hyp_vcpu);
+
 /*
  * Set trap register values based on features in ID_AA64PFR0.
  */
@@ -306,15 +312,30 @@ struct pkvm_hyp_vcpu *pkvm_load_hyp_vcpu(pkvm_handle_t handle,
 	struct pkvm_hyp_vcpu *hyp_vcpu = NULL;
 	struct pkvm_hyp_vm *hyp_vm;
 
+	/* Cannot load a new vcpu without putting the old one first. */
+	if (__this_cpu_read(loaded_hyp_vcpu))
+		return NULL;
+
 	hyp_spin_lock(&vm_table_lock);
 	hyp_vm = get_vm_by_handle(handle);
 	if (!hyp_vm || hyp_vm->nr_vcpus <= vcpu_idx)
 		goto unlock;
 
 	hyp_vcpu = hyp_vm->vcpus[vcpu_idx];
+
+	/* Ensure vcpu isn't loaded on more than one cpu simultaneously. */
+	if (unlikely(hyp_vcpu->loaded_hyp_vcpu)) {
+		hyp_vcpu = NULL;
+		goto unlock;
+	}
+
+	hyp_vcpu->loaded_hyp_vcpu = this_cpu_ptr(&loaded_hyp_vcpu);
 	hyp_page_ref_inc(hyp_virt_to_page(hyp_vm));
 unlock:
 	hyp_spin_unlock(&vm_table_lock);
+
+	if (hyp_vcpu)
+		__this_cpu_write(loaded_hyp_vcpu, hyp_vcpu);
 	return hyp_vcpu;
 }
 
@@ -323,10 +344,18 @@ void pkvm_put_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu)
 	struct pkvm_hyp_vm *hyp_vm = pkvm_hyp_vcpu_to_hyp_vm(hyp_vcpu);
 
 	hyp_spin_lock(&vm_table_lock);
+	hyp_vcpu->loaded_hyp_vcpu = NULL;
+	__this_cpu_write(loaded_hyp_vcpu, NULL);
 	hyp_page_ref_dec(hyp_virt_to_page(hyp_vm));
 	hyp_spin_unlock(&vm_table_lock);
 }
 
+struct pkvm_hyp_vcpu *pkvm_get_loaded_hyp_vcpu(void)
+{
+	return __this_cpu_read(loaded_hyp_vcpu);
+
+}
+
 struct pkvm_hyp_vm *get_pkvm_hyp_vm(pkvm_handle_t handle)
 {
 	struct pkvm_hyp_vm *hyp_vm;
diff --git a/arch/arm64/kvm/vgic/vgic-v3.c b/arch/arm64/kvm/vgic/vgic-v3.c
index f267bc2486a1..c2ef41fff079 100644
--- a/arch/arm64/kvm/vgic/vgic-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-v3.c
@@ -734,7 +734,8 @@ void vgic_v3_load(struct kvm_vcpu *vcpu)
 {
 	struct vgic_v3_cpu_if *cpu_if = &vcpu->arch.vgic_cpu.vgic_v3;
 
-	kvm_call_hyp(__vgic_v3_restore_vmcr_aprs, cpu_if);
+	if (likely(!is_protected_kvm_enabled()))
+		kvm_call_hyp(__vgic_v3_restore_vmcr_aprs, cpu_if);
 
 	if (has_vhe())
 		__vgic_v3_activate_traps(cpu_if);
@@ -746,7 +747,8 @@ void vgic_v3_put(struct kvm_vcpu *vcpu)
 {
 	struct vgic_v3_cpu_if *cpu_if = &vcpu->arch.vgic_cpu.vgic_v3;
 
-	kvm_call_hyp(__vgic_v3_save_vmcr_aprs, cpu_if);
+	if (likely(!is_protected_kvm_enabled()))
+		kvm_call_hyp(__vgic_v3_save_vmcr_aprs, cpu_if);
 	WARN_ON(vgic_v4_put(vcpu));
 
 	if (has_vhe())
-- 
2.47.0.338.g60cca15819-goog

