Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD43433C5
	for <kvmarm@lists.linux.dev>; Wed, 20 Nov 2024 10:53:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732100003; cv=none; b=iJx6eBiJ+uKG87Na53RwDtYnOktzo2KMYmRdhlTSGKNCvCwEgoHB5xwf8uggKX2eyhalVbL34+OzValq412CQ8i+0fSsAtN15YFjOf/c5PB7OH0O/WJ5r1OaNhZgNH4Og0qoNy/A9QEHw3Yb189AR676SJZwlNJL20eDNy8E30I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732100003; c=relaxed/simple;
	bh=RtbIW0QSVNVclRWf/PBNI1dRb19qLg41FCuzJmt1vpE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=M2dWNBJU7TRYKkKPpkUod9HD/AqT5aUY+dWIBaJkVYkMY7+NAizq3hY52ErYgazKSALK5tQr8H6VPkcyvRub4yy1duVtkigY2mFr2x+Rm3nQSetHP+ZVPFmuRd2MPqFALUJV4IkGWfoYJuiZWD9wxIeAUK1L9cpVtf6bH4UoOqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=V7fjR7Xg; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="V7fjR7Xg"
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-6ea6aa3b68bso99555947b3.3
        for <kvmarm@lists.linux.dev>; Wed, 20 Nov 2024 02:53:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732100001; x=1732704801; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=6JquR2uEtGIuvh8lVzjpHJvjKLaOnO/ZBqND0mi6cdw=;
        b=V7fjR7Xgs2Kf0iRl9g0wvwdAAMkukUP6RIuL9HU4Tr1Zgj+48/LnzkT44PwijO32t3
         uwzU7xZVQ1ijRMGvmWsNV2HktfS+u9t9u/NVgMeBIs1QXnuCX5reH8WYJZ11b6HF9xFN
         CUwHT0Fe+KVWf380G0NWYiKVL+exIMGHMqHPhejhoGelbZsxtnMxqp1+GmBwiYLBqPnr
         Y6pfFgTTi0D444w62Mu67DkDtASt7EKiOnWsHRj4tMeEhGTrlj56zyIeaG/uDEYJPX5e
         Xr3eAVvByWx0G7AHr4mBDSs0ROV2ZA/VW2wn9E7XD1OxX5ODEFi1LWwxCeHl4J9GdOuA
         VJgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732100001; x=1732704801;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6JquR2uEtGIuvh8lVzjpHJvjKLaOnO/ZBqND0mi6cdw=;
        b=B+7gB5bLAOgzZknkob5VK/eBrazj79DF7YE3crrwVeCJanRk+iLpR+ebcQ7XtNtQOk
         SEoCv/fFciqea9+UHvWD1JHbyO5LKMmG0RdJMufqIniZt8PoT0Zdo2zCv8nP8lMvyc2c
         2EQL1MTReUC1IsnHN8jC2X0L6bE6PdQkzEaDQjsa+BSTiiurlkp1rsK9+KI2Bl8ZHAlk
         RYD9i0L+teH67iJG2/thKAET0hZvfZaYlw9CCMhqctmC0Nx3C3pNmtfVBvQI5ztDdlC+
         gpfFfm1R9yuM91LutROj4C0bgkSPV7KVX625QtKqd9hyCix6rdYQVI9uSwHQM+ulPxLx
         3OBQ==
X-Gm-Message-State: AOJu0YxgzB/lI7uzUgpGYeWqHdIviFMXwa3RgIIF9gIaawrg/s74JnO3
	NIoDWu0qKRExel+1u1/hVRE1nqHbxApRy0j4esK+Zz7ELPmaeh8Zn+dxGkHBFGqK9VIa9IP96SJ
	HMoVZmAdIdSlD7LmY3BUq4Yd/Mz9YEZzuKmMsqfmt4XLkyqnsPTlMiQlFvuA3mxzE/O1HkCRSuX
	h8IRpagTPl4iOHMjDPVP2ynH0n3GU=
