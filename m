Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 283B342AAD
	for <kvmarm@lists.linux.dev>; Mon,  2 Dec 2024 15:48:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733154496; cv=none; b=q4deiCOkJm/hTKbpoPs6lQ1x7YXVWvesoXRKqgwqmfUq3+ZNu91BhsKyQQ4PUgSxBRFeXEz22TdjP0LJkxRs3ybRQHVqpZoj73Zs20ZNGno9AMdF5NFpLlofXYEZHaciCp/nO8kqOFTXfBokr7k/MuX63Cgn+jO4yH0MO9CdrV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733154496; c=relaxed/simple;
	bh=HzA+mpw1nT6JtBZUA9jpg6O/uR2ve+PAsAnZoMorOkc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=BYBCmhD0mCXVvi8Wf/7IsL/tgQ7eXTN2PAmhPDY/v6TJFescC6/E7cT36u0wIrjyVypdVC2HPpdmg+rKD7qTusA5PzYdHilsBocUMzL+E4aGLDMs4nTHXd6ZBmAz4cLQD9131ojM3Q8U0h/oNa8bi1+Z5Cr5yz9c5uFL2l7iTt4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=PnfbI3br; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="PnfbI3br"
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-385df115300so1380043f8f.2
        for <kvmarm@lists.linux.dev>; Mon, 02 Dec 2024 07:48:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1733154492; x=1733759292; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=lnQzw7GXZoQZEyFGDmh2iP65GddGe2quAc7qCM8laWA=;
        b=PnfbI3brI2R3MLo1U12gyPrI+rklyIbQpKmiiJz5zGTXyqHTc8q/oWJMWLHMw+1KSj
         3ENW1EDoJSrnOLr4Ex6ReN/E8mTpxhxD4lZ3VzGuXECZ0J7nixItO5ogLkXW+xr16i3Y
         rpq9LNWeBmtpdf+j7XD/qjcjG6kgIRZupEYdnKEy2aMJtbPfvl0XNhWRqT2J/wB56zzc
         hqRIApQxc+QXv4ndKbV+49QDZulEpo4JuRIIfgFLSh8GZdK51v52lOumLdHaJrbTfB4p
         heWSxj9xuLLHcNqYLEbIhh+FdQw00iHEWRW0Wl7kP4++fHYEJda6W/U9riosFgBHff1G
         LcPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733154492; x=1733759292;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lnQzw7GXZoQZEyFGDmh2iP65GddGe2quAc7qCM8laWA=;
        b=OqBwUkbKZIebkVvMCzhUo94yqs3KRc8oDQErw/qDPPrHCurWcbNq9iIOu6+/BDE8mK
         cgDvfDnFUX1x+ykjxla/cn12/BTlsna0LVfWXO4OodUp05H/TXRjTnNKb4m99tNEoEm1
         lkFGjAp4J6E6FpvnluHgomdOOrhKzTPnkCicRIEIvbyEMTHdTteXqe+HfjL3PYwh1t21
         eqoxOZoH2o0bdf9fNS4TnUnn9QKsilzFWPD8SDt366m+hKsTZXZNAGdECyZNnZbsRR7Z
         aVlVXhDz4bJ0jiKQb1KPjrPj7fTQ1gzlgGbi/ZUI/HBsJeXpMw45Y2lvkNxVAIJUCLMc
         ReaA==
X-Gm-Message-State: AOJu0YxP+p6YhnMaYGZIvQwFfZ1nhfx9jVftOPgyO1h829Z7Q/yOzts/
	9iehe6vlBMgjlD104b70l8swxuZ9X+OOkbdSISLPh5dhEIAP1Xd0ITEyz6xolbIBtLg9IkebC45
	RSVTGvdTOJW7K60RYIKx0CmUXBIrNL1uOlekPaIaERjZszF0CycTfX4VfiobV5mlcKRvLDc/ki/
	AnS/CxUD3TggRU5vGaDSxaQRcaG8k=
X-Google-Smtp-Source: AGHT+IFy6a6TuSNKKxoPdUR7i+hSqxgXnZND2/jd1bnVIE+WVX9SFuEs9tUkydF9BdD5AikuWy+HqIBKag==
X-Received: from wmbjz10.prod.google.com ([2002:a05:600c:580a:b0:431:4bef:d181])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6000:4915:b0:385:e8b4:aca2
 with SMTP id ffacd0b85a97d-385e8b4af8dmr7961023f8f.58.1733154492610; Mon, 02
 Dec 2024 07:48:12 -0800 (PST)
