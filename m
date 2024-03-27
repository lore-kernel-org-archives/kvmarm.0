Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8E2514E2E4
	for <kvmarm@lists.linux.dev>; Wed, 27 Mar 2024 17:37:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711561047; cv=none; b=jgPkGdAcjTI66p1ycgTpYedM0OUMiah92v8SVS66rU2tj0oF2LfgSGh0vyBEgk1edpjaagucIjeGq62YZoOyYWXBgYMvbMgG8kXokUbp2L5AsDrIMqyh2xSSTdGVUq5Mr0jKNV5FdIhIDoF72mxkIlDP4f9Wxne07IYKIOiBINs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711561047; c=relaxed/simple;
	bh=2rU/rvkQDuWTIwv+WfvRZsw4DcspxfQlcef2QnaSDb8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=U49ZwA8tr5QflQZFM7VQtmnQk5G8w6P0VyOBCLOBdkSjRMfAIsaaoTR3+sm9EH50+U/zR5+XuADcNCXiv8xWi7DnqLc13PfS2+NGhODe3QloOZxGI1CGjmhsfCLz6RHaVcbZddp7QdrtSu74Ct1nyZSBCC3QlxDdI2mpPZkgea4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=PHnqlgER; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="PHnqlgER"
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-dc64f63d768so59823276.2
        for <kvmarm@lists.linux.dev>; Wed, 27 Mar 2024 10:37:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1711561045; x=1712165845; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=fZgG4cV6FqKgZ+NY8OaFvmJRipCruOaJlF4F/0McAYU=;
        b=PHnqlgERXzT0jBgrndnWGIgIY/BUl0l148Gs2b4buASM9aItIl8Bc5oe97aXcsHqPC
         7zJqhYkovPSocYI7z3cx8QGOfGnBgHBi04eeLx+EIpRk4D1ZBfZLfO1FeH0AwcuKKJtG
         EvXsEQPhOTx3+dwOmjPlWuH66rkiTvv7Rtmd8edNixy0K8zRe+RwRZf9AWhwgTaA7ASq
         vXCuR2Af253mfwfSq+0bpYSQD2tKlf+O7/hK6VNdfqkwryQG9sYhbscpucY5zk3sUpJX
         vJ4oBAl/Ya91uJC/YoN4WSVsTSp1KLVUbfzeCtNFwEsjH4+4dDf0AqjHsLMe3ZSYRQtN
         G67g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711561045; x=1712165845;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fZgG4cV6FqKgZ+NY8OaFvmJRipCruOaJlF4F/0McAYU=;
        b=LEIsbRRr28sF799gffbXJGHbgSFRn0SkPrg1I2TyCY4v+D8I4CbJpOenIsmh2U7EVb
         1T9SKrhQlZOz0Ol4I0MKedaBCZdCCTU36d4cB53Jq5AO64B+B/85HHecFkaY+yjhRnCc
         61BCb5+mERzOgiJFFOc2Pf4lX3Tw9rSZS2SnaXLyX/Nsw0aqRaoxJtWTSAr0gfDdYZwv
         AcZwEwJHQubVBO4Ie35UkFHHB+koQPpUFy08pA655ZVRlW3dZb/q59V6RabiV2YB0uMc
         NXpjkgYtcgX/KjyZ5kPcNabJ5u7tF1kCE+yBhsA7UMZh4ImZuTibwCZc4Bbr1Xp5rKf4
         SIFw==
X-Gm-Message-State: AOJu0YzljL8eU0lumBCeCqzZ7mPLTHavZFMPE+oxfjom9GlBtMhw+cT8
	vQgJypRrU7bbDW7hvSOJjHjScp+Tn2A1pHDkGpd3qyrpjg0rtIODLPCH5UNC4JbFwtcCaJUoFoz
	keQZzd/7vRUAcMF9+Xp9fqdppYIN+lzOg3V/NRIEpotrZvB4ZiEhbArczW2GJlB43vASa1pBHwK
	VStsS3pte2jbBTpf5ItZYACjXH7W8=
X-Google-Smtp-Source: AGHT+IGQiAj6iZLGb/1rkGaJ3PIWxWW0IYmqAl6CwZaP6vXLL5zUtiJJAo7O5xZW9tVQkEVH8h0bfoKrmw==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a05:6902:1009:b0:dc6:ff2b:7e1b with SMTP id
 w9-20020a056902100900b00dc6ff2b7e1bmr159122ybt.4.1711561044796; Wed, 27 Mar
 2024 10:37:24 -0700 (PDT)
Date: Wed, 27 Mar 2024 17:35:29 +0000
In-Reply-To: <20240327173531.1379685-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240327173531.1379685-1-tabba@google.com>
X-Mailer: git-send-email 2.44.0.478.gd926399ef9-goog
Message-ID: <20240327173531.1379685-43-tabba@google.com>
Subject: [PATCH v1 42/44] KVM: arm64: Fix initializing traps in protected mode
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev
Cc: maz@kernel.org, will@kernel.org, qperret@google.com, tabba@google.com, 
	seanjc@google.com, alexandru.elisei@arm.com, catalin.marinas@arm.com, 
	philmd@linaro.org, james.morse@arm.com, suzuki.poulose@arm.com, 
	oliver.upton@linux.dev, mark.rutland@arm.com, broonie@kernel.org, 
	joey.gouly@arm.com, rananta@google.com
