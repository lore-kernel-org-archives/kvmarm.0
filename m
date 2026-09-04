Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com [209.85.128.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FD4949CF39
	for <kvmarm@lists.linux.dev>; Fri,  4 Sep 2026 13:30:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788528633; cv=none; b=CaCC4MjYWLjQd7Lr5/Bz88ooZed7XMEzaKozDixK3QLRFTs4q4v/4RHXO46lx/gTP7mEdKlrVS+GmqtlfgsvTZCiL2xbYtwLaBEL4T20hCBjUSdkm3c9W/wdkM+is9mHmHPTVDPhtycbjtRf0elcNrxaXIqaHVAnAf3XnF0+LN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788528633; c=relaxed/simple;
	bh=0/cxIaf84kQjvtYAX1of/WtRKCUsCKmhJOuRQ0QVo+Y=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=gRsvbuQgOkeGpn0tu1zpOoD5bhx2dwCi+k1c07vRTTzNEGEXkKQHM5dMSSJoQsbYIvbP9ido2oTl5QtPz8KX1V1mG6NfraUmssHf4Dt8wSmjxIdotpdcfns1zRlvT9qidzlSnoK2XNH3qE2nFV42dVjDMDB5+OqtSfzscm0pr+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=F0OEFW1x; arc=none smtp.client-ip=209.85.128.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="F0OEFW1x"
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-49ccf17d3b0so6691975e9.3
        for <kvmarm@lists.linux.dev>; Fri, 04 Sep 2026 06:30:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788528630; x=1789133430; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ul9UGPOILM7B5DmFYUwOQNUEy1YqQtqP63zgojN5NOI=;
        b=F0OEFW1xdtXkR/lmztZPKtcK3dalavP6XarMsb+aT2EVlXSMbQixTVqh7i8Yslz/2H
         IisD2QMQmxe/7aUUzvq4ee0wTN9MG5MfNTYTlH4YJe76848AfJDlj2ZGlZYp2c0tFjOz
         RUp5o+S/Gb5v/mdRWeMtzAfLoIdsX2UUZZshsfDnlxiKcsvYKt50VDori0CplLZXGFrv
         +bS4Ne/o/W5iLYZurc0d3WxR1EP5KLQOz8mPpfOL5hYD68GP98xkqYdkel+VNM6KZ/YN
         Ca4O0NylDaUcQ41K65RauOzBFw+XevCDB4hRWS4M6tWnfc+LurOG3E1BOHM8W2c6CKfq
         jScQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788528630; x=1789133430;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ul9UGPOILM7B5DmFYUwOQNUEy1YqQtqP63zgojN5NOI=;
        b=FCfnB1t+5c5qit8LW4/ViU2qfr4Ldc7odbNvLnMj0lLnplg/Z+ZUlln1kqETjiQU/q
         DZgcVvgS0q96ZAJ+u+ioeAmLoYOrgu4UxBSZOnOEPmofmp1xSdHqudbW7Wuwtl/u73/v
         mjTEo7OlsCan01EcPSeWqUgqQH/erHjM4DT4bd9o7baJxAjqRpu9rKQ7o6LSEEBE3zHG
         YbHxvRM301rBVm0kO01yXHbb6DRx56rbG/vzEWOScugYX3FU2LcLDxDQ7FLqzY4Xsh2P
         PsBC53n0vg+mF1ZNDGEIQGXH3sIa5nBwWc9dW4R9OHGnjI5VNWNpv5dWeipfKZji/ZYg
         3ELw==
X-Forwarded-Encrypted: i=1; AKwUvBwi+8ywnlOCTlbdloz8Y0FZ+c1C04lCEb1SvpxB4g8mBnLs69iY7vyyy2UPDyjB07QVqZj/xXc=@lists.linux.dev
X-Gm-Message-State: AFuF++n5MX7wMwsqUbQVIHxbRxudOn7lvSaIzGyDKaE/M59fP8wfoh0E
	gtURhri2IF8b4aSCo3XVwPUc3jTg0X6PC0AY2C69u3B7rX79kM0ExYxdV7HCD2RF/TVSjJNjgN+
	5MYTbJYtOwV9rqg==
X-Received: from wmco24.prod.google.com ([2002:a05:600c:a318:b0:495:6d55:63ba])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:a00a:b0:49c:ed94:cdd8 with SMTP id 5b1f17b1804b1-49cf81f6736mr102706005e9.6.1788528628939;
 Fri, 04 Sep 2026 06:30:28 -0700 (PDT)
Date: Fri,  4 Sep 2026 13:28:54 +0000
In-Reply-To: <20260904132855.638117-1-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260904132855.638117-1-smostafa@google.com>
X-Mailer: git-send-email 2.55.0.979.g7e5102b832-goog
Message-ID: <20260904132855.638117-2-smostafa@google.com>
Subject: [PATCH v3 1/2] KVM: arm64: Add stage2_clean_old_pte()
From: Mostafa Saleh <smostafa@google.com>
To: linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oupton@kernel.org, seiden@linux.ibm.com, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, will@kernel.org, vdonnefort@google.com, 
	tabba@google.com, sebastianene@google.com, keirf@google.com, 
	qperret@google.com, linu.cherian@arm.com, Mostafa Saleh <smostafa@google.com>
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

Move step #2 and #3 from stage2_try_break_pte() to a new helper
stage2_clean_old_pte() so it can be re-used by BBML3.

No functional change.

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
2.55.0.979.g7e5102b832-goog