X-Google-Smtp-Source: AGHT+IGjTO1sOEXRqcz5cXGI1+8/omcfLZJdyTvwqzeuyUIxCa2tryhb/BBthy5hFyNh+HC+CU3EpfV4FA==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a05:690c:290c:b0:6ee:c34b:70ac with SMTP id
 00721157ae682-6eec34bae88mr7667b3.0.1732100000244; Wed, 20 Nov 2024 02:53:20
 -0800 (PST)
Date: Wed, 20 Nov 2024 10:52:52 +0000
In-Reply-To: <20241120105254.2842020-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241120105254.2842020-1-tabba@google.com>
X-Mailer: git-send-email 2.47.0.338.g60cca15819-goog
Message-ID: <20241120105254.2842020-11-tabba@google.com>
Subject: [PATCH v1 10/12] KVM: arm64: Calculate cptr_el2 traps on activating traps
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, james.clark@linaro.org, 
	will@kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, broonie@kernel.org
Content-Type: text/plain; charset="UTF-8"

Similar to VHE, calculate the value of cptr_el2 from scratch on
activate traps. This removes the need to store cptr_el2 in every
vcpu structure. Moreover, some traps, such as whether the guest
owns the fp registers, need to be set on every vcpu run.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/include/asm/kvm_host.h |  1 -
 arch/arm64/kvm/arm.c              |  1 -
 arch/arm64/kvm/hyp/nvhe/pkvm.c    | 42 -------------------------------
 arch/arm64/kvm/hyp/nvhe/switch.c  | 30 +++++++++++++++++-----
 4 files changed, 24 insertions(+), 50 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index f333b189fb43..99660d040dda 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -708,7 +708,6 @@ struct kvm_vcpu_arch {
 	u64 hcr_el2;
 	u64 hcrx_el2;
 	u64 mdcr_el2;
-	u64 cptr_el2;
 
 	/* Exception Information */
 	struct kvm_vcpu_fault_info fault;
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index b295218cdc24..8a3d02cf0a7a 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1546,7 +1546,6 @@ static int kvm_arch_vcpu_ioctl_vcpu_init(struct kvm_vcpu *vcpu,
 	}
 
 	vcpu_reset_hcr(vcpu);
-	vcpu->arch.cptr_el2 = kvm_get_reset_cptr_el2(vcpu);
 
 	/*
 	 * Handle the "start in power-off" case.
diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index cede527a59d4..c8ab3e59f4b1 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -83,44 +83,6 @@ static void pvm_init_traps_hcr(struct kvm_vcpu *vcpu)
 	vcpu->arch.hcr_el2 = val;
 }
 
-static void pvm_init_traps_cptr(struct kvm_vcpu *vcpu)
-{
-	struct kvm *kvm = vcpu->kvm;
-	u64 val = vcpu->arch.cptr_el2;
-
-	if (!has_hvhe()) {
-		val |= CPTR_NVHE_EL2_RES1;
-		val &= ~(CPTR_NVHE_EL2_RES0);
-	}
-
-	if (!kvm_has_feat(kvm, ID_AA64PFR0_EL1, AMU, IMP))
-		val |= CPTR_EL2_TAM;
-
-	/* SVE can be disabled by userspace even if supported. */
-	if (!vcpu_has_sve(vcpu)) {
-		if (has_hvhe())
-			val &= ~(CPACR_ELx_ZEN);
-		else
-			val |= CPTR_EL2_TZ;
-	}
-
-	/* No SME support in KVM. */
-	BUG_ON(kvm_has_feat(kvm, ID_AA64PFR1_EL1, SME, IMP));
-	if (has_hvhe())
-		val &= ~(CPACR_ELx_SMEN);
-	else
-		val |= CPTR_EL2_TSM;
-
-	if (!kvm_has_feat(kvm, ID_AA64DFR0_EL1, TraceVer, IMP)) {
-		if (has_hvhe())
-			val |= CPACR_EL1_TTA;
-		else
-			val |= CPTR_EL2_TTA;
-	}
-
-	vcpu->arch.cptr_el2 = val;
-}
-
 static void pvm_init_traps_mdcr(struct kvm_vcpu *vcpu)
 {
 	struct kvm *kvm = vcpu->kvm;
@@ -191,7 +153,6 @@ static int pkvm_vcpu_init_traps(struct pkvm_hyp_vcpu *hyp_vcpu)
 	struct kvm_vcpu *vcpu = &hyp_vcpu->vcpu;
 	int ret;
 
-	vcpu->arch.cptr_el2 = kvm_get_reset_cptr_el2(vcpu);
 	vcpu->arch.mdcr_el2 = 0;
 
 	pkvm_vcpu_reset_hcr(vcpu);
@@ -204,7 +165,6 @@ static int pkvm_vcpu_init_traps(struct pkvm_hyp_vcpu *hyp_vcpu)
 		return ret;
 
 	pvm_init_traps_hcr(vcpu);
-	pvm_init_traps_cptr(vcpu);
 	pvm_init_traps_mdcr(vcpu);
 
 	return 0;
@@ -644,8 +604,6 @@ int __pkvm_init_vcpu(pkvm_handle_t handle, struct kvm_vcpu *host_vcpu,
 		return ret;
 	}
 
-	hyp_vcpu->vcpu.arch.cptr_el2 = kvm_get_reset_cptr_el2(&hyp_vcpu->vcpu);
-
 	return 0;
 }
 
diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
index 7786a83d0fa8..e95f1df86748 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -35,14 +35,10 @@ DEFINE_PER_CPU(unsigned long, kvm_hyp_vector);
 
 extern void kvm_nvhe_prepare_backtrace(unsigned long fp, unsigned long pc);
 
-static void __activate_traps(struct kvm_vcpu *vcpu)
+static void __activate_cptr_traps(struct kvm_vcpu *vcpu)
 {
-	u64 val;
-
-	___activate_traps(vcpu, vcpu->arch.hcr_el2);
-	__activate_traps_common(vcpu);
+	u64 val = kvm_get_reset_cptr_el2(vcpu);
 
-	val = vcpu->arch.cptr_el2;
 	val |= CPTR_EL2_TAM;	/* Same bit irrespective of E2H */
 	val |= has_hvhe() ? CPACR_EL1_TTA : CPTR_EL2_TTA;
 	if (cpus_have_final_cap(ARM64_SME)) {
@@ -61,7 +57,29 @@ static void __activate_traps(struct kvm_vcpu *vcpu)
 		__activate_traps_fpsimd32(vcpu);
 	}
 
+	if (vcpu_is_protected(vcpu)) {
+		struct kvm *kvm = vcpu->kvm;
+
+		if (!kvm_has_feat(kvm, ID_AA64PFR0_EL1, AMU, IMP))
+			val |= CPTR_EL2_TAM;
+
+		if (!vcpu_has_sve(vcpu)) {
+			if (has_hvhe())
+				val &= ~CPACR_ELx_ZEN;
+			else
+				val |= CPTR_EL2_TZ;
+		}
+	}
+
 	kvm_write_cptr_el2(val);
+}
+
+static void __activate_traps(struct kvm_vcpu *vcpu)
+{
+	___activate_traps(vcpu, vcpu->arch.hcr_el2);
+	__activate_traps_common(vcpu);
+	__activate_cptr_traps(vcpu);
+
 	write_sysreg(__this_cpu_read(kvm_hyp_vector), vbar_el2);
 
 	if (cpus_have_final_cap(ARM64_WORKAROUND_SPECULATIVE_AT)) {
-- 
2.47.0.338.g60cca15819-goog

