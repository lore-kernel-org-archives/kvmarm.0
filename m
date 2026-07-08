Received: from mail-oo1-f74.google.com (mail-oo1-f74.google.com [209.85.161.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96D0D38551A
	for <kvmarm@lists.linux.dev>; Wed,  8 Jul 2026 22:52:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783551139; cv=none; b=kknkAWl0yPCcdIE9kwDyJ/i6OVJBmNNoWVHWlFpBf5IfiZfy3zn0yPnwgjdnumsOFPjlOurA3rRMeNrBpDg+h4Jp5mdarcvZ9fmu2XGV6nxeIQbgCWP6+Vk9oGM3r3INgyNNDGTK3FZQ+e6Za+2LLIaPFR+/gWP4l0CzluH3M8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783551139; c=relaxed/simple;
	bh=nUhFMfzpySNDZtLZSUs7iGBvYNcjPGt8shYlgz2wNtQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=VDkFQ+SIpGj/vyxMP2n/zpzyJTQPPJAZhphc6toiW4LsNaAQRJl6FDDZugIbtpqYZr/U7D+kB0Y56/5yZHbxs0+adPtmGRDPrAoHCPzC8blF7mtJrSXAFrHGCnyxD4RIqd4ij9HdRq6emgLJVo61fVCkviskHs4ldSssDPLRQJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=B2zvI5Bn; arc=none smtp.client-ip=209.85.161.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="B2zvI5Bn"
Received: by mail-oo1-f74.google.com with SMTP id 006d021491bc7-6a0c02365c7so1718356eaf.2
        for <kvmarm@lists.linux.dev>; Wed, 08 Jul 2026 15:52:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783551133; x=1784155933; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=BRLBDv0GR5+I5QEs+yagz6DalTxaINze8PKIAjmPSRo=;
        b=B2zvI5BnIPMuW5i6BSrqpQiIThPwl6wj0SDrcCV5Z3lVzB6Hh24fPy6B9Hdni02Kg2
         sq519PXlS+E6SyAF1GDIT41aay3t+Wq1atvNPEck23tsZGMdfnqv+YJNCV00hIvG67ew
         DOZXK8mrIuBGCj9/gQT/iByH5+TpuxzecpfSDIE747LDajfU52qOGuyujlaRbQ/GnHEW
         myHFLrELJ1ygusi3xnJK2ofWSexbHKkb3M4TW67bicXpTVZ7NSHTBpU1vX0g2EEE6mL3
         5icFlP6we8MSOPeXchszve0/Cd/OgzCUmW0yWUGQ0KciPayJQu/ahl5Uuorek9lSvcnq
         dbEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783551133; x=1784155933;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=BRLBDv0GR5+I5QEs+yagz6DalTxaINze8PKIAjmPSRo=;
        b=Lvoo1nz9IAhpSJrtQzC2NZzGK19J7PJJZRZokZNuRJ4PgeXQ5PFHT7/RGIZbS8wcFa
         0EF9qN+yEv72DXFoRGVNHg9Ts2/DTLd+bi9hatormsWMeX3fjTjyKSuQLHa9Tzw9ueLK
         na2ALAZPdcYiGpQZ05Fz2/umsQni3b3X6WsTQpgWtmbPflzNMqpeMWDAsug3GNZS4PWC
         uBwiSvNupyOJkABcIui0/e32YIKUOpDWr2DVHud/y3ZFVrtcI6OjXfnsnkW4NlLU2YQw
         EHd+GKAJErB7FnRIijHNiXKOatkn0iGXGoHFCvtGtNoCslnKlW2XfV72B9d0UawXxbPO
         LYew==
X-Forwarded-Encrypted: i=1; AFNElJ97paLkbZcQFA/cySKPriNO96SLWdiAEkqTgzmgcpecMRiMXRccSEs/HzFJ4XelNSkuXTER1wo=@lists.linux.dev
X-Gm-Message-State: AOJu0YyzJPNThQHajpSnWtrfHv04JcaUI+71oJ+D9qXuR6e4zblUYrwG
	F7qeOaNoCBMoo82eeUSVysm8/88BnVcXJW1PZki2Ai68AUv1j8qztqjObChrhJRFLfcDsbIH1gv
	YXqiMRF6uN0QuEHqGznsyEW7VgQ==
X-Received: from ilmq1.prod.google.com ([2002:a92:d401:0:b0:503:8d4a:5b5b])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6820:5708:10b0:6a3:74fd:a86f with SMTP id 006d021491bc7-6a374fdb227mr1250772eaf.9.1783551133388;
 Wed, 08 Jul 2026 15:52:13 -0700 (PDT)
Date: Wed,  8 Jul 2026 22:51:24 +0000
In-Reply-To: <20260708225124.4130846-1-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260708225124.4130846-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.55.0.795.g602f6c329a-goog
Message-ID: <20260708225124.4130846-7-coltonlewis@google.com>
Subject: [PATCH 6.6 v2 6/6] arm64: Revamp HCR_EL2.E2H RES1 detection
From: Colton Lewis <coltonlewis@google.com>
To: stable@vger.kernel.org
Cc: oliver.upton@linux.dev, sashal@kernel.org, gregkh@linuxfoundation.org, 
	mizhang@google.com, catalin.marinas@arm.com, will@kernel.org, maz@kernel.org, 
	james.morse@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	mark.rutland@arm.com, ahmed.genidi@arm.com, leo.yan@arm.com, 
	miguel.luis@oracle.com, dbrazdil@google.com, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Jan Kotas <jank@cadence.com>
Content-Type: text/plain; charset="UTF-8"

From: Marc Zyngier <maz@kernel.org>

[ Upstream commit ca88ecdce5f51874a7c151809bd2c936ee0d3805 ]

We currently have two ways to identify CPUs that only implement FEAT_VHE
and not FEAT_E2H0:

- either they advertise it via ID_AA64MMFR4_EL1.E2H0,
- or the HCR_EL2.E2H bit is RAO/WI

However, there is a third category of "cpus" that fall between these
two cases: on CPUs that do not implement FEAT_FGT, it is IMPDEF whether
an access to ID_AA64MMFR4_EL1 can trap to EL2 when the register value
is zero.

A consequence of this is that on systems such as Neoverse V2, a NV
guest cannot reliably detect that it is in a VHE-only configuration
(E2H is writable, and ID_AA64MMFR0_EL1 is 0), despite the hypervisor's
best effort to repaint the id register.

Replace the RAO/WI test by a sequence that makes use of the VHE
register remnapping between EL1 and EL2 to detect this situation,
and work out whether we get the VHE behaviour even after having
set HCR_EL2.E2H to 0.

This solves the NV problem, and provides a more reliable acid test
for CPUs that do not completely follow the letter of the architecture
while providing a RES1 behaviour for HCR_EL2.E2H.

Suggested-by: Mark Rutland <mark.rutland@arm.com>
Acked-by: Mark Rutland <mark.rutland@arm.com>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Reviewed-by: Oliver Upton <oliver.upton@linux.dev>
Tested-by: Jan Kotas <jank@cadence.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/15A85F2B-1A0C-4FA7-9FE4-EEC2203CC09E@global.cadence.com

[ Backport: Resolved conflict in arch/arm64/include/asm/el2_setup.h
  by replacing msr_hcr_el2 macro usages with raw msr hcr_el2 (since
  the macro is missing in 6.6.y). ]
---
 arch/arm64/include/asm/el2_setup.h | 38 +++++++++++++++++++++++++-----
 1 file changed, 32 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/include/asm/el2_setup.h b/arch/arm64/include/asm/el2_setup.h
index 76b0d50d286d5..4c7467b382b60 100644
--- a/arch/arm64/include/asm/el2_setup.h
+++ b/arch/arm64/include/asm/el2_setup.h
@@ -24,22 +24,48 @@
 	 * ID_AA64MMFR4_EL1.E2H0 < 0. On such CPUs HCR_EL2.E2H is RES1, but it
 	 * can reset into an UNKNOWN state and might not read as 1 until it has
 	 * been initialized explicitly.
-	 *
-	 * Fruity CPUs seem to have HCR_EL2.E2H set to RAO/WI, but
-	 * don't advertise it (they predate this relaxation).
-	 *
 	 * Initalize HCR_EL2.E2H so that later code can rely upon HCR_EL2.E2H
 	 * indicating whether the CPU is running in E2H mode.
 	 */
 	mrs_s	x1, SYS_ID_AA64MMFR4_EL1
 	sbfx	x1, x1, #ID_AA64MMFR4_EL1_E2H0_SHIFT, #ID_AA64MMFR4_EL1_E2H0_WIDTH
 	cmp	x1, #0
-	b.ge	.LnVHE_\@
+	b.lt	.LnE2H0_\@
 
+	/*
+	 * Unfortunately, HCR_EL2.E2H can be RES1 even if not advertised
+	 * as such via ID_AA64MMFR4_EL1.E2H0:
+	 *
+	 * - Fruity CPUs predate the !FEAT_E2H0 relaxation, and seem to
+	 *   have HCR_EL2.E2H implemented as RAO/WI.
+	 *
+	 * - On CPUs that lack FEAT_FGT, a hypervisor can't trap guest
+	 *   reads of ID_AA64MMFR4_EL1 to advertise !FEAT_E2H0. NV
+	 *   guests on these hosts can write to HCR_EL2.E2H without
+	 *   trapping to the hypervisor, but these writes have no
+	 *   functional effect.
+	 *
+	 * Handle both cases by checking for an essential VHE property
+	 * (system register remapping) to decide whether we're
+	 * effectively VHE-only or not.
+	 */
+	msr	hcr_el2, x0		// Setup HCR_EL2 as nVHE
+	isb
+	mov	x1, #1		// Write something to FAR_EL1
+	msr	far_el1, x1
+	isb
+	mov	x1, #2		// Try to overwrite it via FAR_EL2
+	msr	far_el2, x1
+	isb
+	mrs	x1, far_el1	// If we see the latest write in FAR_EL1,
+	cmp	x1, #2		// we can safely assume we are VHE only.
+	b.ne	.LnVHE_\@	// Otherwise, we know that nVHE works.
+
+.LnE2H0_\@:
 	orr	x0, x0, #HCR_E2H
-.LnVHE_\@:
 	msr	hcr_el2, x0
 	isb
+.LnVHE_\@:
 .endm
 
 .macro __init_el2_sctlr
-- 
2.55.0.795.g602f6c329a-goog

