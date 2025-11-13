Received: from mail-il1-f201.google.com (mail-il1-f201.google.com [209.85.166.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32680302165
	for <kvmarm@lists.linux.dev>; Thu, 13 Nov 2025 05:25:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763011511; cv=none; b=RzHjUQFF//PY7PvX0pVkXgDgcnRoqQd8NOfO5fcGIYmUu9Z/wIg5xAjjz/R2EI3rYy0F5UE7m8++g21nDFN02gIY1u8n8hKcfJHzVWaZlJCEUdlIlRh87Kg3g0ToGdUd93EEfRWHBAVFUUI8K43WRHKA7QI/JlyEKYuNm2IoSN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763011511; c=relaxed/simple;
	bh=w/PDH8oJeD6dMpuJ8r5XsK3/Zk2LCzp9EjWC0515E8Y=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=j+ssDH2At2nndT6Znv5V0QMO2e8544lJEmiCNawlKewgorhnNvO2ItshHly4nvNIJbF1XuQm3hb7P69DrpVhXYOt5o72fp2gc2eAHyWGkRiupvS3pO0IRxZrgKyWmRgMMdCxhnVcGCt/oiKQasqGsOfcd6JyT73fPSyBVEo7hxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--rananta.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=wRcHxOKF; arc=none smtp.client-ip=209.85.166.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--rananta.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="wRcHxOKF"
Received: by mail-il1-f201.google.com with SMTP id e9e14a558f8ab-432fb58f876so26041475ab.1
        for <kvmarm@lists.linux.dev>; Wed, 12 Nov 2025 21:25:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763011509; x=1763616309; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=s9SgCCzfx7hqB2TFCbu/gbrkrcw0YcG+BnpWWFTO5/g=;
        b=wRcHxOKFkFFYxDGPPxQ3IqDCDI0AbOdVZgktzGAsUjBjg0WxkOdvH0K47/cAaYazRM
         olc72VGp5uW/jm4wWzWuo5glhif4W9gsEp/uqVNWaR1wcgjzW7nPZeWxKPaPPDrg7wKr
         Uvls9CvRFPzbxFZvzahA1yTaYplgYD1HXNJ+tlLMjd2z1mFZMgoEQUKBcYP57BjUVq+S
         fEXtL9Rtb2LtNdGma93ReFYQCqPI93NIbGqJmP7jPDhQF0nvwL8A+pQiD5kk2Bl2IoEQ
         jy/ykqtGZEw88IHWB02sZeeXml3dOzOk0jUfH6XJN++sPQ0n44n9yS8w8yrdOw8s+7Nv
         rpIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763011509; x=1763616309;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=s9SgCCzfx7hqB2TFCbu/gbrkrcw0YcG+BnpWWFTO5/g=;
        b=atuOSkgHGSR8AUed8Bm+juph0ENeAjF9x0L8aQqfl9WWlvR4shfEgOlskfMV4FvG1r
         ZzRNCtC6WiN2JUdkL+EWczuuYbHorj0zBoO93vlPHgy47Mf8s0DrmykhkoGMzrCb7R/M
         j4JIYieInpPZL+SY3Ccc4Ipia5GvnyvW02qQY24LE9X/c4wTWCTceG9Nz5S8UYgIfaP8
         wlKr8YlYTQpXLABhX6xQRPEx0Ko1HNSM7Ey9WSABDs1v1SqjYLvBDjxpmbOIbQ2smKcP
         C7fA4HpgOBTWMKXYhwZEgJFfZ/C0Vwc/ZYbxHZI0QDR1XiDClN0uihQbuJvnUf8LxQH0
         B8MQ==
X-Forwarded-Encrypted: i=1; AJvYcCXBm7DfdKV2PM0Ga/BauGCT1MxwVpE8ZuuPpyzbOdPoKtcQltTuO5PDG/rJ8Y3QcQmQmitXdWQ=@lists.linux.dev
X-Gm-Message-State: AOJu0YxvWhEJNF0lKw0CnGoi2nRSiJqdJZyKZJ1EnntJw052n4tLB2nf
	mNsEX7QwwCItLcdVLuzIWKSv1FooDn8M2zMvlWCtJ8NAmXfiHjmPAskF49NsOSLUx4EbAaTww0w
	EwhE8NKVVuA==
X-Google-Smtp-Source: AGHT+IEyJSyJIvlGRNrSoUOGgfcAkjKY1WyU5H5l7T8c0BR5P21QqG7oUV9JZZVGF8o1Ck1Nj4/ZN1JRw7Lq
X-Received: from ilbbk5.prod.google.com ([2002:a05:6e02:3285:b0:433:76d7:5d39])
 (user=rananta job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6e02:190e:b0:433:7310:f5bf
 with SMTP id e9e14a558f8ab-43473daeab5mr67314545ab.22.1763011509204; Wed, 12
 Nov 2025 21:25:09 -0800 (PST)
Date: Thu, 13 Nov 2025 05:24:50 +0000
In-Reply-To: <20251113052452.975081-1-rananta@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251113052452.975081-1-rananta@google.com>
X-Mailer: git-send-email 2.51.2.1041.gc1ab5b90ca-goog
Message-ID: <20251113052452.975081-2-rananta@google.com>
Subject: [PATCH 1/3] KVM: arm64: Only drop references on empty tables in stage2_free_walker
From: Raghavendra Rao Ananta <rananta@google.com>
To: Oliver Upton <oupton@kernel.org>, Marc Zyngier <maz@kernel.org>
Cc: Raghavendra Rao Anata <rananta@google.com>, Mingwei Zhang <mizhang@google.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	Oliver Upton <oliver.upton@linux.dev>
Content-Type: text/plain; charset="UTF-8"

From: Oliver Upton <oliver.upton@linux.dev>

A subsequent change to the way KVM frees stage-2s will invoke the free
walker on sub-ranges of the VM's IPA space, meaning there's potential
for only partially visiting a table's PTEs.

Split the leaf and table visitors and only drop references on a table
when the page count reaches 1, implying there are no valid PTEs that
need to be visited. Invalidate the table PTE to avoid traversing the
stale reference.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/hyp/pgtable.c | 38 ++++++++++++++++++++++++++++++------
 1 file changed, 32 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index c351b4abd5dbf..6d6a23f7dedb6 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -1535,20 +1535,46 @@ size_t kvm_pgtable_stage2_pgd_size(u64 vtcr)
 	return kvm_pgd_pages(ia_bits, start_level) * PAGE_SIZE;
 }
 
-static int stage2_free_walker(const struct kvm_pgtable_visit_ctx *ctx,
-			      enum kvm_pgtable_walk_flags visit)
+static int stage2_free_leaf(const struct kvm_pgtable_visit_ctx *ctx)
 {
 	struct kvm_pgtable_mm_ops *mm_ops = ctx->mm_ops;
 
-	if (!stage2_pte_is_counted(ctx->old))
+	mm_ops->put_page(ctx->ptep);
+	return 0;
+}
+
+static int stage2_free_table_post(const struct kvm_pgtable_visit_ctx *ctx)
+{
+	struct kvm_pgtable_mm_ops *mm_ops = ctx->mm_ops;
+	kvm_pte_t *childp = kvm_pte_follow(ctx->old, mm_ops);
+
+	if (mm_ops->page_count(childp) != 1)
 		return 0;
 
+	/*
+	 * Drop references and clear the now stale PTE to avoid rewalking the
+	 * freed page table.
+	 */
 	mm_ops->put_page(ctx->ptep);
+	mm_ops->put_page(childp);
+	kvm_clear_pte(ctx->ptep);
+	return 0;
+}
 
-	if (kvm_pte_table(ctx->old, ctx->level))
-		mm_ops->put_page(kvm_pte_follow(ctx->old, mm_ops));
+static int stage2_free_walker(const struct kvm_pgtable_visit_ctx *ctx,
+			      enum kvm_pgtable_walk_flags visit)
+{
+	if (!stage2_pte_is_counted(ctx->old))
+		return 0;
 
-	return 0;
+	switch (visit) {
+	case KVM_PGTABLE_WALK_LEAF:
+		return stage2_free_leaf(ctx);
+	case KVM_PGTABLE_WALK_TABLE_POST:
+		return stage2_free_table_post(ctx);
+	default:
+		return -EINVAL;
+	}
 }
 
 void kvm_pgtable_stage2_destroy(struct kvm_pgtable *pgt)
-- 
2.51.2.1041.gc1ab5b90ca-goog

