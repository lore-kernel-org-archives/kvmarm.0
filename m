Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55F1247F6C
	for <kvmarm@lists.linux.dev>; Fri, 19 Apr 2024 07:59:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713513592; cv=none; b=nqRUK2PTutLKoF16BPOYwTwkdWoT3uQMx4l26Q4R6YOI2FXB+swpeOQR7OW90IVEsUaAe7LXsD9al5zScSe9ZmO1HWcCEAQYhgAXZJEcD13R+Uc3UiTVZl1j1UDFF3moZT5cztI8Zk8ukQFUM6XJS0SrKtDt90gF9cXu/zcHjGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713513592; c=relaxed/simple;
	bh=mMr4rG2QZBKu7aYkAGboHYMkl5dS68AmyVWZiSFaeZM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=JFdFeLclHaFrvPhHJG/P5EIsgGfp66U5RbEJjcBV7begX2T1AzwsUH6SNU++LuLezspPq1WfgmFjbjQDPH3cOKuh4k5mz/1w8mOYum1uGWa1l3aYaHwjnHy25yKW3tlQaJxmLb5lkVuKvLz2jxFo5kx+4V938l3QTKrkDW2R6jY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=FYRq0Acc; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="FYRq0Acc"
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-6167463c60cso20592927b3.1
        for <kvmarm@lists.linux.dev>; Fri, 19 Apr 2024 00:59:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713513590; x=1714118390; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ytT1oldFL3BQvdYui/SIWTnj3WyOFs3WfWhY5XM6n70=;
        b=FYRq0Acc9cHoAvgdpcuQQE3vQucn5Q1yJu4ko86x/5UqxqJNtyzvSk5hI3F9/4bIA1
         UXEcBbbhmShGYsSe5pcktdQ62TT2IW4gRkhtDi2NZWKcUxC2e9dBexR2dMD2uPGXI/zu
         gzcQlvwqNMtKye5nxwaxri/7F+WCCURbjnSyao587HXcr7iPNjsRj0tM70NEJu081Tt+
         Qfy2bgvDEGthHZHWx7ta07j8y7nRVgyHbQXBUkdoMbUIO6rQ4SHYdQD3o8mIk7thrwpJ
         uskavv7EE/jId9m43yHcDPmJz8Si1HN1Dq14JHEBRTvxSSlxLxi3jAA6zllb6mvmrlC8
         HLSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713513590; x=1714118390;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ytT1oldFL3BQvdYui/SIWTnj3WyOFs3WfWhY5XM6n70=;
        b=OKa96nr51okFfsBBB5oTr+L5V8l8LDp1hzQXms0HbkMqX9BT2pzOs39S7mXPe2S+em
         lDo0uNH2t4ayXydfV3YVAD0672eBzoFgly4XbpE9iO8gN2LzjFAm/Gzw+PhVgtdR5K21
         GbLfv4gLTAJqDgro7IaKymVcTayVO8UQr8qAMzurWQV8zMlyZRy+lDn6+wg5y4wsNgyh
         liUU6hZgUFkXPcR6wJfmTTI4Rgj7c4JtgSiT6/CIcQ2MEVPtAVZr7nTllAhwRwkBToJV
         H6hXgb35o+o21vd3arn+Xzj2E4DfUaGwkG130/m/ljZ01HcHWQ7yRgyfzKe9S8bSnQ/C
         iAYA==
X-Gm-Message-State: AOJu0YzJMD22GDhZ2fgsfNYWUthrfqGygxRXsnuXwbWHL3lu6peTqBwR
	aRMr1hsKeeMSIYQ9H+6GFrEtpPd2bH+kWR8fxsvdEr2QtnnFC++Ld6nITeHUIrCv4KUaG5Tk3ne
	EjvOZCcvcFG5dp3WeFVjJesM+J/LRHuQ9KZIM10qdvXSsxWQXCgMa90gXXV3xtAU2xhYqFbpP+/
	GP8iBnVlnmWgXWgd1+5kgd2GR7euw=
