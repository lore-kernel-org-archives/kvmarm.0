Received: from mail-oo1-f73.google.com (mail-oo1-f73.google.com [209.85.161.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25C2B33D6E3
	for <kvmarm@lists.linux.dev>; Thu,  9 Jul 2026 22:37:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783636639; cv=none; b=V92wwAmSkDMcrCoBj6rD9IBTTlLkAzA3HHa9cjdjMsKFeP8Uc10KAcIyCGK48x4wYYGOOpm0K6TBuMFMZ9SUdvjzoi/1/u9nSuNExY2m+3Ri9688X1nUxqDBWURoslk0erPN5h+AX0Gu5xLdG1YEzokC8kQxmz7ELmJNQSUCiLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783636639; c=relaxed/simple;
	bh=Nj4ah24RhizplgZwjA+WJE62tsCAD+HTC4rE4PJN5ps=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=PgCVOE0lrENo4v7oyqdXQZWTw3NqSxrCgSZ/XBV3AYhkGHwRRruX61oKFm6iXVgsRFrokMDqDvcZaEM1jSg1T9sgVLbqK95WvJkZ/pbli1kjryvANp+DJdVK9epIiFyIDuwlgSyUpPaIM8YBypG75DJoKOfr0uMHGvzZM6+X2Yo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=MGanI6ai; arc=none smtp.client-ip=209.85.161.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="MGanI6ai"
Received: by mail-oo1-f73.google.com with SMTP id 006d021491bc7-6a373cdae78so546753eaf.0
        for <kvmarm@lists.linux.dev>; Thu, 09 Jul 2026 15:37:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783636636; x=1784241436; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=bLsOz0Axj25l+wvraALNIMv5XA28LGDsXUMLwaYR1e8=;
        b=MGanI6airmyUGKXHh2a2AFqd/i/LGdzHE2vsUnpZwwUWKd6hbO/oufET0JoPjBOvzh
         4q4BDQLJLoGxMaEvS2++MrbgrcW4N2EQBDCTs4j+fbI2nRdvj4RkFrPRjuY6GNQMOpKp
         ObT+JZj9Sb2nx4UXkoRYuKH2/pt12ULkx5LyBuPtX3d7iLmZLTDGY3pWotTZE7RPTdoN
         o3SaVbgbJ8hHivuTKFKS4lyISa/bfCy7KmrPGwv8I0bEkdhJVcK8OA8qEEq8eE+fTow6
         6qX7i8l27a6XvbmjVa/NCYvURwhQc5EEfzbJ96Xd3BcpnhHa5ZaCiO9bv0nzusOLsBhR
         pMTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783636636; x=1784241436;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=bLsOz0Axj25l+wvraALNIMv5XA28LGDsXUMLwaYR1e8=;
        b=qi4pXkKSQvESjartExjfFz45rQ1wMI5cRT9mMhQgH2t+oi0m8xdb3lJW5mu1gT+zaq
         Zl3nILGieatVViQPYnjPoxUpurvRPqHvk4IcVY3NRRvvcWF+wdMyrMFTliy5gP6JZJ4j
         N4SK5RbmUfZAErRc4DAEhIY87N0klUE5SeCn/zUBPns14iduK6COAh0sxicptLdWxwv3
         HQoLK8TedA31J5/fxjPgj5nLfcc1WN0Gk6aMGOhNSLzIweagrI94S3vFO+w9gAGKsCj3
         UQq4kOkJ9uNRMbJ5W3lcX2FHp3E/rm2qcCdJ/vtG7mzVEHpH+gFCLd+6JoVyOcB+fXrm
         atyQ==
X-Forwarded-Encrypted: i=1; AFNElJ+9zSZh7uil8dcxFG1VXTfmaYv9lt1t/PEL5AfRVYCA4gCSl/Ieh7Gfopz1/65pKptrnnLCEP0=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy3Od8y1sXQeHWYYjaNuvE+LN6XTGN+hDKCTbOAmHh4zi3I+nvX
	HJkF31NTMqPCXsRuiWDzaAFwPSPeqxDhKky+4f9uy0dm5Hl6cn073O2kHg5OIbKmtyil19X4xwj
	gwyTnzwEp3WyJatEOGF/9+5722g==
X-Received: from iobfq12.prod.google.com ([2002:a05:6602:66c:b0:9a4:e1b0:4d23])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6820:612:b0:6a1:3e91:dca6 with SMTP id 006d021491bc7-6a36d899d80mr6402785eaf.22.1783636635779;
 Thu, 09 Jul 2026 15:37:15 -0700 (PDT)
Date: Thu,  9 Jul 2026 22:35:59 +0000
In-Reply-To: <20260709223604.12934-1-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260709223604.12934-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.55.0.795.g602f6c329a-goog
Message-ID: <20260709223604.12934-3-coltonlewis@google.com>
Subject: [PATCH 6.6 v3 2/6] arm64: Treat HCR_EL2.E2H as RES1 when
 ID_AA64MMFR4_EL1.E2H0 is negative
From: Colton Lewis <coltonlewis@google.com>
To: stable@vger.kernel.org
Cc: oliver.upton@linux.dev, sashal@kernel.org, gregkh@linuxfoundation.org, 
	mizhang@google.com, catalin.marinas@arm.com, will@kernel.org, maz@kernel.org, 
	james.morse@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	mark.rutland@arm.com, ahmed.genidi@arm.com, leo.yan@arm.com, 
	miguel.luis@oracle.com, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Colton Lewis <coltonlewis@google.com>
Content-Type: text/plain; charset="UTF-8"

From: Marc Zyngier <maz@kernel.org>

[ Upstream commit 3944382fa6f22b54fd399632b1af92c28123979b ]

For CPUs that have ID_AA64MMFR4_EL1.E2H0 as negative, it is important
to avoid the boot path that sets HCR_EL2.E2H=0. Fortunately, we
already have this path to cope with fruity CPUs.

Tweak init_el2 to look at ID_AA64MMFR4_EL1.E2H0 first.

Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Link: https://lore.kernel.org/r/20240122181344.258974-8-maz@kernel.org
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
Signed-off-by: Colton Lewis <coltonlewis@google.com>
---
 arch/arm64/kernel/head.S | 23 +++++++++++++++--------
 1 file changed, 15 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/kernel/head.S b/arch/arm64/kernel/head.S
index 6517bf2644a08..e32c8dd0b17a7 100644
--- a/arch/arm64/kernel/head.S
+++ b/arch/arm64/kernel/head.S
@@ -589,25 +589,32 @@ SYM_INNER_LABEL(init_el2, SYM_L_LOCAL)
 	mov_q	x1, INIT_SCTLR_EL1_MMU_OFF
 
 	/*
-	 * Fruity CPUs seem to have HCR_EL2.E2H set to RES1,
-	 * making it impossible to start in nVHE mode. Is that
-	 * compliant with the architecture? Absolutely not!
+	 * Compliant CPUs advertise their VHE-onlyness with
+	 * ID_AA64MMFR4_EL1.E2H0 < 0. HCR_EL2.E2H can be
+	 * RES1 in that case.
+	 *
+	 * Fruity CPUs seem to have HCR_EL2.E2H set to RES1, but
+	 * don't advertise it (they predate this relaxation).
 	 */
+	mrs_s	x0, SYS_ID_AA64MMFR4_EL1
+	ubfx	x0, x0, #ID_AA64MMFR4_EL1_E2H0_SHIFT, #ID_AA64MMFR4_EL1_E2H0_WIDTH
+	tbnz	x0, #(ID_AA64MMFR4_EL1_E2H0_SHIFT + ID_AA64MMFR4_EL1_E2H0_WIDTH - 1), 1f
+
 	mrs	x0, hcr_el2
 	and	x0, x0, #HCR_E2H
-	cbz	x0, 1f
-
+	cbz	x0, 2f
+1:
 	/* Set a sane SCTLR_EL1, the VHE way */
 	pre_disable_mmu_workaround
 	msr_s	SYS_SCTLR_EL12, x1
 	mov	x2, #BOOT_CPU_FLAG_E2H
-	b	2f
+	b	3f
 
-1:
+2:
 	pre_disable_mmu_workaround
 	msr	sctlr_el1, x1
 	mov	x2, xzr
-2:
+3:
 	__init_el2_nvhe_prepare_eret
 
 	mov	w0, #BOOT_CPU_MODE_EL2
-- 
2.55.0.795.g602f6c329a-goog

