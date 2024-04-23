Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7757D13B58D
	for <kvmarm@lists.linux.dev>; Tue, 23 Apr 2024 15:05:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713884760; cv=none; b=mURP7Cik1JxAiLqelIgMPOXPXuQ4Vre/D/ziPMedJQAfoa/TZ/urPvfqMfue3kQdMiKS+rdqnH9939kz9yhEqaYeaTc1DDfBM1fHCs0mUqrygTgy3/mOagnNnSD2KbYgULFU6XSUwmD1FGYGb/3qhKDD2UE7UtV8Fv6YALHqaSA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713884760; c=relaxed/simple;
	bh=ND0UI8zwOlMYrXWuXY9PS7raItt8oX6nCoN1VfoqtxM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Ib10XcOftMho7sd5MJRVv+NfwjrY37afWjcx9+eUSNQj8/hstpZBOdCikFUMeY1o3EyffJbZvM1Y/MqRAig2fsrdc2XK58M4+lyvPTtPcTZBA75mubqT9dE3CmMIQkt7duaVQsGYD21t5mIpZZ5IBu6yH+qPTPZkRSlcfTZyoBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Q7dsjGYk; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Q7dsjGYk"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-41a3369659eso11324865e9.1
        for <kvmarm@lists.linux.dev>; Tue, 23 Apr 2024 08:05:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713884757; x=1714489557; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=IBa5mK88uNPh7mBsQdtczbuGlBv1JXXU73/DcJ6dpWI=;
        b=Q7dsjGYkWoFoTzATe7Jjrgt9Ygc+pHCwVer4HA1ypKrYCwjj/PLbqSVg3q1msUPeX/
         StkLaGrQ0h1XqST3eQx9cx9F1521prSL/GVOHNKXy++fbiFAtbRS+9Z4KlHv5NYIK/6M
         ieWtTtwNDRfXjRA6UNbpyUvbMCwMFmeAOeaQP+w2dQ4HUFk6zaaKQ1i+7IZxXa875Odd
         3G5XgBjiEcdaQl3XI55runKJxEne0N5pryVY/6fWwSM8WLRKtNItpMgFtHi/DQ3yuoua
         I/UAmq6LlDONgCa07emiGuGw3oPtzhgstq4xAezeJPXZuvj9j2G/y39ZSbFPofG2AdDz
         u0zA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713884757; x=1714489557;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IBa5mK88uNPh7mBsQdtczbuGlBv1JXXU73/DcJ6dpWI=;
        b=nk1E3yzGtUjm+qv1QTAJasWGPBzDbrZ0mkcMq2hcULf5y+BV/cA+Sog6mm0y3evVyR
         +L6abZ6TXm97DBV+VwRemAgLml/tXgOvz4uJYUAZUV3jidJmpFYiH+w1yuQEQYHlOBOM
         N3cqf1FVvDIBm+Ut7thnLPeC0LwLZvVWrpVlisVU4J0jZOoWbAfdCzJ5PIRa30VTUHMw
         O7YTIrwYaOFjNY7ptF9VVvuEwjhfIDUF/m2cUNjpVIG/XfuplkKLYxsTHyKT4kT3Iskv
         Iafj1g3TjQQPTPg10zdggW1zcHk1fO7pxedu0sidQRX/nsx1e4ARc54YdE4Y+1xWWs/G
         XgQQ==
X-Gm-Message-State: AOJu0YxTn0d4/Csmf9S1HjGrQIzF9SnEEYXNLyk3S5NFXo0lFGeFswKt
	3bfYpNGeuXErX3GuYtiHPHr2VtUBsRei0mb+dHoRooXO0CIiF4ZtYUnRakB2GNipTxTMnSHVqBL
	urRfCeWwov121d7bpvRzZyPupfryk+mQcjSkLGKzxZDcfhByIeunqXX7soKyjr4xawHhJzTVmbd
	MkNzOTWmfJqm6lZ9RDNpSBbD3mLf4=
X-Google-Smtp-Source: AGHT+IHGpoCwosQMqoYqtm7YjKXgsuQlAWAVV5gMt37RCePQ0StGreVdydyRj3UoU6nHiUmg/6pfw8pBZg==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a05:600c:2d55:b0:418:9a5b:d68 with SMTP id
 a21-20020a05600c2d5500b004189a5b0d68mr25959wmg.2.1713884756793; Tue, 23 Apr
 2024 08:05:56 -0700 (PDT)
Date: Tue, 23 Apr 2024 16:05:15 +0100
In-Reply-To: <20240423150538.2103045-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240423150538.2103045-1-tabba@google.com>
X-Mailer: git-send-email 2.44.0.769.g3c40516874-goog
Message-ID: <20240423150538.2103045-8-tabba@google.com>
Subject: [PATCH v4 07/30] KVM: arm64: Check for PTE validity when checking for executable/cacheable
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

