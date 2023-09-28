Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40295374FC
	for <kvmarm@lists.linux.dev>; Thu, 28 Sep 2023 17:32:18 +0000 (UTC)
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-d8191a1d5acso20260679276.1
        for <kvmarm@lists.linux.dev>; Thu, 28 Sep 2023 10:32:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1695922338; x=1696527138; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=oE1bPfUJTQsQ/yIbfzwaE5cLdZ9DfBf0dADmXwJMZog=;
        b=hDHzCo5gcJ6jOfZBZVb/k9YjglXNEbDNcD/unbIsZmDHcecvfwr30eKZrQCkIKXbyR
         e5EYqqERfWlP+bLuLFoBumU9/eWbrRaCW91nGy8Vs33T5i6CtVaioxzDYABnno4KAKNh
         hv5zFC4PuGYWK6vBZj4cx6YH1KB2ahHIvvj78t6da4LzttLRqNQ4P32EMUp2q2JwgRHi
         fefhGSqWuK0vkS8GMsvvixBBYjVDtJ7qOARlcYYTGZBl6Oquux+MVH/rWxJyLjT3QiFP
         wXSelvelUwCho7LO9YLby/rmBoxP8Vh6NU43QWsP6pJWXWohIQyIJ990zZE7Tj1+lAQN
         5g0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695922338; x=1696527138;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oE1bPfUJTQsQ/yIbfzwaE5cLdZ9DfBf0dADmXwJMZog=;
        b=r3+0QFRoqDhE32dHXACO2m5J7w9u8JKqQVjR9M/6Ev4T66XLWfjFjkvBPrz4AXOhvY
         bna4qqJY0YplrcLD4qrvcWgqdEBBUQF2F7gilSaihb2Owqz0ttmfX/9X0fXBebIAktsO
         pii4GYMinQlVM1xqqltg5jy3d0XnHOvGCwzG9yOa0VsZgcECXJFoTpoXnfVxRrVUt7p2
         C3nDY75LuaeOXUR7yz26yhgZ6LPmJGJ9Z9ViPCaimIf0+vIpRmts14LIkotM+UGYrysf
         kH5s9dwPtNPYfbgstYQcmyLLwlI9tVS6txkTgm0yTTmDcuOS8Z/59u/dIA84TJhFpP0B
         FkPw==
X-Gm-Message-State: AOJu0YwzDfU16MVAsHbT1zAHt8OudBmhV9PQxjMrnk2BiugAah5WWlyr
	ja8FpC10etNiLUh8lzz8cYglKlYqlvSj0EXH
X-Google-Smtp-Source: AGHT+IEYD/Bsn2ww5i0Im0lm2faKv5QwH7fKM71MswQZo1QvGz692BVrUSJZXvIpRoyOP952GIplH8aBbdhhmTza
X-Received: from vdonnefort.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:2eea])
 (user=vdonnefort job=sendgmr) by 2002:a25:408a:0:b0:d77:f4f5:9e4 with SMTP id
 n132-20020a25408a000000b00d77f4f509e4mr23919yba.2.1695922337778; Thu, 28 Sep
 2023 10:32:17 -0700 (PDT)
Date: Thu, 28 Sep 2023 18:32:04 +0100
In-Reply-To: <20230928173205.2826598-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230928173205.2826598-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.42.0.515.g380fc7ccd1-goog
Message-ID: <20230928173205.2826598-3-vdonnefort@google.com>
Subject: [PATCH v2 2/2] KVM: arm64: Use folio for THP adjustment
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oliver.upton@linux.dev
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	kernel-team@android.com, will@kernel.org, willy@infradead.org, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

