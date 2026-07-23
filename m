Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com [209.85.221.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AE3D3B8BDA
	for <kvmarm@lists.linux.dev>; Thu, 23 Jul 2026 18:21:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784830919; cv=none; b=VA9O2L8AJZ91U1DHYqQYTbaFG6PDXMBZ41ARb4z63s+tyCnXF4uABheLjuZtOwDuS/Y0tvUKGzh/TFlV0E2rinPyvUYYJcBb/sCk9rQFq3nk0J+buzs6XNNEclFGlDhfaXjdlOaZLHZNpsTwfJmg7i76L+99TgXs+qvU7n5E5/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784830919; c=relaxed/simple;
	bh=0tb67XafB5UfHWrQ/N2Zv8/FnZ2jU3xBrAVpocbKjDE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=q/sBHG+VfH4umbm023UEB4qLqtt6QE25k8dEpEzsc24R2NX+u9ByXXGdOF1U9mUbE/2CxJzdJrBm1f/rAsHA4PR/5nUn4n+fNHkyXqO54kM/5c4/gCd02PC1SJ6AnbFCT+golq77Oj8YONVzhnG/AN0LNJ450NjdFWz+/koJfFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=qUGUbYXf; arc=none smtp.client-ip=209.85.221.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qUGUbYXf"
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-47407691804so749125f8f.1
        for <kvmarm@lists.linux.dev>; Thu, 23 Jul 2026 11:21:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784830911; x=1785435711; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=N52o3BVp773wN3Idd00jSA0m0Lpy2g57ImYGMyeejhc=;
        b=qUGUbYXfgFxIF//FYZTB8XYQ7YwQOqPXtLpUJr/41AFIh3iltcpDMz9W73h1iX47Vh
         jU4beBIWhk9sInCCsP/AzfKpt5HMkHUVhAS1jh+y/4eyIbZhsWXiinBDPN5AR9/UaSUa
         NRIVOnQGQgILrY4+2pRqhGzCKrB1XI7GPPjzDCZIuVBjLmQzB+QEOb41/lLgqUT7risz
         K/N5J44CNiPQaFYVAS26h4lDLW+4BtaFY8bMc38DdIzKLrK/Z/C0X5f3ZftPzFx3W6FK
         Uspzb+37RT623h78rvWGydV9PtEc2fT/aID8BO3URwckti/69YGw0Cja8RsmX8xcPBEZ
         lbUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784830911; x=1785435711;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=N52o3BVp773wN3Idd00jSA0m0Lpy2g57ImYGMyeejhc=;
        b=eZa4IlZot0fwj6x3+2Tq+keKU/JYiCI0Z49wm2v4YeuLQHRQIbeeMkFujAAgojUTK7
         s0Oe6RK6TVEuN6YRiPmR+hAJfeB6cdijkdNARvVgfDrh94aJQOTjytFECgkkhQWtw+XU
         JypzvgAE8jHhuZ0B3VRrF6mIY/lp+hYJKy2jAnuZp1AdC9C+hrgjEF/hH06BosOyb+8m
         Mk7CfpNpyTrEZnyTfC2xoHoJpGOVDtqnOj6aecmvZzkf7JfqmyT8KIDD/Z7F3gVTwnlY
         Ggnk1udu13HCD+wEgvoT0ArZOuIlyFDSZXO7KlJcsOQ/TXRnMy6pS89G5AaFh0emaal2
         Y6HQ==
X-Forwarded-Encrypted: i=1; AHgh+RqbhI9mHnFeE84Jdm37q1VdbYX15HPBXLuQN14Bhr40vYePFM1pzsONQ05NKn0AuZI6TwQYsXo=@lists.linux.dev
X-Gm-Message-State: AOJu0YxVMcF3hE0oc1ECt0C3Yz3lnCJiuiS4qG0dH9+kKvyULQRuGL44
	j58YWQ7VuwwxIWwqmwFz+okd7dfC8dQLGa6xp4dQoYaY/J50EL9YWLGXX7g6oOkAHElSvv/PpIF
	EDWe8Ahx9qxky4g==
X-Received: from wrhm19.prod.google.com ([2002:a05:6000:1813:b0:472:9520:f359])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a7b:c84c:0:b0:495:3eb2:b763 with SMTP id 5b1f17b1804b1-49573cffa2emr35967485e9.21.1784830911229;
 Thu, 23 Jul 2026 11:21:51 -0700 (PDT)
Date: Thu, 23 Jul 2026 18:21:40 +0000
In-Reply-To: <20260723182140.4025575-1-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260723182140.4025575-1-smostafa@google.com>
X-Mailer: git-send-email 2.55.0.229.g6434b31f56-goog
Message-ID: <20260723182140.4025575-3-smostafa@google.com>
Subject: [RFC PATCH v2 2/2] KVM: arm64: Support BBM level 3
From: Mostafa Saleh <smostafa@google.com>
To: linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oupton@kernel.org, seiden@linux.ibm.com, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, will@kernel.org, vdonnefort@google.com, 
	tabba@google.com, sebastianene@google.com, keirf@google.com, 
	linu.cherian@arm.com, Mostafa Saleh <smostafa@google.com>
Content-Type: text/plain; charset="UTF-8"

If the system supports hardware Break-Before-Make (BBM) level 3, use it
to replace stage-2 PTEs directly. Otherwise, fall back to the software
BBM sequence.

For BBML3 the sequence is:
1) Get a reference count on the containing table for the new PTE.
2) Atomically update the PTE with the new valid descriptor.
3) Invalidate the TLB for the old PTE.
4) Drop the reference count holding the old PTE.

