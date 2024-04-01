Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4CFF58AA1
	for <kvmarm@lists.linux.dev>; Mon,  1 Apr 2024 23:30:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712014205; cv=none; b=MUCV9MGsgayBTxXvoWmAaCZVl1y5RVz9w06JT5ly7Ok5zf1u0aNpD99xjvrMH3B60mz3umnYht2TSgIw550RePJHLLk8qWihrVt7HmFbWjTFQH/WPKIEf4pd6ykNOWkGEsVamii1N67ZBt2g7+iIq6RveTIajeBH3pNTv4JqCdA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712014205; c=relaxed/simple;
	bh=vEJ66PSQneaCo/JOqhHafRHhgsXUJtqqHHPI2pDYAj0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=PFkuLeeC89uJUFevSrAtio+1ZjA16XA7Z9X8+cFa1bJJy7vRacPkbkTr1xbDempoc5SLlxcdJNgP1MjgFSVD5ERqStfLFvKqkKWaUjM8d6cjjCw5VSumzmsYIqHeaGZNf4HAqcgp/YaTnG8Vx3f8Dg4rGnH8/25hzqDa7KjaiA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=xy+w9VKZ; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="xy+w9VKZ"
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-60cbba6f571so83605377b3.1
        for <kvmarm@lists.linux.dev>; Mon, 01 Apr 2024 16:30:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712014202; x=1712619002; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=CifQvULm5VcvU50LwCct+JTf2gCEq9urL1yip38iv3E=;
        b=xy+w9VKZs54zGkL4orZK4RQ3YPnD9kxxRSlMt9n6b6B6/qLjuoymS7JbO5nVtziUUt
         xcFZaaEbJP6Rd+N3wDmuNjzFaJ7CxUjrbl2SiTxpoUdkhKA8gT+8fpXgjTGWydT71xAj
         KUPPJH/BsozigWWXb04stQoChh76y49CBsMGHfFDfUSZz7Vv/HpcSsePLkOA3jvf9UmS
         +xUIeDDt5c5XWlY5MbiDxQAo4Ae2kMrlHR7v/hHpIJ7EWBPAn5fwSrGS0Hgoaa3nrZ1S
         sNvjQ2nj1ebZhElj3C5rOxwEiULDOe949T1Tw60DdZiXfZQmRtkQRj8z6STpMGQrp6xA
         6vpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712014202; x=1712619002;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CifQvULm5VcvU50LwCct+JTf2gCEq9urL1yip38iv3E=;
        b=YYSZ77IYlmeO984qgLbQT2KFHV7hRXOBIx6byeTO4kFfDCkzM6HPtPZ9UmxbXiF4Ac
         3CWpaIX/+ldWckUa3AwOZ4STRcNOAhVicD28btpiwlMxJM4g06/1uiVZg8iDuVt6OLoT
         yXPKM4LJX6NYDHddcmOJDbjijli98pHJp6LLmTlB7RFMjbPyOVl8FI3YtaFdG4uPRVYD
         SySmCJdwUI1HnBPgloZrr7eb5M8ZjZMp/u253nhrorgByG2SR2jKRsoL07633+0QfMr5
         QFBqGvqoLsksjQaRckru5BU9c2Df460jQbfTDLgMyrlKn82TXEDS0vTOkeV6rdoB1LuT
         MnGg==
X-Forwarded-Encrypted: i=1; AJvYcCXQfmFV1NhJ/K2assOAQZloxQX9mAe4rVQy3Yxn80spKg8+MMdzVK+SzcRx6WafYKLx5CaAZwDlSxvj7fs7ngsPIuZWEsMa
X-Gm-Message-State: AOJu0YwQVeK9mdLB5IVxlnT8OcXEPbM3jCtoxrqYkNcaI4Qe3maQwU9s
	kXVPGjdeyhq8zuOnDu0FKQCMOmJDyO0rbBAkRYpjcMj6y+7v3/RF3/ZRsiFgkg8QqQiE/yHID5r
	acD4YOHd6D7wvBUTW8Q==
