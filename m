Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4268913C800
	for <kvmarm@lists.linux.dev>; Tue, 23 Apr 2024 15:06:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713884766; cv=none; b=WBIIkC4+34z+JV7EGd0J2kFmvsAT9i7b07Lege3+ycxheucKY0JdSTKwsmlPetfxFXaPKy4Px5mSmQih3zdpxTOeiwo2BJPdfFb+iZG1P1tKxUI5wAVAkhhFnMLC1coSzn227tJtlDhLYQu/spnaclBkotbbsPPXEwRZeLSiEnk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713884766; c=relaxed/simple;
	bh=ZhcT3hrioUyZP/7shsfJ+pBmKUDF+gm1TlAJBHBaoa8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=gqGPN0lWDuwZHd9f/o+nHYPil5pXvaUzsBTaT+Jqzs2w0JJ5sDzwQs6xVg7CbNjtrp66aJpJt1tGB/byf0fTSR4RGNetI4gOHovjJTOphEJ8jCAEYCY9HJmOIyVbqQSh6ZqV7tK1ozs2FCY1mE1vurUHBHkyw/y1+aMpJl+OyJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=1JvhVHYx; arc=none smtp.client-ip=209.85.221.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="1JvhVHYx"
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-343e54fc19bso4032797f8f.2
        for <kvmarm@lists.linux.dev>; Tue, 23 Apr 2024 08:06:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713884763; x=1714489563; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=KP3IXJiz9t6LqRntHs3hTl+RolGyLk0E3su4dXkPQtc=;
        b=1JvhVHYxExWcWE+OWbQjLt7GMRyhnf7h+UaBiG6whffR5nDieHrvlDSraWxdukMeTC
         7yikPG/Xz2WhHrX+DyHlJ8VMLJeFCgZKhnyJVa0FA7DX6kVdBIrpIgafjlOW8GGN67gC
         A/TMsnTT7fL7+lWSDabY3F17WYojPf4KMLjsv2mGxgTERmoG5GOayXYp9YXyXBFa1Y4k
         YJalKH7Z1QHgBZR+cD3staRSb7P5iLkIXWjx1ZSRWrTvOaxCntEWEfYNcXTWK7MD92SI
         iqg7r7OG1/C6EBIdJpaFJ4i+kk0yIsejqCAxRzhMxS1brnwcZrRUddPsdQdo50JZKMUe
         ZT7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713884763; x=1714489563;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KP3IXJiz9t6LqRntHs3hTl+RolGyLk0E3su4dXkPQtc=;
        b=puUssyymzFDz3YYGOCH3s1DOPBOzLIQgRqcxz7eBSWmFr69tv8PkfMCxZNiQeMgbNV
         YZFPj+Dlj+GVM29TCK0ggO39OJ1av8hYTJkcUGZcsiwo4vSZgDg7D6BxE1kusU/HcPHt
         uk9+YV+CVqtvC64hL90KIUtuTMOKUogHewnJ3iCd9glhMEjz32HC5cpT0q14/rrmFVCm
         KNfon0AbL8JovysCIWfrLmSDKUVVReX0yH6IjNcNv+GZF2wVn2vV46X8vBLXgdijHT25
         1acXwGxSEThNeidUhuLQG4AdMsNAb/AvXheSuwFZbRHEHnP71hOL0dH/pVYe9+Ogvhsc
         5Pbg==
X-Gm-Message-State: AOJu0YxXxQhV9A8/IxzKbV8gqlyIdDdq4hRVeDf4GKOKk+ze7odl+qrK
	ttihZaHVi0bS2qeYT6T9Rln33A0rUx+EuEqOsvRW8BC13fWfbMgbiVqeSrV8cuX6Y4c5FWeBwYA
	eCw4FdS4gZRtVF7iCMYDelw9CPAu+/VxLKyRGwlcvPMdKCZGqdEstPnrHf0+4m2dXkn2g/uRIjK
	0SaBOWbtxg74P2rMnN0VNWtaAXVyM=
X-Google-Smtp-Source: AGHT+IEinVQI+oDuvAnR/KRvN2cgpwZx5Ec95UvXrR5U32N6Ou62sxzlmv1QjZDPF2IdeJJWJ9RisTruDQ==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a5d:4402:0:b0:349:ba19:6e4d with SMTP id
 z2-20020a5d4402000000b00349ba196e4dmr28826wrq.7.1713884763578; Tue, 23 Apr
 2024 08:06:03 -0700 (PDT)
Date: Tue, 23 Apr 2024 16:05:18 +0100
In-Reply-To: <20240423150538.2103045-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240423150538.2103045-1-tabba@google.com>
X-Mailer: git-send-email 2.44.0.769.g3c40516874-goog
Message-ID: <20240423150538.2103045-11-tabba@google.com>
Subject: [PATCH v4 10/30] KVM: arm64: Rename __tlb_switch_to_{guest,host}() in VHE
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev
Cc: maz@kernel.org, will@kernel.org, qperret@google.com, tabba@google.com, 
	seanjc@google.com, alexandru.elisei@arm.com, catalin.marinas@arm.com, 
	philmd@linaro.org, james.morse@arm.com, suzuki.poulose@arm.com, 
	oliver.upton@linux.dev, mark.rutland@arm.com, broonie@kernel.org, 
	joey.gouly@arm.com, rananta@google.com, smostafa@google.com
