Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 982742907
	for <kvmarm@lists.linux.dev>; Tue, 16 Apr 2024 09:57:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713261427; cv=none; b=B2EJaQWNkDWhfKv9Zrhpxvxnd6BVAugTeRSvhs7A2ZvQe0asB/H36jbaoS/j1Xjd9DQNLp2R4O7ezKaxlG+BNKZ6U0vPlARoJv/HANm8CaKRDymH7ZdkmARswZAu8obOBpQWd/xKeU2K+U9PofIQf+L4gUgexqamZoE4wBL4GPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713261427; c=relaxed/simple;
	bh=ZXg2PlxNJfZxKE7Zu3YJWmERCtQabXjTSztOY4h3esU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=bo07/5L1T3Y/nw55m3uD1jFMz975DZL/F4WxN+VrlHknRtPWlONOrbixAlpTrwWqLcSIUd2FjVSMhTKzEvGNTgCrctMKK3rJR6abbg2xhVkWMLivnNPmQFRi1BAmYDgV8rVQL6M2Y5E92JwGpAfOIw1phsd08Xq3Hv0Gn28IZn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=CcQlulkB; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="CcQlulkB"
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-dcc4563611cso6233133276.3
        for <kvmarm@lists.linux.dev>; Tue, 16 Apr 2024 02:57:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713261424; x=1713866224; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=oYwxp7rCyU3/ndHYm1axqaSYVKPAguzyKh22KkcYoyU=;
        b=CcQlulkBVSbP+w4xF5etbHVC1Tp69vOp+shx9cnpFfEOKHmgrNGYqSOT7YWTlQa2uc
         MmPhV9TMV4mSnAyuA8yYRZQgCIbtjbSsdHYhjrTfxcnfmfZBZBtOrrbclnph5sRxZPKq
         MtLr2cl6bx1qotF7OfSYKrduD6lS3dpK+lGalbs7J8uvAUqyWQFV/HDDSeNOfRnCRIyZ
         5Q0D07hsmcvsuvwU7MWAl34lu+O1lA+ua/6NUGuZzcu8ReOJIzSOydHNFxF1hfYS5/+O
         Ay2fARjorwddRVBzVpZn4OtdjS83oLhlrhaYSFLhrPwLuZfwdk5B9/aGciUo0eH7P33J
         LATQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713261424; x=1713866224;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oYwxp7rCyU3/ndHYm1axqaSYVKPAguzyKh22KkcYoyU=;
        b=SveW8RsIzMMCPDSikP0wUAcI9ImYIf+8eci8no0MzDOtom9RQqOaLafEj6820/CvXy
         hVAavwIotkPA6AE7jUyCMGmhkzgPacJgHxztNCf1yMZ/TlcavIl99xBq/OjvqKCzTAR/
         eebTyH9QH9TAz6/d3wzgUsQt9Ughbq3Jmg5uVd5A/b/uoiu+p4a/ns/ElYwvgmSFeimt
         Ly0VtK/isACvRhVi/oF0SfY1Cbhio+hglUsk+lD8+eFhlIwnv9tY5l6LTIRJigWow4RK
         thmWhc5UUfvYZIxtxTakEZpjjRE9a7uIRHhf91p98QihVNgeYAAxD7rp/poTNezpgmXz
         pVag==
X-Gm-Message-State: AOJu0YzTCK29ENDYH/JQn24IZKnt8I0W4QrLK0Xp3qlnTd61JaBJY7sR
	JEDQAiIr08CZ+1RmWUS1OGI0ZMeFN7EPIJapPzNTU5ht6A3YThTIZHb6g4LT5OqTh/AU3GzksuJ
	THoGvMxZ8PDZgp24QM8aL12cnc7CBxcUaqVc5nfC/jOR36muHI1S7uvkUmFGR6we9VTQ9mANcyR
	Z4a4KvWofStxTBDcb9ekoD0Tk53W0=