X-Google-Smtp-Source: AGHT+IGQAk6u/Sk8y21e9rySBKwdkEDK33GoLWkr+tAsmcolw1O4jbXBJxOpzuSZWzDHw9bmaDUMZf63oZp0WmR7
X-Received: from jthoughton.c.googlers.com ([fda3:e722:ac3:cc00:14:4d90:c0a8:2a4f])
 (user=jthoughton job=sendgmr) by 2002:a05:690c:650e:b0:615:165b:8dde with
 SMTP id hw14-20020a05690c650e00b00615165b8ddemr268650ywb.10.1712014201787;
 Mon, 01 Apr 2024 16:30:01 -0700 (PDT)
Date: Mon,  1 Apr 2024 23:29:45 +0000
In-Reply-To: <20240401232946.1837665-1-jthoughton@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240401232946.1837665-1-jthoughton@google.com>
X-Mailer: git-send-email 2.44.0.478.gd926399ef9-goog
Message-ID: <20240401232946.1837665-7-jthoughton@google.com>
Subject: [PATCH v3 6/7] KVM: arm64: Participate in bitmap-based PTE aging
From: James Houghton <jthoughton@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, Paolo Bonzini <pbonzini@redhat.com>
Cc: Yu Zhao <yuzhao@google.com>, David Matlack <dmatlack@google.com>, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Sean Christopherson <seanjc@google.com>, Jonathan Corbet <corbet@lwn.net>, James Morse <james.morse@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Shaoqin Huang <shahuang@redhat.com>, 
	Gavin Shan <gshan@redhat.com>, Ricardo Koller <ricarkol@google.com>, 
	Raghavendra Rao Ananta <rananta@google.com>, Ryan Roberts <ryan.roberts@arm.com>, 
	David Rientjes <rientjes@google.com>, Axel Rasmussen <axelrasmussen@google.com>, 
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-mm@kvack.org, 
	linux-trace-kernel@vger.kernel.org, James Houghton <jthoughton@google.com>
Content-Type: text/plain; charset="UTF-8"

Participate in bitmap-based aging while grabbing the KVM MMU lock for
reading. Ideally we wouldn't need to grab this lock at all, but that
would require a more intrustive and risky change. Also pass
KVM_PGTABLE_WALK_SHARED, as this software walker is safe to run in
parallel with other walkers.

It is safe only to grab the KVM MMU lock for reading as the kvm_pgtable
is destroyed while holding the lock for writing, and freeing of the page
table pages is either done while holding the MMU lock for writing or
after an RCU grace period.

When mkold == false, record the young pages in the passed-in bitmap.

When mkold == true, only age the pages that need aging according to the
passed-in bitmap.

Suggested-by: Yu Zhao <yuzhao@google.com>
Signed-off-by: James Houghton <jthoughton@google.com>
---
 arch/arm64/include/asm/kvm_host.h    |  5 +++++
 arch/arm64/include/asm/kvm_pgtable.h |  4 +++-
 arch/arm64/kvm/hyp/pgtable.c         | 21 ++++++++++++++-------
 arch/arm64/kvm/mmu.c                 | 23 +++++++++++++++++++++--
 4 files changed, 43 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 9e8a496fb284..e503553cb356 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -1331,4 +1331,9 @@ bool kvm_arm_vcpu_stopped(struct kvm_vcpu *vcpu);
 	(get_idreg_field((kvm), id, fld) >= expand_field_sign(id, fld, min) && \
 	 get_idreg_field((kvm), id, fld) <= expand_field_sign(id, fld, max))
 
+#define kvm_arch_prepare_bitmap_age kvm_arch_prepare_bitmap_age
+bool kvm_arch_prepare_bitmap_age(struct mmu_notifier *mn);
+#define kvm_arch_finish_bitmap_age kvm_arch_finish_bitmap_age
+void kvm_arch_finish_bitmap_age(struct mmu_notifier *mn);
+
 #endif /* __ARM64_KVM_HOST_H__ */
diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index 19278dfe7978..1976b4e26188 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -644,6 +644,7 @@ kvm_pte_t kvm_pgtable_stage2_mkyoung(struct kvm_pgtable *pgt, u64 addr);
  * @addr:	Intermediate physical address to identify the page-table entry.
  * @size:	Size of the address range to visit.
  * @mkold:	True if the access flag should be cleared.
+ * @range:	The kvm_gfn_range that is being used for the memslot walker.
  *
  * The offset of @addr within a page is ignored.
  *
