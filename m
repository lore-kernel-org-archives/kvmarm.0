Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF561F4E2
	for <kvmarm@lists.linux.dev>; Wed, 27 Mar 2024 17:35:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711560953; cv=none; b=BOlkdhsaDUhE0vSTRWks5ojaPlhMERJApAnJhWr0ezk3wV3yrQ6K5XV7IIggzv7YT9WKUuXPsZS1bXdvzCzhLNTnmRIlhsLBOcwJhpbx1IioVir1yrSFYJzpfclEvbx+W5U60QDXWfldcQpiXElqzr6Ksxk/9T6zgKPuK1rJ65k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711560953; c=relaxed/simple;
	bh=i3ibqpIE+NefM7ew39vE55zGxk434nuYbFt4cMamINw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=rXDOYOFG60mIoLfnGJLEhmQk1OXkqczY62VxUYvKd8MuEwJPf6cj3MFHTBH0nrOIGTqjCaiQXe75O8zI0KCwEStVV8ELpvWXnmn6bs0gQD+gh96gqL+q/szDDBZJe92adA/Gc76yVFmY8TIrbSWRhlhENuWX4cySbR57NdzSO/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ET9eqb7s; arc=none smtp.client-ip=209.85.221.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ET9eqb7s"
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-33ed2555b61so3794431f8f.3
        for <kvmarm@lists.linux.dev>; Wed, 27 Mar 2024 10:35:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1711560950; x=1712165750; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Ju9tvoRMsxoVlb5DG8yq7HjzK0aDJAkqbcSOI3LYCiI=;
        b=ET9eqb7s49QIclxzXAMeuEHENop9EIVVKTQbvXnbgPsC//mQI2Obxs00KzATPB2Wkg
         h7YvTfVpigRvF4uY2RnlcOeYWg/GzGQhGX5Hj4jLnwAARaOuZelZF8NsnaDjUkio4WLF
         deurg3GB05NL59ZYBAv6JLzfLhffegkBMSxR0pttuufbqEirvuqw4uuRMa9f8RV6Y/lE
         q1BBvR4RjCAkDeBDAxIvnAoEVrKYWoTxia+EY2TjuKG0voHfcQiAEUVJWzb4dcyZaocW
         eTzT7B8Z2Ltyn5Bfu4kIL81B47f5LZG8ObVwaFnyKo45O+Syx8Yc4r8rC6iCbcm00wtW
         yhuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711560950; x=1712165750;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ju9tvoRMsxoVlb5DG8yq7HjzK0aDJAkqbcSOI3LYCiI=;
        b=hwn+w1JwEI0akWGUAAzUPCA1H3E0oGf6T6fV7Zcya+zP4BPtMWq9JHS6yGng+415zF
         OpPTEYEK1a+h0/HI0zkr1m3N0kU9zLsbGRYVftpOd6cWtbgjUKQT+HcSYwRUzrfH2Ls7
         cd69RHagMoNKuDhDSfvu3nJ52EeBhUxKDMS5vB3oi2FFVDSC8LaYjnsC7lUCHrQfvmkw
         cSvoA5BykMu3Co2/e0QI9edwACjoNctPIaiYy1z1+OKB10sChofqUnGnBu+0g3jq7hdZ
         XIvZHIjmY5iwTeVsKukRQyWLxa7KCG4WoOfRmEV78cuXi1qVX2Edt9TLSqN2ul9gW+0V
         TuZA==
X-Gm-Message-State: AOJu0YxugvZ5siydadfmHBjySXBItiA1QQasz6jMJE2us4zTMfZ/TFU2
	EDLxMfjdTWn2i5Jnt52u+wnKhVYF3G5T9ZzRk4t8CT8uEjussu5jT3/pEV6ckXeODhlb/n0ufjU
	VSZFPrqp/sp9PLb9jkieuzwFfefLPtqVkceSpeGJ2Ue+2SMKg6h99NkIXPE5dv3mrCpTEu3Q83y
	kmSG1WGy6hfwg2bP8w6dH7zET0jNU=
X-Google-Smtp-Source: AGHT+IEgBIjBAsiDB+EzYawlP4tFofiyEjLKNhkKjlMo9B0tNe1oTjfeD4QRtSLa0gZ1yi8lzcyksFVFWA==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:adf:9c87:0:b0:33e:d6e0:ccf9 with SMTP id
 d7-20020adf9c87000000b0033ed6e0ccf9mr28wre.10.1711560949781; Wed, 27 Mar 2024
 10:35:49 -0700 (PDT)
