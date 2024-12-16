Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6CB8203D53
	for <kvmarm@lists.linux.dev>; Mon, 16 Dec 2024 10:51:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734346286; cv=none; b=LF2bIcqSSHvOETfgY35iGkcK2uue2cCsW8VwgL/yskUpGLNX8Ta+B4ZttYZjywckTR4HZamTFKeQz6Mg1a6m/1ypyM1JzYtFJzQT+uHQishb2n8Wd1jbthcItfoPwFsFKz5ItclttTfLK2QLkulW3W2rgbK4HK++M94soobtXWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734346286; c=relaxed/simple;
	bh=FNYQgjOEt0OR01zRsOIXdDTYlv0eY7yv7e7GqMcfriA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=I2fipe0qQ0i740whNyZEI+x5SZYmRZBOagT2pIDrsTUE232PWNI71Wso+xMbpYCZInUcVBLcNoieML/vGyy4h2OuHT/NnZL0l8KDjyitay3V7NEdncnrhLB4eZmCw3dbOKynJkbxqk4fckNWltfDQ6ABqCETh3QEApRimBrc2nU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=2D31478W; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="2D31478W"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-436289a570eso31099295e9.0
        for <kvmarm@lists.linux.dev>; Mon, 16 Dec 2024 02:51:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1734346283; x=1734951083; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Cbd/uo+NO1CBjIio6qB3jbFJGmjwtAEiGWP4NC9yzL4=;
        b=2D31478W4YkUmmkChFOcp14lIMjKVXK6rhoGAf1a6qbTPrc//USuCq0hVbfrz1z9BZ
         8RjMowk1Ek9oTx4wDhG2C1tUKhDIpKDIlxQFJoezB7X5Layp0kFTLihe2P01GDb9qlOt
         ccG15/uUb3EhnHEEMWSxjp8qnOUfa4qBk6mKpC5pkG+pewQtci6E55ZFMVg098fJCXll
         XMbKQ+aN+tmuQt43v33JmSNdm25hFOC9Tq2NoClzmShRLw1d7GGd0ByYFrHS37/jF/ua
         d/D/jPF9u/0GDkuOtC8H2HiC6+ooCcAiNFjv2ALLh+/5ui24LlcL3aiojs8Ur5tiEX1n
         tRIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734346283; x=1734951083;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Cbd/uo+NO1CBjIio6qB3jbFJGmjwtAEiGWP4NC9yzL4=;
        b=fotUo0MpnoWWvKjUMfZJbDavVd+oAihuRno9MfAv6OerMTMF0OYm1R9hL7ycNrijtg
         zha/nsXsjvmzIlFOh47gsws92i/nM7d/Vgy1I1e1R+zpX0Rx+faoi1t8mBECt25nOmWa
         WYjDXV4ATiB76+XZ+ALlsubob6bclbflGAJ84nsdzD1Emtai6c9F5IbrDlvTSukH+trP
         tDZGhekxuIK2rBx/RJDvAZQhmXuqaGuhsa1tp7XMuMqDHFZP7MsdPduwSJ4SjhmvDWl5
         DAFBX66SO/O7NBuNFde68c/AwxdLiyRGBUvDGCJjzV0A/AnHWIjWOmc2T3iFHHyY6vdg
         FzEQ==
X-Gm-Message-State: AOJu0YyoDr+Yrr+oHyn/YNkfcbwUUgyg/vYn4ztmIK631DhYLZ5f0/zN
	QoDIZ3LHZaCAgvwtk060WZwAo0sJco1vnLXBTDfp4KD2DqeL55GxiTGSfoZPnAqknCW+SwumI7r
	epFJQTy9rLFAc3ru4Ya/QJ2loNr1fumPP7OutT7lkeWfsKXhfEvRUBErtHLQnsEC4wcLQ/cimh0
	VkUKETgXV+rp7/GuJbplVGtS0eCEI=
