Received: from mail-il1-f202.google.com (mail-il1-f202.google.com [209.85.166.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 585F563A6
	for <kvmarm@lists.linux.dev>; Fri, 14 Apr 2023 17:29:33 +0000 (UTC)
Received: by mail-il1-f202.google.com with SMTP id w14-20020a056e0213ee00b0032827955ae6so13476628ilj.7
        for <kvmarm@lists.linux.dev>; Fri, 14 Apr 2023 10:29:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1681493372; x=1684085372;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=B/zMNPvsJ76QjkM1FVDxX2x1kCiWFrXUv8piHTPNmKE=;
        b=Nx6yKI3EIRZ1j9gTwptzX9+uokMoja8+/mQJmU3Rbml7atU0NoaDLBGoC2ADYzVIzd
         7aha5aGITbsGDsKM1l7NfS0DEzKHMH2NeeQayQA6VslRgzCarBgdYEG+PUEtCAER1UXf
         fyrUxrpkNjxH5oSb49dS7Rfk+7CWIo2gqojXOL8s9xSwDoxq+npACrZokCS2ovl6fOzW
         8l09mW/ccEk4oAdZg2MnlEm5WTsX7ut19ZEDWM18wpQZ6t2WzsLVdUB3PkYURffuJxRY
         g+aUVAE5+Yw98jqRcnug+ZTFUE+1aDOhSwxOp+NtIoyMuMlVf2eoWotUhma2O9uNKFW9
         +UAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681493372; x=1684085372;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=B/zMNPvsJ76QjkM1FVDxX2x1kCiWFrXUv8piHTPNmKE=;
        b=TRHDhoKLmMrh92KiO/Zc8C8R7r+tbhDGBnyE8mxJQZMgjmkFjcQaGKn+jzJMTe92lC
         x7IKKhPeWBDaz613heLeRVfAnSw/AgEr+Vy7BCv678je0MJ+i0puwsrOR5keho3xAlpy
         MI1t/9QmXBvNeXbqBfyak05OAvqbHZw3L16Zuzpdhn1HEUDmeJSgJeG49byK5H3JBUfa
         f8OVFIF7xK58lKL9v12+Jk+D7+9aIGb3ZN+nOCbnf3lMP1iGea+572lVtBOb6ckofEFA
         MhuFCQFrUHqvUNqy3S3+Wak/Q5q1FXqrzQC9bg2WYxkLBWdB4YVDi4tUj9a7qvCb8Tlw
         SkjQ==
X-Gm-Message-State: AAQBX9dl4xPKeiz9vkUdFTwY7DOhi9waPQpjBwWyu4oS0h/iQ4nCdzJy
	sgpbYrqy4JzW+zAaZTXLd9Kdlc5+6zmm
X-Google-Smtp-Source: AKy350Z4dUZKdVtn0ngicjL45vSsU+MnN2dqL/cSY7ktGGKCk03DL47Ioacf0/CM1+w6Tkn33IoibTV1wujW
X-Received: from rananta-linux.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:22b5])
 (user=rananta job=sendgmr) by 2002:a02:85ed:0:b0:40b:bd17:3c31 with SMTP id
 d100-20020a0285ed000000b0040bbd173c31mr2482742jai.0.1681493372447; Fri, 14
 Apr 2023 10:29:32 -0700 (PDT)
Date: Fri, 14 Apr 2023 17:29:22 +0000
In-Reply-To: <20230414172922.812640-1-rananta@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230414172922.812640-1-rananta@google.com>
X-Mailer: git-send-email 2.40.0.634.g4ca3ef3211-goog
Message-ID: <20230414172922.812640-8-rananta@google.com>
Subject: [PATCH v3 7/7] KVM: arm64: Use TLBI range-based intructions for unmap
From: Raghavendra Rao Ananta <rananta@google.com>
To: Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: Ricardo Koller <ricarkol@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Jing Zhang <jingzhangos@google.com>, Colton Lewis <coltonlewis@google.com>, 
	Raghavendra Rao Anata <rananta@google.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

