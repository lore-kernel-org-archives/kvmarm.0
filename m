Received: from mail-oi1-f201.google.com (mail-oi1-f201.google.com [209.85.167.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55D703B4EBF
	for <kvmarm@lists.linux.dev>; Wed,  1 Jul 2026 20:43:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782938629; cv=none; b=Mj1Go0fQMvIg1XS0CZq8wRUdxCdMwOIePCRzfGPh7dArMWMXYl1zzAPB81cXlwV7V71WtqGUUxU3dB5L82CYsAxXK1z7L5YHVuw4AClby43TEWMio1NiyHL+Ek+JQ7gQgy+ouPogii0b9DqUDRp/GxjZVEcorDBaQHDiUi8NkRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782938629; c=relaxed/simple;
	bh=bmRDfx1/ufTmqcCMk26xG2VDu49ewCYi92Vwoda0RBI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=lXYZ8gaDmRlsNpTMmxSqAe9zMGNysmC9MKHQX6SbZnWRVOAmfvq1KYQvmwHCD6VxTErYZZZca/cE+NmmA3wX4ARbM0KuQsQOOJTvX41xIwpPc/5ViclmbRv2SA1aVy3r8RDo9x8rsTQKs4iG828AoJZIFSQhW+PWeu/sbXkS3JM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=c4+nordr; arc=none smtp.client-ip=209.85.167.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="c4+nordr"
Received: by mail-oi1-f201.google.com with SMTP id 5614622812f47-4960487333eso1462585b6e.3
        for <kvmarm@lists.linux.dev>; Wed, 01 Jul 2026 13:43:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782938626; x=1783543426; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Wg29pCUTpKczjE5e4X1UMhkcqHVRIiR57OKtS+T144E=;
        b=c4+nordrIn6LOhaBxbzK56SW9lEGYnYi5ThSDikhxu4kGTzNvIf6GztAW6cXzku7De
         55RoMOPDcoq/pIE17UcHR9L/mduF8NubEgv1sRhKsIQTLclc+BnqJqgjSaJntV0FnGb/
         K9AneFmNMyDaPPw3Py5Nsmeg8N65V2JaLNMiSDToft5P/MvVVNIIz985cUBFaTUMIMHM
         5T4M88ABFEXr6jVXuZWV0HAKkFADXRVTzocMOcshgjzZQoorvY24/finoX598CbpVNve
         T5vwYeCkGa2U6ZdxfavlUGMeza0hOiEyKbdPzplO0o4/8DRkTzZNUr0o3g8qwt56ktXK
         dYzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782938626; x=1783543426;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Wg29pCUTpKczjE5e4X1UMhkcqHVRIiR57OKtS+T144E=;
        b=a6VK30YByWlHoM7tbqtM/gg0YlBDiyKahrVphtDHdg43zZXHUmmdU11ktlE9SJFc4F
         x5B8eEgliyk2oS/hDSkaa8dSUZIORcP2IUmjGVQBBPuqZXaBEoCY5HE+oJEyN+4Mu88G
         rU4EXKjSOOAMN+2u8xkVktciy0NH44PpV6HzkrkqqBJk+1/fim8cEPR1wy6J+H3uDpc/
         NbuCcWtQ6y6BqAvmUs1xrBDg5cQLJzW7xDrpFKn7WOAxegie99dXy6dLOAMgJhCp4y+B
         4rtQ8GR3UpUZZJooA+gH1UjWhCYiDnTV0oEC8hTGwK83OXvdkGMPZl9y6cWAlMyhE+Oe
         6aCA==
X-Forwarded-Encrypted: i=1; AFNElJ+6+kfzlaUWZaXjl1/Mn7KayAcodxmELrMqEX1ifm9iFQdMwnR75bYI7BbZ72g6zpM3bJk/soQ=@lists.linux.dev
X-Gm-Message-State: AOJu0Yzx1vwbMCfSPcNpHhm/iLtH6i1n+9VAz1MwcTCc4iOsLinujoDE
	pE/ifQGgcGDzwP21eBhUtp/0dHbW7uFuim63eYhfl7V8yBF7Bw4WW1lZAt/gby87qB3td9pdgYN
	dxDl5ipxTuFH81OQIvLJZQgw9zg==
X-Received: from illu13.prod.google.com ([2002:a05:6e02:170d:b0:503:4fb5:5493])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6808:15a4:b0:48b:1e49:24a8 with SMTP id 5614622812f47-4962d75e616mr1411593b6e.11.1782938626032;
 Wed, 01 Jul 2026 13:43:46 -0700 (PDT)
Date: Wed,  1 Jul 2026 20:43:40 +0000
In-Reply-To: <20260701204342.2654385-1-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260701204342.2654385-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.55.0.rc2.803.g1fd1e6609c-goog
Message-ID: <20260701204342.2654385-4-coltonlewis@google.com>
Subject: [PATCH 3/5] arm64: Fix early handling of FEAT_E2H0 not being implemented
From: Colton Lewis <coltonlewis@google.com>
To: stable@vger.kernel.org
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Mingwei Zhang <mizhang@google.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

From: Marc Zyngier <maz@kernel.org>

[ Upstream commit b3320142f3db9b3f36a59bd9769ba249f06155b4 ]

Commit 3944382fa6f2 introduced checks for the FEAT_E2H0 not being
implemented. However, the check is absolutely wrong and makes a
point it testing a bit that is guaranteed to be zero.

On top of that, the detection happens way too late, after the
init_el2_state has done its job.

This went undetected because the HW this was tested on has E2H being
RAO/WI, and not RES1. However, the bug shows up when run as a nested
guest, where HCR_EL2.E2H is not necessarily set to 1. As a result,
booting the kernel in hVHE mode fails with timer accesses being
cought in a trap loop (which was fun to debug).

Fix the check for ID_AA64MMFR4_EL1.E2H0, and set the HCR_EL2.E2H bit
early so that it can be checked by the rest of the init sequence.

With this, hVHE works again in a NV environment that doesn't have
FEAT_E2H0.

Fixes: 3944382fa6f2 ("arm64: Treat HCR_EL2.E2H as RES1 when ID_AA64MMFR4_EL1.E2H0 is negative")
Signed-off-by: Marc Zyngier <maz@kernel.org>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Link: https://lore.kernel.org/r/20240321115414.3169115-1-maz@kernel.org
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kernel/head.S | 29 ++++++++++++++++-------------
 1 file changed, 16 insertions(+), 13 deletions(-)

diff --git a/arch/arm64/kernel/head.S b/arch/arm64/kernel/head.S
index e32c8dd0b17a7..e0e710b36da37 100644
--- a/arch/arm64/kernel/head.S
+++ b/arch/arm64/kernel/head.S
@@ -576,6 +576,21 @@ SYM_INNER_LABEL(init_el2, SYM_L_LOCAL)
 	isb
 0:
 	mov_q	x0, HCR_HOST_NVHE_FLAGS
+
+	/*
+	 * Compliant CPUs advertise their VHE-onlyness with
+	 * ID_AA64MMFR4_EL1.E2H0 < 0. HCR_EL2.E2H can be
+	 * RES1 in that case. Publish the E2H bit early so that
+	 * it can be picked up by the init_el2_state macro.
+	 *
+	 * Fruity CPUs seem to have HCR_EL2.E2H set to RAO/WI, but
+	 * don't advertise it (they predate this relaxation).
+	 */
+	mrs_s	x1, SYS_ID_AA64MMFR4_EL1
+	tbz	x1, #(ID_AA64MMFR4_EL1_E2H0_SHIFT + ID_AA64MMFR4_EL1_E2H0_WIDTH - 1), 1f
+
+	orr	x0, x0, #HCR_E2H
+1:
 	msr	hcr_el2, x0
 	isb
 
@@ -588,22 +603,10 @@ SYM_INNER_LABEL(init_el2, SYM_L_LOCAL)
 
 	mov_q	x1, INIT_SCTLR_EL1_MMU_OFF
 
-	/*
-	 * Compliant CPUs advertise their VHE-onlyness with
-	 * ID_AA64MMFR4_EL1.E2H0 < 0. HCR_EL2.E2H can be
-	 * RES1 in that case.
-	 *
-	 * Fruity CPUs seem to have HCR_EL2.E2H set to RES1, but
-	 * don't advertise it (they predate this relaxation).
-	 */
-	mrs_s	x0, SYS_ID_AA64MMFR4_EL1
-	ubfx	x0, x0, #ID_AA64MMFR4_EL1_E2H0_SHIFT, #ID_AA64MMFR4_EL1_E2H0_WIDTH
-	tbnz	x0, #(ID_AA64MMFR4_EL1_E2H0_SHIFT + ID_AA64MMFR4_EL1_E2H0_WIDTH - 1), 1f
-
 	mrs	x0, hcr_el2
 	and	x0, x0, #HCR_E2H
 	cbz	x0, 2f
-1:
+
 	/* Set a sane SCTLR_EL1, the VHE way */
 	pre_disable_mmu_workaround
 	msr_s	SYS_SCTLR_EL12, x1
-- 
2.55.0.rc2.803.g1fd1e6609c-goog

