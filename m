Received: from mail-oi1-f202.google.com (mail-oi1-f202.google.com [209.85.167.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A91A3BB126
	for <kvmarm@lists.linux.dev>; Wed,  1 Jul 2026 20:43:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782938630; cv=none; b=lTcVBzUHguybDKu4QARfqj0A0RARgwk73eW/w28Kyzfnhda6sH8wHuAnYen0VFM3s64JQ8iEddFh3Hk7YAItUBS/r0BOVH9jwdc52Wy3eaYPX+c4iZ6Gj2Hi37r4yfNmzj2ooLSh1JNYNYHFRAuksFQ/N+KVQYedlfDeE0XJ7v0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782938630; c=relaxed/simple;
	bh=o3KE/c4h20q430m4u503sTesvQ9Ro+QbUhfL64h7kLk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=u2FbsSnQ+t4uVVfvAcfW3QE+9kiUStydST/VrfgldRd4u3Uigu7lfFneVnUd4+mhXU/IQusBryLO6vAsAhtulhL+P7NnRk/VWQF6iGl0RNHRdrL3XUErcjZZmoB/1oKd9o0iLBOGhgI5mp8b/9uDlmwgn3ma38B7rx8U0uaTA4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=b4rUUDjg; arc=none smtp.client-ip=209.85.167.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="b4rUUDjg"
Received: by mail-oi1-f202.google.com with SMTP id 5614622812f47-495f7693e7dso1557270b6e.0
        for <kvmarm@lists.linux.dev>; Wed, 01 Jul 2026 13:43:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782938627; x=1783543427; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=tFUa7znH4M21s1U2YoShafNp4F1ZnEDYd6H2bCRg/JI=;
        b=b4rUUDjg4pYEUsiT4rWbPrCZhsIVWcq5nCgi2J44RN0WT1gHvWsF+kw/75e6fHAL5+
         lR7ebMsNDmoHAf7PL67YKhWsrlUuBm/bInsztCbpcFoSJpik9h+sBtdB4x4xBU4OAuMj
         htB1Zvy5AZNFN9tg98vuZLlP7X7BCUNNyINvam/T++jHUlJrq9Zt7v9CcLzGsOvywE3k
         VsR7+gWhUgEzZ2g+b0egpTHiQLMFFt0acKTW6TuOVTRubl1ewIwOBiw5qAzRmLf/BI5P
         cQFvNQnVFmT90HgIoAzU7vpxHkgRnL4Q9oQ7/6viRyDMwfLzT3kZ0Vefj9yyTkPs3p2N
         AdkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782938627; x=1783543427;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tFUa7znH4M21s1U2YoShafNp4F1ZnEDYd6H2bCRg/JI=;
        b=YZ6IzFRjcDTy6xrQxUkMnRxnEqJfxbgeGgCa2OxH3cKUf8JPs7t6en0KihYRpfoNir
         /sfzFkmaEcFpbZyPKeFWnHBNPg1gsL+tuihx1KmwQ1CKMCTcsib4NQOLVyDxoRZ9dcyo
         IOduxRViZk4KCkpGhQywVGNkQuJZvg9Wn5Q7uQ+4/3F+agiWkoffc7agMhCformDSNWK
         e8WzGrflqerYoegjfy9wNHYJeKM8/rViQ25M5P/jlzSwD/BzB8rP8owrpjPTtgabOyIh
         KexUn5w1DmBiznj/v+XveXbC+zzkqCGvQxnz+iheHLqZyJkQWIrjpIKpvKzBTVFbAJYi
         q0OA==
X-Forwarded-Encrypted: i=1; AFNElJ9BmlfLt/Ssyz8YGZO8hLnjzw4H48pWF/cagqWFS31247W1OmeFMVzDnr4iCblBcf4V/Iugg/E=@lists.linux.dev
X-Gm-Message-State: AOJu0YytEz7Tm5ISaLO/zZY4ITM4FCBcmmrKjb3kusaiQAunAeLS0Yu6
	AqHDARA4zQ5bBbAZD3+G0R7YfTDJScG6DhCRZapnBLsT/9kkm029DTjxoRPKiqbX0+Zsr1PCTZr
	/yL1n91ErAxwah8Geow72Hb3EIA==
X-Received: from ilb3-n1.prod.google.com ([2002:a05:6e02:5303:10b0:503:bd20:d827])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6808:c3ee:b0:495:ca1b:7865 with SMTP id 5614622812f47-495f502375fmr5855417b6e.11.1782938626972;
 Wed, 01 Jul 2026 13:43:46 -0700 (PDT)
Date: Wed,  1 Jul 2026 20:43:41 +0000
In-Reply-To: <20260701204342.2654385-1-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260701204342.2654385-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.55.0.rc2.803.g1fd1e6609c-goog
Message-ID: <20260701204342.2654385-5-coltonlewis@google.com>
Subject: [PATCH 4/5] KVM: arm64: Initialize HCR_EL2.E2H early
From: Colton Lewis <coltonlewis@google.com>
To: stable@vger.kernel.org
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Mingwei Zhang <mizhang@google.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, Mark Rutland <mark.rutland@arm.com>, 
	Ahmed Genidi <ahmed.genidi@arm.com>, Ben Horgan <ben.horgan@arm.com>, Leo Yan <leo.yan@arm.com>
Content-Type: text/plain; charset="UTF-8"

From: Mark Rutland <mark.rutland@arm.com>

[ Upstream commit 7a68b55ff39b0d2dcd92ee241b12b23a7e03c621 ]

On CPUs without FEAT_E2H0, HCR_EL2.E2H is RES1, but may reset to an
UNKNOWN value out of reset and consequently may not read as 1 unless it
has been explicitly initialized.

We handled this for the head.S boot code in commits:

  3944382fa6f22b54 ("arm64: Treat HCR_EL2.E2H as RES1 when ID_AA64MMFR4_EL1.E2H0 is negative")
  b3320142f3db9b3f ("arm64: Fix early handling of FEAT_E2H0 not being implemented")

Unfortunately, we forgot to apply a similar fix to the KVM PSCI entry
points used when relaying CPU_ON, CPU_SUSPEND, and SYSTEM SUSPEND. When
KVM is entered via these entry points, the value of HCR_EL2.E2H may be
consumed before it has been initialized (e.g. by the 'init_el2_state'
macro).

Initialize HCR_EL2.E2H early in these paths such that it can be consumed
reliably. The existing code in head.S is factored out into a new
'init_el2_hcr' macro, and this is used in the __kvm_hyp_init_cpu()
function common to all the relevant PSCI entry points.

For clarity, I've tweaked the assembly used to check whether
ID_AA64MMFR4_EL1.E2H0 is negative. The bitfield is extracted as a signed
value, and this is checked with a signed-greater-or-equal (GE) comparison.

As the hyp code will reconfigure HCR_EL2 later in ___kvm_hyp_init(), all
bits other than E2H are initialized to zero in __kvm_hyp_init_cpu().

Fixes: 3944382fa6f22b54 ("arm64: Treat HCR_EL2.E2H as RES1 when ID_AA64MMFR4_EL1.E2H0 is negative")
Fixes: b3320142f3db9b3f ("arm64: Fix early handling of FEAT_E2H0 not being implemented")
Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: Ahmed Genidi <ahmed.genidi@arm.com>
Cc: Ben Horgan <ben.horgan@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Leo Yan <leo.yan@arm.com>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>
Cc: Will Deacon <will@kernel.org>
Link: https://lore.kernel.org/r/20250227180526.1204723-2-mark.rutland@arm.com
[maz: fixed LT->GE thinko]
Signed-off-by: Marc Zyngier <maz@kernel.org>

[ Backport: Resolved conflict in arch/arm64/kvm/hyp/nvhe/hyp-init.S
  by extracting EL2 state initialization into __kvm_init_el2_state
  and calling it after HCR setup. ]
---
 arch/arm64/include/asm/el2_setup.h | 26 ++++++++++++++++++++++++++
 arch/arm64/kernel/head.S           | 19 +------------------
 arch/arm64/kvm/hyp/nvhe/hyp-init.S | 16 +++++++++++++---
 3 files changed, 40 insertions(+), 21 deletions(-)

diff --git a/arch/arm64/include/asm/el2_setup.h b/arch/arm64/include/asm/el2_setup.h
index b7afaa026842b..3498dc5d02c18 100644
--- a/arch/arm64/include/asm/el2_setup.h
+++ b/arch/arm64/include/asm/el2_setup.h
@@ -16,6 +16,32 @@
 #include <asm/sysreg.h>
 #include <linux/irqchip/arm-gic-v3.h>
 
+.macro init_el2_hcr	val
+	mov_q	x0, \val
+
+	/*
+	 * Compliant CPUs advertise their VHE-onlyness with
+	 * ID_AA64MMFR4_EL1.E2H0 < 0. On such CPUs HCR_EL2.E2H is RES1, but it
+	 * can reset into an UNKNOWN state and might not read as 1 until it has
+	 * been initialized explicitly.
+	 *
+	 * Fruity CPUs seem to have HCR_EL2.E2H set to RAO/WI, but
+	 * don't advertise it (they predate this relaxation).
+	 *
+	 * Initalize HCR_EL2.E2H so that later code can rely upon HCR_EL2.E2H
+	 * indicating whether the CPU is running in E2H mode.
+	 */
+	mrs_s	x1, SYS_ID_AA64MMFR4_EL1
+	sbfx	x1, x1, #ID_AA64MMFR4_EL1_E2H0_SHIFT, #ID_AA64MMFR4_EL1_E2H0_WIDTH
+	cmp	x1, #0
+	b.ge	.LnVHE_\@
+
+	orr	x0, x0, #HCR_E2H
+.LnVHE_\@:
+	msr	hcr_el2, x0
+	isb
+.endm
+
 .macro __init_el2_sctlr
 	mov_q	x0, INIT_SCTLR_EL2_MMU_OFF
 	msr	sctlr_el2, x0
diff --git a/arch/arm64/kernel/head.S b/arch/arm64/kernel/head.S
index e0e710b36da37..ff7769821166a 100644
--- a/arch/arm64/kernel/head.S
+++ b/arch/arm64/kernel/head.S
@@ -575,25 +575,8 @@ SYM_INNER_LABEL(init_el2, SYM_L_LOCAL)
 	msr	sctlr_el2, x0
 	isb
 0:
-	mov_q	x0, HCR_HOST_NVHE_FLAGS
-
-	/*
-	 * Compliant CPUs advertise their VHE-onlyness with
-	 * ID_AA64MMFR4_EL1.E2H0 < 0. HCR_EL2.E2H can be
-	 * RES1 in that case. Publish the E2H bit early so that
-	 * it can be picked up by the init_el2_state macro.
-	 *
-	 * Fruity CPUs seem to have HCR_EL2.E2H set to RAO/WI, but
-	 * don't advertise it (they predate this relaxation).
-	 */
-	mrs_s	x1, SYS_ID_AA64MMFR4_EL1
-	tbz	x1, #(ID_AA64MMFR4_EL1_E2H0_SHIFT + ID_AA64MMFR4_EL1_E2H0_WIDTH - 1), 1f
-
-	orr	x0, x0, #HCR_E2H
-1:
-	msr	hcr_el2, x0
-	isb
 
+	init_el2_hcr	HCR_HOST_NVHE_FLAGS
 	init_el2_state
 
 	/* Hypervisor stub */
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-init.S b/arch/arm64/kvm/hyp/nvhe/hyp-init.S
index 1cc06e6797bda..a08363b9b10fd 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-init.S
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-init.S
@@ -75,6 +75,16 @@ __do_hyp_init:
 	eret
 SYM_CODE_END(__kvm_hyp_init)
 
+/*
+ * Initialize EL2 CPU state to sane values.
+ *
+ * HCR_EL2.E2H must have been initialized already.
+ */
+SYM_CODE_START_LOCAL(__kvm_init_el2_state)
+	init_el2_state				// Clobbers x0..x2
+	finalise_el2_state
+	ret
+SYM_CODE_END(__kvm_init_el2_state)
 /*
  * Initialize the hypervisor in EL2.
  *
@@ -202,9 +212,9 @@ SYM_CODE_START_LOCAL(__kvm_hyp_init_cpu)
 
 2:	msr	SPsel, #1			// We want to use SP_EL{1,2}
 
-	/* Initialize EL2 CPU state to sane values. */
-	init_el2_state				// Clobbers x0..x2
-	finalise_el2_state
+	init_el2_hcr	0
+
+	bl	__kvm_init_el2_state
 	__init_el2_nvhe_prepare_eret
 
 	/* Enable MMU, set vectors and stack. */
-- 
2.55.0.rc2.803.g1fd1e6609c-goog