X-Google-Smtp-Source: AGHT+IHQpMUD5Ufg6ncR+DYXiz45XSjCbThNagxr5Qe2g02tE7dcE3XeENLHTpkqIaaAJdwjO/UfavK8ww==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a05:6902:1509:b0:dc2:398d:a671 with SMTP id
 q9-20020a056902150900b00dc2398da671mr3997758ybu.10.1713261424169; Tue, 16 Apr
 2024 02:57:04 -0700 (PDT)
Date: Tue, 16 Apr 2024 10:56:01 +0100
In-Reply-To: <20240416095638.3620345-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240416095638.3620345-1-tabba@google.com>
X-Mailer: git-send-email 2.44.0.683.g7961c838ac-goog
Message-ID: <20240416095638.3620345-11-tabba@google.com>
Subject: [PATCH v2 10/47] KVM: arm64: Support TLB invalidation in guest context
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev
Cc: maz@kernel.org, will@kernel.org, qperret@google.com, tabba@google.com, 
	seanjc@google.com, alexandru.elisei@arm.com, catalin.marinas@arm.com, 
	philmd@linaro.org, james.morse@arm.com, suzuki.poulose@arm.com, 
	oliver.upton@linux.dev, mark.rutland@arm.com, broonie@kernel.org, 
	joey.gouly@arm.com, rananta@google.com, smostafa@google.com
Content-Type: text/plain; charset="UTF-8"

From: Will Deacon <will@kernel.org>

Typically, TLB invalidation of guest stage-2 mappings using nVHE is
performed by a hypercall originating from the host. For the invalidation
instruction to be effective, therefore, __tlb_switch_to_{guest,host}()
swizzle the active stage-2 context around the TLBI instruction.

With guest-to-host memory sharing and unsharing hypercalls
originating from the guest under pKVM, there is need to support
both guest and host VMID invalidations issued from guest context.

Replace the __tlb_switch_to_{guest,host}() functions with a more general
{enter,exit}_vmid_context() implementation which supports being invoked
from guest context and acts as a no-op if the target context matches the
running context.

Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/hyp/nvhe/tlb.c | 115 +++++++++++++++++++++++++++-------
 1 file changed, 91 insertions(+), 24 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/tlb.c b/arch/arm64/kvm/hyp/nvhe/tlb.c
index 2fc68da4036d..ca3c09df8d7c 100644
--- a/arch/arm64/kvm/hyp/nvhe/tlb.c
+++ b/arch/arm64/kvm/hyp/nvhe/tlb.c
@@ -11,13 +11,23 @@
 #include <nvhe/mem_protect.h>
 
 struct tlb_inv_context {
-	u64		tcr;
+	struct kvm_s2_mmu	*mmu;
+	u64			tcr;
+	u64			sctlr;
 };
 
