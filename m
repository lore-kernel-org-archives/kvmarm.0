Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 631203A1A8
	for <kvmarm@lists.linux.dev>; Fri, 19 Apr 2024 08:00:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713513607; cv=none; b=LeSNx5her1wAgbKD++jPFIWYK9y9LOodW3PJFVuOi+2AG8mJ9+Bc002GkBCY6rR11RIRQ/Z9O0DTkD5Y1Fo0J/hRhYZdwj/XY6HO6xGeXLRmCFkyw33TqRy8+YKCqH4jgpzLFyGpgPvioWKq2b08JWADpC0lGKn7nO53bLaRB5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713513607; c=relaxed/simple;
	bh=AyTHGhDgYKwIm1R6XGjmqmHM8aE8x9PLQTGcj+DxhDQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=SjnU4gRLKN+N3IsftKDaHaaqBXYCeUNAobPRni5YLFE7E5WJgcIs5DTSOuZZNlL31dhLcCApZbgtHt6LApiImxt9p49q4PzRHDnicNMxc2Bh3pV4S2amBkXrFD+ezNU6OIyOb3TKFVnwmATHKoCEBirHl0hnCHCl7eDiwvsncnI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=n4+0Qkw0; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="n4+0Qkw0"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-418f18458a0so6896105e9.0
        for <kvmarm@lists.linux.dev>; Fri, 19 Apr 2024 01:00:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713513604; x=1714118404; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=+57gbtltf2G7eWaOvuOveh7IKhMCfe4qtXMeZIFcBT4=;
        b=n4+0Qkw0/NryqLVRVQuX0epNcHGFcfDnrz+KE/B0xPAfDMfdhuWd3tjtWTzA1OVJpL
         EcayYiXPDzye8ithvh3J/xesiDBGXBM0Uav/bTozmtt2NPgAB2FSVbbw3td+91W4pNyi
         qX/cHJv28rlgnvho9PxEF+mweGaH2kUbKiUSqo8a4jc6Yl02NXEQSGMp+MThKbKeSlob
         XMHahhNF7XbQRYxzvsMK0YuKIm/BL6EPBzaAfFYCOCGA4B82nnQ7Z4maTZ3oTcRm7zb1
         1jxQezOE/DVNi5XkQrJWs0jXCIWWFxUJZP6bCbJ8Kyb3mcR0yIBnnNp12sXwfAHtgzts
         ASDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713513604; x=1714118404;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+57gbtltf2G7eWaOvuOveh7IKhMCfe4qtXMeZIFcBT4=;
        b=nNrKZz3VAshIrmkGOusWyvyWuwKKdhXxGkHtk3EHq/stQnVlQ6pf19ZaFq7LsGXKHB
         Y3DVPUHanKWfcElGMzb+uVfUgoUuh9SO8zwLU5UeGJ+SuRF5j+hya+UzekbLzRXu2m2O
         Q7hbbCbNprpW36eEZiKKHWYKxZFzsowzcay6iV1xHdDBu8DR34YCyF8JzjJBStVmgv1z
         ztIXwmZCRjOS+wWFWwM+vbNcY8wVUgBLRBQQ6EHasBPfIhRGpef32Vm/BgPKCZWDQE8R
         zlyvtaUUyMeOLS4s3Isah4ksUlmB3eKrHbce2SUAYWZUMC3vScUklMt7mIBxo1Lv4g3F
         71nA==
X-Gm-Message-State: AOJu0YyRBob8zVO1jVJIKig9Qlak4evbcDK8NFzr01EV7YPh4RBRClAF
	HIIGGxh8miq+e2Mb1SygPeZrlGW6ognjEo3hAm/MJF8c+T5D30f5PjJjd1b3pXg69UuRNJe0AXb
	X7UzCopGGYU1RFu2r29P2YdQvdaSka+8lM6rUxOHO2xqSntRJVnU97fhfdHPC2mhlh0KaawFcrN
	24jzkjJeY2SJ6XmHvUSvQoX2U2Qj0=
X-Google-Smtp-Source: AGHT+IH/6ul3vtEbp8Zg4sKkEM/3R11TtsUAcCvSLqCfdkW/pzwJ7t51+ufoUWCLY+LARlcszLaeCrkifw==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a05:600c:5122:b0:418:9fb1:fba9 with SMTP id
 o34-20020a05600c512200b004189fb1fba9mr4627wms.8.1713513603598; Fri, 19 Apr
 2024 01:00:03 -0700 (PDT)
Date: Fri, 19 Apr 2024 08:59:19 +0100
In-Reply-To: <20240419075941.4085061-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240419075941.4085061-1-tabba@google.com>
X-Mailer: git-send-email 2.44.0.769.g3c40516874-goog
Message-ID: <20240419075941.4085061-10-tabba@google.com>
Subject: [PATCH v3 09/31] KVM: arm64: Support TLB invalidation in guest context
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
2.44.0.769.g3c40516874-goog