The current implementation of the stage-2 unmap walker traverses
the given range and, as a part of break-before-make, performs
TLB invalidations with a DSB for every PTE. A multitude of this
combination could cause a performance bottleneck.

Hence, if the system supports FEAT_TLBIRANGE, defer the TLB
invalidations until the entire walk is finished, and then
use range-based instructions to invalidate the TLBs in one go.
Condition this upon S2FWB in order to avoid walking the page-table
again to perform the CMOs after issuing the TLBI.

Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
Suggested-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/hyp/pgtable.c | 33 +++++++++++++++++++++++++++++----
 1 file changed, 29 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index 3f136e35feb5e..bcb748e3566c7 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -987,10 +987,16 @@ int kvm_pgtable_stage2_set_owner(struct kvm_pgtable *pgt, u64 addr, u64 size,
 	return ret;
 }
 
+struct stage2_unmap_data {
+	struct kvm_pgtable *pgt;
+	bool skip_pte_tlbis;
+};
+
 static int stage2_unmap_walker(const struct kvm_pgtable_visit_ctx *ctx,
 			       enum kvm_pgtable_walk_flags visit)
 {
-	struct kvm_pgtable *pgt = ctx->arg;
+	struct stage2_unmap_data *unmap_data = ctx->arg;
+	struct kvm_pgtable *pgt = unmap_data->pgt;
 	struct kvm_s2_mmu *mmu = pgt->mmu;
 	struct kvm_pgtable_mm_ops *mm_ops = ctx->mm_ops;
 	kvm_pte_t *childp = NULL;
@@ -1018,7 +1024,7 @@ static int stage2_unmap_walker(const struct kvm_pgtable_visit_ctx *ctx,
 	 * block entry and rely on the remaining portions being faulted
 	 * back lazily.
 	 */
-	stage2_put_pte(ctx, mmu, mm_ops, false);
+	stage2_put_pte(ctx, mmu, mm_ops, unmap_data->skip_pte_tlbis);
 
 	if (need_flush && mm_ops->dcache_clean_inval_poc)
 		mm_ops->dcache_clean_inval_poc(kvm_pte_follow(ctx->old, mm_ops),
@@ -1032,13 +1038,32 @@ static int stage2_unmap_walker(const struct kvm_pgtable_visit_ctx *ctx,
 
 int kvm_pgtable_stage2_unmap(struct kvm_pgtable *pgt, u64 addr, u64 size)
 {
+	int ret;
+	struct stage2_unmap_data unmap_data = {
+		.pgt = pgt,
+		/*
+		 * If FEAT_TLBIRANGE is implemented, defer the individial PTE
+		 * TLB invalidations until the entire walk is finished, and
+		 * then use the range-based TLBI instructions to do the
+		 * invalidations. Condition this upon S2FWB in order to avoid
+		 * a page-table walk again to perform the CMOs after TLBI.
+		 */
+		.skip_pte_tlbis = system_supports_tlb_range() &&
+					stage2_has_fwb(pgt),
+	};
 	struct kvm_pgtable_walker walker = {
 		.cb	= stage2_unmap_walker,
-		.arg	= pgt,
+		.arg	= &unmap_data,
 		.flags	= KVM_PGTABLE_WALK_LEAF | KVM_PGTABLE_WALK_TABLE_POST,
 	};
 
-	return kvm_pgtable_walk(pgt, addr, size, &walker);
+	ret = kvm_pgtable_walk(pgt, addr, size, &walker);
+	if (unmap_data.skip_pte_tlbis)
+		/* Perform the deferred TLB invalidations */
+		kvm_call_hyp(__kvm_tlb_flush_vmid_range, pgt->mmu,
+				addr, addr + size);
+
+	return ret;
 }
 
 struct stage2_attr_data {
-- 
2.40.0.634.g4ca3ef3211-goog

