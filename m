Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 188D23A1A8
	for <kvmarm@lists.linux.dev>; Fri, 19 Apr 2024 08:00:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713513602; cv=none; b=cdB5I5JBecrvGJuMXGNk41X+PsP3+2huKRGKIsc+lgQ0wE3/uKB/hJ9ktmNZoZKt/9iPkp4nxrPW0Jx6OUY/zEpDz4YJ2TDVZa9vKwZk8EgiklGO8UW/WJnwekW4b1aHpmXT2A33pu6tRAY9ziYZiIZYCT37FbHkyzIMUhLxbt4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713513602; c=relaxed/simple;
	bh=ND0UI8zwOlMYrXWuXY9PS7raItt8oX6nCoN1VfoqtxM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=qwPRtZJ3r74EYM7LKVAafDv4yg5yLFzIw2l8KXBaOo0No9Va//35MIY9/YIPCkXjnQzBaH32QaOn+GHxHEmU4XMGep/HlgKhfVZaZcu+gDLfyxlUYvXX4yGhBsG1SjtDM/Ha2fAlMBvdhIr26zinQEz5bd3Le4GWn/C8d48pgUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=zSNXCrWS; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="zSNXCrWS"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-41895b0a62cso14464645e9.2
        for <kvmarm@lists.linux.dev>; Fri, 19 Apr 2024 01:00:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713513599; x=1714118399; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=IBa5mK88uNPh7mBsQdtczbuGlBv1JXXU73/DcJ6dpWI=;
        b=zSNXCrWSOMB3AB2ZuNAYw3LEQiq1FYBC0Cbyy63Fe7J2Z9a1UOIyOM66Md26IK7xSm
         3K0/XjZrxsfVlxtI56afnj4IqjcUlSapG3S14gvVuQLEG9bIlDZzoOFcPDxpr6Cat/e5
         8gKFankTqEGnVy4qqJJl1IFQ5n1HWdK/P+jigYlfjHMeU7X6/h8Uu0lSp1s0vyeEz42M
         TcCcXCUYPUEODRQr4V2bcP8OF5G9JQlS+AzMVz8mh9SYaFPyzG4L63e3SCdeMLzPJB6r
         lpxLsJx49BMUGTZNqnuaW20okwHtiEpHOhAIC2dfWvBm5NVpovttmKGAj5Tkf5pnkosS
         EVnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713513599; x=1714118399;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IBa5mK88uNPh7mBsQdtczbuGlBv1JXXU73/DcJ6dpWI=;
        b=Oz8LW/zeB6B18QCUKpeogNbq65EHNs+Xcfxjipl2ajuuJmz5+PO3+EO4Fb01thTgcM
         2Fe5Ja39Q1kkUSKzR4fPjDB2EXY6CZsxy+ph6JpkngslKrTsmaj3rbcZGxT4IkZ8Ur71
         jNN/wj46SB09H85tWQofNB9bexWTDMc1pPdeDZCdGLAm3HoSpjJKBG+nK4LQ509hXrJL
         duxKAus7sa5eg83rfFWTiFzaCvCtx/+C8lN0tFdUt2rtJfEG9eHGt7QhE22CS5nNNPxS
         JjzXU1dDKuBSJqmWf1Uwb1H24bikgLlo7AxWsKhc0WvH2buPbID9bg0tt+/HXNrnRzS/
         XLdA==
X-Gm-Message-State: AOJu0Yw7ErBbScvYho6JBbgLuoN1MPAcQh7OTfDkt5KMHVOiiLH6wpN0
	/+bqZDN7mzGCyidLNVMfIVfB08BshRPDSFJEddkpyTR6S1Ibxf8gO1TmrsNdBjdDuRCY2nWY3B0
	R8ng49xHhqm/HyN+EycC+hg6IUcoZXDan4IXM+XhZwDVoc1hwfnkAII8rm8yH4w1nurq/a05++h
	9JiFuuM18YVcQ0N5+KFAsOyYOq9CA=
X-Google-Smtp-Source: AGHT+IHdroVaYAakXVvSS79kkOvrsUdrD1Gd0Z8XIdanlU658SEjD11dvpfeVRJQTlRbnkAwTazhExIMbA==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a05:600c:4f45:b0:418:f770:b9f with SMTP id
 m5-20020a05600c4f4500b00418f7700b9fmr10344wmq.0.1713513599478; Fri, 19 Apr
 2024 00:59:59 -0700 (PDT)
Date: Fri, 19 Apr 2024 08:59:17 +0100
In-Reply-To: <20240419075941.4085061-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240419075941.4085061-1-tabba@google.com>
X-Mailer: git-send-email 2.44.0.769.g3c40516874-goog
Message-ID: <20240419075941.4085061-8-tabba@google.com>
Subject: [PATCH v3 07/31] KVM: arm64: Check for PTE validity when checking for executable/cacheable
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev
Cc: maz@kernel.org, will@kernel.org, qperret@google.com, tabba@google.com, 
	seanjc@google.com, alexandru.elisei@arm.com, catalin.marinas@arm.com, 
	philmd@linaro.org, james.morse@arm.com, suzuki.poulose@arm.com, 
	oliver.upton@linux.dev, mark.rutland@arm.com, broonie@kernel.org, 
	joey.gouly@arm.com, rananta@google.com, smostafa@google.com
Content-Type: text/plain; charset="UTF-8"

From: Marc Zyngier <maz@kernel.org>

Don't just assume that the PTE is valid when checking whether it
describes an executable or cacheable mapping.

This makes sure that we don't issue CMOs for invalid mappings.

Suggested-by: Will Deacon <will@kernel.org>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/hyp/pgtable.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index 5a59ef88b646..67647b853c9b 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -914,12 +914,12 @@ static void stage2_unmap_put_pte(const struct kvm_pgtable_visit_ctx *ctx,
 static bool stage2_pte_cacheable(struct kvm_pgtable *pgt, kvm_pte_t pte)
 {
 	u64 memattr = pte & KVM_PTE_LEAF_ATTR_LO_S2_MEMATTR;
-	return memattr == KVM_S2_MEMATTR(pgt, NORMAL);
+	return kvm_pte_valid(pte) && memattr == KVM_S2_MEMATTR(pgt, NORMAL);
 }
 
 static bool stage2_pte_executable(kvm_pte_t pte)
 {
-	return !(pte & KVM_PTE_LEAF_ATTR_HI_S2_XN);
+	return kvm_pte_valid(pte) && !(pte & KVM_PTE_LEAF_ATTR_HI_S2_XN);
 }
 
 static u64 stage2_map_walker_phys_addr(const struct kvm_pgtable_visit_ctx *ctx,
@@ -1370,7 +1370,7 @@ static int stage2_flush_walker(const struct kvm_pgtable_visit_ctx *ctx,
 	struct kvm_pgtable *pgt = ctx->arg;
 	struct kvm_pgtable_mm_ops *mm_ops = pgt->mm_ops;
 
-	if (!kvm_pte_valid(ctx->old) || !stage2_pte_cacheable(pgt, ctx->old))
+	if (!stage2_pte_cacheable(pgt, ctx->old))
 		return 0;
 
 	if (mm_ops->dcache_clean_inval_poc)
-- 
2.44.0.769.g3c40516874-goog