X-Google-Smtp-Source: AGHT+IHhuOgHStq1xjneh/ff0+sU88+D62ARmEkELpqdolVuu/fap0cEePk/qdITcqnSeeAkj/nFIBfHuw==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a81:b403:0:b0:611:5a9d:bb0e with SMTP id
 h3-20020a81b403000000b006115a9dbb0emr378820ywi.4.1713513590174; Fri, 19 Apr
 2024 00:59:50 -0700 (PDT)
Date: Fri, 19 Apr 2024 08:59:13 +0100
In-Reply-To: <20240419075941.4085061-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240419075941.4085061-1-tabba@google.com>
X-Mailer: git-send-email 2.44.0.769.g3c40516874-goog
Message-ID: <20240419075941.4085061-4-tabba@google.com>
Subject: [PATCH v3 03/31] KVM: arm64: Refactor checks for FP state ownership
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev
Cc: maz@kernel.org, will@kernel.org, qperret@google.com, tabba@google.com, 
	seanjc@google.com, alexandru.elisei@arm.com, catalin.marinas@arm.com, 
	philmd@linaro.org, james.morse@arm.com, suzuki.poulose@arm.com, 
	oliver.upton@linux.dev, mark.rutland@arm.com, broonie@kernel.org, 
	joey.gouly@arm.com, rananta@google.com, smostafa@google.com
Content-Type: text/plain; charset="UTF-8"

To avoid direct comparison against the fp_owner enum, add a new
function that performs the check, host_owns_fp_regs(), to
complement the existing guest_owns_fp_regs().

To check for fpsimd state ownership, use the helpers instead of
directly using the enums.

No functional change intended.

Suggested-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/include/asm/kvm_emulate.h    | 6 ++----
 arch/arm64/include/asm/kvm_host.h       | 6 ++++++
 arch/arm64/kvm/fpsimd.c                 | 5 ++---
 arch/arm64/kvm/hyp/include/hyp/switch.h | 2 +-
 arch/arm64/kvm/hyp/nvhe/switch.c        | 2 +-
 arch/arm64/kvm/hyp/vhe/switch.c         | 2 +-
 6 files changed, 13 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index 3d65d9413608..deaa88b972ec 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -587,16 +587,14 @@ static __always_inline u64 kvm_get_reset_cptr_el2(struct kvm_vcpu *vcpu)
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
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 2889e1d8a8c1..4609d1b9ddde 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -1213,6 +1213,12 @@ static inline bool guest_owns_fp_regs(void)
 	return *host_data_ptr(fp_owner) == FP_STATE_GUEST_OWNED;
 }
 
+/* Check whether the FP regs are owned by the host */
+static inline bool host_owns_fp_regs(void)
+{
+	return *host_data_ptr(fp_owner) == FP_STATE_HOST_OWNED;
+}
+
 static inline void kvm_init_host_cpu_context(struct kvm_cpu_context *cpu_ctxt)
 {
 	/* The host's MPIDR is immutable, so let's set it up at boot time */
diff --git a/arch/arm64/kvm/fpsimd.c b/arch/arm64/kvm/fpsimd.c
index 7507dcc4e553..d5837d65e4a1 100644
--- a/arch/arm64/kvm/fpsimd.c
+++ b/arch/arm64/kvm/fpsimd.c
@@ -141,8 +141,7 @@ void kvm_arch_vcpu_ctxsync_fp(struct kvm_vcpu *vcpu)
 
 	WARN_ON_ONCE(!irqs_disabled());
 
-	if (*host_data_ptr(fp_owner) == FP_STATE_GUEST_OWNED) {
-
+	if (guest_owns_fp_regs()) {
 		/*
 		 * Currently we do not support SME guests so SVCR is
 		 * always 0 and we just need a variable to point to.
@@ -195,7 +194,7 @@ void kvm_arch_vcpu_put_fp(struct kvm_vcpu *vcpu)
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
index 1b22654a3180..5d2d4d6465e8 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -337,7 +337,7 @@ int __kvm_vcpu_run(struct kvm_vcpu *vcpu)
 
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
2.44.0.769.g3c40516874-goog