Date: Wed, 27 Mar 2024 17:34:54 +0000
In-Reply-To: <20240327173531.1379685-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240327173531.1379685-1-tabba@google.com>
X-Mailer: git-send-email 2.44.0.478.gd926399ef9-goog
Message-ID: <20240327173531.1379685-8-tabba@google.com>
Subject: [PATCH v1 07/44] KVM: arm64: Support TLB invalidation in guest context
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev
Cc: maz@kernel.org, will@kernel.org, qperret@google.com, tabba@google.com, 
	seanjc@google.com, alexandru.elisei@arm.com, catalin.marinas@arm.com, 
	philmd@linaro.org, james.morse@arm.com, suzuki.poulose@arm.com, 
	oliver.upton@linux.dev, mark.rutland@arm.com, broonie@kernel.org, 
	joey.gouly@arm.com, rananta@google.com
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
 arch/arm64/kvm/hyp/nvhe/tlb.c | 114 +++++++++++++++++++++++++++-------
 1 file changed, 90 insertions(+), 24 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/tlb.c b/arch/arm64/kvm/hyp/nvhe/tlb.c
index a60fb13e2192..05a66b2ed76d 100644
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
@@ -40,20 +50,52 @@ static void __tlb_switch_to_guest(struct kvm_s2_mmu *mmu,
 	else
 		dsb(ish);
 
+	/*
+	 * If we're already in the desired context, then there's nothing
+	 * to do.
+	 */
+	if (vcpu) {
+		/* We're in guest context */
+		if (mmu == vcpu->arch.hw_mmu || WARN_ON(mmu != host_s2_mmu))
+			return;
+
+		cxt->mmu = vcpu->arch.hw_mmu;
+	} else {
+		/* We're in host context */
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
@@ -62,20 +104,44 @@ static void __tlb_switch_to_guest(struct kvm_s2_mmu *mmu,
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
+
+	cxt->mmu = NULL;
 }
 
 void __kvm_tlb_flush_vmid_ipa(struct kvm_s2_mmu *mmu,
@@ -84,7 +150,7 @@ void __kvm_tlb_flush_vmid_ipa(struct kvm_s2_mmu *mmu,
 	struct tlb_inv_context cxt;
 
 	/* Switch to requested VMID */
-	__tlb_switch_to_guest(mmu, &cxt, false);
+	enter_vmid_context(mmu, &cxt, false);
 
 	/*
 	 * We could do so much better if we had the VA as well.
@@ -105,7 +171,7 @@ void __kvm_tlb_flush_vmid_ipa(struct kvm_s2_mmu *mmu,
 	dsb(ish);
 	isb();
 
-	__tlb_switch_to_host(&cxt);
+	exit_vmid_context(&cxt);
 }
 
 void __kvm_tlb_flush_vmid_ipa_nsh(struct kvm_s2_mmu *mmu,
@@ -114,7 +180,7 @@ void __kvm_tlb_flush_vmid_ipa_nsh(struct kvm_s2_mmu *mmu,
 	struct tlb_inv_context cxt;
 
 	/* Switch to requested VMID */
-	__tlb_switch_to_guest(mmu, &cxt, true);
+	enter_vmid_context(mmu, &cxt, true);
 
 	/*
 	 * We could do so much better if we had the VA as well.
@@ -135,7 +201,7 @@ void __kvm_tlb_flush_vmid_ipa_nsh(struct kvm_s2_mmu *mmu,
 	dsb(nsh);
 	isb();
 
-	__tlb_switch_to_host(&cxt);
+	exit_vmid_context(&cxt);
 }
 
 void __kvm_tlb_flush_vmid_range(struct kvm_s2_mmu *mmu,
@@ -152,7 +218,7 @@ void __kvm_tlb_flush_vmid_range(struct kvm_s2_mmu *mmu,
 	start = round_down(start, stride);
 
 	/* Switch to requested VMID */
-	__tlb_switch_to_guest(mmu, &cxt, false);
+	enter_vmid_context(mmu, &cxt, false);
 
 	__flush_s2_tlb_range_op(ipas2e1is, start, pages, stride, 0);
 
@@ -161,7 +227,7 @@ void __kvm_tlb_flush_vmid_range(struct kvm_s2_mmu *mmu,
 	dsb(ish);
 	isb();
 
-	__tlb_switch_to_host(&cxt);
+	exit_vmid_context(&cxt);
 }
 
 void __kvm_tlb_flush_vmid(struct kvm_s2_mmu *mmu)
@@ -169,13 +235,13 @@ void __kvm_tlb_flush_vmid(struct kvm_s2_mmu *mmu)
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
@@ -183,19 +249,19 @@ void __kvm_flush_cpu_context(struct kvm_s2_mmu *mmu)
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
2.44.0.478.gd926399ef9-goog

