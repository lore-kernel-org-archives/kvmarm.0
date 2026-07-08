Received: from mail-oo1-f73.google.com (mail-oo1-f73.google.com [209.85.161.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1F0C39524E
	for <kvmarm@lists.linux.dev>; Wed,  8 Jul 2026 22:52:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783551135; cv=none; b=txHFjWBifIAvVVftSKC2DM7IGe6CwNFYkexWqzJ5ln/CdkEkVET/6xWUfYiRHjLQ8PldiTNA7lXEfMSwiE0mft6fMQEvJDfesveHt/EzTyxNrcBOMh02p5PKHcVw94j36LqwCUDxwExWhYQVMQ7oDU1H/g0nCRVm/H+DEy9RZ1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783551135; c=relaxed/simple;
	bh=GcTzCgDwS7y4wDnrGBefwcu9zbRuGcMdXbDLOI4++CE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Bja1oePhILHiGvrC+LIUq+au0GzwtboGt/65IHL/gacVQ2LsXIe6wWqfbdp/XkrKSBBfBL7aNHMiCEQJWsFrTqn9CwSLDcjxeLaMRZbAKXrp6nsi1W0/5ymsUmB1t+4888KV8+DI01WSk6u/TbG557O4NWNyAWAQZB5yUEOywek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ZmEMWqTg; arc=none smtp.client-ip=209.85.161.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ZmEMWqTg"
Received: by mail-oo1-f73.google.com with SMTP id 006d021491bc7-6a37685f41aso544248eaf.3
        for <kvmarm@lists.linux.dev>; Wed, 08 Jul 2026 15:52:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783551131; x=1784155931; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=YVcT/XbiQLVXOFsg2iWKEGLEgGzJkv14kL5pzrUYsoQ=;
        b=ZmEMWqTgHLd+i0PcGnwHu+5+gnxfI3vf+cOshDgEvRDFbsvAuzAX3LQ9OlMmDmyKsW
         3GayO+STj2GnzPItDIrjKOQS05EBeZNfoH0IViRZhL9tUY3Z2W6YJgI6AQ2AhhpJziH5
         FKQ1gF3ZUAGVcUaN5or1eQGTZ/c9CREg9tnfEYheXOGQf/2Gtyqp8NiiyMfJHXTTkDjD
         zFnyLpXa+8i51Pn86CrcHTcAefVoTqQmnI9i1sFRDkI7ZPmG5itZ9Soaj2mehh8ktYwU
         QkBLXe4BDdz2sky4sgO12A2t8udXEhW8UaMM+48++z+z54Tc8ztaHBWw2TvqWlTXcYGH
         HF+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783551131; x=1784155931;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=YVcT/XbiQLVXOFsg2iWKEGLEgGzJkv14kL5pzrUYsoQ=;
        b=ov9KdsgMEjSqfaF+AKpRiBsUOpYudczNlys4jwYm6W7XtoN2/V0V9TyMUbF9jf6S4h
         pTFzfJBMe5qnUsNrJ74kVgg9JCzLqcfx92ET0jX4UuwGgPDrra/QhvW088QFwJP40h0a
         ThhDEtL/+M5mkL6aWaJSvNuc8LNxx4BqTACEhQpYoCXRkJU/SJeBNi0dzhbPspTvohfK
         AJu/O34k54Rby7AWqmKB4o4L7Z6VYz6o3yiGn+QhQyirx8+1+ADwJYatHZdfsIGb+0z5
         ssPNYKrdR02HSgwkV6djpSy5U5DHnonQgjXsdf8suD5sSq8gH16UdHEVIcgWRhZN3+NS
         qZmQ==
X-Forwarded-Encrypted: i=1; AFNElJ+vOFtmTv+owWl/ViNaZalRadcabqWQ1V+BOH1WB8EcQsKJh2VpzcojefKF0LYQ1XL8WJVnOe0=@lists.linux.dev
X-Gm-Message-State: AOJu0YwS8JybteA8cET5rB4GqQM9BBDslXqWac8Hd1QGsbYcmi1oDEmE
	jW/T4rRqMmHLFkrHPxd01kAAXLe9RmRvY9AyzI0zkgQGviCOsnnRZTHg4kfqGZ2K1wn1Nbza2Mb
	erbnO6DlDDpOpvLoGHuXxMeXhRQ==
X-Received: from ilov7.prod.google.com ([2002:a05:6e02:f87:b0:503:921d:b167])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6820:8c5:b0:69e:34f1:9690 with SMTP id 006d021491bc7-6a36da60d5emr3142261eaf.35.1783551130514;
 Wed, 08 Jul 2026 15:52:10 -0700 (PDT)
Date: Wed,  8 Jul 2026 22:51:21 +0000
In-Reply-To: <20260708225124.4130846-1-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260708225124.4130846-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.55.0.795.g602f6c329a-goog
Message-ID: <20260708225124.4130846-4-coltonlewis@google.com>
Subject: [PATCH 6.6 v2 3/6] arm64: Fix early handling of FEAT_E2H0 not being implemented
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

[ Upstream commit b3320142f3db9b3f2a23460abd3e22292e1530a5 ]

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
2.55.0.795.g602f6c329a-goog

