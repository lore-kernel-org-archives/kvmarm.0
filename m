Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7841D198A11
	for <kvmarm@lists.linux.dev>; Thu, 28 Nov 2024 12:35:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732797349; cv=none; b=ln4ewB+y76kiWvJgjoz08iT+P2LTeHzdRLmCMQ7QGBW+ca/8+biyo4qtNQRAtmj5pPsFro95p2GE7G37P9jk2de2BGcuBVfdWBx1cK4BV8C6b+MvDoUwU0rUkHpgkGQ6B4Ltlr8SKb51C5Lzc4jMTFkX/IDNdBGo9y3ixxUb5Qk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732797349; c=relaxed/simple;
	bh=bRFndAkiQ4qpCaPDpdv8w3xi35nPklXSubEE/GtAIT8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=MqUl7a4OQxHkrZvwDmSFzJYHQtE1z5V212Gt2zZM9D1d24eMxlb5lKHx1khI5VMJ3Ru0GoyUeMNhVaQPu5eYs2tslnhmGZhfoTh84kd0o1CY8uL5g/3IFSr6ZBcEdUbTwGH0yaNFMVe8hFDBUP0CuN6DpXBbt/qQrFvmnRh3g8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=uFfu6ETy; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="uFfu6ETy"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-434a51e44d0so6338145e9.3
        for <kvmarm@lists.linux.dev>; Thu, 28 Nov 2024 04:35:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732797346; x=1733402146; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=YF0iu1qTW3uDPg7gvgOAF2duWb+mdqKkjo5pBm4g7Cw=;
        b=uFfu6ETyCQ3JusBNQPE0i4li/PSPjZjccLIRpgtJCgxLvtpxaE5M24exuMIEPX+k5B
         1D3Q+ZYKzMYzxcoA5RMl4gh4Ccr6G8QarSsVPdg/6fQVqpc4IK5Ae7jajtPO2wJ/wU5f
         0XnfbbZ+UaBitw8NvhJKWaChqMMnCXgEqYb4NfYR2KKArHy6Nb+MVM2QJ1mxgTaEJpis
         n9prVbg9Xhk1HQoyXhZ7G6rTLEt5oYJEHaqZe3+oVv4ztgZpHeo04RxhvdryvnGkoSHD
         xtQE/0n7fXQjcFWY5FiD9nmUJD4Wr8uNnvd/5PiPA40L0SQhzt6RrACgArIOXlRAA6+N
         2Emg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732797346; x=1733402146;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YF0iu1qTW3uDPg7gvgOAF2duWb+mdqKkjo5pBm4g7Cw=;
        b=hoR2nP/AB2iSWV0T40Z7ptRfe7oMwz9qCYAgpN3qIHLhJAg0C8/W/EivDra+7EW5TK
         Xe3CwVxJhj4AEB5m7QUr69254LDyLoEBbeXDblEdyfMNv4iFwmOJhUr8N6Ue3XyVWG+x
         sL7vCKhq3RAuRBekLJ6eG3ZJE4zK6GAMQmKkxKPlfOx1qyJR8jFcCi2EDEhnWHIh50RR
         FPZRO0DwdEwom+343Z7rYQWvRpYVfBG9mQlIXgu7vxh3nUBG3sOU139s2Fohp40O4H3U
         r+LU6/HTW2fTM/IyRR01Bvey/sKO33rBMHK/bWFvd95ERXeCJfztZb4mDGUPSBbt03Fh
         7ZHw==
X-Gm-Message-State: AOJu0YxVbHECNoT0tUx9wmMC9hnyfDIUkO0iwrCVajOMmBZ5sUwerObm
	KkOPQ8I/wK4rmJUaHXOGlVdnq/Xd2rr1LEcZHHpQkkbQ5uZFQfbEyhSSH4hbYFhqIGb35eV5G4D
	RZL6BWL4Dc00H6NVdhBDmfl7dCrVGODeqZiN2eyUZ6f92OIpK+3hi/nCkiqfwoba0mLheWbefxb
	NvyvRPLtAduIJbBPBV7nWqXMg5DCY=
