Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ABE22907
	for <kvmarm@lists.linux.dev>; Tue, 16 Apr 2024 09:57:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713261422; cv=none; b=VwEGmnE7Ii1fNuAT41/HnDR1/oW24epMUZDk7sq3yJPdagzc8f0NhVQIAEwirvvLiclVzzDQdM1b41CecCTu3rA9eAvEKROHOAw33Qy4c8REv1Q5T2UMxtk3eopmLP1mAI5jMW2rTK/MPBvsbqaJEgVgzsKcq9KwMU9Ue4oFPq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713261422; c=relaxed/simple;
	bh=H90qUlK9bUC3MyrhfhY5ihXN2fNS8HVH0gDN0PZjoKg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=XKJ1TMW8n71PVUpK6D2wOxUE8UNU+h/NA4+nAAwwo5G/OFX1q8/qXTm5Og8PSnN2ApzvfzHVdSco4HPpZhZ6m6BFjU8CijUl87JU8tc+xDY5pz0UzYbd05lek4Aqf7/jufUEfqy3OOdv/y4gDtUqdI6FJgXQS26F0XeJGMKza3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=b90R8+Qa; arc=none smtp.client-ip=209.85.221.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="b90R8+Qa"
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-343e46df264so2179686f8f.1
        for <kvmarm@lists.linux.dev>; Tue, 16 Apr 2024 02:57:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713261420; x=1713866220; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ceW0GVGFC4yezCwg0d+LQIakBS4pQWF6amaHbEkFLRU=;
        b=b90R8+QaPZht+V+FtzH5jDZAWUrv/HZaX70Y1FSlrYRoqqdXX9GPvCAqlbtcb8LFqq
         vQHML/a+jmmQBfU8LoukT0soh7UG4MrwVYMHYbtcMcQjidDcyl3IDwvW2Pz2PsVnHd5G
         eePwwYsuZTTqbVzrCkpWVZ0uw4iLoLpa2X6YmzYJrUFTChKCUH3z0igzDqbc9nrIvqfk
         /gucmOQ4c+Z1cXSO0LCsxweCTTFAGOwjhfeV+oPF1GNPW2QUj22qTQQImnDtr/g5SvV8
         uR3TyD7c0UwXBbt4lX3TTuxIDBBRsl0iiWhh0LbswykFqtn+++rXXyRDg8ifnl7Eb/yN
         OZnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713261420; x=1713866220;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ceW0GVGFC4yezCwg0d+LQIakBS4pQWF6amaHbEkFLRU=;
        b=pTW4orZqa4SJmaKW8IJlYI27xsKbyH3p0vq0/J+qAaTLlhXMABaAW+t52Y3L103o3D
         k6OPBrGCcNulVq9qqLRjITKa12bk8pHHMrBzqu7U+s4cbml4lLjw3FJWIkbb2+Wejql8
         qztX0vCExj+76hkX0aJ70xH2IlcdVSi+/pGb4d+jY76o2VldXNb1IubCHBbFr7JPPHaj
         uEBo4e7srzAyqVFFywDRaZ38QS/hswYI0/zXdWdZ+MQhCOX1Vy2ZhjK8TmP638Erp6+L
         0bpDiCPXnM+kExziocoiSFIuEngzHt8Xl+j8CstdDOrpfjONzR5i62C8sFCt67scrFYj
         Iqng==
X-Gm-Message-State: AOJu0YyHKfTIC1e8O8nebZrxf+j5e70zzR0zzCS3Oh9ZCVeYdr+sIFpA
	/zxqyke+aXpeW7OntxEf+DO8MZuAhlXQS1T7UzWeZ9nHK2yBedfuLR6NrYvCVi8AuK52UkrZeaf
	vxMHccr7NwU/P9w238uSWzGMV/s0iOfXibT7qQu2jsOVE7oTqnnjFgcFUWAaDv/563BN3InEmlM
	bhJUml0TKTCj9/jTUOUsC4XK5vhBs=
X-Google-Smtp-Source: AGHT+IFYCmnla1J1VlBjXbN1oym1khqIOzFEX9wJnt3dgpq5DvQ/M1Tm/IGbxLQV3UKE/lbwvtjf5SRhcQ==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a5d:66cd:0:b0:346:df86:9da2 with SMTP id
 k13-20020a5d66cd000000b00346df869da2mr24527wrw.3.1713261419324; Tue, 16 Apr
 2024 02:56:59 -0700 (PDT)
Date: Tue, 16 Apr 2024 10:55:59 +0100
In-Reply-To: <20240416095638.3620345-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240416095638.3620345-1-tabba@google.com>
X-Mailer: git-send-email 2.44.0.683.g7961c838ac-goog
Message-ID: <20240416095638.3620345-9-tabba@google.com>
Subject: [PATCH v2 08/47] KVM: arm64: Check for PTE validity when checking for executable/cacheable
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
2.44.0.683.g7961c838ac-goog

