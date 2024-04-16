Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAC0F86250
	for <kvmarm@lists.linux.dev>; Tue, 16 Apr 2024 09:58:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713261510; cv=none; b=h/FAUjtsAXKlem+nq4uXoEQQHcoYNFTBfhG5P98O8Xcq+BWf+eEoFHlmyRfUk0tYrXG//D4Et44eBU8JINcUm4+srVTHx8W64nOFYlCnc3sxdwTGjctRHrqCgsncbl4jacNV/dRdSlig2MCkciWinFybR6tdTSfn5XeEgWA7Wyc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713261510; c=relaxed/simple;
	bh=o3BE04HbQ8X4f5xqpfzTO6x8y7wVTrLmpI6z9n0oanc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=t3vWiQHRFoLC0X79YAkXNhOIG5TwcWOZuU5jD1JZvTAtKdlRph7xRsYIOl5/WknDNQlgAqlcsX41O0GCMhTQDwewmNmYizcIPb55/6T3Qk80IRkd5ctSu59jMU/eH/XT0R7odLFUz4/z1xtlAJOb+yB1+tx+rajRenZ4nD3nFHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=4ClumohV; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="4ClumohV"
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-dc6b2682870so6876139276.0
        for <kvmarm@lists.linux.dev>; Tue, 16 Apr 2024 02:58:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713261508; x=1713866308; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=wv9sL4x5/tTP0WXF3r4stZRatLGD0IwpDxT9/tbgfJ0=;
        b=4ClumohVtuNU9nbN/j3y6jnLR6sSabRDHdoRQdzG301a/7jux8aSTq0i57JzSmXtJT
         iM1gdzeG73JJMx49Nz0snLtIuQTUQ4RnqGUXJWoodVWTJLpmI97zAXzNRK7iIFoq6ocs
         8Y0J1d6BA8ACLYe/tDtNQaHrqMXbNCQEXjVkrs4vakV7oM+eARNNTyAGUi9xK5Le6xZl
         p1jYGKCkHMMU5tKqPK2jBv3HF6HY6ex4HywtZNs1U2OM97889+Xsj3Fid35t+F5FUdGG
         ec+fhVHFstNohU80mXMX54CcJoEd7kUVeglx2pdwTEEBLge8i3HoQbQvOpkVrNFqfHUK
         RCcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713261508; x=1713866308;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wv9sL4x5/tTP0WXF3r4stZRatLGD0IwpDxT9/tbgfJ0=;
        b=KMRsCpSTVys+6FfpTMdHRSjWQqZK3fg/fbcN8YJDKLqShBikhpVwuI0qYSI+wKaQH0
         0LZU/HBVMz1okm045HveIc3GBVw0zFPWKFSIucx6k9If/tKcI8tkLh85VYTbA/+IkzkY
         EMEShyg6ayd4XFggiT8ODHXCMFrJDK+XNLQk8ECZ9y6HtlMEY4N1c7zmguKJm+YsrnkR
         jg1IOglV0u3THw9JdTTE4OyNKovUEG0KDCMm+y2QFbhBNJoOImmKLnWq+wFRqaEvsWyR
         DF8id45vNQusJhxp0Ebtap2Ut02acr4LMFm+a5HFE/xLSmPOfSwT0le+sIgyjI5u+Shb
         Uifw==
X-Gm-Message-State: AOJu0YwQ/RBOLv9E5bSOArnThWBo+mDUgzL4716N27iN97HVgrg7nm6n
	mUYOz+alUsPsuuO5WHv86qrChCoAoXm2wte2JwI4a1c7JNuvBDoBmZYfVqyQtHHa05RqzBytHg/
	QqtE24ViwWuTBWERNfiOYAaki9IZdLar0KnOcA/WfU8ngAbGyC1mJMbH8K2EP/cUredWT9KVObv
	6QD5JZ1W+K7VMPBfOdvEFZ39sSY8Q=
X-Google-Smtp-Source: AGHT+IHXe3TyixPUQQc4EXTszp81lqLdh7dZFFT5Zherxv9atVFxAtVlgShU9l00amCPuzZvLwbNk6jh1g==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a25:a1c3:0:b0:dcd:3172:7265 with SMTP id
 a61-20020a25a1c3000000b00dcd31727265mr3479592ybi.8.1713261507892; Tue, 16 Apr
 2024 02:58:27 -0700 (PDT)
Date: Tue, 16 Apr 2024 10:56:38 +0100
In-Reply-To: <20240416095638.3620345-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240416095638.3620345-1-tabba@google.com>
X-Mailer: git-send-email 2.44.0.683.g7961c838ac-goog
Message-ID: <20240416095638.3620345-48-tabba@google.com>
Subject: [PATCH v2 47/47] KVM: arm64: Refactor checks for FP state ownership
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev
Cc: maz@kernel.org, will@kernel.org, qperret@google.com, tabba@google.com, 
	seanjc@google.com, alexandru.elisei@arm.com, catalin.marinas@arm.com, 
	philmd@linaro.org, james.morse@arm.com, suzuki.poulose@arm.com, 
	oliver.upton@linux.dev, mark.rutland@arm.com, broonie@kernel.org, 
	joey.gouly@arm.com, rananta@google.com, smostafa@google.com
