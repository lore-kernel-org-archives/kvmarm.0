Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3746EC7
	for <kvmarm@lists.linux.dev>; Tue, 11 Jun 2024 00:22:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718065322; cv=none; b=TxzZs4BMJ5VrUE/4ll0/5Z9pwXgKlszQqXcoZHNLUVcvm9Ji4dO2u8CvVv3t4B8iUq399twIN6klwhuvgvw6mb0uqTFonJVr1jNET+Gs//fTscmK0Y8usdSxfkhvqD2dZ5b9ZSWaw92O5/4FYJI86gPZg2mX9Q8mC7V7RuU5Rcw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718065322; c=relaxed/simple;
	bh=IMzEBBV4IPFmaMdvHVInrQZr7OKJx2Kta2GVtSnPoRs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=eztEpvvcL59y/csYv/2fdIiAqvHkquUmMX63+nYweR9WC5RRZwkzpozXdpdQUKHc9GCejxNFNztm8c1k5dntugY/F4OKK59x6ZEiWDiaEZFyT/wP8g9uPs0CNJ8+YG6SuX+UMv1hsUmea5axtWIGyMld1uGKqA1k+fiNuAvAhtI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=jMJf9UMd; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jMJf9UMd"
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-62a088faef7so66894407b3.0
        for <kvmarm@lists.linux.dev>; Mon, 10 Jun 2024 17:22:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1718065320; x=1718670120; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=UYg8xBfSHgODLvTlV3mxh03y8s3TyTlow0j+6oXRZyE=;
        b=jMJf9UMd8Uv77NfippBM8pW6UYU5EZTKn+4ou06PdkmULVxk8+XB2XFJCwQwQuXOTh
         coAnt3Ie8mI6l4+DG79W597zayC6y5/crp6ddupj/OuNvVDbRBxELjsFiuOSMRNJsD+K
         ghKhEEJ7Z328Hke7GbBl0XozIRrcEJvb25oP+6b5OSzvl28R18kmUGGC3B9x4jMSc5lv
         nt30jsRm/fcSXOECmZsHpPYwY1rjMh8VMhu3QqZDrYuL5J3yGbhgXgnJLzhd1EjaPGHb
         sDeQFy/7F1NEStjWxFA8gd08o9dCwdl4c4TKE0UUt8ZDAZo9kzzBawxzGYD1o4qtZCmY
         P13w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718065320; x=1718670120;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UYg8xBfSHgODLvTlV3mxh03y8s3TyTlow0j+6oXRZyE=;
        b=dnQowHAvjUPgy4PXSuhTB70CSPeDmzc6PYzkezx4q8KW6tdgw0+hOD527czXLZ7cbS
         fYxg4PBK4QHQY/uFLf3y8EaK6mXYHbP1WGtWNoqnsdNce0D3K1gE5qcVANpiXMr0qZls
         gnA48IuhLZG4hThpclSwYH+4xBnRfWNgeW7lOfdUeh4Zu+yfooS01ixtQGWyU207EwI6
         sPR0qKP3WHdGAQHoar+26JA8VmacS0/tizIV8qWFdt5ku3KpF34BiGDS8PS+u5+egmd1
         BFaghY7y8egXjgY3fyBtqiRANf0VMx/vL+ByHP5p+kxtVYV970fdEjTzIH/nXhdKVEuh
         aiBA==
X-Forwarded-Encrypted: i=1; AJvYcCVyj49C5nwdX2zgY0mtlHD6DSn56fGlndIexOpBvFj96+vw50HqvXGvU0kcDZWBxaNiLqvJX0PiGqZ+FjvplBSujyf/o8gW
X-Gm-Message-State: AOJu0YwY7myd/n5HIQmGavwAgv1J83SSu8OINDtOoXl/zc4Q3Hqn+S/t
	KFnmn1cIKhPLGJN4CtcS4It93xwEt/6fxk8Jd5NfEcInfM2oJqOAetpQB9upq1x+QMj7YvtzMHl
	3sYlmyfDI1NoHzNZxgg==
X-Google-Smtp-Source: AGHT+IEGsmdXMyxgJ1Cj/3hdc6/ErG88swxZnK/rdFuCwoqmhzkdtuuICPRcxc2axyqsks7ulwYmlzACcQfHnSLC
X-Received: from jthoughton.c.googlers.com ([fda3:e722:ac3:cc00:14:4d90:c0a8:2a4f])
 (user=jthoughton job=sendgmr) by 2002:a05:6902:1003:b0:dd9:20c1:85b6 with
 SMTP id 3f1490d57ef6-dfd9fcb617bmr288182276.2.1718065319751; Mon, 10 Jun 2024
 17:21:59 -0700 (PDT)
Date: Tue, 11 Jun 2024 00:21:37 +0000
In-Reply-To: <20240611002145.2078921-1-jthoughton@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240611002145.2078921-1-jthoughton@google.com>
X-Mailer: git-send-email 2.45.2.505.gda0bf45e8d-goog
Message-ID: <20240611002145.2078921-2-jthoughton@google.com>
Subject: [PATCH v5 1/9] KVM: Add lockless memslot walk to KVM
From: James Houghton <jthoughton@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, Paolo Bonzini <pbonzini@redhat.com>
Cc: Ankit Agrawal <ankita@nvidia.com>, Axel Rasmussen <axelrasmussen@google.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, David Matlack <dmatlack@google.com>, 
	David Rientjes <rientjes@google.com>, James Houghton <jthoughton@google.com>, 
	James Morse <james.morse@arm.com>, Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Raghavendra Rao Ananta <rananta@google.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Sean Christopherson <seanjc@google.com>, 
	Shaoqin Huang <shahuang@redhat.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Wei Xu <weixugc@google.com>, Will Deacon <will@kernel.org>, Yu Zhao <yuzhao@google.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, kvmarm@lists.linux.dev, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"