@@ -657,7 +658,8 @@ kvm_pte_t kvm_pgtable_stage2_mkyoung(struct kvm_pgtable *pgt, u64 addr);
  * Return: True if any of the visited PTEs had the access flag set.
  */
 bool kvm_pgtable_stage2_test_clear_young(struct kvm_pgtable *pgt, u64 addr,
-					 u64 size, bool mkold);
+					 u64 size, bool mkold,
+					 struct kvm_gfn_range *range);
 
 /**
  * kvm_pgtable_stage2_relax_perms() - Relax the permissions enforced by a
diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index 3fae5830f8d2..e881d3595aca 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -1281,6 +1281,7 @@ kvm_pte_t kvm_pgtable_stage2_mkyoung(struct kvm_pgtable *pgt, u64 addr)
 }
 
 struct stage2_age_data {
+	struct kvm_gfn_range *range;
 	bool	mkold;
 	bool	young;
 };
@@ -1290,20 +1291,24 @@ static int stage2_age_walker(const struct kvm_pgtable_visit_ctx *ctx,
 {
 	kvm_pte_t new = ctx->old & ~KVM_PTE_LEAF_ATTR_LO_S2_AF;
 	struct stage2_age_data *data = ctx->arg;
+	gfn_t gfn = ctx->addr / PAGE_SIZE;
 
 	if (!kvm_pte_valid(ctx->old) || new == ctx->old)
 		return 0;
 
 	data->young = true;
 
+
 	/*
-	 * stage2_age_walker() is always called while holding the MMU lock for
-	 * write, so this will always succeed. Nonetheless, this deliberately
-	 * follows the race detection pattern of the other stage-2 walkers in
-	 * case the locking mechanics of the MMU notifiers is ever changed.
+	 * stage2_age_walker() may not be holding the MMU lock for write, so
+	 * follow the race detection pattern of the other stage-2 walkers.
 	 */
-	if (data->mkold && !stage2_try_set_pte(ctx, new))
-		return -EAGAIN;
+	if (data->mkold) {
+		if (kvm_gfn_should_age(data->range, gfn) &&
+				!stage2_try_set_pte(ctx, new))
+			return -EAGAIN;
+	} else
+		kvm_gfn_record_young(data->range, gfn);
 
 	/*
 	 * "But where's the TLBI?!", you scream.
@@ -1315,10 +1320,12 @@ static int stage2_age_walker(const struct kvm_pgtable_visit_ctx *ctx,
 }
 
 bool kvm_pgtable_stage2_test_clear_young(struct kvm_pgtable *pgt, u64 addr,
-					 u64 size, bool mkold)
+					 u64 size, bool mkold,
+					 struct kvm_gfn_range *range)
 {
 	struct stage2_age_data data = {
 		.mkold		= mkold,
+		.range		= range,
 	};
 	struct kvm_pgtable_walker walker = {
 		.cb		= stage2_age_walker,
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 18680771cdb0..104cc23e9bb3 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1802,6 +1802,25 @@ bool kvm_set_spte_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 	return false;
 }
 
+bool kvm_arch_prepare_bitmap_age(struct mmu_notifier *mn)
+{
+	struct kvm *kvm = mmu_notifier_to_kvm(mn);
+
+	/*
+	 * We need to hold the MMU lock for reading to prevent page tables
+	 * from being freed underneath us.
+	 */
+	read_lock(&kvm->mmu_lock);
+	return true;
+}
+
+void kvm_arch_finish_bitmap_age(struct mmu_notifier *mn)
+{
+	struct kvm *kvm = mmu_notifier_to_kvm(mn);
+
+	read_unlock(&kvm->mmu_lock);
+}
+
 bool kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 {
 	u64 size = (range->end - range->start) << PAGE_SHIFT;
@@ -1811,7 +1830,7 @@ bool kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 
 	return kvm_pgtable_stage2_test_clear_young(kvm->arch.mmu.pgt,
 						   range->start << PAGE_SHIFT,
-						   size, true);
+						   size, true, range);
 }
 
 bool kvm_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
@@ -1823,7 +1842,7 @@ bool kvm_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 
 	return kvm_pgtable_stage2_test_clear_young(kvm->arch.mmu.pgt,
 						   range->start << PAGE_SHIFT,
-						   size, false);
+						   size, false, range);
 }
 
 phys_addr_t kvm_mmu_get_httbr(void)
-- 
2.44.0.478.gd926399ef9-goog