Content-Type: text/plain; charset="UTF-8"

To check for fpsimd state ownership, use the helpers
host_owns_fp_regs() and guest_owns_fp_regs() instead of directly
using the enums.

No functional change intended.

Suggested-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/include/asm/kvm_emulate.h    | 6 ++----
 arch/arm64/kvm/fpsimd.c                 | 5 ++---
 arch/arm64/kvm/hyp/include/hyp/switch.h | 2 +-
 arch/arm64/kvm/hyp/nvhe/switch.c        | 2 +-
 arch/arm64/kvm/hyp/vhe/switch.c         | 2 +-
 5 files changed, 7 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index 36e0a7281bc0..2e666dae640f 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -604,16 +604,14 @@ static __always_inline u64 kvm_get_reset_cptr_el2(struct kvm_vcpu *vcpu)
 	} else if (has_hvhe()) {
 		val = (CPACR_EL1_FPEN_EL0EN | CPACR_EL1_FPEN_EL1EN);
 
-		if (!vcpu_has_sve(vcpu) ||
-		    (*host_data_ptr(fp_owner) != FP_STATE_GUEST_OWNED))
+		if (!vcpu_has_sve(vcpu) || !guest_owns_fp_regs())
 			val |= CPACR_EL1_ZEN_EL1EN | CPACR_EL1_ZEN_EL0EN;
 		if (cpus_have_final_cap(ARM64_SME))
 			val |= CPACR_EL1_SMEN_EL1EN | CPACR_EL1_SMEN_EL0EN;
 	} else {
 		val = CPTR_NVHE_EL2_RES1;
 
-		if (vcpu_has_sve(vcpu) &&
-		    (*host_data_ptr(fp_owner) == FP_STATE_GUEST_OWNED))
+		if (vcpu_has_sve(vcpu) && guest_owns_fp_regs())
 			val |= CPTR_EL2_TZ;
 		if (cpus_have_final_cap(ARM64_SME))
 			val &= ~CPTR_EL2_TSM;
diff --git a/arch/arm64/kvm/fpsimd.c b/arch/arm64/kvm/fpsimd.c
index 51a1b18858b3..dbb731df3f68 100644
--- a/arch/arm64/kvm/fpsimd.c
+++ b/arch/arm64/kvm/fpsimd.c
@@ -118,8 +118,7 @@ void kvm_arch_vcpu_ctxsync_fp(struct kvm_vcpu *vcpu)
 
 	WARN_ON_ONCE(!irqs_disabled());
 
-	if (*host_data_ptr(fp_owner) == FP_STATE_GUEST_OWNED) {
-
+	if (guest_owns_fp_regs()) {
 		/*
 		 * Currently we do not support SME guests so SVCR is
 		 * always 0 and we just need a variable to point to.
@@ -172,7 +171,7 @@ void kvm_arch_vcpu_put_fp(struct kvm_vcpu *vcpu)
 		isb();
 	}
 
-	if (*host_data_ptr(fp_owner) == FP_STATE_GUEST_OWNED) {
+	if (guest_owns_fp_regs()) {
 		if (vcpu_has_sve(vcpu)) {
 			__vcpu_sys_reg(vcpu, ZCR_EL1) = read_sysreg_el1(SYS_ZCR);
 
diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index 38961b6b1a18..38b4e2623b02 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -370,7 +370,7 @@ static bool kvm_hyp_handle_fpsimd(struct kvm_vcpu *vcpu, u64 *exit_code)
 	isb();
 
 	/* Write out the host state if it's in the registers */
-	if (*host_data_ptr(fp_owner) == FP_STATE_HOST_OWNED)
+	if (host_owns_fp_regs())
 		__fpsimd_save_state(*host_data_ptr(fpsimd_state));
 
 	/* Restore the guest state */
diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
index cc29e05980ec..9494fd0dd285 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -335,7 +335,7 @@ int __kvm_vcpu_run(struct kvm_vcpu *vcpu)
 
 	__sysreg_restore_state_nvhe(host_ctxt);
 
-	if (*host_data_ptr(fp_owner) == FP_STATE_GUEST_OWNED)
+	if (guest_owns_fp_regs())
 		__fpsimd_save_fpexc32(vcpu);
 
 	__debug_switch_to_host(vcpu);
diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
index 7286db75b8d6..93f78df8b0f6 100644
--- a/arch/arm64/kvm/hyp/vhe/switch.c
+++ b/arch/arm64/kvm/hyp/vhe/switch.c
@@ -258,7 +258,7 @@ static int __kvm_vcpu_run_vhe(struct kvm_vcpu *vcpu)
 
 	sysreg_restore_host_state_vhe(host_ctxt);
 
-	if (*host_data_ptr(fp_owner) == FP_STATE_GUEST_OWNED)
+	if (guest_owns_fp_regs())
 		__fpsimd_save_fpexc32(vcpu);
 
 	__debug_switch_to_host(vcpu);
-- 
2.44.0.683.g7961c838ac-goog