Date: Mon,  2 Dec 2024 15:47:41 +0000
In-Reply-To: <20241202154742.3611749-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241202154742.3611749-1-tabba@google.com>
X-Mailer: git-send-email 2.47.0.338.g60cca15819-goog
Message-ID: <20241202154742.3611749-15-tabba@google.com>
Subject: [PATCH v4 14/14] KVM: arm64: Convert the SVE guest vcpu flag to a vm flag
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
 arch/arm64/include/asm/kvm_emulate.h | 12 +++++++++---
 arch/arm64/include/asm/kvm_host.h    | 18 ++++++++++++------
 arch/arm64/kvm/hyp/nvhe/pkvm.c       | 11 +++++++----
 arch/arm64/kvm/reset.c               |  2 +-
 4 files changed, 29 insertions(+), 14 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index 406e99a452bf..2d91fb88298a 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -620,7 +620,7 @@ static __always_inline void kvm_write_cptr_el2(u64 val)
 }
 
 /* Resets the value of cptr_el2 when returning to the host. */
-static __always_inline void kvm_reset_cptr_el2(struct kvm_vcpu *vcpu)
+static __always_inline void __kvm_reset_cptr_el2(struct kvm *kvm)
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
@@ -647,6 +647,12 @@ static __always_inline void kvm_reset_cptr_el2(struct kvm_vcpu *vcpu)
 	kvm_write_cptr_el2(val);
 }
 
+#ifdef __KVM_NVHE_HYPERVISOR__
+#define kvm_reset_cptr_el2(v)	__kvm_reset_cptr_el2(kern_hyp_va((v)->kvm))
+#else
+#define kvm_reset_cptr_el2(v)	__kvm_reset_cptr_el2((v)->kvm)
+#endif
+
 /*
  * Returns a 'sanitised' view of CPTR_EL2, translating from nVHE to the VHE
  * format if E2H isn't set.
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index e6be8fe6627a..c834b6768247 100644
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
@@ -862,12 +864,10 @@ struct kvm_vcpu_arch {
 #define vcpu_set_flag(v, ...)	__vcpu_set_flag((v), __VA_ARGS__)
 #define vcpu_clear_flag(v, ...)	__vcpu_clear_flag((v), __VA_ARGS__)
 
-/* SVE exposed to guest */
-#define GUEST_HAS_SVE		__vcpu_single_flag(cflags, BIT(0))
+/* KVM_ARM_VCPU_INIT completed */
+#define VCPU_INITIALIZED	__vcpu_single_flag(cflags, BIT(0))
 /* SVE config completed */
 #define VCPU_SVE_FINALIZED	__vcpu_single_flag(cflags, BIT(1))
-/* KVM_ARM_VCPU_INIT completed */
-#define VCPU_INITIALIZED	__vcpu_single_flag(cflags, BIT(2))
 
 /* Exception pending */
 #define PENDING_EXCEPTION	__vcpu_single_flag(iflags, BIT(0))
@@ -956,8 +956,14 @@ struct kvm_vcpu_arch {
 				 KVM_GUESTDBG_USE_HW | \
 				 KVM_GUESTDBG_SINGLESTEP)
 
-#define vcpu_has_sve(vcpu) (system_supports_sve() &&			\
-			    vcpu_get_flag(vcpu, GUEST_HAS_SVE))
+#define kvm_has_sve(kvm)	(system_supports_sve() &&		\
+				 test_bit(KVM_ARCH_FLAG_GUEST_HAS_SVE, &(kvm)->arch.flags))
+
+#ifdef __KVM_NVHE_HYPERVISOR__
+#define vcpu_has_sve(vcpu)	kvm_has_sve(kern_hyp_va((vcpu)->kvm))
+#else
+#define vcpu_has_sve(vcpu)	kvm_has_sve((vcpu)->kvm)
+#endif
 
 #ifdef CONFIG_ARM64_PTR_AUTH
 #define vcpu_has_ptrauth(vcpu)						\
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