X-Google-Smtp-Source: AGHT+IEb+GFl3HbZTUYpgpp3V8l8JvfAMY57Oif8T21Hqpmw854CA+eMx3AN6VzLfj54jG08uCh4Nxx+zA==
X-Received: from wmqm6.prod.google.com ([2002:a05:600c:4f46:b0:42c:bfc2:aa72])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:3581:b0:434:9f0d:3823
 with SMTP id 5b1f17b1804b1-434a9dbf4e3mr64699625e9.9.1732797345859; Thu, 28
 Nov 2024 04:35:45 -0800 (PST)
Date: Thu, 28 Nov 2024 12:35:14 +0000
In-Reply-To: <20241128123515.1709777-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241128123515.1709777-1-tabba@google.com>
X-Mailer: git-send-email 2.47.0.338.g60cca15819-goog
Message-ID: <20241128123515.1709777-15-tabba@google.com>
Subject: [PATCH v3 14/15] KVM: arm64: Convert the SVE guest vcpu flag to a vm flag
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, james.clark@linaro.org, 
	will@kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, broonie@kernel.org, 
	qperret@google.com, kristina.martsenko@arm.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

The vcpu flag GUEST_HAS_SVE is per-vcpu, but it is based on what
is now a per-vm feature. Make the flag per-vm.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/include/asm/kvm_emulate.h    |  6 +++---
 arch/arm64/include/asm/kvm_host.h       | 10 ++++++----
 arch/arm64/kvm/hyp/include/hyp/switch.h |  2 +-
 arch/arm64/kvm/hyp/nvhe/hyp-main.c      |  2 +-
 arch/arm64/kvm/hyp/nvhe/pkvm.c          | 11 +++++++----
 arch/arm64/kvm/hyp/nvhe/switch.c        |  8 ++++----
 arch/arm64/kvm/hyp/vhe/switch.c         |  2 +-
 arch/arm64/kvm/reset.c                  |  2 +-
 8 files changed, 24 insertions(+), 19 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index 406e99a452bf..ae6d0dc0e4ff 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -620,7 +620,7 @@ static __always_inline void kvm_write_cptr_el2(u64 val)
 }
 
 /* Resets the value of cptr_el2 when returning to the host. */
