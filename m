Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com [209.85.128.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5B5A3BB9F7
	for <kvmarm@lists.linux.dev>; Thu, 23 Jul 2026 18:21:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784830919; cv=none; b=Pcp1jUbS6LbHtshjfmZvDtmYTl9Wq8ttCMEIX3zaa7VyBVt4IhtZtIRhuf+cuaXAIrlDMQ3BVUe65/z7KeAM1qqzP78afQGgWPdmILF7dFXzamcjYs2iCX8Km1OIyc2r51nq4p2U6pyFbYk+0HU14gMUsjX4Q1cqLuQB0fojXas=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784830919; c=relaxed/simple;
	bh=mMr1WmosQxXB2EcGfwJiQaiR9DVyE3hjJJoEXxfwmHY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=u4HcFykyNnWcfx0Nbp5fDLV+gtJ/synpF9c+x4edvTfvfzpvWQcmuPo7sapu0BsSj5XVpm1C0VgFFjNKK3h8UL+i5qq9+jhZuek2T0Pii1BMOOffdCvPvQFpDyZQ4SoGTMaVavY75AvX1pvdfmqMDJs5rIhDtP4Vja/joX56tTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=wd81SMAn; arc=none smtp.client-ip=209.85.128.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="wd81SMAn"
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-495474a5fbcso9819215e9.1
        for <kvmarm@lists.linux.dev>; Thu, 23 Jul 2026 11:21:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784830908; x=1785435708; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=9FpdytHdhxDISqer6403yWjEFqnIJW3e2H1iU7+f5M0=;
        b=wd81SMAnolXBuZAIxcKsTJCPvvN7truMQQyu1T3EUdo1CB7Ca6C3FEmR9ICXELBf8M
         jQRN6HgK9dbGhXnTUx+ssNwFOhtm482h5WJtHgLPV7ZkWSK28cIiCuocbVL5k9slKMid
         AAMXF/wx4vyFhNyR85pVjx0PdlHVimn4wK2CslrPgaabXGAxLyyvpH9M+ORUJW/ZQXNv
         1V4maBXM+ARCBw1ZRzP4BUgpmUx+sThYr92JewipdT269UXVURMhTbT+lMlzZDcJHcWD
         bRixZAGHlLdCyeZbsMI8hcUSVYDBuQRgoxTOKOoJrGUFpazeTb+k/to3p+z5UNo/ZQMU
         Lprw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784830908; x=1785435708;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=9FpdytHdhxDISqer6403yWjEFqnIJW3e2H1iU7+f5M0=;
        b=oS/hAhoPoA0VdltuDMr5siVcr6aIM0ZqQO5mwO5LwJk9ajELvyU/28wnDBGJVzcxQO
         QJY/MH1J+ntij9PlffecP10YfByxGzN4T3kyAEGHs5yn0to38mY7+Nqx1sSCLaGgg+PM
         lHlpxwuLdLThiLGzLIe71S4w4L+NyV33PDtbaznmKTU0vuxkq8X0QW01MFOJOLjzXnFG
         I1Gc3VkEp3Fr2lXAbCOo1RrYU6EWTBUR12iBr8Fyxu0PrmTScgJ1kb4OjNbNNafZOJKH
         dx6TTlI4LivhDttPYApmphYtcw6sWIuvNqszf4H8Y/pqFM4fZdtOxciGIqHH7hf6Zran
         /3wA==
X-Forwarded-Encrypted: i=1; AHgh+Roc21iF+674uPeFZUx5W4nth3fIvhL0YccnkquJYU4oq/0dvYZy3L/9fjJQqlxWEegz/O7rU+k=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy1LaK29Haf5KvZQJSY/OvXmoe4bhEx7P/N1ltjBPxOOeqlO28x
	IjExM4d/LVdx45PBYs5NXHOKWYKLnUgow8vSOCuUlkfzaE1P6jQiqNcwGKOAWvjLtiEIqBR6iwo
	LyhADUeUkNEqREA==
X-Received: from wmbgw6.prod.google.com ([2002:a05:600c:8506:b0:495:4855:c65d])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:21c3:b0:493:f6e6:ce2a with SMTP id 5b1f17b1804b1-49573cbe93emr35666835e9.2.1784830908237;
 Thu, 23 Jul 2026 11:21:48 -0700 (PDT)
Date: Thu, 23 Jul 2026 18:21:39 +0000
In-Reply-To: <20260723182140.4025575-1-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260723182140.4025575-1-smostafa@google.com>
X-Mailer: git-send-email 2.55.0.229.g6434b31f56-goog
Message-ID: <20260723182140.4025575-2-smostafa@google.com>
Subject: [RFC PATCH v2 1/2] KVM: arm64: Add stage2_clean_old_pte()
From: Mostafa Saleh <smostafa@google.com>
To: linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oupton@kernel.org, seiden@linux.ibm.com, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, will@kernel.org, vdonnefort@google.com, 
	tabba@google.com, sebastianene@google.com, keirf@google.com, 
	linu.cherian@arm.com, Mostafa Saleh <smostafa@google.com>
Content-Type: text/plain; charset="UTF-8"

At the moment, the pgtable code rely on BBM in SW which looks like:
Break: stage2_try_break_pte()
	1) Break PTE and lock it
	2) TLBI
	3) Put the ref on the old PTE

