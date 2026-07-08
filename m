Received: from mail-ot1-f73.google.com (mail-ot1-f73.google.com [209.85.210.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF0A738AC79
	for <kvmarm@lists.linux.dev>; Wed,  8 Jul 2026 22:52:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783551132; cv=none; b=UdDJA6oUq0w6MUOijxD8/BNEYHBu/M2KJOkQZwKU73Ln5ENKRd6qbD2p3SYMWWo8GeDCJqZ2oD1J4mRZz1ONvaKyQnHyFLwH/JZqdQdsuZ3D6JjPzj+AspTe/zGrDKarH9XHXJG0U/sZ9fgHNqVPq9qAc+hJoM40BJMEkuyUbJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783551132; c=relaxed/simple;
	bh=e1QBSxc/Yh7FOkNKih8p3yMQhq4Djozfjn76t2aVd98=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=bbWsvqtBbXQXgxxBeqwkwO2a1n8YXBB9dbJqG948vGu2WaDbgp8lohMgL93jfXc13NE08YutHLU5J+MKo+E6Of1VbtDG6NhT2GGNrz+unHvt5R0La8hWBpIYoiyh57XIiT6kXuqYSKfCFnc2Qtl3RV67iqd/iX3wccmWkfWM/W4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=GYXO9gRg; arc=none smtp.client-ip=209.85.210.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="GYXO9gRg"
Received: by mail-ot1-f73.google.com with SMTP id 46e09a7af769-7e99ff505c2so202350a34.1
        for <kvmarm@lists.linux.dev>; Wed, 08 Jul 2026 15:52:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783551130; x=1784155930; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=FPSpGPhYj+nCWbyX4YSYp8uqE5DTFDcur5HhjhyAr24=;
        b=GYXO9gRg5QLbGPbe9OAr2QY4uNfkTALNFuDst1efjCReGA7hNZTWtmiyH7EKswiE3u
         +G+sGTFiN7KfWciE0b7R9jKr6uNkYSyl4NX5+ITKR/Roiz2kLATqDxlbJGK7E79NL3nL
         CQQuZQszjyDrrzYjYA3qP+d1WhrCXFKapnyB/+YcPhCPHL64neuJ2KN0fMeCABqVrwpL
         CZ2JpA6zIF9NhXr0xfsjwkmuj4NhLrM2/9hHCrp6Qz5T59Y52hZt+cpJAUdnqlJJNIIy
         FIDSp0czA6UDYDVrwT59Z1P8djcLi1CalL7zSseVnRaPYdwv2Rzv46lF/4B2EdqFSdYL
         U0PA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783551130; x=1784155930;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=FPSpGPhYj+nCWbyX4YSYp8uqE5DTFDcur5HhjhyAr24=;
        b=oHJzK2QrtmSz0wdMOfTvkOncgpfmiHmuAgaAQI/CohObqwrdCNJk2vB6HqUpPvx7Hg
         0ER4aOglZCNw27Cu0TPLcQKwcXZpj+6tFkcL47EpQxPLrDDYFUy+c/Og9KzeKY4rJH5B
         Th72/i07Assx6gKXjVJ3E7/oEx+TnaGC8WxuvBNcOEA21wqBHkXl/0EDNkPXBG42gUci
         Gr69d4WtY1YrbjtUX9mRIh+AVBEz2X2Ia96gJzjRHf74wUDyiY3KcCKk2utQNgKOOLdt
         Zxj/2CHnskWKp8nxH2Kr/u8jrRFP5bCv6ANisuVKw74Slar5/VGH2uXia7lZJkkruE4a
         le5Q==
X-Forwarded-Encrypted: i=1; AFNElJ9npgLvzMSmoZMV0SB3t7tLhhkEo6FFD0C4RF6sc333J2xFd8FQGrgOexL2jjbMEnkAEVlBLB8=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw374+pF+M6fJLace1axuPSicviwk29ddGbhu4/t8muvcUtCgXp
	85bwRTeeUEzzEiap1sjlsoGIsGQ/sk58FgU4ndkr+d9CdSDruE5QN+E0P8/EOBaalIixg72MemU
	7VJMyk9yg7NHH9n59OIRkumC9RA==
X-Received: from iobp6-n1.prod.google.com ([2002:a05:6602:8686:10b0:9a8:30d:4dd8])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6820:202:b0:6a1:5acb:e954 with SMTP id 006d021491bc7-6a36d972ba9mr3178365eaf.19.1783551129511;
 Wed, 08 Jul 2026 15:52:09 -0700 (PDT)
Date: Wed,  8 Jul 2026 22:51:20 +0000
In-Reply-To: <20260708225124.4130846-1-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260708225124.4130846-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.55.0.795.g602f6c329a-goog
Message-ID: <20260708225124.4130846-3-coltonlewis@google.com>
Subject: [PATCH 6.6 v2 2/6] arm64: Treat HCR_EL2.E2H as RES1 when
 ID_AA64MMFR4_EL1.E2H0 is negative
From: Colton Lewis <coltonlewis@google.com>
To: stable@vger.kernel.org
Cc: oliver.upton@linux.dev, sashal@kernel.org, gregkh@linuxfoundation.org, 
	mizhang@google.com, catalin.marinas@arm.com, will@kernel.org, maz@kernel.org, 
	james.morse@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	mark.rutland@arm.com, ahmed.genidi@arm.com, leo.yan@arm.com, 
	miguel.luis@oracle.com, dbrazdil@google.com, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
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

