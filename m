Received: from mail-il1-f202.google.com (mail-il1-f202.google.com [209.85.166.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45A0B244688
	for <kvmarm@lists.linux.dev>; Thu, 24 Jul 2025 23:51:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753401111; cv=none; b=N4XZxmVClCgX6uAs6d6MKpbvmkahyB7q0pYZM6HzdIac+EZ2HBSn/wzTg9P1ptU0ZObqMtE+dGDjF1Ysz7b36ytGt1Jv9iu0ixFSGwFkQV3To33u1GgKArc49Tj01EZenxun601hfYZQjdE7Ovey+pKpb/Cw08eoIMkKaL9t+C8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753401111; c=relaxed/simple;
	bh=mJZhkVqzAlktMiicVdZMAgFidWnCL7xJSgsFsqv8CX4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=dGz5surflKjMF35msvzVa9ILy25QqkglMLhEi2Ot1gwJWOLQOm8hC0/29mE7Lq5Vjpp/hFJal/gHEt6dZ9iKqYKSQ8Y180+2isIY+kaYt/NsYFFv3XIIuKcLDeLB9MSnkdQ3ewDIlW/DCfTnwl4XkKoa6Aq6Yv/x4RBYRdhWvWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--rananta.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=t2SKE0gI; arc=none smtp.client-ip=209.85.166.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--rananta.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="t2SKE0gI"
Received: by mail-il1-f202.google.com with SMTP id e9e14a558f8ab-3e2c4f303f1so33362635ab.2
        for <kvmarm@lists.linux.dev>; Thu, 24 Jul 2025 16:51:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753401109; x=1754005909; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=r0ewaMZlNiX4XUwdWiCIffQ7VQjkoCOyqrIjMyhZukM=;
        b=t2SKE0gIYil9yR5jj5GvtkYameyQbG8qM68bfXwwBw5mOXRwALeqslcIJz3qZpIvzc
         RnVzCcttrj5Glb16G7udPU8y4EhWrkjXavPZRkgdEjZdzVW/NysFHgeP1MhTuCde6eRX
         OMvDGcVD99iq3JHQHZxayncQ2VD2tChLN5NoSG9YbskuRQF0E74MIXQMOEzEx2bXUgTp
         o4hXVkjP2HIEAE8844qnI4ZFPWjiHE8SIIrlQEaI/OYgxy37eFvGbrKhdFmodH8BEdVw
         a/odDtzbsBU9jwNXT5zsZ0JQHaUwHjnBqg9kn3M25JCzxZ238ainhNX0QuXWq7b/i49R
         6lMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753401109; x=1754005909;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=r0ewaMZlNiX4XUwdWiCIffQ7VQjkoCOyqrIjMyhZukM=;
        b=fJZ/znf7DAjr/JH+ptoxaTz3dQic1jOrmblQDN4x9u1av9Kg+w6OpBvG1Y3ED/BLdZ
         CEbCb97K2vJkLsFMYfIpovFFkSj4+Lp7XLwwbZMyRTkNOsd9gJ59UGzSY3EeFOYDiekG
         aDmYAgu0ZuJBUdicVPSayZ2/sgu1FOgE4EGEHPnL8TSH/w83dA0FV1oAvp+QUkc7RID7
         uK6j8ZP63rakquNIDatBOeAgXyQ5dUoKwgHHaSq+mZePWIsaHVH5wJrU8ry+SKsU7G2P
         P+I4Kng3IHpxSmuI4NT6GdbqD9NHk8cBY0N2XC8BJgYxaGTdW3G785lS3VJo5Fk+Nxpk
         NHzA==
X-Forwarded-Encrypted: i=1; AJvYcCX72a0onZE/ReZq5W77bOAX+hpAxtuOeTxuHWi1nQsotZwOzuIGT/GLg5pe+B6+IrvIt32LT1Y=@lists.linux.dev
X-Gm-Message-State: AOJu0YwBRlh32A0rlXG70K7TWAkBRRboegyHvivJ7mUU21c3qXUEneqV
	GSwTXnTQ0cEd0dDVhc8RmiOINT2pOEw0/bIJUrMz/UlDy887kDDV3zUKeThuuXoK4YJGFCPqXDZ
	LpgMm9eS3xQ==
X-Google-Smtp-Source: AGHT+IE3uwh7rhlhnMSw8HCvEnAO71PNq4x2deGAz1aZwNBL6ubSNi4i+u/4ukPGZg4fKVPvTraBAf35Sn8T
X-Received: from ilsx9.prod.google.com ([2002:a05:6e02:749:b0:3dd:ca88:fcaf])
 (user=rananta job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6e02:3c87:b0:3e2:c33f:351d
 with SMTP id e9e14a558f8ab-3e32fc216e6mr150034255ab.3.1753401109503; Thu, 24
 Jul 2025 16:51:49 -0700 (PDT)
Date: Thu, 24 Jul 2025 23:51:43 +0000
In-Reply-To: <20250724235144.2428795-1-rananta@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250724235144.2428795-1-rananta@google.com>
X-Mailer: git-send-email 2.50.1.470.g6ba607880d-goog
Message-ID: <20250724235144.2428795-2-rananta@google.com>
Subject: [PATCH 1/2] KVM: arm64: Split kvm_pgtable_stage2_destroy()
From: Raghavendra Rao Ananta <rananta@google.com>
To: Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>
Cc: Raghavendra Rao Anata <rananta@google.com>, Mingwei Zhang <mizhang@google.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Split kvm_pgtable_stage2_destroy() into two:
  - kvm_pgtable_stage2_destroy_range(), that performs the
    page-table walk and free the entries over a range of addresses.
  - kvm_pgtable_stage2_destroy_pgd(), that frees the PGD.

This refactoring enables subsequent patches to free large page-tables
in chunks, calling cond_resched() between each chunk, to yield the CPU
as necessary.

Direct callers of kvm_pgtable_stage2_destroy() will continue to walk
the entire range of the VM as before, ensuring no functional changes.

Also, add equivalent pkvm_pgtable_stage2_*() stubs to maintain 1:1
mapping of the page-table functions.

Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
---
 arch/arm64/include/asm/kvm_pgtable.h | 19 +++++++++++++++++++
 arch/arm64/include/asm/kvm_pkvm.h    |  3 +++
 arch/arm64/kvm/hyp/pgtable.c         | 23 ++++++++++++++++++++---
 arch/arm64/kvm/pkvm.c                | 11 +++++++++++
 4 files changed, 53 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index 2888b5d03757..20aea58eca18 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -542,6 +542,25 @@ static inline int kvm_pgtable_stage2_init(struct kvm_pgtable *pgt, struct kvm_s2
 	return __kvm_pgtable_stage2_init(pgt, mmu, mm_ops, 0, NULL);
 }
 
+/**
+ * kvm_pgtable_stage2_destroy_range() - Destroy the unlinked range of addresses.
+ * @pgt:	Page-table structure initialised by kvm_pgtable_stage2_init*().
+ * @addr:	Intermediate physical address at which to place the mapping.
+ * @size:	Size of the mapping.
+ *
+ * The page-table is assumed to be unreachable by any hardware walkers prior
+ * to freeing and therefore no TLB invalidation is performed.
+ */
+void kvm_pgtable_stage2_destroy_range(struct kvm_pgtable *pgt,
+				       u64 addr, u64 size);
+/**
+ * kvm_pgtable_stage2_destroy_pgd() - Destroy the PGD of guest stage-2 page-table.
+ * @pgt:	Page-table structure initialised by kvm_pgtable_stage2_init*().
+ *
+ * It is assumed that the rest of the page-table is freed before this operation.
+ */
+void kvm_pgtable_stage2_destroy_pgd(struct kvm_pgtable *pgt);
+
 /**
  * kvm_pgtable_stage2_destroy() - Destroy an unused guest stage-2 page-table.
  * @pgt:	Page-table structure initialised by kvm_pgtable_stage2_init*().
diff --git a/arch/arm64/include/asm/kvm_pkvm.h b/arch/arm64/include/asm/kvm_pkvm.h
index ea58282f59bb..ad32ea90639c 100644
--- a/arch/arm64/include/asm/kvm_pkvm.h
+++ b/arch/arm64/include/asm/kvm_pkvm.h
@@ -197,4 +197,7 @@ void pkvm_pgtable_stage2_free_unlinked(struct kvm_pgtable_mm_ops *mm_ops, void *
 kvm_pte_t *pkvm_pgtable_stage2_create_unlinked(struct kvm_pgtable *pgt, u64 phys, s8 level,
 					       enum kvm_pgtable_prot prot, void *mc,
 					       bool force_pte);
+void pkvm_pgtable_stage2_destroy_range(struct kvm_pgtable *pgt,
+					u64 addr, u64 size);
+void pkvm_pgtable_stage2_destroy_pgd(struct kvm_pgtable *pgt);
 #endif	/* __ARM64_KVM_PKVM_H__ */
diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index c351b4abd5db..7fad791cf40b 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -1551,21 +1551,38 @@ static int stage2_free_walker(const struct kvm_pgtable_visit_ctx *ctx,
 	return 0;
 }
 
-void kvm_pgtable_stage2_destroy(struct kvm_pgtable *pgt)
+void kvm_pgtable_stage2_destroy_range(struct kvm_pgtable *pgt,
+				       u64 addr, u64 size)
 {
-	size_t pgd_sz;
 	struct kvm_pgtable_walker walker = {
 		.cb	= stage2_free_walker,
 		.flags	= KVM_PGTABLE_WALK_LEAF |
 			  KVM_PGTABLE_WALK_TABLE_POST,
 	};
 
-	WARN_ON(kvm_pgtable_walk(pgt, 0, BIT(pgt->ia_bits), &walker));
+	WARN_ON(kvm_pgtable_walk(pgt, addr, size, &walker));
+}
+
+void kvm_pgtable_stage2_destroy_pgd(struct kvm_pgtable *pgt)
+{
+	/*
+	 * We aren't doing a pgtable walk here, but the walker struct is needed
+	 * for kvm_dereference_pteref(), which only looks at the ->flags.
+	 */
+	struct kvm_pgtable_walker walker = {0};
+	size_t pgd_sz;
+
 	pgd_sz = kvm_pgd_pages(pgt->ia_bits, pgt->start_level) * PAGE_SIZE;
 	pgt->mm_ops->free_pages_exact(kvm_dereference_pteref(&walker, pgt->pgd), pgd_sz);
 	pgt->pgd = NULL;
 }
 
+void kvm_pgtable_stage2_destroy(struct kvm_pgtable *pgt)
+{
+	kvm_pgtable_stage2_destroy_range(pgt, 0, BIT(pgt->ia_bits));
+	kvm_pgtable_stage2_destroy_pgd(pgt);
+}
+
 void kvm_pgtable_stage2_free_unlinked(struct kvm_pgtable_mm_ops *mm_ops, void *pgtable, s8 level)
 {
 	kvm_pteref_t ptep = (kvm_pteref_t)pgtable;
diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
index fcd70bfe44fb..bf737717ccb4 100644
--- a/arch/arm64/kvm/pkvm.c
+++ b/arch/arm64/kvm/pkvm.c
@@ -450,3 +450,14 @@ int pkvm_pgtable_stage2_split(struct kvm_pgtable *pgt, u64 addr, u64 size,
 	WARN_ON_ONCE(1);
 	return -EINVAL;
 }
+
+void pkvm_pgtable_stage2_destroy_range(struct kvm_pgtable *pgt,
+					u64 addr, u64 size)
+{
+	WARN_ON_ONCE(1);
+}
+
+void pkvm_pgtable_stage2_destroy_pgd(struct kvm_pgtable *pgt)
+{
+	WARN_ON_ONCE(1);
+}
-- 
2.50.1.470.g6ba607880d-goog

