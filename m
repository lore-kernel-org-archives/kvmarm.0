Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A959713BADC
	for <kvmarm@lists.linux.dev>; Tue, 23 Apr 2024 15:05:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713884748; cv=none; b=nWR/XN04UCKENm0GkMJAzwIr+nSMXSnGYCH4Lt++RP2VasB9poSEIIwFffTMVVHsVga0MAp37Ik0+trbmo1iW9wRuzK03pRzhgogfa/EZBK4/EuXxTz4G/e9sDS2RaG0V7bfNxEAMF2Q8prjEQqsL658L8esdQESbR/mrOfAEqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713884748; c=relaxed/simple;
	bh=Fi0fqh/53uNOdX3QxpBsmLU03FADc6YcAJiIQHg+4LM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=u16+4+K5QyqTapSs65+wMGtGiVS2YBFIOjz9CFST5uYnijiEuLTD+smrTw2Bqf5CzsE99b8G/3CBdnV3eh1FX22Frv9qvI3kblC9hjPppyW6XQgAhW4v66nPfdG22YUpoeTfWTdEgg5jl8xtHfna8Yj133oZ9z2r8exNGCIvkg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Snjtvpry; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Snjtvpry"
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-61afa79081dso98276177b3.2
        for <kvmarm@lists.linux.dev>; Tue, 23 Apr 2024 08:05:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713884745; x=1714489545; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=0v/WveyMQKVn5E1RewUvOuzzO1kFx2OaJnddNLGMg0U=;
        b=SnjtvpryR48uJ/IySto2q/AO2dpIPnvAAn9un3MCff92nZsUt7+I9pnKC3ELD/ewTF
         Shu5/FNRuHfbqcG65VPU3T9a6Mz/dhuhAOkNOAVPQ2FXxlFEsnBbyj9a4snHEeDqDHdP
         GPuOQYVBa8rPms/MfSgr7qIGqbX3b26hGaG9bA/xEuXo15FwIjqgscRlqUDEIlT1qb8P
         /2ai7PWkgFxsM45Mu1Z9bNmsPcN2Ns7WB+FP39C56jYIf+btjwM6tPoLPBoXNIcPNX7J
         JNiVar9CcATbPFVH5sMeImaCl0QMXah2dTgvJ1RL5J9eWgK7drnAG252BxGaMtnoJiDq
         Kb3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713884745; x=1714489545;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0v/WveyMQKVn5E1RewUvOuzzO1kFx2OaJnddNLGMg0U=;
        b=TOWXoCHH7qhE8U+Sv+dtAHLd70sSD03F0QNGZJj34q/kxRJ0eiQ4nEPkh6LZTzavrK
         8lnOAQBev8JlrtxYYs8DM8I/XqlBlAgyeGRUMdNO5WgyGJ5Xz48suXgbl57VVGBYW/b2
         fsAjc8lWE69281WfhjEmNzN4e+3U9MZ6kzoH3XA/Oavjz1twNrntvwz/Tdgz8QcKXZjU
         7o0f3+MBTPMkR6Q1BbPIjRpSRo5bT2T/IyQB2yEl3CmV/KhTdtT/c/YodarGqQr5AIS6
         mMiXixLXTWVVd0LXceyQ9Nh8sXU0Gn51FKu/bpS1ZFE2/5RsFmvS1iapWiRyGFaTLZHe
         fVSQ==
X-Gm-Message-State: AOJu0YxwaUWebSuaT8VePRreRl4wdMn4QpIZCjRRwRgAbzLDFkWJ/99c
	L+CAM/kOk1SkX0AwxbHVWq0ePJn4pozsVO4weLcqvN+40dc1yD6bW3TOqHI54+yC7HkS7sigm2+
	ATv/9Mvd9dJTJiPGwTiAPIGmYTorfS4PE8c7Elt4U0GJEgpPvvgR0MSLwV3AtnsOawzJjtkDIzg
	ivolzmuuUtnIeFd0vxn07S4bh7MZQ=
X-Google-Smtp-Source: AGHT+IHSLRTb4beET0KTPB/k1HFcGsBJqgPxdjOX/yjFPkiB9tIO8J7GPwmdH0TBSKzjqWsEI56iO/ZUyg==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a05:6902:2b02:b0:de5:2ce1:b62d with SMTP id
 fi2-20020a0569022b0200b00de52ce1b62dmr582464ybb.10.1713884745397; Tue, 23 Apr
 2024 08:05:45 -0700 (PDT)
