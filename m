Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C751198A11
	for <kvmarm@lists.linux.dev>; Thu, 28 Nov 2024 12:35:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732797341; cv=none; b=Xe7zHLBnBaOELc+SXgchxIg/A4dhcRNBBiFL1oiM+kjFIl+hfSZ6vx6UTYD+POI3JzQz7qXUe/K++Iuan1ShBKI5kaFZ4JCSivM+UfwqR9llJAmdwy3LvnN5hj35AHEADGb9qYx2O/PLqS0tp5lANQrgu6/jqHImyeezkB09gHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732797341; c=relaxed/simple;
	bh=mkBlhJKSwNQmi0ocDHJo+disZBZFnFwX/uiGo6fkOrI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=gcOjw+eEaVIy2sjC17i6bFP1Q19+yUhn5wNb+NjMRS0kgThw2gGxhw85CP++DCbhuekAfWmlp048+oJOdE8JSbrwKCUTORWi6ZuE2vGU2fPidoZFcvtsY7+LNUXDn72LVKw8KlIDYON7KgyQ6d69g8TyfxAmn7vE+SirlSozj5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=qCbEVnli; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qCbEVnli"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-434a6483514so5926235e9.0
        for <kvmarm@lists.linux.dev>; Thu, 28 Nov 2024 04:35:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732797338; x=1733402138; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=F/8DKR9VojN+CM/GyAHC15iuTbMv0usRa/8w1XuoQEo=;
        b=qCbEVnliOQs0arHF/v2mWWR662nhFsgM+OF39kr/G9f4EeWbgxMnlUAwnuOh7Bwzdx
         3YWpnvlo+eZsxcSspKMUN/ZlLMiM2zpLc7pfPB2wZv6kSZ0t+KW2EEHvZd3vuYVYjNCl
         F6FWXTN9Jr+AjglD/ha701SA7Uryy1JvIEo+8htU+YEJj5L3nry3HOIuLNYsgpLISK+r
         wskw+cM7beSEcRtl0IeiQ4aX4sQ5CKnqhRyXR+JSJQVXRkn2uPBl8uj0I5LklMasNLD2
         8yCKzb6DZmKeHiYjuVgPsdOxcS3zVJSnJS76z4O07anXdLJit1PUH4TS1rmxgPhVJEJI
         o3MA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732797338; x=1733402138;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=F/8DKR9VojN+CM/GyAHC15iuTbMv0usRa/8w1XuoQEo=;
        b=nUUd4BonxxvW34NYkws0GFiMQWbWmsLg3i71lccdBkreMr+hXOqU7WHuQQdoWamLhZ
         EtC95pdfg8UguZ59rZZqHl9DCG6w1EQg3+2HjW4JIYk+Oe8T03FiVXEBY3UNOnfFBxNR
         LT+v+roMJnS2AXYc1W8nUoOU+/RbxWAFYrsT5sHyZ3HXlQsxX0d1oHgbTgdcT71OX8kj
         i8FxZvQf5bfTCYXVTf/m12WDv1eONxYBH3nnIP35OxDcTWI9+LRAf/aKhhjN3ynDGX97
         LNPBafGFl57VI8oDSyk+zbsW4ohHUhLg4pe/HQZoQPqRoli8bpiCfdimCAsD98RoSgeH
         mUTA==
X-Gm-Message-State: AOJu0YxwUVge+gbkZ9KRssZww1tTAkxyJ9bWi9u75GDHvfQSLdygmGVw
	t/66C9n+tNKBWq5rKrbaO7lKyxKXOtsKI4drRLDVolVX+CiC4OGziVAwvxGh9g5arsM7nkDvRwI
	zbJq/xOiAlV4C2sE7vEgUj+eb5xJTdB3qtD+8SbYDkTaQUZt5nbzd82wSqPrbhYpUmjsQCMAG4d
	Y6f0pihQCKGeP6CY4woAkwO/Oa2d4=
X-Google-Smtp-Source: AGHT+IFPcc2J2Eu7ZPevLU68alNQpF7RWG0tNeIALz4NQ3zYV/MYUDazB4YkSCQM3ycygfMGbH5rolouQg==
X-Received: from wmpk22.prod.google.com ([2002:a05:600c:816:b0:434:a1da:32c5])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:5253:b0:434:9e1d:7629
 with SMTP id 5b1f17b1804b1-434a9e07911mr55116025e9.33.1732797337899; Thu, 28
 Nov 2024 04:35:37 -0800 (PST)
Date: Thu, 28 Nov 2024 12:35:10 +0000
In-Reply-To: <20241128123515.1709777-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241128123515.1709777-1-tabba@google.com>
X-Mailer: git-send-email 2.47.0.338.g60cca15819-goog
Message-ID: <20241128123515.1709777-11-tabba@google.com>
Subject: [PATCH v3 10/15] KVM: arm64: Calculate cptr_el2 traps on activating traps
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
2.47.0.338.g60cca15819-goog

