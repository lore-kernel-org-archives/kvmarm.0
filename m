Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4398D13C687
	for <kvmarm@lists.linux.dev>; Tue, 23 Apr 2024 15:06:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713884766; cv=none; b=P1EpKI0cRQgAwAKF5thWHIntVitXH5lI+kYgMRgJr0giPU0Tt2df4pGoiW+oXXuxGfMlmZoSl2pBUt5DlFXBdUFTUk+kBBeNP8a/ihy8uD0uRlAL3sdjWMfhYDH124uIrzG1S3ijV+fs9XalH88r6hPvusfuTOsUTVKzOhPoBgU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713884766; c=relaxed/simple;
	bh=AyTHGhDgYKwIm1R6XGjmqmHM8aE8x9PLQTGcj+DxhDQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=sCKVE7b6Dn69xy0Ek5ZapSVD7xUz98T/gq339uT3d+DX0h+rPiyjkmYuvdZV8jZUMvQUCGGKMT4+iDEue7spJEZCjmOvbvYd5CwDUyyQD/F9gu6JwYwhqWIyyOBSUGAJBgQfhFDLIEbv7iy9so1B9WpEJnP7FRQ6DQD/GrQauy4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=oIfhYlLm; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="oIfhYlLm"
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-343d6732721so3597320f8f.2
        for <kvmarm@lists.linux.dev>; Tue, 23 Apr 2024 08:06:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713884761; x=1714489561; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=+57gbtltf2G7eWaOvuOveh7IKhMCfe4qtXMeZIFcBT4=;
        b=oIfhYlLmI9HOaQ0mU7hQhbvk/iw4rWK86GS//NOqxUKvNKKk2wJi6ZcaSaDAuFlPI9
         tyDTfPikd09bDaKXB/9/VPYmfzVtRIQw09McObI/6578eGz7+G0MZUA2rpufjXuR4F/h
         LNVaEXbnnMSBojy3Ml+dXSkAI8vQmso7W77JMHl8ZMm6SpBe4L+fgmfZ2uTvgIUMEtQL
         DlTWBT+e5afzndGXJLnfU7aqYH8DItLPKMt7/FRvak1L/Zv/woLjP+1fRganefp8oau9
         1YToVHN1fF6l3Pk5g0+m3pS2NwGFhOEAnv7PZCPKC3nX1LMd5HCUd25g3lsI2C6d/jfP
         J7NA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713884761; x=1714489561;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+57gbtltf2G7eWaOvuOveh7IKhMCfe4qtXMeZIFcBT4=;
        b=fxwOM6KONc3la0dByQp85pgo13afRJt+0C/oJ7V1SLDQiC9B84Rt4x/lNrSvk6Zz2b
         qtZfSRUoMPj56u4hZSqjkmR7FsdIjJU84ZBWVYPEkG1W7AcjTP6mlxVVFNmVgRiIK4G0
         187+FslxvN9KWiNKJPl1pgn9U6bfhu0mSwlBDOSq5NjaNVEg8OAk+IV1BicqtX/p3+Kt
         GQehF1fkeTEVhbrPBNOS601KMmMb81gzC2BeJFKuZVl5YR563bzeEw49dkI3m0xI+x8O
         76aGCz3cLlEmCLutd7k9I3tBomrqyQ8Syoj6xTn7KBHdIApTDGhhEwO9CAXJLMWIX/Hi
         3Ohw==
X-Gm-Message-State: AOJu0Yy5JThyymr5mF5mU7skzTaYv5WrrCnex+vR2CygjBF6HYDwPs2Z
	qMlQpNB+AsATnyz58IrF68+sX36idniMrVKcIXjEDaTU32qfXEI4iwRRlfRrnI0txqS2uP7h2ni
	f7vOfhegZGTzKUTcXJTYub4Qj6S21nz41DOlAn9bf7gU+yHkYEDnkAdgl+SM5cbaftxOstwUL3N
	eFGeP0nUpgzLovKtTH4abeJqykfck=
X-Google-Smtp-Source: AGHT+IGDPp17wZKC3ySg3oWhbH9DF+KquOOtn1GKyWv8R6ga9naNiXyfN+kqsGobmWrcoIw93vEYw/qTEw==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:adf:ea90:0:b0:34a:d53f:6a5c with SMTP id
 s16-20020adfea90000000b0034ad53f6a5cmr21362wrm.2.1713884761414; Tue, 23 Apr
 2024 08:06:01 -0700 (PDT)
Date: Tue, 23 Apr 2024 16:05:17 +0100
In-Reply-To: <20240423150538.2103045-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240423150538.2103045-1-tabba@google.com>
X-Mailer: git-send-email 2.44.0.769.g3c40516874-goog
Message-ID: <20240423150538.2103045-10-tabba@google.com>
Subject: [PATCH v4 09/30] KVM: arm64: Support TLB invalidation in guest context
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

