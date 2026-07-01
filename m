Received: from mail-oi1-f202.google.com (mail-oi1-f202.google.com [209.85.167.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14CA538332E
	for <kvmarm@lists.linux.dev>; Wed,  1 Jul 2026 20:43:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782938630; cv=none; b=MgbEw/jVzHwUcvaLq997q4bj5YHh69PyWPJeSSpLt64Px8SZRWa34K4Z3Uv4mYnIZIC8Gvl+hk38yCA6DaPRzgBOi9FkHgaBHmsMySyisvl1c1Pobt0vMkBKEQIyYyjr3KYIuzjnV9PlJnz2Pv3+JlXYshSludERcVlCvt0fEVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782938630; c=relaxed/simple;
	bh=6eCkFQ3pHgwn8l4mQYBv1gAg6isYBlWYb4iaywME6zA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=TEJ3lp8mLod9CtbsifG7WqJ2tmlZlx2g08zjBF3akDqE9iKb7QkTamaFKbPhdGbeUhPt4fTocSpEyofvnCuE6AHY7A+ZxsjcAjC0nMDTG8ygz4sclrYkws6NGOWS/r5+92U0KyhenBkgKllnFmQpYY47eEcAcGvHqrCkcR6Fjio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=RtbdIRZQ; arc=none smtp.client-ip=209.85.167.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="RtbdIRZQ"
Received: by mail-oi1-f202.google.com with SMTP id 5614622812f47-48e2ce64834so1029158b6e.3
        for <kvmarm@lists.linux.dev>; Wed, 01 Jul 2026 13:43:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782938628; x=1783543428; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=sot0xOLLqT5jl7UPs1tEjpIi3IAlhrP2GH6sB88yxis=;
        b=RtbdIRZQVnIUJsI0UaSinitEl4moKEc6pV5d+eaqxdFCC3nA8POZ0q1JKgKpFb0m1M
         +IfAxgMf8pE47gtgGq9piP7Z/kcTXZgC6/Le7GvCRmM0j33yf5P8hYSoYw7PS4+Siygx
         augYoTVcG0Yeei5qklUtR5XccoCgde+twT8za1OIGaz47EQrJpJj4hwXpiESGxta37DX
         b5b1xvrqvklvjFPEZFXzrdzhKQcIJKrwbdZnv+Pq00sFziQfawltHaAocybpF39s2L1D
         mDIaxs9YTJghvhhNjS3ZzZytVizAmj7EM7G4rcia3VY+G+S/5YoClZjmNnAEZ78fhOgx
         g4Eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782938628; x=1783543428;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sot0xOLLqT5jl7UPs1tEjpIi3IAlhrP2GH6sB88yxis=;
        b=kAgbQK3RSpP6KtktaOsjBqOHWWvqzQNZ2V0H/yrbFe9oNDUX0nI4NEuHMbNYHprwLk
         coSqAqJRtmmpwzptLv8nv1ji31eEf+8b8E2thQ9m6uOJalvQB3eG4nXXdYNyiIbdnEYq
         TGC26H6F0FUy7uAjNNYS86JEI1o8BbkALeXWdpIWgoJ0jZMb42/GUXv2fDHZZL6eFZzp
         f82tET4y3Qu/i2bbhFebfa3hXHCJ/cxXc/O6so39MRB0aXhS9y3gG0voDGmFVNqdA71T
         PJ4H3b6p7+wge48hWKFs2gS/qSG/6sLnPnnH1Il6eUPKYEqW598rID9mY/7Hu2Iptj0q
         nj1w==
X-Forwarded-Encrypted: i=1; AFNElJ88v8Ynmo/dUD65IZWoEQPOaHm7P3T7U5+gFnBSiYJylFy5PO6wyHOrEfdFHfA4tmsVmMOvLgY=@lists.linux.dev
X-Gm-Message-State: AOJu0YxhG8FlYW8qF3BE97gVcHdTNb3qwwtjxyIDf8Qqn/fXoNqLpz4Z
	YNnutTDCDtKiPVi+CBhXpwU8B6HdbUWS3AMj4H9VcJFRDgSTiJicP0HIWbI+zbjkOpxTEyBD2F8
	vD1k3pUDTxPtVfT9e7CQ799xp6w==
X-Received: from jabjw14.prod.google.com ([2002:a05:6638:a20e:b0:5e7:3ea0:602c])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6808:1210:b0:48a:3f80:ee5f with SMTP id 5614622812f47-4960f04d9cdmr2092075b6e.29.1782938627860;
 Wed, 01 Jul 2026 13:43:47 -0700 (PDT)
Date: Wed,  1 Jul 2026 20:43:42 +0000
In-Reply-To: <20260701204342.2654385-1-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260701204342.2654385-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.55.0.rc2.803.g1fd1e6609c-goog
Message-ID: <20260701204342.2654385-6-coltonlewis@google.com>
Subject: [PATCH 5/5] arm64: Revamp HCR_EL2.E2H RES1 detection
From: Colton Lewis <coltonlewis@google.com>
To: stable@vger.kernel.org
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Mingwei Zhang <mizhang@google.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, Mark Rutland <mark.rutland@arm.com>, 
	Jan Kotas <jank@cadence.com>
Content-Type: text/plain; charset="UTF-8"

From: Marc Zyngier <maz@kernel.org>

[ Upstream commit ca88ecdce5f5127ef2ee241b12b23a7e03c6210f ]

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
index 3498dc5d02c18..38d32116a23eb 100644
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
2.55.0.rc2.803.g1fd1e6609c-goog

