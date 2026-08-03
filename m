Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com [209.85.128.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEFAB34027B
	for <kvmarm@lists.linux.dev>; Mon,  3 Aug 2026 10:10:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785751856; cv=none; b=Yn34R4brkQcuvPR4fXYX9lDb50WVk5co06fuLCzcBVl8dOF9eQP7KilGA/juYw6wciEmyqhK+XXQOY2IIeW3YSvfquyhD49dtMFAtT6xRxYMn60bAXm7Dj+dX8HAEwIPsdl/g+YWin2+xjVvDD1y+kDvMeU1Ib+9iR7doGiF9q0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785751856; c=relaxed/simple;
	bh=FDdkEvPejmXsCvVyZ2Lla8KpV9sLGSaxRm+WfBbhnmI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=a+4hKwm3VAIKYCTL4Ur/idT6jii1phiJCAouiaL7odaxk9hd2jt9xaswaGWWU0SNjJAsfe41ZCss8TFrlfgQKGcxQhACQWrO6iJMG88qenRq48sSQozp1/igUh1puTXoz0QtKBPEw63aHdUFXFPuviziWrqWP5Ein4IYJpsPOeg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=AWvL0BvO; arc=none smtp.client-ip=209.85.128.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="AWvL0BvO"
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-49554715277so17968515e9.1
        for <kvmarm@lists.linux.dev>; Mon, 03 Aug 2026 03:10:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785751853; x=1786356653; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=bcrHsg0qcfO16N3JWjbmr3Z8a3Wp5JQC0FcWux6rQJw=;
        b=AWvL0BvO8KrCgLBZEg0ODjD4Uo2nZvo+UsQiRVaMHx62vJYdNHlPztUMLOzVXTGGY7
         txPn0W0ErcoX0RWHj99cTLCL0U9AbNEP5BpxLiS+1JIwlizCk2IPwOwJsN/ObEVOXMTu
         5y5C9YafwR/H0CUJotwCTIFklsjjXYAN3mPiL1eSwVI1+y5bKiVMZ5JDoBvZu+JWq0MC
         MiGzUkngp5Xr2wQbMHLQknoc4JuIfpP2YG7TMLM2g/WDGc16HGOpbGBYhBNZoE/VxCa0
         0iyZ47pZId1H3KYae8yRWzoQU5Q3hh8wjFF5j3lOFHyUzxFP3Xj06Af1zRZhsYcnbSTR
         26qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785751853; x=1786356653;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=bcrHsg0qcfO16N3JWjbmr3Z8a3Wp5JQC0FcWux6rQJw=;
        b=HJ07KOz3evPz4N84WLq7QXHMYOc4YOY1YhDx4d5x1EZL53ij6QEzAu7YfwmmK8gPxM
         /I5kSCKlDd12220UsMt/AETrK2Zn52C1xLhrX2X3fdJmS9j5V37wh6epE5Fs8dQLl2mJ
         Br8XOMICT8il6viyQBkZCtiYIseOn7u8/fhYyV5lJpqk/TjL1R2NajVFrHt3RLFhE86r
         E/J+cbW8/Pwyw1yCwZxr2zTOg5naBNnoTukmfcFkuaakUlXqbcse+tQTfKMxK+p8Dw1M
         LMVZIU5E68N0NtVJVesfolMhBVb56Fn5GNyE1V5HZ+2I796E1hQF7+CTNHeIyZCr0E6h
         mSuQ==
X-Forwarded-Encrypted: i=1; AHgh+Rq5VpBtiHRigmMDBt74HnhgdhzbzvaKfHa8BeDfzKOYluud+s+ixnHz0Oy3tdpFE20l8OXpSck=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz4myZtUF2WbuV7JEG3roPYxEMuwCN+3JF3jZi3yvwlLmNibz1x
	ic1x9lq1ae1gDy6GU9qXN9OyI6LZEtt/nu0mnGuRoFGCa/wfQOrP6NWJzi39mSrVGz8wMOY0TfO
	CL5jTHUAGEvX0fKHCfInygA==
X-Received: from wmox20.prod.google.com ([2002:a05:600c:1794:b0:495:5204:e932])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:4453:b0:495:6274:56c2 with SMTP id 5b1f17b1804b1-4980c649c6emr195270835e9.2.1785751852702;
 Mon, 03 Aug 2026 03:10:52 -0700 (PDT)
Date: Mon,  3 Aug 2026 11:08:45 +0100
In-Reply-To: <20260803100904.3563942-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260803100904.3563942-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.55.0.508.g3f0d502094-goog
Message-ID: <20260803100904.3563942-2-vdonnefort@google.com>
Subject: [PATCH 01/20] KVM: arm64: Prefault host stage-2 entries on block split
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, 
	kernel-team@android.com, fuad.tabba@linux.dev, qperret@google.com, 
	keirf@google.com, Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

From: Keir Fraser <keirf@google.com>

For the host stage-2 that is idmap, we can avoid lazy-mapping on block
splitting by propagate existing valid mappings to neighbouring entries
of the new table.

Co-developed-by: Quentin Perret <qperret@google.com>
Signed-off-by: Keir Fraser <keirf@google.com>
Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index b74dd5ce1efd..34f78a58cded 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -1030,10 +1030,39 @@ static int stage2_map_walk_table_pre(const struct kvm_pgtable_visit_ctx *ctx,
 	return 0;
 }
 
+static void stage2_map_prefault_idmap(const struct kvm_pgtable_visit_ctx *ctx, kvm_pte_t *ptep)
+{
+	kvm_pte_t block_pte = ctx->old;
+	u64 pa;
+	int i;
+
+	if (!kvm_pte_valid(block_pte))
+		return;
+
+	pa = ALIGN_DOWN(ctx->addr, kvm_granule_size(ctx->level));
+	for (i = 0; i < PTRS_PER_PTE; ++i, ++ptep, pa += kvm_granule_size(ctx->level + 1)) {
+		kvm_pte_t pte = kvm_init_valid_leaf_pte(pa, block_pte, ctx->level + 1);
+
+		/*
+		 * Skip ptes in the range being modified by the caller if we're
+		 * installing last level entries. Otherwise, we need to
+		 * temporarily put in a valid mapping to make sure the
+		 * prefaulting logic is triggered on the next
+		 * stage2_map_walk_leaf(). This adds an unnecessary TLBI as
+		 * we'll presumably re-break the freshly installed block, but
+		 * that should happen very infrequently.
+		 */
+		if ((ctx->level < (KVM_PGTABLE_LAST_LEVEL - 1)) ||
+		    (pa < ctx->addr) || (pa >= ctx->end))
+			*ptep = pte;
+	}
+}
+
 static int stage2_map_walk_leaf(const struct kvm_pgtable_visit_ctx *ctx,
 				struct stage2_map_data *data)
 {
 	struct kvm_pgtable_mm_ops *mm_ops = ctx->mm_ops;
+	struct kvm_pgtable *pgt = data->mmu->pgt;
 	kvm_pte_t *childp, new;
 	int ret;
 
@@ -1051,6 +1080,9 @@ static int stage2_map_walk_leaf(const struct kvm_pgtable_visit_ctx *ctx,
 	if (!childp)
 		return -ENOMEM;
 
+	if (pgt->flags & KVM_PGTABLE_S2_IDMAP)
+		stage2_map_prefault_idmap(ctx, childp);
+
 	if (!stage2_try_break_pte(ctx, data->mmu)) {
 		mm_ops->put_page(childp);
 		return -EAGAIN;
-- 
2.55.0.508.g3f0d502094-goog