Since commit cb196ee1ef39 ("mm/huge_memory: convert
do_huge_pmd_anonymous_page() to use vma_alloc_folio()"), transparent
huge pages use folios. It enables us to check efficiently if a page is
mapped by a block simply looking at the folio size. This is saving a
page table walk.

It is safe to read the folio in this path. We've just increased its
refcount (GUP from __gfn_to_pfn_memslot()). This will prevent attempts
of splitting the huge page.

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index de5e5148ef5d..69fcbcc7aca5 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -791,51 +791,6 @@ int create_hyp_exec_mappings(phys_addr_t phys_addr, size_t size,
 	return 0;
 }
 
-static struct kvm_pgtable_mm_ops kvm_user_mm_ops = {
-	/* We shouldn't need any other callback to walk the PT */
-	.phys_to_virt		= kvm_host_va,
-};
-
-static int get_user_mapping_size(struct kvm *kvm, u64 addr)
-{
-	struct kvm_pgtable pgt = {
-		.pgd		= (kvm_pteref_t)kvm->mm->pgd,
-		.ia_bits	= vabits_actual,
-		.start_level	= (KVM_PGTABLE_MAX_LEVELS -
-				   CONFIG_PGTABLE_LEVELS),
-		.mm_ops		= &kvm_user_mm_ops,
-	};
-	unsigned long flags;
-	kvm_pte_t pte = 0;	/* Keep GCC quiet... */
-	u32 level = ~0;
-	int ret;
-
-	/*
-	 * Disable IRQs so that we hazard against a concurrent
-	 * teardown of the userspace page tables (which relies on
-	 * IPI-ing threads).
-	 */
-	local_irq_save(flags);
-	ret = kvm_pgtable_get_leaf(&pgt, addr, &pte, &level);
-	local_irq_restore(flags);
-
-	if (ret)
-		return ret;
-
-	/*
-	 * Not seeing an error, but not updating level? Something went
-	 * deeply wrong...
-	 */
-	if (WARN_ON(level >= KVM_PGTABLE_MAX_LEVELS))
-		return -EFAULT;
-
-	/* Oops, the userspace PTs are gone... Replay the fault */
-	if (!kvm_pte_valid(pte))
-		return -EAGAIN;
-
-	return BIT(ARM64_HW_PGTABLE_LEVEL_SHIFT(level));
-}
-
 static struct kvm_pgtable_mm_ops kvm_s2_mm_ops = {
 	.zalloc_page		= stage2_memcache_zalloc_page,
 	.zalloc_pages_exact	= kvm_s2_zalloc_pages_exact,
@@ -1274,7 +1229,7 @@ static bool fault_supports_stage2_huge_mapping(struct kvm_memory_slot *memslot,
  *
  * Returns the size of the mapping.
  */
-static long
+static unsigned long
 transparent_hugepage_adjust(struct kvm *kvm, struct kvm_memory_slot *memslot,
 			    unsigned long hva, kvm_pfn_t *pfnp,
 			    phys_addr_t *ipap)
@@ -1287,10 +1242,7 @@ transparent_hugepage_adjust(struct kvm *kvm, struct kvm_memory_slot *memslot,
 	 * block map is contained within the memslot.
 	 */
 	if (fault_supports_stage2_huge_mapping(memslot, hva, PMD_SIZE)) {
-		int sz = get_user_mapping_size(kvm, hva);
-
-		if (sz < 0)
-			return sz;
+		size_t sz = folio_size(pfn_folio(pfn));
 
 		if (sz < PMD_SIZE)
 			return PAGE_SIZE;
@@ -1385,7 +1337,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	kvm_pfn_t pfn;
 	bool logging_active = memslot_is_logging(memslot);
 	unsigned long fault_level = kvm_vcpu_trap_get_fault_level(vcpu);
-	long vma_pagesize, fault_granule;
+	unsigned long vma_pagesize, fault_granule;
 	enum kvm_pgtable_prot prot = KVM_PGTABLE_PROT_R;
 	struct kvm_pgtable *pgt;
 
@@ -1530,11 +1482,6 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 			vma_pagesize = transparent_hugepage_adjust(kvm, memslot,
 								   hva, &pfn,
 								   &fault_ipa);
-
-		if (vma_pagesize < 0) {
-			ret = vma_pagesize;
-			goto out_unlock;
-		}
 	}
 
 	if (fault_status != ESR_ELx_FSC_PERM && !device && kvm_has_mte(kvm)) {
-- 
2.42.0.515.g380fc7ccd1-goog