Content-Type: text/plain; charset="UTF-8"

The values of the trapping registers for protected VMs should be
computed from the ground up, and not depend on potentially
preexisting values.

Moreover, non-protected VMs should not be restricted in protected
mode in the same manner as protected VMs.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/hyp/nvhe/pkvm.c | 48 +++++++++++++++++++++++-----------
 1 file changed, 33 insertions(+), 15 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index bc520f9f6d07..5693b431b310 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -179,19 +179,27 @@ static void pvm_init_traps_aa64mmfr1(struct kvm_vcpu *vcpu)
  */
 static void pvm_init_trap_regs(struct kvm_vcpu *vcpu)
 {
-	const u64 hcr_trap_feat_regs = HCR_TID3;
-	const u64 hcr_trap_impdef = HCR_TACR | HCR_TIDCP | HCR_TID1;
-
 	/*
 	 * Always trap:
 	 * - Feature id registers: to control features exposed to guests
 	 * - Implementation-defined features
 	 */
-	vcpu->arch.hcr_el2 |= hcr_trap_feat_regs | hcr_trap_impdef;
+	vcpu->arch.hcr_el2 = HCR_GUEST_FLAGS |
+			     HCR_TID3 | HCR_TACR | HCR_TIDCP | HCR_TID1;
+
+	if (cpus_have_final_cap(ARM64_HAS_RAS_EXTN)) {
+		/* route synchronous external abort exceptions to EL2 */
+		vcpu->arch.hcr_el2 |= HCR_TEA;
+		/* trap error record accesses */
+		vcpu->arch.hcr_el2 |= HCR_TERR;
+	}
+
+	if (cpus_have_final_cap(ARM64_HAS_STAGE2_FWB))
+		vcpu->arch.hcr_el2 |= HCR_FWB;
+
+	if (cpus_have_final_cap(ARM64_MISMATCHED_CACHE_TYPE))
+		vcpu->arch.hcr_el2 |= HCR_TID2;
 
-	/* Clear res0 and set res1 bits to trap potential new features. */
-	vcpu->arch.hcr_el2 &= ~(HCR_RES0);
-	vcpu->arch.mdcr_el2 &= ~(MDCR_EL2_RES0);
 	if (!has_hvhe()) {
 		vcpu->arch.cptr_el2 |= CPTR_NVHE_EL2_RES1;
 		vcpu->arch.cptr_el2 &= ~(CPTR_NVHE_EL2_RES0);
@@ -201,14 +209,24 @@ static void pvm_init_trap_regs(struct kvm_vcpu *vcpu)
 /*
  * Initialize trap register values in protected mode.
  */
-static void pkvm_vcpu_init_traps(struct kvm_vcpu *vcpu)
+static void pkvm_vcpu_init_traps(struct pkvm_hyp_vcpu *hyp_vcpu)
 {
-	pvm_init_trap_regs(vcpu);
-	pvm_init_traps_aa64pfr0(vcpu);
-	pvm_init_traps_aa64pfr1(vcpu);
-	pvm_init_traps_aa64dfr0(vcpu);
-	pvm_init_traps_aa64mmfr0(vcpu);
-	pvm_init_traps_aa64mmfr1(vcpu);
+	hyp_vcpu->vcpu.arch.cptr_el2 = kvm_get_reset_cptr_el2(&hyp_vcpu->vcpu);
+	hyp_vcpu->vcpu.arch.mdcr_el2 = 0;
+
+	if (!pkvm_hyp_vcpu_is_protected(hyp_vcpu)) {
+		u64 hcr = READ_ONCE(hyp_vcpu->host_vcpu->arch.hcr_el2);
+
+		hyp_vcpu->vcpu.arch.hcr_el2 = HCR_GUEST_FLAGS | hcr;
+		return;
+	}
+
+	pvm_init_trap_regs(&hyp_vcpu->vcpu);
+	pvm_init_traps_aa64pfr0(&hyp_vcpu->vcpu);
+	pvm_init_traps_aa64pfr1(&hyp_vcpu->vcpu);
+	pvm_init_traps_aa64dfr0(&hyp_vcpu->vcpu);
+	pvm_init_traps_aa64mmfr0(&hyp_vcpu->vcpu);
+	pvm_init_traps_aa64mmfr1(&hyp_vcpu->vcpu);
 }
 
 /*
@@ -333,7 +351,7 @@ static int init_pkvm_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu,
 	hyp_vcpu->vcpu.arch.hw_mmu = &hyp_vm->kvm.arch.mmu;
 	hyp_vcpu->vcpu.arch.cflags = READ_ONCE(host_vcpu->arch.cflags);
 
-	pkvm_vcpu_init_traps(&hyp_vcpu->vcpu);
+	pkvm_vcpu_init_traps(hyp_vcpu);
 done:
 	if (ret)
 		unpin_host_vcpu(host_vcpu);
-- 
2.44.0.478.gd926399ef9-goog