Date: Tue, 23 Apr 2024 16:05:10 +0100
In-Reply-To: <20240423150538.2103045-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240423150538.2103045-1-tabba@google.com>
X-Mailer: git-send-email 2.44.0.769.g3c40516874-goog
Message-ID: <20240423150538.2103045-3-tabba@google.com>
Subject: [PATCH v4 02/30] KVM: arm64: Move guest_owns_fp_regs() to increase
 its scope
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev
Cc: maz@kernel.org, will@kernel.org, qperret@google.com, tabba@google.com, 
	seanjc@google.com, alexandru.elisei@arm.com, catalin.marinas@arm.com, 
	philmd@linaro.org, james.morse@arm.com, suzuki.poulose@arm.com, 
	oliver.upton@linux.dev, mark.rutland@arm.com, broonie@kernel.org, 
	joey.gouly@arm.com, rananta@google.com, smostafa@google.com
Content-Type: text/plain; charset="UTF-8"

guest_owns_fp_regs() will be used to check fpsimd state ownership
across kvm/arm64. Therefore, move it to kvm_host.h to widen its
scope.

Moreover, the host state is not per-vcpu anymore, the vcpu
parameter isn't used, so remove it as well.

No functional change intended.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/include/asm/kvm_host.h       | 6 ++++++
 arch/arm64/kvm/hyp/include/hyp/switch.h | 6 ------
 arch/arm64/kvm/hyp/nvhe/switch.c        | 2 +-
 arch/arm64/kvm/hyp/vhe/switch.c         | 2 +-
 4 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index cdc0aad43d41..9e382a5b0875 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -1212,6 +1212,12 @@ DECLARE_KVM_HYP_PER_CPU(struct kvm_host_data, kvm_host_data);
 	 &this_cpu_ptr_hyp_sym(kvm_host_data)->f)
 #endif
 
+/* Check whether the FP regs are owned by the guest */
+static inline bool guest_owns_fp_regs(void)
+{
+	return *host_data_ptr(fp_owner) == FP_STATE_GUEST_OWNED;
+}
+
 static inline void kvm_init_host_cpu_context(struct kvm_cpu_context *cpu_ctxt)
 {
 	/* The host's MPIDR is immutable, so let's set it up at boot time */
diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index 61772bf1d3e6..e97c981e5bef 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -40,12 +40,6 @@ struct kvm_exception_table_entry {
 extern struct kvm_exception_table_entry __start___kvm_ex_table;
 extern struct kvm_exception_table_entry __stop___kvm_ex_table;
 
-/* Check whether the FP regs are owned by the guest */
-static inline bool guest_owns_fp_regs(struct kvm_vcpu *vcpu)
-{
-	return *host_data_ptr(fp_owner) == FP_STATE_GUEST_OWNED;
-}
-
 /* Save the 32-bit only FPSIMD system register state */
 static inline void __fpsimd_save_fpexc32(struct kvm_vcpu *vcpu)
 {
diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
index 563604b55ea2..d373578c7a49 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -53,7 +53,7 @@ static void __activate_traps(struct kvm_vcpu *vcpu)
 			val |= CPTR_EL2_TSM;
 	}
 
-	if (!guest_owns_fp_regs(vcpu)) {
+	if (!guest_owns_fp_regs()) {
 		if (has_hvhe())
 			val &= ~(CPACR_EL1_FPEN_EL0EN | CPACR_EL1_FPEN_EL1EN |
 				 CPACR_EL1_ZEN_EL0EN | CPACR_EL1_ZEN_EL1EN);
diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
index 90f22926b15b..9e8d3605a9a1 100644
--- a/arch/arm64/kvm/hyp/vhe/switch.c
+++ b/arch/arm64/kvm/hyp/vhe/switch.c
@@ -107,7 +107,7 @@ static void __activate_traps(struct kvm_vcpu *vcpu)
 
 	val |= CPTR_EL2_TAM;
 
-	if (guest_owns_fp_regs(vcpu)) {
+	if (guest_owns_fp_regs()) {
 		if (vcpu_has_sve(vcpu))
 			val |= CPACR_EL1_ZEN_EL0EN | CPACR_EL1_ZEN_EL1EN;
 	} else {
-- 
2.44.0.769.g3c40516874-goog

