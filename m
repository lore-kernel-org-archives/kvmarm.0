Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8DB01E1E01
	for <kvmarm@lists.linux.dev>; Wed, 26 Feb 2025 21:55:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740606928; cv=none; b=abXDHTqfpCiiEPJwytWrOy7zIH5iysT4Dbf8HxZhMJfkr2czKpQBORnItjKY1tt93xEcxhzD1O+Ce3PKjQwhwxaZPNFRDxYaTZMqPLh3RuW/YdMvuNlxH5E3g+ByodsuodfLJayc5+yaxKo3wTD3K6rimxdguJrpX8hAJ59eRSM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740606928; c=relaxed/simple;
	bh=dTGJXEGqyvih7AYaO0814xceTdvdB0k2puWiJupbvDg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=d4fUunblydelJxHm0sBRuSipfm/CXPJNGrXBEy1MEoH1MY5t5vmVrOb+6p+2O3R8l+kyIk7KqJ9+f+lgZHGY94NAR45CbBuNMLjb8w4BgEX5lxcVzfdmsPOp+iSc58F34/pdcavNz0iIT0Rd8oRB244Yok1ODEUgn0B3ov+9nNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=TI1ZVGcO; arc=none smtp.client-ip=209.85.221.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="TI1ZVGcO"
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-38f4156f3daso162018f8f.2
        for <kvmarm@lists.linux.dev>; Wed, 26 Feb 2025 13:55:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740606925; x=1741211725; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=YMoANj4p5EHkRVZCluw47mqWJPi0FfnC4TlDJfr4IcM=;
        b=TI1ZVGcOLghMwYjPJqcL88vQD6SYZb4jSy86R8V9+Hmm7wWSTHdz/0LoRIgJIpT8fr
         cI6LWtqZDE9VRGMX0VkuQxQiJeUIjdtZHXZT2Kgtha1aUxQ9vadKjn0Alc/ytvmvIgjo
         8c836ju6batkbZpB1eCXMY9k7CzUITyJ/QGBUnWgHeC/7P1SVQf4fsPJQspjJ8Dff32U
         c8QpjrVG4Sr/ISb1YbBTpeSyrNZEOUxfQj6WxJ2hjjhTx/6jFYV20JE/AKugwQVCewOJ
         rTyPjPfU2I9gLn2Ormr3/XKhhna5AfDdEBfYYTevjaS9vvsAsuFLg+iv7oCnHHP7Bbcx
         U/bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740606925; x=1741211725;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YMoANj4p5EHkRVZCluw47mqWJPi0FfnC4TlDJfr4IcM=;
        b=gMEHM/zavOWITI9Mk/3Slyx9uieXeRilbVq3mLIDRibwoI22MwRCX4rfl/Ky6bgHkx
         fN/U6lPJqr8g0JqCZw6DbccMgzw+YwmC69D2xMrEit3erSV906IYo/FbpcQoaiLw90Ap
         3RHA3T/wU8LdrzOKHBLb9KGOZun8tLriN7zNWJNoF4V39YOSrjzysdSnH10jdtiz+PfJ
         fsn0/SlfTD5gJcMc3b4GQI0rnboFGUQeGKyb0FHOpEn/zL0GQV3eZvuO0EgvvVA/na4x
         Ym96zstF/K9B0vXgW0tZ/hbrPnJEkDOLPqMqfJyDMz0LzAVVMmcd41VzaYP5iHVuNzQV
         4YoA==
X-Gm-Message-State: AOJu0YzVrHxrIBiQJxLhlM1UPduf4SXP0R3iJb+NpZ0Shj4Gkd5/6Z0v
	Vmfa3d/hRMwVUjnhoBVfWc0VhWjQvglOwbHYACltl1ijrftOBbZNZ2wlaoDpuLetxujXYAS5+xB
	acbiHGF5uYIzjNqpcqlucesB4ptzxN6rvqSeucD3Qk7RzypJrwZEbBEq+nrnp0oyok1jroqVDkx
	pFyrINqsm7G7h2vjcVpFf9eNpiLjg=
