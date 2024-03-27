Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFB4EF4E2
	for <kvmarm@lists.linux.dev>; Wed, 27 Mar 2024 17:35:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711560947; cv=none; b=hcy5ljDkNEPtrSrR8SIMN9xhb8OtA2HciEfcbZ9BLdL2OwqqBhl2Pxqa/jlt6QIIcKO6Nu+67U3gBd1KFhP5trn7jwq7cJ/+ZasyatXyqF++oH/PoectwuStaUXcEIVywHf4iDcbXsJapu4i94Me1eyE2rajoKibHd9FtzrjmO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711560947; c=relaxed/simple;
	bh=4wtGI//AGlnE7+FTN8hLM5sx09iLTLOxNg6urTGT3RI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=iHbq0xWTk12XuC9MyqJJZsWItQZZkbXL7650gQ91Dlu1cNeYr/RM63zJ5vXnIWuxhJWik7npEG76vYzEq/jLKztWW+PkqhPLBRo/5OrWXTiByWS8s7PamH+Lkb6d+yghherlsfcE3Ity1TI+UbDS6TdZmoj1B2T1+XbraGIDczw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=H8bBFASG; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="H8bBFASG"
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-60a0b18e52dso1519407b3.1
        for <kvmarm@lists.linux.dev>; Wed, 27 Mar 2024 10:35:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1711560945; x=1712165745; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=AdsRr1W9utXU8wOm/wwGYZdTQQlPQJtNrxC4CxJ9fF0=;
        b=H8bBFASGcMjsW0ohbhPkzQq/+jv+1TVGRn4DoOWxIBnE8EI0u9bdPlT7L4z/JJVTuR
         gUjbbJO38LLS9Hdp338YhHdN7pdyqJ+uIUrhs15+p27pw63pfhsXjHFr4KldhZ1rjRpb
         kwHFCCJ2qlkdsgAWPN5pXEvTak3RdeiXZZBiFQvsU41Sbub/aV9rYC71QrfjmQEILQQh
         22Ot26SWhC+4nI0sonfI2IiJ7PFYRO2fg2Bim0+xTIMyHyMATf3JLn1f+hERaOm9y9rp
         Ub8DuWUBGR3UKh0aZiBnpe0CUQTShjNewD032TZTTQGeFToxPzMGcD6anZFoMxKHjYZg
         Lopg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711560945; x=1712165745;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AdsRr1W9utXU8wOm/wwGYZdTQQlPQJtNrxC4CxJ9fF0=;
        b=T+WzYa2U7uTna0GZZIiqoqt1gNF9bOkiDAs9AnjoePeUBbbmcxhEfWKKx8gtPl21v3
         bMrBkMHGHGq9/dqh2Nqnp8U4uxwSuQ0awYod/hybg3ga0JmZ431GfHlWE+xjcxTLbMIP
         MYnTT8hYgTUsAAczP+eHKzxKi49BFykT3Tc8yGjb1bbMdAnfTVPr5YO21E1pkhUetjtt
         OYFnuA6iLp7hCQhW9CdDhWUOtmS1cv9m+Tlk+ON5ZPDNSZCJLUHsjPP78rOaeBJL1CWw
         i8elSMIsSj5hFmPawF5ipIO/fhIMy/vjg2QzDeUAxUWfkrSg0aqDl4s5XzXwRhhGf1SR
         zxtg==
X-Gm-Message-State: AOJu0YzntpwE8QZiBoxM1kdb3BVWe2ssFc983gtp0lLt1/yME2H7tfwV
	vRYn5C423AnOUI5MywqclQZzM1u1CEKqdkhFIA9xOiG+sJvnkOtehcAPM54ZBw7m0EiGJ3t7Py6
	aV3SrFQ22mzyKtI9lsKey/J/jivDuDD6aX2YPLmD5eA3Ezxv6MtjOfZXPHbj/Taw9zV8ccF20Uu
	wDUPvpKF+Vfo/Mkx77jc467XmE80k=
X-Google-Smtp-Source: AGHT+IFVRGYaIe5gRLVqqM4iwoydnpjkjghOM775bYyvcrAZVn+rEgQFGdu5YlHqPm/MbZLdzO/Pdk8PFw==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a81:be0e:0:b0:613:eb91:7381 with SMTP id
 i14-20020a81be0e000000b00613eb917381mr55254ywn.2.1711560944956; Wed, 27 Mar
 2024 10:35:44 -0700 (PDT)
Date: Wed, 27 Mar 2024 17:34:52 +0000
In-Reply-To: <20240327173531.1379685-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240327173531.1379685-1-tabba@google.com>
X-Mailer: git-send-email 2.44.0.478.gd926399ef9-goog
Message-ID: <20240327173531.1379685-6-tabba@google.com>
Subject: [PATCH v1 05/44] KVM: arm64: Check for PTE validity when checking for executable/cacheable
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev
Cc: maz@kernel.org, will@kernel.org, qperret@google.com, tabba@google.com, 
	seanjc@google.com, alexandru.elisei@arm.com, catalin.marinas@arm.com, 
	philmd@linaro.org, james.morse@arm.com, suzuki.poulose@arm.com, 
	oliver.upton@linux.dev, mark.rutland@arm.com, broonie@kernel.org, 
	joey.gouly@arm.com, rananta@google.com
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
index 3fae5830f8d2..da54bb312910 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -907,12 +907,12 @@ static void stage2_unmap_put_pte(const struct kvm_pgtable_visit_ctx *ctx,
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
@@ -1363,7 +1363,7 @@ static int stage2_flush_walker(const struct kvm_pgtable_visit_ctx *ctx,
 	struct kvm_pgtable *pgt = ctx->arg;
 	struct kvm_pgtable_mm_ops *mm_ops = pgt->mm_ops;
 
-	if (!kvm_pte_valid(ctx->old) || !stage2_pte_cacheable(pgt, ctx->old))
+	if (!stage2_pte_cacheable(pgt, ctx->old))
 		return 0;
 
 	if (mm_ops->dcache_clean_inval_poc)
-- 
2.44.0.478.gd926399ef9-goog

