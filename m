Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 157ED8664B
	for <kvmarm@lists.linux.dev>; Tue, 16 Apr 2024 09:58:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713261497; cv=none; b=n2lrGv41MkGAPElJU+iK+bFtUvGVofK0qJFSY0vscCYp4XjUk7V9x02YzachdmAZoGMf8NjEjLZYFXq6C/IQPf6YeB9i0pN56sPf0n5jtRmJWrhglHJ8XdqQWcUsU6at2UzsTRZngAoSOA6BvnsTFcWwt6OQzEH8E4jOQeB/ZKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713261497; c=relaxed/simple;
	bh=e3l5rdTVDaj/4jy6KQoqA037o/6ofgYIuG/8SBgpEm4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=UHtZUFuCRYFfrcjY70WJ0QdVo97UvCsfzV91KJPxkwWN+qWEkE83EaNzLonCgTaBdPFhOBalH0PszOLZSCInV0IQAceqR5JQlo9BC0JzSf1lp3hyFZXSstsc0Qeb8MDcWxYWSiFEw8XMa9kI9PRO3/xTCF7wz51yGGnxR723rx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Lh5vXcMw; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Lh5vXcMw"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-41681022d82so16506305e9.1
        for <kvmarm@lists.linux.dev>; Tue, 16 Apr 2024 02:58:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713261494; x=1713866294; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=I2zCjlKRW6RSDXouujCjjIvmHgxppJs7CTX8UCNE+4M=;
        b=Lh5vXcMwLczFxx9Xfx3iBggcA1zClCBzpBKJl5qp7eSXYAUjc7V6s2pUR6JJ9F41c4
         1kb75IcHcHl85o495aTSCxXTkCHmmU7Q/1+HfaE7aoWo/YT6k8HhOmcG6El1ldt0dC/e
         8J5nfkWmfKLRE9sewPhrnIqmgLajxU05v46Y8+oKbcu9aJAy03H/Oe7OdFkyFK8zHNWb
         DWaXvp3Y/e5laN10XBf0ItzXs47HXmIqbNlJa5nzr9VFZBmOZU5LVrJo6PWA+aQhd3hN
         fMJLh/mrcj1ca1QDBPHD0IwNFinUADHjMiFCZ2jMzcR9x97UYEoMdNBeOAnV9qVNzb8j
         pktg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713261494; x=1713866294;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=I2zCjlKRW6RSDXouujCjjIvmHgxppJs7CTX8UCNE+4M=;
        b=pZ2DLn8WMETLrMbMjzAXLdvDhN9dk00ltIv47k0mS509f0Zvo0niQHixe0EHyAi17G
         cXLlb33iYF+AXqA9xn8x6zSMo1RzaooWm12pMr4WPnWkJZlfUwIN8ZxuLyzyGB2ZRR+c
         3wSO/aqk6J1qBwalNJxxiG574NmNXpIQhw5GMvPu4N31t0lkptfxD2GUjltzCiKk8NbX
         LnByGJ284uApWi3KOWmChrCKCRispfhLw9Js48FJvD6uCD4jl6gItyAPLpByDq42tPQX
         ESV8j5qf8p0dsS4XcVWGJObpgKdHffeBNT7iLDn62wvBuyBQQYkL3srk4ofUNEB2Cm9V
         EgIA==
X-Gm-Message-State: AOJu0YzE1nQOH+lmPpXNCuf5l2E0L8nMVoG8VRhh/gdoTk3r6Jw7g5FH
	lr+hlaMbKIU6VFpGYXjg1Z6/Xy1SfsDLM/1bVj2sXaTAB52cWerMdpU7QqBmGg8pHlb9LzVsUDP
	og14RAo4QJ8SQ7Ho4CNb6yR0dJaQBU33wU/n+gOmHmJCQcTePF4O2FQtndrg4EKJocSIIBF/syq
	uh60wCsWtfRdDLYYRAaAwTJFSkaes=
X-Google-Smtp-Source: AGHT+IGoE4lLCCXKRVJ7U4JPesIVvzmf7hoOEDhGgMcUHNhLHLWxUqgj7+h87ZJkHM9MiaCP9BG+l/mfMw==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a05:600c:35d5:b0:414:843:3ac1 with SMTP id
 r21-20020a05600c35d500b0041408433ac1mr134683wmq.7.1713261494495; Tue, 16 Apr
 2024 02:58:14 -0700 (PDT)
Date: Tue, 16 Apr 2024 10:56:32 +0100
In-Reply-To: <20240416095638.3620345-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240416095638.3620345-1-tabba@google.com>
X-Mailer: git-send-email 2.44.0.683.g7961c838ac-goog
Message-ID: <20240416095638.3620345-42-tabba@google.com>
Subject: [PATCH v2 41/47] KVM: arm64: Fix initializing traps in protected mode
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev
Cc: maz@kernel.org, will@kernel.org, qperret@google.com, tabba@google.com, 
	seanjc@google.com, alexandru.elisei@arm.com, catalin.marinas@arm.com, 
	philmd@linaro.org, james.morse@arm.com, suzuki.poulose@arm.com, 
	oliver.upton@linux.dev, mark.rutland@arm.com, broonie@kernel.org, 
	joey.gouly@arm.com, rananta@google.com, smostafa@google.com
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
index 19d514c4ea2e..63d0bcd3a53a 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -187,19 +187,27 @@ static void pvm_init_traps_aa64mmfr1(struct kvm_vcpu *vcpu)
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
@@ -209,14 +217,24 @@ static void pvm_init_trap_regs(struct kvm_vcpu *vcpu)
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
@@ -351,7 +369,7 @@ static int init_pkvm_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu,
 	hyp_vcpu->vcpu.arch.hw_mmu = &hyp_vm->kvm.arch.mmu;
 	hyp_vcpu->vcpu.arch.cflags = READ_ONCE(host_vcpu->arch.cflags);
 
-	pkvm_vcpu_init_traps(&hyp_vcpu->vcpu);
+	pkvm_vcpu_init_traps(hyp_vcpu);
 done:
 	if (ret)
 		unpin_host_vcpu(host_vcpu);
-- 
2.44.0.683.g7961c838ac-goog