-static void __tlb_switch_to_guest(struct kvm_s2_mmu *mmu,
-				  struct tlb_inv_context *cxt,
-				  bool nsh)
+static void enter_vmid_context(struct kvm_s2_mmu *mmu,
+			       struct tlb_inv_context *cxt,
+			       bool nsh)
 {
+	struct kvm_s2_mmu *host_s2_mmu = &host_mmu.arch.mmu;
+	struct kvm_cpu_context *host_ctxt;
+	struct kvm_vcpu *vcpu;
+
+	host_ctxt = &this_cpu_ptr(&kvm_host_data)->host_ctxt;
+	vcpu = host_ctxt->__hyp_running_vcpu;
+	cxt->mmu = NULL;
+
 	/*
 	 * We have two requirements:
 	 *
@@ -40,20 +50,55 @@ static void __tlb_switch_to_guest(struct kvm_s2_mmu *mmu,
 	else
 		dsb(ish);
 
+	/*
+	 * If we're already in the desired context, then there's nothing to do.
+	 */
+	if (vcpu) {
+		/*
+		 * We're in guest context. However, for this to work, this needs
+		 * to be called from within __kvm_vcpu_run(), which ensures that
+		 * __hyp_running_vcpu is set to the current guest vcpu.
+		 */
+		if (mmu == vcpu->arch.hw_mmu || WARN_ON(mmu != host_s2_mmu))
+			return;
+
+		cxt->mmu = vcpu->arch.hw_mmu;
+	} else {
+		/* We're in host context. */
+		if (mmu == host_s2_mmu)
+			return;
+
+		cxt->mmu = host_s2_mmu;
+	}
+
 	if (cpus_have_final_cap(ARM64_WORKAROUND_SPECULATIVE_AT)) {
 		u64 val;
 
 		/*
 		 * For CPUs that are affected by ARM 1319367, we need to
-		 * avoid a host Stage-1 walk while we have the guest's
-		 * VMID set in the VTTBR in order to invalidate TLBs.
-		 * We're guaranteed that the S1 MMU is enabled, so we can
-		 * simply set the EPD bits to avoid any further TLB fill.
+		 * avoid a Stage-1 walk with the old VMID while we have
+		 * the new VMID set in the VTTBR in order to invalidate TLBs.
+		 * We're guaranteed that the host S1 MMU is enabled, so
+		 * we can simply set the EPD bits to avoid any further
+		 * TLB fill. For guests, we ensure that the S1 MMU is
+		 * temporarily enabled in the next context.
 		 */
 		val = cxt->tcr = read_sysreg_el1(SYS_TCR);
 		val |= TCR_EPD1_MASK | TCR_EPD0_MASK;
 		write_sysreg_el1(val, SYS_TCR);
 		isb();
+
+		if (vcpu) {
+			val = cxt->sctlr = read_sysreg_el1(SYS_SCTLR);
+			if (!(val & SCTLR_ELx_M)) {
+				val |= SCTLR_ELx_M;
+				write_sysreg_el1(val, SYS_SCTLR);
+				isb();
+			}
+		} else {
+			/* The host S1 MMU is always enabled. */
+			cxt->sctlr = SCTLR_ELx_M;
+		}
 	}
 
 	/*
@@ -62,18 +107,40 @@ static void __tlb_switch_to_guest(struct kvm_s2_mmu *mmu,
 	 * ensuring that we always have an ISB, but not two ISBs back
 	 * to back.
 	 */
-	__load_stage2(mmu, kern_hyp_va(mmu->arch));
+	if (vcpu)
+		__load_host_stage2();
+	else
+		__load_stage2(mmu, kern_hyp_va(mmu->arch));
+
 	asm(ALTERNATIVE("isb", "nop", ARM64_WORKAROUND_SPECULATIVE_AT));
 }
 
-static void __tlb_switch_to_host(struct tlb_inv_context *cxt)
+static void exit_vmid_context(struct tlb_inv_context *cxt)
 {
-	__load_host_stage2();
+	struct kvm_s2_mmu *mmu = cxt->mmu;
+	struct kvm_cpu_context *host_ctxt;
+	struct kvm_vcpu *vcpu;
+
+	host_ctxt = &this_cpu_ptr(&kvm_host_data)->host_ctxt;
+	vcpu = host_ctxt->__hyp_running_vcpu;
+
+	if (!mmu)
+		return;
+
+	if (vcpu)
+		__load_stage2(mmu, kern_hyp_va(mmu->arch));
+	else
+		__load_host_stage2();
 
 	if (cpus_have_final_cap(ARM64_WORKAROUND_SPECULATIVE_AT)) {
-		/* Ensure write of the host VMID */
+		/* Ensure write of the old VMID */
 		isb();
-		/* Restore the host's TCR_EL1 */
+
+		if (!(cxt->sctlr & SCTLR_ELx_M)) {
+			write_sysreg_el1(cxt->sctlr, SYS_SCTLR);
+			isb();
+		}
+
 		write_sysreg_el1(cxt->tcr, SYS_TCR);
 	}
 }
