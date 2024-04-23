Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AAC013BAED
	for <kvmarm@lists.linux.dev>; Tue, 23 Apr 2024 15:05:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713884751; cv=none; b=XfBmLfjz+fMmYPc48mwB7U4G9f344ZB5XazEgOctnTytMYy5GdqxzC3Hjc9jkP3Dc9PnteXtHrFLnR9c4D98sXtS7Acc/Bmq4K5s2mbZ9cBBxEYq4bIeMkXlrnEEHsIyBF22UqJ3Y1NihPagfCKZD7wHsWMKIfATlt6ykTj33/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713884751; c=relaxed/simple;
	bh=7v1umB0/A1cjS8yw+dsGSQaKZD+/21gaaXSISTzsswc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=RV2Hoq21gY5sOfojyx8EeNYOlKzBUamVCKPFnacHOTqamt3lhizEq3ePhaTczcPwpEP4kzE9WiKMw9Wfr1xMcF2lFDpuiQq+Gz+snOTQ78AoxxPzBXgNV+euCuOK6DMdddRHItea0I+E2skBwCx1PKBx1OpIRmpxyCXMxNwxcn4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=dNRDxBVj; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="dNRDxBVj"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-416e58bdc0eso24065235e9.0
        for <kvmarm@lists.linux.dev>; Tue, 23 Apr 2024 08:05:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713884748; x=1714489548; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=bycnYl6s6b2K1Dc5tdJ0ejyT+YcdRIlqKxvzu34Tjhs=;
        b=dNRDxBVj83NWXJCT737WVMPp3ksFK2QU2C0iBk8bw9+rdlA0ETUWDp4frRG0E7PnSm
         V5+n3PAQCXIk0NQ10rtcN84eHPn/dJvWFuZ1KR0MYLCy7rLnUXgBbX0TeQoed427BAGg
         xd5wmmBHoP2TbPez3UuEyVdPEYDY7YucARmTvKoBNUPeJGEGUtTS+z7ey+xEqGOxVywN
         AK6BGeK6dNG2STsw+ERv1zQMmVHQ/fNCJnk2C6qLI9j49HTTz3xlg1Z0d335zqX8K8Yg
         E9l7IosQuDCiAl0dT82h3VgsTyFyPpGZqeKytro/HzV/vT40jCQJT5d+uE1XWkak1NnE
         QCng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713884748; x=1714489548;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bycnYl6s6b2K1Dc5tdJ0ejyT+YcdRIlqKxvzu34Tjhs=;
        b=B6MtdUk2XFpO3DofeDtcz9ZDXmSRAbqWSZLortNb+4C0WTxKR6JxF1yw/8KLSNe5Jw
         PoL4YtlANWG2LxICnzFr+QITgWlSXyJDjq7ykf4BB1AOpCor+TC0LDGq/DeEbI3E+dfa
         srogdS2WTtSWubfQeBFfySrYF9ccDBu0TQoORPt83/XDej6kBOjkECQfQ9o45ZJ2g3yB
         0t8yL4Qt3SJs8SJV0S44GxJ2llBnW4I5eQvAasps4OuCj137a/YQmDZTVCOHF60hXNKo
         5oXIx8vjLfNoWgFgk7i3viVijyGQIEPoO5I0WlmDWNeFx8gwCUe+JT+hJul5RcG2aKBk
         ppow==
X-Gm-Message-State: AOJu0YyjxQN8u1bvYvH+DVzvnP08eJiimn5b7ZdUvDmULfzUkvLGi4R1
	U1ZGNNLaAWM3hiBb1Cuqr3s8QxXwth7+9k0u1WNUN2G4LkZtN0zDvxLx82FlPSqOtXYeIleTe32
	n2kMg8n7tHORT7bhSEp5OH8ZF0ANYs3t4x5UiU8FUO9f3d8loGOiOFeaolqdVZKszj8Y5cMlNzW
	o4jNBV5SkFx/28Nw9oxDtneAztKWs=
X-Google-Smtp-Source: AGHT+IGhPkT/h8wPuSKs6RyyIFL0299+X/8ZYh1h6/XPMkoRwvTo7yJ+69j2xgNzfnFzJb2pt/UOLfnKAQ==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a05:600c:3b27:b0:416:542e:c74c with SMTP id
 m39-20020a05600c3b2700b00416542ec74cmr70591wms.7.1713884747670; Tue, 23 Apr
 2024 08:05:47 -0700 (PDT)
Date: Tue, 23 Apr 2024 16:05:11 +0100
In-Reply-To: <20240423150538.2103045-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240423150538.2103045-1-tabba@google.com>
X-Mailer: git-send-email 2.44.0.769.g3c40516874-goog
Message-ID: <20240423150538.2103045-4-tabba@google.com>
Subject: [PATCH v4 03/30] KVM: arm64: Refactor checks for FP state ownership
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
index 16ed1edc3780..501e3e019c93 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -577,16 +577,14 @@ static __always_inline u64 kvm_get_reset_cptr_el2(struct kvm_vcpu *vcpu)
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
index 9e382a5b0875..bb831a1bf4cb 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -1218,6 +1218,12 @@ static inline bool guest_owns_fp_regs(void)
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
index e97c981e5bef..a92566f36022 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -369,7 +369,7 @@ static bool kvm_hyp_handle_fpsimd(struct kvm_vcpu *vcpu, u64 *exit_code)
 	isb();
 
 	/* Write out the host state if it's in the registers */
-	if (*host_data_ptr(fp_owner) == FP_STATE_HOST_OWNED)
+	if (host_owns_fp_regs())
 		__fpsimd_save_state(*host_data_ptr(fpsimd_state));
 
 	/* Restore the guest state */
diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
index d373578c7a49..136f6ff2edd3 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -335,7 +335,7 @@ int __kvm_vcpu_run(struct kvm_vcpu *vcpu)
 
 	__sysreg_restore_state_nvhe(host_ctxt);
 
-	if (*host_data_ptr(fp_owner) == FP_STATE_GUEST_OWNED)
+	if (guest_owns_fp_regs())
 		__fpsimd_save_fpexc32(vcpu);
 
 	__debug_switch_to_host(vcpu);
diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
index 9e8d3605a9a1..3c339d552591 100644
--- a/arch/arm64/kvm/hyp/vhe/switch.c
+++ b/arch/arm64/kvm/hyp/vhe/switch.c
@@ -338,7 +338,7 @@ static int __kvm_vcpu_run_vhe(struct kvm_vcpu *vcpu)
 
 	sysreg_restore_host_state_vhe(host_ctxt);
 
-	if (*host_data_ptr(fp_owner) == FP_STATE_GUEST_OWNED)
+	if (guest_owns_fp_regs())
 		__fpsimd_save_fpexc32(vcpu);
 
 	__debug_switch_to_host(vcpu);
-- 
2.44.0.769.g3c40516874-goog