Provide flexibility to the architecture to synchronize as optimally as
they can instead of always taking the MMU lock for writing.

Architectures that do their own locking must select
CONFIG_KVM_MMU_NOTIFIER_YOUNG_LOCKLESS.

The immediate application is to allow architectures to implement the
test/clear_young MMU notifiers more cheaply.

Suggested-by: Yu Zhao <yuzhao@google.com>
Signed-off-by: James Houghton <jthoughton@google.com>
---
 include/linux/kvm_host.h |  1 +
 virt/kvm/Kconfig         |  3 +++
 virt/kvm/kvm_main.c      | 26 +++++++++++++++++++-------
 3 files changed, 23 insertions(+), 7 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 692c01e41a18..4d7c3e8632e6 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -266,6 +266,7 @@ struct kvm_gfn_range {
 	gfn_t end;
 	union kvm_mmu_notifier_arg arg;
 	bool may_block;
+	bool lockless;
 };
 bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range);
 bool kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range);
diff --git a/virt/kvm/Kconfig b/virt/kvm/Kconfig
index 29b73eedfe74..0404857c1702 100644
--- a/virt/kvm/Kconfig
+++ b/virt/kvm/Kconfig
@@ -97,6 +97,9 @@ config KVM_GENERIC_MMU_NOTIFIER
        select MMU_NOTIFIER
        bool
 
+config KVM_MMU_NOTIFIER_YOUNG_LOCKLESS
+       bool
+
 config KVM_GENERIC_MEMORY_ATTRIBUTES
        depends on KVM_GENERIC_MMU_NOTIFIER
        bool
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 14841acb8b95..d8fa0d617f12 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -558,6 +558,7 @@ struct kvm_mmu_notifier_range {
 	on_lock_fn_t on_lock;
 	bool flush_on_ret;
 	bool may_block;
+	bool lockless;
 };
 
 /*
@@ -612,6 +613,10 @@ static __always_inline kvm_mn_ret_t __kvm_handle_hva_range(struct kvm *kvm,
 			 IS_KVM_NULL_FN(range->handler)))
 		return r;
 
+	/* on_lock will never be called for lockless walks */
+	if (WARN_ON_ONCE(range->lockless && !IS_KVM_NULL_FN(range->on_lock)))
+		return r;
+
 	idx = srcu_read_lock(&kvm->srcu);
 
 	for (i = 0; i < kvm_arch_nr_memslot_as_ids(kvm); i++) {
@@ -643,15 +648,18 @@ static __always_inline kvm_mn_ret_t __kvm_handle_hva_range(struct kvm *kvm,
 			gfn_range.start = hva_to_gfn_memslot(hva_start, slot);
 			gfn_range.end = hva_to_gfn_memslot(hva_end + PAGE_SIZE - 1, slot);
 			gfn_range.slot = slot;
+			gfn_range.lockless = range->lockless;
 
 			if (!r.found_memslot) {
 				r.found_memslot = true;
-				KVM_MMU_LOCK(kvm);
-				if (!IS_KVM_NULL_FN(range->on_lock))
-					range->on_lock(kvm);
-
-				if (IS_KVM_NULL_FN(range->handler))
-					break;
+				if (!range->lockless) {
+					KVM_MMU_LOCK(kvm);
+					if (!IS_KVM_NULL_FN(range->on_lock))
+						range->on_lock(kvm);
+
+					if (IS_KVM_NULL_FN(range->handler))
+						break;
+				}
 			}
 			r.ret |= range->handler(kvm, &gfn_range);
 		}
@@ -660,7 +668,7 @@ static __always_inline kvm_mn_ret_t __kvm_handle_hva_range(struct kvm *kvm,
 	if (range->flush_on_ret && r.ret)
 		kvm_flush_remote_tlbs(kvm);
 
-	if (r.found_memslot)
+	if (r.found_memslot && !range->lockless)
 		KVM_MMU_UNLOCK(kvm);
 
 	srcu_read_unlock(&kvm->srcu, idx);
@@ -681,6 +689,8 @@ static __always_inline int kvm_handle_hva_range(struct mmu_notifier *mn,
 		.on_lock	= (void *)kvm_null_fn,
 		.flush_on_ret	= true,
 		.may_block	= false,
+		.lockless	=
+			IS_ENABLED(CONFIG_KVM_MMU_NOTIFIER_YOUNG_LOCKLESS),
 	};
 
 	return __kvm_handle_hva_range(kvm, &range).ret;
@@ -699,6 +709,8 @@ static __always_inline int kvm_handle_hva_range_no_flush(struct mmu_notifier *mn
 		.on_lock	= (void *)kvm_null_fn,
 		.flush_on_ret	= false,
 		.may_block	= false,
+		.lockless	=
+			IS_ENABLED(CONFIG_KVM_MMU_NOTIFIER_YOUNG_LOCKLESS),
 	};
 
 	return __kvm_handle_hva_range(kvm, &range).ret;
-- 
2.45.2.505.gda0bf45e8d-goog