Make: stage2_make_pte()
	1) Get a ref on the new PTE
	2) Install the new PTE

With BBML3, the sequence will look as
	1) Get ref on the new PTE
	2) Install new PTE
	3) TLBI
	4) Put the ref on the old PTE

Which requires moving step #2 #3 from the break function to the make
function, although it is possible to do that for SW BBM also, that
means the stage2_try_break_pte() did not fully break the PTE as it
is referenced in TLBs, although that works it seems fragile.

Instead, move this logic to a new function stage2_clean_old_pte()
so that can be called from BBML3.

Signed-off-by: Mostafa Saleh <smostafa@google.com>
---
 arch/arm64/kvm/hyp/pgtable.c | 67 ++++++++++++++++++++----------------
 1 file changed, 37 insertions(+), 30 deletions(-)

diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index b74dd5ce1efd..d670da8882a5 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -810,39 +810,10 @@ static bool stage2_try_set_pte(const struct kvm_pgtable_visit_ctx *ctx, kvm_pte_
 	return cmpxchg(ctx->ptep, ctx->old, new) == ctx->old;
 }
 
-/**
- * stage2_try_break_pte() - Invalidates a pte according to the
- *			    'break-before-make' requirements of the
- *			    architecture.
- *
- * @ctx: context of the visited pte.
- * @mmu: stage-2 mmu
- *
- * Returns: true if the pte was successfully broken.
- *
- * If the removed pte was valid, performs the necessary serialization and TLB
- * invalidation for the old value. For counted ptes, drops the reference count
- * on the containing table page.
- */
-static bool stage2_try_break_pte(const struct kvm_pgtable_visit_ctx *ctx,
+static void stage2_clean_old_pte(const struct kvm_pgtable_visit_ctx *ctx,
 				 struct kvm_s2_mmu *mmu)
 {
 	struct kvm_pgtable_mm_ops *mm_ops = ctx->mm_ops;
-	kvm_pte_t locked_pte;
-
-	if (stage2_pte_is_locked(ctx->old)) {
-		/*
-		 * Should never occur if this walker has exclusive access to the
-		 * page tables.
-		 */
-		WARN_ON(!kvm_pgtable_walk_shared(ctx));
-		return false;
-	}
-
-	locked_pte = FIELD_PREP(KVM_INVALID_PTE_TYPE_MASK,
-				KVM_INVALID_PTE_TYPE_LOCKED);
-	if (!stage2_try_set_pte(ctx, locked_pte))
-		return false;
 
 	if (!kvm_pgtable_walk_skip_bbm_tlbi(ctx)) {
 		/*
@@ -862,6 +833,42 @@ static bool stage2_try_break_pte(const struct kvm_pgtable_visit_ctx *ctx,
 
 	if (stage2_pte_is_counted(ctx->old))
 		mm_ops->put_page(ctx->ptep);
+}
+
+/**
+ * stage2_try_break_pte() - Invalidates a pte according to the
+ *			    'break-before-make' requirements of the
+ *			    architecture.
+ *
+ * @ctx: context of the visited pte.
+ * @mmu: stage-2 mmu
+ *
+ * Returns: true if the pte was successfully broken.
+ *
+ * If the removed pte was valid, performs the necessary serialization and TLB
+ * invalidation for the old value. For counted ptes, drops the reference count
+ * on the containing table page.
+ */
+static bool stage2_try_break_pte(const struct kvm_pgtable_visit_ctx *ctx,
+				 struct kvm_s2_mmu *mmu)
+{
+	kvm_pte_t locked_pte;
+
+	if (stage2_pte_is_locked(ctx->old)) {
+		/*
+		 * Should never occur if this walker has exclusive access to the
+		 * page tables.
+		 */
+		WARN_ON(!kvm_pgtable_walk_shared(ctx));
+		return false;
+	}
+
+	locked_pte = FIELD_PREP(KVM_INVALID_PTE_TYPE_MASK,
+				KVM_INVALID_PTE_TYPE_LOCKED);
+	if (!stage2_try_set_pte(ctx, locked_pte))
+		return false;
+
+	stage2_clean_old_pte(ctx, mmu);
 
 	return true;
 }
-- 
2.55.0.229.g6434b31f56-goog

