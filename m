Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com [209.85.128.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9D23384CC8
	for <kvmarm@lists.linux.dev>; Fri, 11 Sep 2026 13:51:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789134667; cv=none; b=NvXb0SOY0LxO05n2PvmHCMAlhniJeDxUNKDq6QRD3e+jLNTeRMECKEuXilt5/stRwhZlGUQfWjpoOXREuUdNvKBegNnqNxxv22GxPCUrPod+F1M4HJW+vHo0XDi0q1k66MLRhZ01mbCdqL4qFozsRGnGfjCefExjDdlbTBAdvVQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789134667; c=relaxed/simple;
	bh=hZTEDZnDyLc9Vv0ahJUu80x0ZbGDOsx82IPMFf2Le6E=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=SRL3xwTYOxE5ek2wtqBldo+xiNzrmf1xZSPTQTVxbxb6JSpP961nDS19it3EIYqMiE9RjwzhfJq6jjcfw55QH5e1iI+dctO7JLeFShblU2hfcusYf9iGyCtsXzH1azSpj95jkdqPGPt1PDnLMNO2V4sJrrHmjtqcHMREbRhME/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=swZZkmpm; arc=none smtp.client-ip=209.85.128.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="swZZkmpm"
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-4994cf6cdb9so7634415e9.3
        for <kvmarm@lists.linux.dev>; Fri, 11 Sep 2026 06:51:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789134664; x=1789739464; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=k/UyVFH1eJeaIvyHBxmk+soLwxzPqsgvrdFkmaPkpfI=;
        b=swZZkmpmDeQ8imdjB9WnQAyYR/u4jglr5h3yT+kYCTuteni31jnrrz7gtw3ZLTn6w4
         IRFLEGq5ok6TY/YZXdyQrlMe7i+YDiAivAQul5PG8P+mYLMdHS9cDDOI+WL28v81z9rs
         0T5t0gb2EEualu0OK7QZGHHbjKMLax2z4ke+zIESWDbt7ihFmH4lfh2cJcTAXn9JHxNn
         SIEmloXKMiSy/XGMFHk8fi5VouVoBSOa+VbjmctTGpiPERFiYPPDAB29Wq9orYuVF9xQ
         A0G5c9jKgH2ZlS0N5cnFqsC7caVBNPq5/1Hg2zqkQkwiKAyTCpXbv7Hr/4Kt+NVX1+iH
         nkEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789134664; x=1789739464;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=k/UyVFH1eJeaIvyHBxmk+soLwxzPqsgvrdFkmaPkpfI=;
        b=lTaRV92nGos/Vr3po9u4ar7kvNUt+xWX99ifMfQ2VemUuWOm+EAstxagNSSdchIMQW
         NNt7SFABWns6lchTXMBQehEoCgT5/jngRzr+lbvZ9igAR0VncfVMyfv7V5Rn/Cx4LmLq
         MuRyKrjNWR3b/FASG3pLB4mB75Qd+fM5MYffs/sNMRD8rC0xDRl7U/aCiEB01M/H3xdX
         IIdDX9DOjb89qhkwuIw+LujOj1Y20zJ0VTi101Od0hNO+MGtVsdPL61tBF8R5OYSDukM
         VuYuMUAbgnUhTt8v2sj9l37E8RLrIUUSmxXxGZDe0bImatUMHHXpHMyoFaxu1xJpffgv
         6vuQ==
X-Forwarded-Encrypted: i=1; AKwUvBxGZyADF+AM8z8n5rPn9hrE+q1RxXSWRRWPxcJvRsKXYHQ9e/0VdgF89p69GPZlnxB12e3+7/g=@lists.linux.dev
X-Gm-Message-State: AFuF++k5YDOVrso/uMgsTY16tNYSXkN9IwH+ejfLqwJbGjvcgIkCf8/L
	GSSm/7GMzW6MngfCfbJAX8dk5pGNSOmWrWCKA/bOAAUxAu6iU9+bXO36eyDGPXTEh/j8RArs4Zw
	fel21FGe7e9h6Lb5zZ3pOIw==
X-Received: from wmbje22.prod.google.com ([2002:a05:600c:1f96:b0:49d:c0e:4350])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:3104:b0:499:621a:2ec2 with SMTP id 5b1f17b1804b1-49e6188899fmr53302515e9.3.1789134663691;
 Fri, 11 Sep 2026 06:51:03 -0700 (PDT)
Date: Fri, 11 Sep 2026 14:50:33 +0100
In-Reply-To: <20260911135053.146435-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260911135053.146435-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.55.0.1007.g17ff1f9808-goog
Message-ID: <20260911135053.146435-3-vdonnefort@google.com>
Subject: [PATCH v2 02/22] KVM: arm64: Propagate host stage-2 annotated entries
 on block split
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, 
	kernel-team@android.com, fuad.tabba@linux.dev, qperret@google.com, 
	weilin.chang@arm.com, Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

Propagate ownership refcounts for invalid stage-2 entries mapped on
block split. This intends to allow splitting host stage-2 blocks while
keeping existing page ownership and metadata annotations.

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
---
 arch/arm64/kvm/hyp/pgtable.c | 22 +++++++++++++++++++---
 1 file changed, 19 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index 34f78a58cded..0ca157ecee64 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -1033,15 +1033,28 @@ static int stage2_map_walk_table_pre(const struct kvm_pgtable_visit_ctx *ctx,
 static void stage2_map_prefault_idmap(const struct kvm_pgtable_visit_ctx *ctx, kvm_pte_t *ptep)
 {
 	kvm_pte_t block_pte = ctx->old;
+	bool counted, valid;
 	u64 pa;
 	int i;
 
-	if (!kvm_pte_valid(block_pte))
+	counted = stage2_pte_is_counted(block_pte);
+	valid = kvm_pte_valid(block_pte);
+
+	if (!valid && !counted)
+		return;
+
+	/*
+	 * Shared walks not supported: cannot rollback refcounts on break
+	 * failure.
+	 */
+	if (counted && WARN_ON_ONCE(kvm_pgtable_walk_shared(ctx)))
 		return;
 
 	pa = ALIGN_DOWN(ctx->addr, kvm_granule_size(ctx->level));
 	for (i = 0; i < PTRS_PER_PTE; ++i, ++ptep, pa += kvm_granule_size(ctx->level + 1)) {
-		kvm_pte_t pte = kvm_init_valid_leaf_pte(pa, block_pte, ctx->level + 1);
+		kvm_pte_t pte = valid ?
+			kvm_init_valid_leaf_pte(pa, block_pte, ctx->level + 1) :
+			block_pte;
 
 		/*
 		 * Skip ptes in the range being modified by the caller if we're
@@ -1053,8 +1066,11 @@ static void stage2_map_prefault_idmap(const struct kvm_pgtable_visit_ctx *ctx, k
 		 * that should happen very infrequently.
 		 */
 		if ((ctx->level < (KVM_PGTABLE_LAST_LEVEL - 1)) ||
-		    (pa < ctx->addr) || (pa >= ctx->end))
+		    (pa < ctx->addr) || (pa >= ctx->end)) {
 			*ptep = pte;
+			if (counted)
+				ctx->mm_ops->get_page(ptep);
+		}
 	}
 }
 
-- 
2.55.0.1007.g17ff1f9808-goog