X-Google-Smtp-Source: AGHT+IEJ4se9RFNwrxdb4kqwAHewqStxP3HtVLIzrXCd8vP+LoN3FNPH/SD5mwMnyKMOV43HoFc4YOD9Cg==
X-Received: from wmqd1.prod.google.com ([2002:a05:600c:34c1:b0:434:fe2b:fea7])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:1da4:b0:434:f753:6012
 with SMTP id 5b1f17b1804b1-4362aa509abmr114661285e9.17.1734346283345; Mon, 16
 Dec 2024 02:51:23 -0800 (PST)
Date: Mon, 16 Dec 2024 10:50:52 +0000
In-Reply-To: <20241216105057.579031-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241216105057.579031-1-tabba@google.com>
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
Message-ID: <20241216105057.579031-13-tabba@google.com>
Subject: [PATCH v5 12/17] KVM: arm64: Calculate cptr_el2 traps on activating traps
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, james.clark@linaro.org, 
	will@kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, broonie@kernel.org, 
	qperret@google.com, kristina.martsenko@arm.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

Similar to VHE, calculate the value of cptr_el2 from scratch on
activate traps. This removes the need to store cptr_el2 in every
vcpu structure. Moreover, some traps, such as whether the guest
owns the fp registers, need to be set on every vcpu run.

Reported-by: James Clark <james.clark@linaro.org>
Fixes: 5294afdbf45a ("KVM: arm64: Exclude FP ownership from kvm_vcpu_arch")
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/include/asm/kvm_host.h |  1 -
 arch/arm64/kvm/arm.c              |  1 -
 arch/arm64/kvm/hyp/nvhe/pkvm.c    | 42 -------------------------
 arch/arm64/kvm/hyp/nvhe/switch.c  | 51 +++++++++++++++++++------------
 4 files changed, 32 insertions(+), 63 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 230b0638f0c2..69cb88c9ce3e 100644
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
index 21864d101230..956385ee4aa2 100644
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
index 7786a83d0fa8..0ebf84a9f9e2 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -35,33 +35,46 @@ DEFINE_PER_CPU(unsigned long, kvm_hyp_vector);
 
 extern void kvm_nvhe_prepare_backtrace(unsigned long fp, unsigned long pc);
 
-static void __activate_traps(struct kvm_vcpu *vcpu)
+static void __activate_cptr_traps(struct kvm_vcpu *vcpu)
 {
-	u64 val;
+	u64 val = CPTR_EL2_TAM;	/* Same bit irrespective of E2H */
 
-	___activate_traps(vcpu, vcpu->arch.hcr_el2);
-	__activate_traps_common(vcpu);
+	if (has_hvhe()) {
+		val |= CPACR_ELx_TTA;
 
-	val = vcpu->arch.cptr_el2;
-	val |= CPTR_EL2_TAM;	/* Same bit irrespective of E2H */
-	val |= has_hvhe() ? CPACR_EL1_TTA : CPTR_EL2_TTA;
-	if (cpus_have_final_cap(ARM64_SME)) {
-		if (has_hvhe())
-			val &= ~CPACR_ELx_SMEN;
-		else
-			val |= CPTR_EL2_TSM;
-	}
+		if (guest_owns_fp_regs()) {
+			val |= CPACR_ELx_FPEN;
+			if (vcpu_has_sve(vcpu))
+				val |= CPACR_ELx_ZEN;
+		}
+	} else {
+		val |= CPTR_EL2_TTA | CPTR_NVHE_EL2_RES1;
 
-	if (!guest_owns_fp_regs()) {
-		if (has_hvhe())
-			val &= ~(CPACR_ELx_FPEN | CPACR_ELx_ZEN);
-		else
-			val |= CPTR_EL2_TFP | CPTR_EL2_TZ;
+		/*
+		 * Always trap SME since it's not supported in KVM.
+		 * TSM is RES1 if SME isn't implemented.
+		 */
+		val |= CPTR_EL2_TSM;
 
-		__activate_traps_fpsimd32(vcpu);
+		if (!vcpu_has_sve(vcpu) || !guest_owns_fp_regs())
+			val |= CPTR_EL2_TZ;
+
+		if (!guest_owns_fp_regs())
+			val |= CPTR_EL2_TFP;
 	}
 
+	if (!guest_owns_fp_regs())
+		__activate_traps_fpsimd32(vcpu);
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
2.47.1.613.gc27f4b7a9f-goog

