Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B69173F870E
	for <kvmarm@lists.linux.dev>; Fri, 17 Jul 2026 13:09:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784293751; cv=none; b=uMAx7IKfsjF2iYGYMdKA4h0rtB3ciPVNgVQajlVOSjNSR8R3R7lTeeLN+AVia0nRAP1x4bTjBIl8zOuvVLk0gpLycvuax6iCrrJZktypeHeGIxA3lmWRKrioMc6oNqFWC69NYxyACl19r5N6LFt4SNuVjD+ii0fqn/htpu6uZS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784293751; c=relaxed/simple;
	bh=Mjz8ivQNJtbkbZVgumLby1xtvMOe4isndBrW/gdbi9E=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=TlEQtARkjR+nHy61S0818HgMAPg7vgI9RIT4xr3q2y6AprCYI0WsbnbapDZa7o9h9d+Ztq9QZ9Z9u2vhw4K5oCyIUA9oftGHNoSWl8y1BK25yZDPqfV16I7lVbs5ITJ5VZLX61lOkOzcEqHmIi3ltNiiSccfzu3GF0Z5Igh6q1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=bYdKzV0K; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bYdKzV0K"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-49545755b03so12826775e9.0
        for <kvmarm@lists.linux.dev>; Fri, 17 Jul 2026 06:09:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784293748; x=1784898548; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+n0quTBKTLkuwq9QawKwspQRW3gBb6Rua2VTww6C7Lw=;
        b=bYdKzV0KxTMHoJgDMGdSCL7KawKeHupyHCyT6I3SuJ6mYqeXSn9bIALYdxZTEcAu8W
         IpsfMa+37sACFoPcEQO8Ij77TZ1wEJslOtGSUDIYuOiJAQPnIpOW6HbGcAvnDGOxXldm
         AMQsWDgbB6+oVF/T0VUypcb9nq6YD30kuS6AkrhbCJWTTaX7RjsJSSUrmQzQ40Lf5bs+
         6yzZaB4ktyI0rZj3jMYL7oLDeyZPyur/oTQtjQR8pNb8hM62zL6JKpGRTjFLmpyepGdI
         0lnqWoOUR3zpX6zWVhkirX0T+mWVH1F5t5AFP17q2GhOoTgWLlopSsrjEH6z6aWSZd+7
         sxpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784293748; x=1784898548;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=+n0quTBKTLkuwq9QawKwspQRW3gBb6Rua2VTww6C7Lw=;
        b=jbqCb9wnUnqiCo1+VnENmzsLYnKDgZcmabLOyIHT6gh5myaQaALteiWRjKfbolVuiU
         oGvfajv/oIlzjXo4AHQuSVuvAsPHT60UEBagqFDhymNmMOPJEufHUk9UPAeaw2HkMf/0
         gN8BL7b3jZlMg6yMubzC5bZtG6vbYmsDPcvYKeHTfrd+f+AvWEu4n3bc+AsK2uaydRcJ
         uJ46FqU4D8z3Xn3bdJXLI6daR1wCyOSQ/cAV9QxbuLsdfZBRkBgyRdtcjFrBEjFQjoyf
         3eCtQXXQzYQKxlu3ZRsAs9pQQyI7dYML2ZMDlYFhKycrPlsfZ7qcPegM50esjET95tDZ
         XttQ==
X-Forwarded-Encrypted: i=1; AHgh+RoJ2DUaTZ8Pmuc4XJprEN9DTv2fxMkDFIeer+KkFQE+JJ9zMphPoy7L24Dnesvvl2R8yrvtONw=@lists.linux.dev
X-Gm-Message-State: AOJu0YxZBE5Pp4YZy73Yk+d7CD2Nly/NhkvfNPe7FKIuJKU02qRU6IHP
	G65858DCNMwqf87tqQfyicRrR6iD5WJ+7CxVULPkZCCFhUHZjVTNNnfJB4cohwhov8L5twzB2Zn
	M/ENmkBnqqi6p+A==
X-Received: from wrbcg5.prod.google.com ([2002:a5d:5cc5:0:b0:47f:4f99:b306])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:154e:b0:495:49eb:1ccc with SMTP id 5b1f17b1804b1-4954a3eff56mr32478345e9.13.1784293747452;
 Fri, 17 Jul 2026 06:09:07 -0700 (PDT)
Date: Fri, 17 Jul 2026 13:09:00 +0000
In-Reply-To: <20260717130901.2239134-1-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260717130901.2239134-1-smostafa@google.com>
X-Mailer: git-send-email 2.55.0.229.g6434b31f56-goog
Message-ID: <20260717130901.2239134-3-smostafa@google.com>
Subject: [RFC PATCH 2/2] KVM: arm64: Support BBM level 3
From: Mostafa Saleh <smostafa@google.com>
To: linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oupton@kernel.org, seiden@linux.ibm.com, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, will@kernel.org, vdonnefort@google.com, 
	tabba@google.com, Mostafa Saleh <smostafa@google.com>
Content-Type: text/plain; charset="UTF-8"

If the system supports hardware Break-Before-Make (BBM) level 3, use it
to replace stage-2 PTEs directly instead of falling back to the software
break-before-make sequence.