One interesting case, as BBML3 will update the PTE atomically, it
can only know it raced with another core at the point of the cmpxchg
failing, unlike the SW implementation which locks the PTE first.
And as we must issue CMOs to the new mapped page before the update,
that means with BBML3 racing cores will issue redundant CMOs.
To avoid this, limit BBML3 support for systems with DIC and FWB,
which does not require CMOs.

Signed-off-by: Mostafa Saleh <smostafa@google.com>
---
 arch/arm64/kvm/hyp/pgtable.c | 58 +++++++++++++++++++++++++++++++-----
 1 file changed, 51 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index d670da8882a5..4644b596f020 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -835,10 +835,24 @@ static void stage2_clean_old_pte(const struct kvm_pgtable_visit_ctx *ctx,
 		mm_ops->put_page(ctx->ptep);
 }
 
+/*
+ * We assume that KVM will never change the OA of an active translation.
+ * If the host needs to move the backing PFN, it should do an explicit
+ * unmap to issue the required TLBI.
+ */
+static bool stage2_use_bbml3(void)
+{
+	return system_supports_bbml3() &&
+	       cpus_have_final_cap(ARM64_HAS_STAGE2_FWB) &&
+	       cpus_have_final_cap(ARM64_HAS_CACHE_DIC);
+}
+
 /**
  * stage2_try_break_pte() - Invalidates a pte according to the
  *			    'break-before-make' requirements of the
- *			    architecture.
+ *			    architecture, if BMML3 is supported it
+ *			    will be used, meaning that this function
+ *			    won't break the PTE.
  *
  * @ctx: context of the visited pte.
  * @mmu: stage-2 mmu
@@ -854,6 +868,10 @@ static bool stage2_try_break_pte(const struct kvm_pgtable_visit_ctx *ctx,
 {
 	kvm_pte_t locked_pte;
 
+	/* All handled in stage2_make_pte() */
+	if (stage2_use_bbml3() && kvm_pte_valid(ctx->old))
+		return true;
+
 	if (stage2_pte_is_locked(ctx->old)) {
 		/*
 		 * Should never occur if this walker has exclusive access to the
@@ -873,16 +891,35 @@ static bool stage2_try_break_pte(const struct kvm_pgtable_visit_ctx *ctx,
 	return true;
 }
 
-static void stage2_make_pte(const struct kvm_pgtable_visit_ctx *ctx, kvm_pte_t new)
+static bool stage2_make_pte(const struct kvm_pgtable_visit_ctx *ctx, struct kvm_s2_mmu *mmu,
+			    kvm_pte_t new)
 {
 	struct kvm_pgtable_mm_ops *mm_ops = ctx->mm_ops;
 
-	WARN_ON(!stage2_pte_is_locked(*ctx->ptep));
-
 	if (stage2_pte_is_counted(new))
 		mm_ops->get_page(ctx->ptep);
 
+	if (stage2_use_bbml3() && kvm_pte_valid(ctx->old)) {
+		/*
+		 * Barrier is required because stage2_try_set_pte() uses
+		 * WRITE_ONCE for non-shared walks, lacking release semantics
+		 * used in the software BBM case.
+		 */
+		smp_wmb();
+		if (!stage2_try_set_pte(ctx, new)) {
+			/* Raced with another core. */
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
@@ -1014,7 +1051,8 @@ static int stage2_map_walker_try_leaf(const struct kvm_pgtable_visit_ctx *ctx,
 	    stage2_pte_executable(new))
 		mm_ops->icache_inval_pou(kvm_pte_follow(new, mm_ops), granule);
 
-	stage2_make_pte(ctx, new);
+	if (!stage2_make_pte(ctx, data->mmu, new))
+		return -EAGAIN;
 
 	return 0;
 }
@@ -1069,7 +1107,10 @@ static int stage2_map_walk_leaf(const struct kvm_pgtable_visit_ctx *ctx,
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
@@ -1560,7 +1601,10 @@ static int stage2_split_walker(const struct kvm_pgtable_visit_ctx *ctx,
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

