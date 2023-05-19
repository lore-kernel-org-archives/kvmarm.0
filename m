Received: from mail-io1-f74.google.com (mail-io1-f74.google.com [209.85.166.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC953362
	for <kvmarm@lists.linux.dev>; Fri, 19 May 2023 00:52:42 +0000 (UTC)
Received: by mail-io1-f74.google.com with SMTP id ca18e2360f4ac-76c63aadc10so27405439f.0
        for <kvmarm@lists.linux.dev>; Thu, 18 May 2023 17:52:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1684457562; x=1687049562;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=rGsmPoc/T4Ss3kfVhJrmlF6LuTv5aUCcul/iCKRGGfw=;
        b=xW05sinAfw8C44WTP/9vyg4AsrI69Imj2ZmwYQLJZF8kEHkqon5WhJrYk6DNXK7Gw6
         ORpvYUQiCd6GWx/VkoJW+RFSdfhvlRh0N9mjXQWCD6GhGofxw22goCURFVI2zQtlWjI3
         q40Px7tzzEXTuwbuR/ZiN0k40rk4wWlizlUEyM3BENmLsLioAlGtY649VgAWbXD8mNoT
         jqpj50br7Y7C26Wwzs7ZYrY5XUZtlZuQUEmP94MjpBLWtfJKC0Hj0gvsmYFqFZ6EU0/5
         BTWcttwAOtqDV1LAtO7UFkbUjq6YDBOiaJ3QlnQPpYOq6lbHz3ZzDuYKfXJ/7nDGH2YH
         /vSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684457562; x=1687049562;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rGsmPoc/T4Ss3kfVhJrmlF6LuTv5aUCcul/iCKRGGfw=;
        b=ek4qVgQzRXboorsiluOC3oxQg8RRZ0bNnuf9UzGTdJrnp7KOMT/tcMzv8bXjAV/cQ4
         ftb3TofOWv97VARaA8RrXvcomRHskLGXWcG/RwMeleVhuX4JB7CDTamEn8TOGguwGJ+5
         bhVC847LSSj5x2Ud/jE/4xEcFVJPQ5SULd0h8VleplAaKWOTe00aAfGf4jwSHDyuALAi
         pMZwaUVNUwEAaa87hlKWY0vxqoYry9KmfWwsUaAoOaLX+LLSmIZdTaBQqMSntOCM7qje
         7GPrM4b0mbxu5DY1QfgYLW0KsciTVeuwTIsURoxvJ6iXH4FDUFCHFaGRIXVY3V+aE2X8
         KagA==
X-Gm-Message-State: AC+VfDxcwEmw2TZ2mNNE95nAbCbRH76jLJfLSSVay/prHPmhd9wPzpF0
	d+4b6pLcr9cGaaBQWMrL8W22Ji6trGOq
X-Google-Smtp-Source: ACHHUZ6TXO388gzfHLwp1jHRgCji0izRBrbXcyR7uAZvijYpyuzGsSLXba63Usu2McZd5g1WZCldx8ML+Rhn
X-Received: from rananta-linux.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:22b5])
 (user=rananta job=sendgmr) by 2002:a05:6602:2ac4:b0:763:b184:fe92 with SMTP
 id m4-20020a0566022ac400b00763b184fe92mr5060981iov.0.1684457562041; Thu, 18
 May 2023 17:52:42 -0700 (PDT)
Date: Fri, 19 May 2023 00:52:31 +0000
In-Reply-To: <20230519005231.3027912-1-rananta@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230519005231.3027912-1-rananta@google.com>
X-Mailer: git-send-email 2.40.1.698.g37aff9b760-goog
Message-ID: <20230519005231.3027912-7-rananta@google.com>
Subject: [PATCH v4 6/6] KVM: arm64: Use TLBI range-based intructions for unmap
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

Rename stage2_put_pte() to stage2_unmap_put_pte() as the function
now serves the stage-2 unmap walker specifically, rather than
acting generic.

Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
---
 arch/arm64/kvm/hyp/pgtable.c | 35 ++++++++++++++++++++++++++++++-----
 1 file changed, 30 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index b8f0dbd12f773..5832ee3418fb0 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -771,16 +771,34 @@ static void stage2_make_pte(const struct kvm_pgtable_visit_ctx *ctx, kvm_pte_t n
 	smp_store_release(ctx->ptep, new);
 }
 
-static void stage2_put_pte(const struct kvm_pgtable_visit_ctx *ctx, struct kvm_s2_mmu *mmu,
-			   struct kvm_pgtable_mm_ops *mm_ops)
+static bool stage2_unmap_defer_tlb_flush(struct kvm_pgtable *pgt)
 {
+	/*
+	 * If FEAT_TLBIRANGE is implemented, defer the individial PTE
+	 * TLB invalidations until the entire walk is finished, and
+	 * then use the range-based TLBI instructions to do the
+	 * invalidations. Condition this upon S2FWB in order to avoid
+	 * a page-table walk again to perform the CMOs after TLBI.
+	 */
+	return system_supports_tlb_range() && stage2_has_fwb(pgt);
+}
+
+static void stage2_unmap_put_pte(const struct kvm_pgtable_visit_ctx *ctx,
+				struct kvm_s2_mmu *mmu,
+				struct kvm_pgtable_mm_ops *mm_ops)
+{
+	struct kvm_pgtable *pgt = ctx->arg;
+
 	/*
 	 * Clear the existing PTE, and perform break-before-make with
 	 * TLB maintenance if it was valid.
 	 */
 	if (kvm_pte_valid(ctx->old)) {
 		kvm_clear_pte(ctx->ptep);
-		kvm_call_hyp(__kvm_tlb_flush_vmid_ipa, mmu, ctx->addr, ctx->level);
+
+		if (!stage2_unmap_defer_tlb_flush(pgt))
+			kvm_call_hyp(__kvm_tlb_flush_vmid_ipa, mmu,
+					ctx->addr, ctx->level);
 	}
 
 	mm_ops->put_page(ctx->ptep);
@@ -1015,7 +1033,7 @@ static int stage2_unmap_walker(const struct kvm_pgtable_visit_ctx *ctx,
 	 * block entry and rely on the remaining portions being faulted
 	 * back lazily.
 	 */
-	stage2_put_pte(ctx, mmu, mm_ops);
+	stage2_unmap_put_pte(ctx, mmu, mm_ops);
 
 	if (need_flush && mm_ops->dcache_clean_inval_poc)
 		mm_ops->dcache_clean_inval_poc(kvm_pte_follow(ctx->old, mm_ops),
@@ -1029,13 +1047,20 @@ static int stage2_unmap_walker(const struct kvm_pgtable_visit_ctx *ctx,
 
 int kvm_pgtable_stage2_unmap(struct kvm_pgtable *pgt, u64 addr, u64 size)
 {
+	int ret;
 	struct kvm_pgtable_walker walker = {
 		.cb	= stage2_unmap_walker,
 		.arg	= pgt,
 		.flags	= KVM_PGTABLE_WALK_LEAF | KVM_PGTABLE_WALK_TABLE_POST,
 	};
 
-	return kvm_pgtable_walk(pgt, addr, size, &walker);
+	ret = kvm_pgtable_walk(pgt, addr, size, &walker);
+	if (stage2_unmap_defer_tlb_flush(pgt))
+		/* Perform the deferred TLB invalidations */
+		kvm_call_hyp(__kvm_tlb_flush_vmid_range, pgt->mmu,
+				addr, addr + size);
+
+	return ret;
 }
 
 struct stage2_attr_data {
-- 
2.40.1.698.g37aff9b760-goog