1) Get a reference count on the containing table for the new PTE.
2) Atomically update the PTE with the new valid descriptor.
3) Invalidate the TLB for the old PTE.
4) Drop the reference count holding the old PTE.

One interesting case, as BBML3 will update the PTE atomically, it
can only know it raced with another core at the point of the cmpxchg
failing, unlike the SW implementation which locks the PTE first.
And as we must issue CMOs to the new mapped page before the update,
that means with BBML3 racing cores will issue redundant CMOs,
to improve this:
- We only use BBML3 if the old PTE was live.
- To reduce the window of the race, an early check is added before
  the CMO to exit early, but that does not eliminate the race.

Signed-off-by: Mostafa Saleh <smostafa@google.com>
---
 arch/arm64/kvm/hyp/pgtable.c | 53 +++++++++++++++++++++++++++++++-----
 1 file changed, 46 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index 127b7f9541b1..69d52308236f 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -838,7 +838,8 @@ static void stage2_clean_old_pte(const struct kvm_pgtable_visit_ctx *ctx,
 /**
  * stage2_try_break_pte() - Invalidates a pte according to the
  *			    'break-before-make' requirements of the
- *			    architecture.
+ *			    architecture, if BMML3 is supported it
+ *			    will be used, otherwise fallback to SW.
  *
  * @ctx: context of the visited pte.
  * @mmu: stage-2 mmu
@@ -854,6 +855,18 @@ static bool stage2_try_break_pte(const struct kvm_pgtable_visit_ctx *ctx,
 {
 	kvm_pte_t locked_pte;
 
+	if (system_supports_bbml3() && kvm_pte_valid(ctx->old)) {
+		kvm_pte_t curr_pte = READ_ONCE(*ctx->ptep);
+
+		/*
+		 * All handled in stage2_make_pte(). However exit early if we already
+		 * lost the race to avoid extra CMOs.
+		 */
+		 if (curr_pte != ctx->old)
+			return false;
+		 return true;
+	}
+
 	if (stage2_pte_is_locked(ctx->old)) {
 		/*
 		 * Should never occur if this walker has exclusive access to the
@@ -873,16 +886,35 @@ static bool stage2_try_break_pte(const struct kvm_pgtable_visit_ctx *ctx,
 	return true;
 }
 
-static void stage2_make_pte(const struct kvm_pgtable_visit_ctx *ctx, kvm_pte_t new)
+/* Must be paired with stage2_try_break_pte() */
+static bool stage2_make_pte(const struct kvm_pgtable_visit_ctx *ctx, struct kvm_s2_mmu *mmu,
+			    kvm_pte_t new)
 {
 	struct kvm_pgtable_mm_ops *mm_ops = ctx->mm_ops;
 
-	WARN_ON(!stage2_pte_is_locked(*ctx->ptep));
-
 	if (stage2_pte_is_counted(new))
 		mm_ops->get_page(ctx->ptep);
 
+	if (system_supports_bbml3() && kvm_pte_valid(ctx->old)) {
+		/*
+		 * Barrier is required because stage2_try_set_pte() uses
+		 * WRITE_ONCE for non-shared walks, lacking release semantics
+		 * used in the software BBM case.
+		 */
+		smp_wmb();
+		if (!stage2_try_set_pte(ctx, new)) {
+			if (stage2_pte_is_counted(new))
+				mm_ops->put_page(ctx->ptep);
+			return false;
+		}
+
+		stage2_clean_old_pte(ctx, mmu);
+		return true;
+	}
+
+	WARN_ON(!stage2_pte_is_locked(*ctx->ptep));
 	smp_store_release(ctx->ptep, new);
+	return true;
 }
 
 static bool stage2_unmap_defer_tlb_flush(struct kvm_pgtable *pgt)
@@ -1014,7 +1046,8 @@ static int stage2_map_walker_try_leaf(const struct kvm_pgtable_visit_ctx *ctx,
 	    stage2_pte_executable(new))
 		mm_ops->icache_inval_pou(kvm_pte_follow(new, mm_ops), granule);
 
-	stage2_make_pte(ctx, new);
+	if (!stage2_make_pte(ctx, data->mmu, new))
+		return -EAGAIN;
 
 	return 0;
 }
@@ -1069,7 +1102,10 @@ static int stage2_map_walk_leaf(const struct kvm_pgtable_visit_ctx *ctx,
 	 * will be mapped lazily.
 	 */
 	new = kvm_init_table_pte(childp, mm_ops);
-	stage2_make_pte(ctx, new);
+	if (!stage2_make_pte(ctx, data->mmu, new)) {
+		mm_ops->put_page(childp);
+		return -EAGAIN;
+	}
 
 	return 0;
 }
@@ -1557,7 +1593,10 @@ static int stage2_split_walker(const struct kvm_pgtable_visit_ctx *ctx,
 	 * writes the PTE using smp_store_release().
 	 */
 	new = kvm_init_table_pte(childp, mm_ops);
-	stage2_make_pte(ctx, new);
+	if (!stage2_make_pte(ctx, mmu, new)) {
+		kvm_pgtable_stage2_free_unlinked(mm_ops, childp, level);
+		return -EAGAIN;
+	}
 	return 0;
 }
 
-- 
2.55.0.229.g6434b31f56-goog

