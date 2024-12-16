Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BAC92AF03
	for <kvmarm@lists.linux.dev>; Mon, 16 Dec 2024 10:51:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734346295; cv=none; b=GAyneG5vj3EUv/ainr1IXTYB01YWz2URbc9LwDZzVO3eakpLR8sJMbrkhKz9k6uWQ0V5Qy3oNzL2VZwqkpqD1R3KmiALcTwyOWIPQzKn8mRCrRNFsr6A25M0C7G3HOi8Xp+EGMVb24Xiype+LXSgTCYiEtF5THClqM9Exb3ZFD4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734346295; c=relaxed/simple;
	bh=wU0ba7EJlu/c/7zmAgjVe2lNKtj+Cb0qvSldp9rkIr8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=GghHuwCLxqC+FG4ouwx2/Fq8mxFJ/Hq5dn3OUS/1I2cT3gXa75WZVCMQ8KCi8QXpd331LfYnFA65We0Pjmu6f0CShOyu/B01xnikcsCeaPkgNk4atmGhnzuUKG7DTE29M6R9ZqTo7AQAYyXTeQ+qEQ4XhrirOvFkHeuB7mZAvL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=1F3XMfE5; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="1F3XMfE5"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-43635895374so8359685e9.0
        for <kvmarm@lists.linux.dev>; Mon, 16 Dec 2024 02:51:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1734346292; x=1734951092; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=GWRlIiI31BxmGPjckPOwy0oDiGPfB3G4L1dgRWKrBVw=;
        b=1F3XMfE5PhKP/OfP0LRpC4HdfSg+jNYr52H1w3Su888qgx0qwGne6vrO7rTxqgc5OH
         rd9Np2+43jHNYM41x2P2zub7SL2V5YC2WdhaPt8GdVNmufFgxBjs9dGEipszhNVy2+kR
         h5CBxSAPBd617a8h7MWQERu8X60LbysAAEU32fGC7ugEboG2gdv+3iQo9Qd5VVUalzsK
         xILWEHWSSV+qoHYh76oHCo24BDxgB866Bsik3oOE3b48ZBQ9FAS6u30IceDuduHRNJqg
         7jH/AR1C9U5aGEL6YWBGC8IMYJpgoxF/n9MaKOnMliq0yX7s2jg/TyofJ6mix/FbTvDX
         kaCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734346292; x=1734951092;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GWRlIiI31BxmGPjckPOwy0oDiGPfB3G4L1dgRWKrBVw=;
        b=tiLI7u4u8pKV1jUBMZFD/IrkXr65vtz8T4eezx/xvY+wFdEbwhXGzjUDaFo50WVJzS
         bjhOk66wV3ebhCz5pNJXvS+fP7eu4kf7ieo6IIh9l6BX5i2Mb+7q0/N1SSlN2+Q8klVd
         awSstDktzmsau3V7LfPuirU506/Xwvp3YUeaV0UpXEI5PNFQshCW+FyGysZrPrZ24TLS
         GtMJ2ouctobNU9zhMpLSGE/W5NiW/nmxPu7V3nMc5g+PM/W3ZO62kW9BceLbXFCoPyS+
         V7axkLxi8bCj5LFvmM7lE0QZ+s8po1ArVkEKLeFS3UPG1CE8krNuU9sq0qA4VSUzwZD0
         q1tQ==
X-Gm-Message-State: AOJu0YyhuEg6Sc7iRZ9+MghZ94DW1K/wh7Wcs+4T8so3W/+l0XvJazyP
	gJu3an7FbIeu+Gysx+JTM4XyG70YfpGWgZcD+R0mISjd3Fu2UDEs6f7vsvgn0zG6XTRVXXfU052
	1eejTHzh74klLfB8FyPnmDFacaDRt+68oWGMHT27ZLxo6Q5lslP8I92Zy8CuLex9MsjiezAI3hY
	z1ruy7NK7G+fdA063pSGI/7mrdWTQ=
X-Google-Smtp-Source: AGHT+IEuNL+lWG9lMFyK20DSLRl1dnkflzDK3gJDdXF5BmkvWUPWorOkbhhkOY3ezU3DDXl2n09tnPFLlg==
X-Received: from wmqf13.prod.google.com ([2002:a05:600c:4e8d:b0:434:f21d:7e31])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6000:2cf:b0:386:4332:cc99
 with SMTP id ffacd0b85a97d-387888069d8mr13864516f8f.17.1734346291723; Mon, 16
 Dec 2024 02:51:31 -0800 (PST)
Date: Mon, 16 Dec 2024 10:50:56 +0000
In-Reply-To: <20241216105057.579031-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241216105057.579031-1-tabba@google.com>
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
Message-ID: <20241216105057.579031-17-tabba@google.com>
Subject: [PATCH v5 16/17] KVM: arm64: Convert the SVE guest vcpu flag to a vm flag
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
index b399d69b4b67..446a9114b0d3 100644
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
2.47.1.613.gc27f4b7a9f-goog