Content-Type: text/plain; charset="UTF-8"

Rename __tlb_switch_to_{guest,host}() to
{enter,exit}_vmid_context() in VHE code to maintain symmetry
between the nVHE and VHE TLB invalidations.

No functional change intended.

Suggested-by: Oliver Upton <oliver.upton@linux.dev>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/hyp/vhe/tlb.c | 26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/arch/arm64/kvm/hyp/vhe/tlb.c b/arch/arm64/kvm/hyp/vhe/tlb.c
index 1a60b95381e8..5fa0359f3a87 100644
--- a/arch/arm64/kvm/hyp/vhe/tlb.c
+++ b/arch/arm64/kvm/hyp/vhe/tlb.c
@@ -17,8 +17,8 @@ struct tlb_inv_context {
 	u64			sctlr;
 };
 
-static void __tlb_switch_to_guest(struct kvm_s2_mmu *mmu,
-				  struct tlb_inv_context *cxt)
+static void enter_vmid_context(struct kvm_s2_mmu *mmu,
+			       struct tlb_inv_context *cxt)
 {
 	struct kvm_vcpu *vcpu = kvm_get_running_vcpu();
 	u64 val;
@@ -67,7 +67,7 @@ static void __tlb_switch_to_guest(struct kvm_s2_mmu *mmu,
 	isb();
 }
 
-static void __tlb_switch_to_host(struct tlb_inv_context *cxt)
+static void exit_vmid_context(struct tlb_inv_context *cxt)
 {
 	/*
 	 * We're done with the TLB operation, let's restore the host's
@@ -97,7 +97,7 @@ void __kvm_tlb_flush_vmid_ipa(struct kvm_s2_mmu *mmu,
 	dsb(ishst);
 
 	/* Switch to requested VMID */
-	__tlb_switch_to_guest(mmu, &cxt);
+	enter_vmid_context(mmu, &cxt);
 
 	/*
 	 * We could do so much better if we had the VA as well.
@@ -118,7 +118,7 @@ void __kvm_tlb_flush_vmid_ipa(struct kvm_s2_mmu *mmu,
 	dsb(ish);
 	isb();
 
-	__tlb_switch_to_host(&cxt);
+	exit_vmid_context(&cxt);
 }
 
 void __kvm_tlb_flush_vmid_ipa_nsh(struct kvm_s2_mmu *mmu,
@@ -129,7 +129,7 @@ void __kvm_tlb_flush_vmid_ipa_nsh(struct kvm_s2_mmu *mmu,
 	dsb(nshst);
 
 	/* Switch to requested VMID */
-	__tlb_switch_to_guest(mmu, &cxt);
+	enter_vmid_context(mmu, &cxt);
 
 	/*
 	 * We could do so much better if we had the VA as well.
@@ -150,7 +150,7 @@ void __kvm_tlb_flush_vmid_ipa_nsh(struct kvm_s2_mmu *mmu,
 	dsb(nsh);
 	isb();
 
-	__tlb_switch_to_host(&cxt);
+	exit_vmid_context(&cxt);
 }
 
 void __kvm_tlb_flush_vmid_range(struct kvm_s2_mmu *mmu,
@@ -169,7 +169,7 @@ void __kvm_tlb_flush_vmid_range(struct kvm_s2_mmu *mmu,
 	dsb(ishst);
 
 	/* Switch to requested VMID */
-	__tlb_switch_to_guest(mmu, &cxt);
+	enter_vmid_context(mmu, &cxt);
 
 	__flush_s2_tlb_range_op(ipas2e1is, start, pages, stride,
 				TLBI_TTL_UNKNOWN);
@@ -179,7 +179,7 @@ void __kvm_tlb_flush_vmid_range(struct kvm_s2_mmu *mmu,
 	dsb(ish);
 	isb();
 
-	__tlb_switch_to_host(&cxt);
+	exit_vmid_context(&cxt);
 }
 
 void __kvm_tlb_flush_vmid(struct kvm_s2_mmu *mmu)
@@ -189,13 +189,13 @@ void __kvm_tlb_flush_vmid(struct kvm_s2_mmu *mmu)
 	dsb(ishst);
 
 	/* Switch to requested VMID */
-	__tlb_switch_to_guest(mmu, &cxt);
+	enter_vmid_context(mmu, &cxt);
 
 	__tlbi(vmalls12e1is);
 	dsb(ish);
 	isb();
 
-	__tlb_switch_to_host(&cxt);
+	exit_vmid_context(&cxt);
 }
 
 void __kvm_flush_cpu_context(struct kvm_s2_mmu *mmu)
@@ -203,14 +203,14 @@ void __kvm_flush_cpu_context(struct kvm_s2_mmu *mmu)
 	struct tlb_inv_context cxt;
 
 	/* Switch to requested VMID */
-	__tlb_switch_to_guest(mmu, &cxt);
+	enter_vmid_context(mmu, &cxt);
 
 	__tlbi(vmalle1);
 	asm volatile("ic iallu");
 	dsb(nsh);
 	isb();
 
-	__tlb_switch_to_host(&cxt);
+	exit_vmid_context(&cxt);
 }
 
 void __kvm_flush_vm_context(void)
-- 
2.44.0.769.g3c40516874-goog