X-Google-Smtp-Source: AGHT+IEm+deGA2n4ENvCjeg0FnRMCCHXrVIT4UaweA5DEki0464Z4e8+WEQzh+GM4v+3iZ8npegFP/EaEw==
X-Received: from wroa1.prod.google.com ([2002:adf:ed01:0:b0:38f:3703:662f])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6000:1845:b0:390:d82d:6d4f
 with SMTP id ffacd0b85a97d-390d82d71cemr4013404f8f.52.1740606925196; Wed, 26
 Feb 2025 13:55:25 -0800 (PST)
Date: Wed, 26 Feb 2025 21:55:17 +0000
In-Reply-To: <20250226215520.1759218-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250226215520.1759218-1-tabba@google.com>
X-Mailer: git-send-email 2.48.1.711.g2feabab25a-goog
Message-ID: <20250226215520.1759218-2-tabba@google.com>
Subject: [PATCH v2 1/4] KVM: arm64: Factor out setting HCRX_EL2 traps into
 separate function
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, mark.rutland@arm.com, 
	will@kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, broonie@kernel.org, 
	qperret@google.com, vdonnefort@google.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

Factor out the code for setting a vcpu's HCRX_EL2 traps in to a
separate inline function. This allows us to share the logic with
pKVM when setting the traps in protected mode.

No functional change intended.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/include/asm/kvm_emulate.h | 24 ++++++++++++++++++++++++
 arch/arm64/kvm/sys_regs.c            | 20 +-------------------
 2 files changed, 25 insertions(+), 19 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index 78ec1ef2cfe8..31c8497372d0 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -649,4 +649,28 @@ static inline bool guest_hyp_sve_traps_enabled(const struct kvm_vcpu *vcpu)
 {
 	return __guest_hyp_cptr_xen_trap_enabled(vcpu, ZEN);
 }
+
+static inline void vcpu_set_hcrx(struct kvm_vcpu *vcpu)
+{
+	struct kvm *kvm = vcpu->kvm;
+
+	if (cpus_have_final_cap(ARM64_HAS_HCX)) {
+		/*
+		 * In general, all HCRX_EL2 bits are gated by a feature.
+		 * The only reason we can set SMPME without checking any
+		 * feature is that its effects are not directly observable
+		 * from the guest.
+		 */
+		vcpu->arch.hcrx_el2 = HCRX_EL2_SMPME;
+
+		if (kvm_has_feat(kvm, ID_AA64ISAR2_EL1, MOPS, IMP))
+			vcpu->arch.hcrx_el2 |= (HCRX_EL2_MSCEn | HCRX_EL2_MCE2);
+
+		if (kvm_has_tcr2(kvm))
+			vcpu->arch.hcrx_el2 |= HCRX_EL2_TCR2En;
+
+		if (kvm_has_fpmr(kvm))
+			vcpu->arch.hcrx_el2 |= HCRX_EL2_EnFPM;
+	}
+}
 #endif /* __ARM64_KVM_EMULATE_H__ */
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 82430c1e1dd0..16ce5f584e7c 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -4971,25 +4971,7 @@ void kvm_calculate_traps(struct kvm_vcpu *vcpu)
 	mutex_lock(&kvm->arch.config_lock);
 	vcpu_set_hcr(vcpu);
 	vcpu_set_ich_hcr(vcpu);
-
-	if (cpus_have_final_cap(ARM64_HAS_HCX)) {
-		/*
-		 * In general, all HCRX_EL2 bits are gated by a feature.
-		 * The only reason we can set SMPME without checking any
-		 * feature is that its effects are not directly observable
-		 * from the guest.
-		 */
-		vcpu->arch.hcrx_el2 = HCRX_EL2_SMPME;
-
-		if (kvm_has_feat(kvm, ID_AA64ISAR2_EL1, MOPS, IMP))
-			vcpu->arch.hcrx_el2 |= (HCRX_EL2_MSCEn | HCRX_EL2_MCE2);
-
-		if (kvm_has_tcr2(kvm))
-			vcpu->arch.hcrx_el2 |= HCRX_EL2_TCR2En;
-
-		if (kvm_has_fpmr(kvm))
-			vcpu->arch.hcrx_el2 |= HCRX_EL2_EnFPM;
-	}
+	vcpu_set_hcrx(vcpu);
 
 	if (test_bit(KVM_ARCH_FLAG_FGU_INITIALIZED, &kvm->arch.flags))
 		goto out;
-- 
2.48.1.711.g2feabab25a-goog

