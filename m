Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com [209.85.128.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDA7213D886
	for <kvmarm@lists.linux.dev>; Fri, 11 Sep 2026 13:51:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789134668; cv=none; b=a2L0sagVBCZPkFG8JwAy2y4Ck9YaMqCQv60XinHXs/KtJI3Rb/gWFq99po0LF6W1WJn9UEUFzn8n61OX0EqVYONesETjFYw12Kecnir4bE6hOkd13KlbJq/KkKNtnbnXuJ/ULynF47mLECHUlhkX6PCnkLumg4b0/XMkQh2DIoY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789134668; c=relaxed/simple;
	bh=kJZLWwGlo141f4iwI7DpARuqwQYPLQwIQaUlzBAEj6g=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=X0YopiYZuLWPYrydfeLgeWAoei5HNvEXmhwCTTdYW1gOuZz+43WFKM2dTlZxY2rCHLI0GAVPOu+BGv3lumCiGA9K+i+t/GOnIl8uw1918fE2NeAqE0bW7P18CcW8akN91BVceM2/L6VyyJV85B/UbKVdGgs8tcpAvvzeJcFaMbo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=UPOIrF2+; arc=none smtp.client-ip=209.85.128.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="UPOIrF2+"
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-49e65f2f1baso3986105e9.3
        for <kvmarm@lists.linux.dev>; Fri, 11 Sep 2026 06:51:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789134665; x=1789739465; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=vyZHHI9O+Y8MPWjOIqoFkiQzmwGCk/ETPmyIccR863I=;
        b=UPOIrF2+NyB42zeThaF00zy7W+OxCCFmTmjNoaHglvdgDUnlXQMeS3pKJnutbZpfau
         e6mNxAXR1Lr5ThYIitfC5B1b/K4KM7AvuHW42rs0nvtR/O2zKS3Pta1Edn/K680Yqaqd
         FTLkGKHGUT4QkV695Utp9DR5hGccKY7HTJn26fp+85YWj+Q4qU7j2TTq3BufK4gBAcPg
         sE5WDyGatLX0g9iXnjSWcY8vyMstrXbNxg+RPYFA11txcU0LN82RJdI73JfiI2BpAE4x
         YXyg0c4B473ALWHP3kPkqYmDF3HL7F9d7845DoKgBWlWVYYEc6ka/2pYU8yYg8HkyOv9
         q/WQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789134665; x=1789739465;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=vyZHHI9O+Y8MPWjOIqoFkiQzmwGCk/ETPmyIccR863I=;
        b=oFP1pAghVzJH6j9okNq5d1I1jiNeg0Hx1kx4N2TDTMgG4P0ryv+9O2qsc+zxDltIML
         4rzwfh3+LyVUzBLRVaB7NEkYjQzF3foeoe42cc5RTWJ6S8E+2RN9/NkduSrDwsI+BDUt
         SzeuvmYolS/1KaOO4UyjfsdZzkBwQwrZcUc4m1YIcvNmpKOnWFGDyly/8Tov3BquYJpP
         o4loGkf/mfK2FUYgjh72jwMHcKCikOFCfz5qcfEKF8oo+QG7IOqOVgfeau8y083GJXY6
         kfzQJ8Fge8Htn+2o9FowMdSnthQNb8R9aTueoZYsPFJOLHyWswHA2OtjaAUx00MGWGWE
         tFIw==
X-Forwarded-Encrypted: i=1; AKwUvByblULa+kyTr+JnTi/sSFKEN7fuo0h2LPs7QIQUsQ2zAGrYCaIBRcMgLfyOamr4L7scKv8yc7E=@lists.linux.dev
X-Gm-Message-State: AFuF++l83pRJWy0OdvTJ2Rg09Exu7Xw1RqcGYvLLIO1JJ21JhOQKdEP0
	uAEnyyFeYlTldIF0i+teYxEv2xNI50mSKspr8FhlFjKVt1Tgd1i6ymjA2KrE3YzdHpmMt+2z1Ms
	PgkkIT2ryAtlP0zHKUzPvbQ==
X-Received: from wmhn1.prod.google.com ([2002:a05:600c:3041:b0:49c:da85:4930])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:c490:b0:49c:ffde:45ff with SMTP id 5b1f17b1804b1-49e619c18e0mr50622335e9.17.1789134664664;
 Fri, 11 Sep 2026 06:51:04 -0700 (PDT)
Date: Fri, 11 Sep 2026 14:50:34 +0100
In-Reply-To: <20260911135053.146435-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260911135053.146435-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.55.0.1007.g17ff1f9808-goog
Message-ID: <20260911135053.146435-4-vdonnefort@google.com>
Subject: [PATCH v2 03/22] KVM: arm64: Allow block-level stage-2 annotation
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, 
	kernel-team@android.com, fuad.tabba@linux.dev, qperret@google.com, 
	weilin.chang@arm.com, Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

On host to guest donation, pKVM annotates the host stage-2 invalid
entries with the GFN. Now that the host stage-2 preserves annotations on
block split, we can allow these annotations at block-level. This enables
safe support for guest stage-2 huge mappings.

Allowing block-level annotations also reduces stage-2 fragmentation when
unmapping a huge region, and reduces host stage-2 memory usage by
avoiding the allocation of intermediate page tables.

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
---
 arch/arm64/kvm/hyp/pgtable.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index 0ca157ecee64..c4ebae0544d4 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -947,9 +947,6 @@ static bool stage2_leaf_mapping_allowed(const struct kvm_pgtable_visit_ctx *ctx,
 	if (data->force_pte && ctx->level < KVM_PGTABLE_LAST_LEVEL)
 		return false;
 
-	if (data->annotation)
-		return true;
-
 	return kvm_block_mapping_supported(ctx, phys);
 }
 
@@ -1178,7 +1175,6 @@ int kvm_pgtable_stage2_annotate(struct kvm_pgtable *pgt, u64 addr, u64 size,
 	struct stage2_map_data map_data = {
 		.mmu		= pgt->mmu,
 		.memcache	= mc,
-		.force_pte	= true,
 		.annotation	= true,
 		.pte_annot	= pte_annot |
 				  FIELD_PREP(KVM_INVALID_PTE_TYPE_MASK, type),
-- 
2.55.0.1007.g17ff1f9808-goog