@@ -84,7 +151,7 @@ void __kvm_tlb_flush_vmid_ipa(struct kvm_s2_mmu *mmu,
 	struct tlb_inv_context cxt;
 
 	/* Switch to requested VMID */
-	__tlb_switch_to_guest(mmu, &cxt, false);
+	enter_vmid_context(mmu, &cxt, false);
 
 	/*
 	 * We could do so much better if we had the VA as well.
@@ -105,7 +172,7 @@ void __kvm_tlb_flush_vmid_ipa(struct kvm_s2_mmu *mmu,
 	dsb(ish);
 	isb();
 
-	__tlb_switch_to_host(&cxt);
+	exit_vmid_context(&cxt);
 }
 
 void __kvm_tlb_flush_vmid_ipa_nsh(struct kvm_s2_mmu *mmu,
@@ -114,7 +181,7 @@ void __kvm_tlb_flush_vmid_ipa_nsh(struct kvm_s2_mmu *mmu,
 	struct tlb_inv_context cxt;
 
 	/* Switch to requested VMID */
-	__tlb_switch_to_guest(mmu, &cxt, true);
+	enter_vmid_context(mmu, &cxt, true);
 
 	/*
 	 * We could do so much better if we had the VA as well.
@@ -135,7 +202,7 @@ void __kvm_tlb_flush_vmid_ipa_nsh(struct kvm_s2_mmu *mmu,
 	dsb(nsh);
 	isb();
 
-	__tlb_switch_to_host(&cxt);
+	exit_vmid_context(&cxt);
 }
 
 void __kvm_tlb_flush_vmid_range(struct kvm_s2_mmu *mmu,
@@ -152,7 +219,7 @@ void __kvm_tlb_flush_vmid_range(struct kvm_s2_mmu *mmu,
 	start = round_down(start, stride);
 
 	/* Switch to requested VMID */
-	__tlb_switch_to_guest(mmu, &cxt, false);
+	enter_vmid_context(mmu, &cxt, false);
 
 	__flush_s2_tlb_range_op(ipas2e1is, start, pages, stride,
 				TLBI_TTL_UNKNOWN);
@@ -162,7 +229,7 @@ void __kvm_tlb_flush_vmid_range(struct kvm_s2_mmu *mmu,
 	dsb(ish);
 	isb();
 
-	__tlb_switch_to_host(&cxt);
+	exit_vmid_context(&cxt);
 }
 
 void __kvm_tlb_flush_vmid(struct kvm_s2_mmu *mmu)
@@ -170,13 +237,13 @@ void __kvm_tlb_flush_vmid(struct kvm_s2_mmu *mmu)
 	struct tlb_inv_context cxt;
 
 	/* Switch to requested VMID */
-	__tlb_switch_to_guest(mmu, &cxt, false);
+	enter_vmid_context(mmu, &cxt, false);
 
 	__tlbi(vmalls12e1is);
 	dsb(ish);
 	isb();
 
-	__tlb_switch_to_host(&cxt);
+	exit_vmid_context(&cxt);
 }
 
 void __kvm_flush_cpu_context(struct kvm_s2_mmu *mmu)
@@ -184,19 +251,19 @@ void __kvm_flush_cpu_context(struct kvm_s2_mmu *mmu)
 	struct tlb_inv_context cxt;
 
 	/* Switch to requested VMID */
-	__tlb_switch_to_guest(mmu, &cxt, false);
+	enter_vmid_context(mmu, &cxt, false);
 
 	__tlbi(vmalle1);
 	asm volatile("ic iallu");
 	dsb(nsh);
 	isb();
 
-	__tlb_switch_to_host(&cxt);
+	exit_vmid_context(&cxt);
 }
 
 void __kvm_flush_vm_context(void)
 {
-	/* Same remark as in __tlb_switch_to_guest() */
+	/* Same remark as in enter_vmid_context() */
 	dsb(ish);
 	__tlbi(alle1is);
 	dsb(ish);
-- 
2.44.0.683.g7961c838ac-goog