-static __always_inline void kvm_reset_cptr_el2(struct kvm_vcpu *vcpu)
+static __always_inline void kvm_reset_cptr_el2(struct kvm *kvm)
 {
 	u64 val;
 
@@ -631,14 +631,14 @@ static __always_inline void kvm_reset_cptr_el2(struct kvm_vcpu *vcpu)
 	} else if (has_hvhe()) {
 		val = CPACR_ELx_FPEN;
 
-		if (!vcpu_has_sve(vcpu) || !guest_owns_fp_regs())
+		if (!kvm_has_sve(kvm) || !guest_owns_fp_regs())
 			val |= CPACR_ELx_ZEN;
 		if (cpus_have_final_cap(ARM64_SME))
 			val |= CPACR_ELx_SMEN;
 	} else {
 		val = CPTR_NVHE_EL2_RES1;
 
-		if (vcpu_has_sve(vcpu) && guest_owns_fp_regs())
+		if (kvm_has_sve(kvm) && guest_owns_fp_regs())
 			val |= CPTR_EL2_TZ;
 		if (!cpus_have_final_cap(ARM64_SME))
 			val |= CPTR_EL2_TSM;
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 680ecef1d7aa..c5c80c789ad0 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -331,6 +331,8 @@ struct kvm_arch {
 #define KVM_ARCH_FLAG_ID_REGS_INITIALIZED		7
 	/* Fine-Grained UNDEF initialised */
 #define KVM_ARCH_FLAG_FGU_INITIALIZED			8
+	/* SVE exposed to guest */
+#define KVM_ARCH_FLAG_GUEST_HAS_SVE			9
 	unsigned long flags;
 
 	/* VM-wide vCPU feature set */
@@ -862,8 +864,6 @@ struct kvm_vcpu_arch {
 #define vcpu_set_flag(v, ...)	__vcpu_set_flag((v), __VA_ARGS__)
 #define vcpu_clear_flag(v, ...)	__vcpu_clear_flag((v), __VA_ARGS__)
 
-/* SVE exposed to guest */
-#define GUEST_HAS_SVE		__vcpu_single_flag(cflags, BIT(0))
 /* SVE config completed */
 #define VCPU_SVE_FINALIZED	__vcpu_single_flag(cflags, BIT(1))
 /* KVM_ARM_VCPU_INIT completed */
@@ -956,8 +956,10 @@ struct kvm_vcpu_arch {
 				 KVM_GUESTDBG_USE_HW | \
 				 KVM_GUESTDBG_SINGLESTEP)
 
-#define vcpu_has_sve(vcpu) (system_supports_sve() &&			\
-			    vcpu_get_flag(vcpu, GUEST_HAS_SVE))
+#define kvm_has_sve(kvm)	\
+	test_bit(KVM_ARCH_FLAG_GUEST_HAS_SVE, &(kvm)->arch.flags)
+#define vcpu_has_sve(vcpu)	\
+	kvm_has_sve((vcpu)->kvm)
 
 #ifdef CONFIG_ARM64_PTR_AUTH
 #define vcpu_has_ptrauth(vcpu)						\
diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index 34f53707892d..4c243673e1da 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -391,7 +391,7 @@ static bool kvm_hyp_handle_fpsimd(struct kvm_vcpu *vcpu, u64 *exit_code)
 	if (!system_supports_fpsimd())
 		return false;
 
-	sve_guest = vcpu_has_sve(vcpu);
+	sve_guest = kvm_has_sve(kern_hyp_va(vcpu->kvm));
 	esr_ec = kvm_vcpu_trap_get_class(vcpu);
 
 	/* Only handle traps the vCPU can support here: */
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index 6aa0b13d86e5..226b6e289e08 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -71,7 +71,7 @@ static void fpsimd_sve_sync(struct kvm_vcpu *vcpu)
 	cpacr_clear_set(0, CPACR_ELx_FPEN | CPACR_ELx_ZEN);
 	isb();
 
-	if (vcpu_has_sve(vcpu))
+	if (kvm_has_sve(kern_hyp_va(vcpu->kvm)))
 		__hyp_sve_save_guest(vcpu);
 	else
 		__fpsimd_save_state(&vcpu->arch.ctxt.fp_regs);
diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index dfd031acde31..8a80e494f20c 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -248,10 +248,13 @@ void pkvm_put_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu)
 static void pkvm_init_features_from_host(struct pkvm_hyp_vm *hyp_vm, const struct kvm *host_kvm)
 {
 	struct kvm *kvm = &hyp_vm->kvm;
+	unsigned long host_arch_flags = READ_ONCE(host_kvm->arch.flags);
 	DECLARE_BITMAP(allowed_features, KVM_VCPU_MAX_FEATURES);
 
 	/* No restrictions for non-protected VMs. */
 	if (!kvm_vm_is_protected(kvm)) {
+		hyp_vm->kvm.arch.flags = host_arch_flags;
+
 		bitmap_copy(kvm->arch.vcpu_features,
 			    host_kvm->arch.vcpu_features,
 			    KVM_VCPU_MAX_FEATURES);
@@ -271,8 +274,10 @@ static void pkvm_init_features_from_host(struct pkvm_hyp_vm *hyp_vm, const struc
 	if (kvm_pvm_ext_allowed(KVM_CAP_ARM_PTRAUTH_GENERIC))
 		set_bit(KVM_ARM_VCPU_PTRAUTH_GENERIC, allowed_features);
 
-	if (kvm_pvm_ext_allowed(KVM_CAP_ARM_SVE))
+	if (kvm_pvm_ext_allowed(KVM_CAP_ARM_SVE)) {
 		set_bit(KVM_ARM_VCPU_SVE, allowed_features);
+		kvm->arch.flags |= host_arch_flags & BIT(KVM_ARCH_FLAG_GUEST_HAS_SVE);
+	}
 
 	bitmap_and(kvm->arch.vcpu_features, host_kvm->arch.vcpu_features,
 		   allowed_features, KVM_VCPU_MAX_FEATURES);
@@ -308,10 +313,8 @@ static void pkvm_vcpu_init_sve(struct pkvm_hyp_vcpu *hyp_vcpu, struct kvm_vcpu *
 {
 	struct kvm_vcpu *vcpu = &hyp_vcpu->vcpu;
 
-	if (!vcpu_has_feature(vcpu, KVM_ARM_VCPU_SVE)) {
-		vcpu_clear_flag(vcpu, GUEST_HAS_SVE);
+	if (!vcpu_has_feature(vcpu, KVM_ARM_VCPU_SVE))
 		vcpu_clear_flag(vcpu, VCPU_SVE_FINALIZED);
-	}
 }
 
 static int init_pkvm_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu,
diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
index 0ebf84a9f9e2..b976c07c3108 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -44,7 +44,7 @@ static void __activate_cptr_traps(struct kvm_vcpu *vcpu)
 
 		if (guest_owns_fp_regs()) {
 			val |= CPACR_ELx_FPEN;
-			if (vcpu_has_sve(vcpu))
+			if (kvm_has_sve(kern_hyp_va(vcpu->kvm)))
 				val |= CPACR_ELx_ZEN;
 		}
 	} else {
@@ -56,7 +56,7 @@ static void __activate_cptr_traps(struct kvm_vcpu *vcpu)
 		 */
 		val |= CPTR_EL2_TSM;
 
-		if (!vcpu_has_sve(vcpu) || !guest_owns_fp_regs())
+		if (!kvm_has_sve(kern_hyp_va(vcpu->kvm)) || !guest_owns_fp_regs())
 			val |= CPTR_EL2_TZ;
 
 		if (!guest_owns_fp_regs())
@@ -119,7 +119,7 @@ static void __deactivate_traps(struct kvm_vcpu *vcpu)
 
 	write_sysreg(this_cpu_ptr(&kvm_init_params)->hcr_el2, hcr_el2);
 
-	kvm_reset_cptr_el2(vcpu);
+	kvm_reset_cptr_el2(kern_hyp_va(vcpu->kvm));
 	write_sysreg(__kvm_hyp_host_vector, vbar_el2);
 }
 
@@ -203,7 +203,7 @@ static void kvm_hyp_save_fpsimd_host(struct kvm_vcpu *vcpu)
 		__hyp_sve_save_host();
 
 		/* Re-enable SVE traps if not supported for the guest vcpu. */
-		if (!vcpu_has_sve(vcpu))
+		if (!kvm_has_sve(kern_hyp_va(vcpu->kvm)))
 			cpacr_clear_set(CPACR_ELx_ZEN, 0);
 
 	} else {
diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
index 80581b1c3995..5407f82c2bec 100644
--- a/arch/arm64/kvm/hyp/vhe/switch.c
+++ b/arch/arm64/kvm/hyp/vhe/switch.c
@@ -207,7 +207,7 @@ static void __deactivate_traps(struct kvm_vcpu *vcpu)
 	 */
 	asm(ALTERNATIVE("nop", "isb", ARM64_WORKAROUND_SPECULATIVE_AT));
 
-	kvm_reset_cptr_el2(vcpu);
+	kvm_reset_cptr_el2(vcpu->kvm);
 
 	if (!arm64_kernel_unmapped_at_el0())
 		host_vectors = __this_cpu_read(this_cpu_vector);
diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
index 1cfab6a5d8a5..803e11b0dc8f 100644
--- a/arch/arm64/kvm/reset.c
+++ b/arch/arm64/kvm/reset.c
@@ -85,7 +85,7 @@ static void kvm_vcpu_enable_sve(struct kvm_vcpu *vcpu)
 	 * KVM_REG_ARM64_SVE_VLS.  Allocation is deferred until
 	 * kvm_arm_vcpu_finalize(), which freezes the configuration.
 	 */
-	vcpu_set_flag(vcpu, GUEST_HAS_SVE);
+	set_bit(KVM_ARCH_FLAG_GUEST_HAS_SVE, &vcpu->kvm->arch.flags);
 }
 
 /*
-- 
2.47.0.338.g60cca15819-goog

