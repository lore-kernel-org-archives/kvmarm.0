Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 689EA3FB067
	for <kvmarm@lists.linux.dev>; Fri, 17 Jul 2026 13:09:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784293749; cv=none; b=p2zD3gkrmrpTgKNNl2vXmFXZAFCYaHKacXSd3DjdEtaFY/XW+7Yg+WfcVRB9mnYiMuOfIn333+XmOdtMrno4zNU/dWRd0aLXg9ftzEyToGXTqXOPgfKY62CQNk6l8KpqG3gYbMZ0Ba6VxTnDPlm/inGw7G9FinsjHwYXnCy4Rs0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784293749; c=relaxed/simple;
	bh=8bWbCVTmqjsdXLL+5FJBNFKc14o//Ho5EEc1NgDWZ00=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Dfkasv1EEGQ29hQFzOAPoEKrfSBsNI1HWFILe3b1fYrwtARbWrdLvMukQKXbCuEp1VA15nXySbz00k9HoHig30x4fVJyPo3ST8RZMwu2L8bze5gxQQboq6zSSjeRdZp8dbCIf+qXboqlNVju8MCLJ2rZLcL5+iZE8LI42aFNQ/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=itCT0mbL; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="itCT0mbL"
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-4744b72f90bso4296814f8f.0
        for <kvmarm@lists.linux.dev>; Fri, 17 Jul 2026 06:09:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784293746; x=1784898546; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=VImkqaBVxIups1vL1ulSnRZBEUIJVUK8xJrNhCCDu1A=;
        b=itCT0mbLEMZ6Kk8An9JWiuXpogcdZwVm3lfuzJliXb+TlZtCODkYfu1/By7Ebc+PrE
         Gn9cTuUv/o28/S0KRn+6J3n4qiaw7B7cK4w7LXTVvb4AYUAPBrrfMx8jobqwVlPx1x9K
         bPO5EStM2Chb3dDDYGwpx2ewwSh0WRNeykwBruon3fYhIGB1LPPG5aj+d/9x/f1+udcj
         BLy/j5eMerx0Va8pPvISRX71MhWyB0iFFzVJLmIHEzjUyPivJSPbHLJjc5II5KVqV5Zy
         GDWp+Vh0vujiot1YRSTy8ZTlau4rUhaBUZPON70BWXZIhtmh8s5adOMdVQdN9qNGZH7H
         gbmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784293746; x=1784898546;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=VImkqaBVxIups1vL1ulSnRZBEUIJVUK8xJrNhCCDu1A=;
        b=UGrbhqilpkOIhY/yDgGjqr8nIxDfUq30Nu3mdGtGPSANSzFaztezDCfWjp4M6ugbcc
         ifUN5jUt3lg5U96Ymsh7pw5K79DGVu32ibi608f+itmvUomWS5/F9h5ElZnrBio3j1/h
         uYV5xcDlellJBo10IDWQ8ZpdkChKLi5Uu2rgZMw8QVuufnQiIkghvKt7tYyPiw4RAp64
         /CQJLyN2rnW+lXU8q1DJ2jB+lu0LMB46HF34wU1xgNeJ8pDfnVxF/5pBwBrQnU2uB2gE
         NNxh0ZUQffvhZhSuGyl2vKeAVqk8P57tkYfd76Kp7WG2ZRX8con1+9uCVQ4AkS/ImJx4
         Qe1g==
X-Forwarded-Encrypted: i=1; AHgh+Ro0BsZr5nBFzRkoHdGfVUwnjuMasnesvd7mdD4mvwcONIE7vmIMDrf5OcL/UVZAoOPy2w58/lg=@lists.linux.dev
X-Gm-Message-State: AOJu0YzPMGo/gvtRS2fIvClZtzulIOuxOjUv4DuRSnGudiwPE6kDrWG8
	TUTSErxmsIOSfhWajOe/mg4lQ7YjFKBvdMRFXnhUA0q4+9+qZ+DXNQSnkYG9/NiX1S1YzMmYNaf
	KOnhqdSx1nF5gew==
X-Received: from wrpk9.prod.google.com ([2002:adf:f5c9:0:b0:460:d09:f6ad])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6000:25f0:b0:476:dd2b:611 with SMTP id ffacd0b85a97d-47f623049e7mr3779169f8f.3.1784293746031;
 Fri, 17 Jul 2026 06:09:06 -0700 (PDT)
Date: Fri, 17 Jul 2026 13:08:59 +0000
In-Reply-To: <20260717130901.2239134-1-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260717130901.2239134-1-smostafa@google.com>
X-Mailer: git-send-email 2.55.0.229.g6434b31f56-goog
Message-ID: <20260717130901.2239134-2-smostafa@google.com>
Subject: [RFC PATCH 1/2] KVM: arm64: Add stage2_clean_old_pte()
From: Mostafa Saleh <smostafa@google.com>
To: linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oupton@kernel.org, seiden@linux.ibm.com, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, will@kernel.org, vdonnefort@google.com, 
	tabba@google.com, Mostafa Saleh <smostafa@google.com>
Content-Type: text/plain; charset="UTF-8"

At the moment, the pgtable code rely on BBM in SW which looks like:
Break: stage2_try_break_pte()
	1) Break PTE and lock it
	2) TLBI
	3) Put the ref on the old PTE

Make: stage2_make_pte()
	1) Get a ref on the new PTE
	2) Install the live PTE

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
that can be called from BBML3.

Signed-off-by: Mostafa Saleh <smostafa@google.com>
---
 arch/arm64/kvm/hyp/pgtable.c | 67 ++++++++++++++++++++----------------
 1 file changed, 37 insertions(+), 30 deletions(-)

diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index 91a7dfad6686..127b7f9541b1 100644
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

