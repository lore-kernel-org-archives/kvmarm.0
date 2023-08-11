Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F328A46
	for <kvmarm@lists.linux.dev>; Fri, 11 Aug 2023 11:20:55 +0000 (UTC)
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-30e3ee8a42eso1110996f8f.1
        for <kvmarm@lists.linux.dev>; Fri, 11 Aug 2023 04:20:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1691752853; x=1692357653;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=s0d5RDtF7Q69b5PMzsetdDZKJQDSg4e0IrplZn4jgUw=;
        b=IkPctSKHE53dSZrM8cI8q4NtdmRb63Nvszus5w8T/x55WYGaCJDDjP/nfy4Hf3bP8b
         2oVvPXqa4memFAiWiQ69krCpN4Aok6bgtlp31xnXlUJOy8Ew19LbUP6Jf3GgxAJFaVKJ
         vlZ2uiYBxjfuyQxStWC6KbNd3A0ta5kUyZRxGStUPo8nHQjrzuI5bzd3Lrb5EiH7hu1w
         JOb+T5ykumVbWdHRjuhOmdw4fGrr5RghX4Os1muCaGvWO5fgANiNTM/qlqqpn8EyyplR
         nV3UN9GVQhVwUxxiGJvEmiW3GJDPkfYAp60FHMIKtxyDrOU/R1qzqBH+URNgdWR1vb/9
         Itrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691752853; x=1692357653;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=s0d5RDtF7Q69b5PMzsetdDZKJQDSg4e0IrplZn4jgUw=;
        b=cYeXxS1eCUaeU4NUap7cTL0ViFVE4VgBhzysOXfkQFfZUP4/qjaoNmQIrfSappza5Z
         6kGtWBbtdF2ofzCJ+fGXfDEc1a2s1sbaoJTPNmEfsb2NUTOi5yRTT9YylIKA3BDjyeDC
         gpea2YDwFNCV6Taffq5JllHJnttvV9S0Bv7HrU9Xm81ZzC/XVb096C/U7eBp+9L7Na70
         MkITgPBGkHz1BBXR0MXSkc02X4eKhEvh38xsINxORLBvYsy5hIJ/Wpi27eEdhpUpqNPs
         2LlkltfCwuypi8aFMnuw/MljF6Ear/vrdSryyOqFL43cUOj1vb63mRFfwoXHAb+Q5+t5
         8mPg==
X-Gm-Message-State: AOJu0YwEe/x5EfNsMRhWtt7LnUtlb1X8JxVwO5lGis1Kmkj6PFqIaZ13
	OUmLyqJ3CW9asUrfP524KCvsU/8sX8ubHIjm
X-Google-Smtp-Source: AGHT+IE+8/x0pRcBHakuiIZTI52Y8jvOqEiawcH9yz6Y9vmZUttv/wJraw+OBDTTNgAmwHmC6151+NacYijWfbbJ
X-Received: from vdonnefort.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:2eea])
 (user=vdonnefort job=sendgmr) by 2002:a5d:53c3:0:b0:317:6855:dc2c with SMTP
 id a3-20020a5d53c3000000b003176855dc2cmr7438wrw.6.1691752853236; Fri, 11 Aug
 2023 04:20:53 -0700 (PDT)
Date: Fri, 11 Aug 2023 12:20:37 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.41.0.640.ga95def55d0-goog
Message-ID: <20230811112037.1147863-1-vdonnefort@google.com>
Subject: [PATCH v2] KVM: arm64: Remove size-order align in the nVHE hyp
 private VA range
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oliver.upton@linux.dev
Cc: kvmarm@lists.linux.dev, qperret@google.com, smostafa@google.com, 
	kaleshsingh@google.com, linux-arm-kernel@lists.infradead.org, 
	kernel-team@android.com, will@kernel.org, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

commit f922c13e778d ("KVM: arm64: Introduce
pkvm_alloc_private_va_range()") and commit 92abe0f81e13 ("KVM: arm64:
Introduce hyp_alloc_private_va_range()") added an alignment for the
start address of any allocation into the nVHE hypervisor private VA
range.

This alignment (order of the size of the allocation) intends to enable
efficient stack verification (if the PAGE_SHIFT bit is zero, the stack
pointer is on the guard page and a stack overflow occurred).

But this is only necessary for stack allocation and can waste a lot of
VA space. So instead make stack-specific functions, handling the guard
page requirements, while other users (e.g.  fixmap) will only get page
alignment.

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

---

v1 -> v2:
  * hyp_create_stack() -> pkvm_create_stack() (Kalesh)
  * Add !protected version as well (Kalesh)
  * phys_addr_t as type for PAs

---

diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index 0e1e1ab17b4d..96a80e8f6226 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -168,6 +168,7 @@ int create_hyp_io_mappings(phys_addr_t phys_addr, size_t size,
 			   void __iomem **haddr);
 int create_hyp_exec_mappings(phys_addr_t phys_addr, size_t size,
 			     void **haddr);
+int create_hyp_stack(phys_addr_t phys_addr, unsigned long *haddr);
 void __init free_hyp_pgds(void);
 
 void stage2_unmap_vm(struct kvm *kvm);
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 72dc53a75d1c..9acce45df2b5 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -2283,30 +2283,8 @@ static int __init init_hyp_mode(void)
 	for_each_possible_cpu(cpu) {
 		struct kvm_nvhe_init_params *params = per_cpu_ptr_nvhe_sym(kvm_init_params, cpu);
 		char *stack_page = (char *)per_cpu(kvm_arm_hyp_stack_page, cpu);
-		unsigned long hyp_addr;
 
-		/*
-		 * Allocate a contiguous HYP private VA range for the stack
-		 * and guard page. The allocation is also aligned based on
-		 * the order of its size.
-		 */
-		err = hyp_alloc_private_va_range(PAGE_SIZE * 2, &hyp_addr);
-		if (err) {
-			kvm_err("Cannot allocate hyp stack guard page\n");
-			goto out_err;
-		}
-
-		/*
-		 * Since the stack grows downwards, map the stack to the page
-		 * at the higher address and leave the lower guard page
-		 * unbacked.
-		 *
-		 * Any valid stack address now has the PAGE_SHIFT bit as 1
-		 * and addresses corresponding to the guard page have the
-		 * PAGE_SHIFT bit as 0 - this is used for overflow detection.
-		 */
-		err = __create_hyp_mappings(hyp_addr + PAGE_SIZE, PAGE_SIZE,
-					    __pa(stack_page), PAGE_HYP);
+		err = create_hyp_stack(__pa(stack_page), &params->stack_hyp_va);
 		if (err) {
 			kvm_err("Cannot map hyp stack\n");
 			goto out_err;
@@ -2319,8 +2297,6 @@ static int __init init_hyp_mode(void)
 		 * has been mapped in the flexible private VA space.
 		 */
 		params->stack_pa = __pa(stack_page);
-
-		params->stack_hyp_va = hyp_addr + (2 * PAGE_SIZE);
 	}
 
 	for_each_possible_cpu(cpu) {
diff --git a/arch/arm64/kvm/hyp/include/nvhe/mm.h b/arch/arm64/kvm/hyp/include/nvhe/mm.h
index d5ec972b5c1e..230e4f2527de 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/mm.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/mm.h
@@ -26,6 +26,7 @@ int pkvm_create_mappings_locked(void *from, void *to, enum kvm_pgtable_prot prot
 int __pkvm_create_private_mapping(phys_addr_t phys, size_t size,
 				  enum kvm_pgtable_prot prot,
 				  unsigned long *haddr);
+int pkvm_create_stack(phys_addr_t phys, unsigned long *haddr);
 int pkvm_alloc_private_va_range(size_t size, unsigned long *haddr);
 
 #endif /* __KVM_HYP_MM_H */
diff --git a/arch/arm64/kvm/hyp/nvhe/mm.c b/arch/arm64/kvm/hyp/nvhe/mm.c
index 318298eb3d6b..65a7a186d7b2 100644
--- a/arch/arm64/kvm/hyp/nvhe/mm.c
+++ b/arch/arm64/kvm/hyp/nvhe/mm.c
@@ -44,6 +44,27 @@ static int __pkvm_create_mappings(unsigned long start, unsigned long size,
 	return err;
 }
 
+static int __pkvm_alloc_private_va_range(unsigned long start, size_t size)
+{
+	unsigned long cur;
+
+	hyp_assert_lock_held(&pkvm_pgd_lock);
+
+	if (!start || start < __io_map_base)
+		return -EINVAL;
+
+	/* The allocated size is always a multiple of PAGE_SIZE */
+	cur = start + PAGE_ALIGN(size);
+
+	/* Are we overflowing on the vmemmap ? */
+	if (cur > __hyp_vmemmap)
+		return -ENOMEM;
+
+	__io_map_base = cur;
+
+	return 0;
+}
+
 /**
  * pkvm_alloc_private_va_range - Allocates a private VA range.
  * @size:	The size of the VA range to reserve.
@@ -56,27 +77,16 @@ static int __pkvm_create_mappings(unsigned long start, unsigned long size,
  */
 int pkvm_alloc_private_va_range(size_t size, unsigned long *haddr)
 {
-	unsigned long base, addr;
-	int ret = 0;
+	unsigned long addr;
+	int ret;
 
 	hyp_spin_lock(&pkvm_pgd_lock);
-
-	/* Align the allocation based on the order of its size */
-	addr = ALIGN(__io_map_base, PAGE_SIZE << get_order(size));
-
-	/* The allocated size is always a multiple of PAGE_SIZE */
-	base = addr + PAGE_ALIGN(size);
-
-	/* Are we overflowing on the vmemmap ? */
-	if (!addr || base > __hyp_vmemmap)
-		ret = -ENOMEM;
-	else {
-		__io_map_base = base;
-		*haddr = addr;
-	}
-
+	addr = __io_map_base;
+	ret = __pkvm_alloc_private_va_range(addr, size);
 	hyp_spin_unlock(&pkvm_pgd_lock);
 
+	*haddr = addr;
+
 	return ret;
 }
 
@@ -340,6 +350,45 @@ int hyp_create_idmap(u32 hyp_va_bits)
 	return __pkvm_create_mappings(start, end - start, start, PAGE_HYP_EXEC);
 }
 
+int pkvm_create_stack(phys_addr_t phys, unsigned long *haddr)
+{
+	unsigned long addr, prev_base;
+	size_t size;
+	int ret;
+
+	hyp_spin_lock(&pkvm_pgd_lock);
+
+	prev_base = __io_map_base;
+	/*
+	 * Efficient stack verification using the PAGE_SHIFT bit implies
+	 * an alignment of our allocation on the order of the size.
+	 */
+	size = PAGE_SIZE * 2;
+	addr = ALIGN(__io_map_base, size);
+
+	ret = __pkvm_alloc_private_va_range(addr, size);
+	if (!ret) {
+		/*
+		 * Since the stack grows downwards, map the stack to the page
+		 * at the higher address and leave the lower guard page
+		 * unbacked.
+		 *
+		 * Any valid stack address now has the PAGE_SHIFT bit as 1
+		 * and addresses corresponding to the guard page have the
+		 * PAGE_SHIFT bit as 0 - this is used for overflow detection.
+		 */
+		ret = kvm_pgtable_hyp_map(&pkvm_pgtable, addr + PAGE_SIZE,
+					  PAGE_SIZE, phys, PAGE_HYP);
+		if (ret)
+			__io_map_base = prev_base;
+	}
+	hyp_spin_unlock(&pkvm_pgd_lock);
+
+	*haddr = addr + size;
+
+	return ret;
+}
+
 static void *admit_host_page(void *arg)
 {
 	struct kvm_hyp_memcache *host_mc = arg;
diff --git a/arch/arm64/kvm/hyp/nvhe/setup.c b/arch/arm64/kvm/hyp/nvhe/setup.c
index bb98630dfeaf..0d5e0a89ddce 100644
--- a/arch/arm64/kvm/hyp/nvhe/setup.c
+++ b/arch/arm64/kvm/hyp/nvhe/setup.c
@@ -113,7 +113,6 @@ static int recreate_hyp_mappings(phys_addr_t phys, unsigned long size,
 
 	for (i = 0; i < hyp_nr_cpus; i++) {
 		struct kvm_nvhe_init_params *params = per_cpu_ptr(&kvm_init_params, i);
-		unsigned long hyp_addr;
 
 		start = (void *)kern_hyp_va(per_cpu_base[i]);
 		end = start + PAGE_ALIGN(hyp_percpu_size);
@@ -121,33 +120,9 @@ static int recreate_hyp_mappings(phys_addr_t phys, unsigned long size,
 		if (ret)
 			return ret;
 
-		/*
-		 * Allocate a contiguous HYP private VA range for the stack
-		 * and guard page. The allocation is also aligned based on
-		 * the order of its size.
-		 */
-		ret = pkvm_alloc_private_va_range(PAGE_SIZE * 2, &hyp_addr);
+		ret = pkvm_create_stack(params->stack_pa, &params->stack_hyp_va);
 		if (ret)
 			return ret;
-
-		/*
-		 * Since the stack grows downwards, map the stack to the page
-		 * at the higher address and leave the lower guard page
-		 * unbacked.
-		 *
-		 * Any valid stack address now has the PAGE_SHIFT bit as 1
-		 * and addresses corresponding to the guard page have the
-		 * PAGE_SHIFT bit as 0 - this is used for overflow detection.
-		 */
-		hyp_spin_lock(&pkvm_pgd_lock);
-		ret = kvm_pgtable_hyp_map(&pkvm_pgtable, hyp_addr + PAGE_SIZE,
-					PAGE_SIZE, params->stack_pa, PAGE_HYP);
-		hyp_spin_unlock(&pkvm_pgd_lock);
-		if (ret)
-			return ret;
-
-		/* Update stack_hyp_va to end of the stack's private VA range */
-		params->stack_hyp_va = hyp_addr + (2 * PAGE_SIZE);
 	}
 
 	/*
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index d3b4feed460c..32c2f1665c6e 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -592,6 +592,25 @@ int create_hyp_mappings(void *from, void *to, enum kvm_pgtable_prot prot)
 	return 0;
 }
 
+static int __hyp_alloc_private_va_range(unsigned long base)
+{
+	lockdep_assert_held(&kvm_hyp_pgd_mutex);
+
+	if (!PAGE_ALIGNED(base))
+		return -EINVAL;
+
+	/*
+	 * Verify that BIT(VA_BITS - 1) hasn't been flipped by
+	 * allocating the new area, as it would indicate we've
+	 * overflowed the idmap/IO address range.
+	 */
+	if ((base ^ io_map_base) & BIT(VA_BITS - 1))
+		return -ENOMEM;
+
+	io_map_base = base;
+
+	return 0;
+}
 
 /**
  * hyp_alloc_private_va_range - Allocates a private VA range.
@@ -612,26 +631,16 @@ int hyp_alloc_private_va_range(size_t size, unsigned long *haddr)
 
 	/*
 	 * This assumes that we have enough space below the idmap
-	 * page to allocate our VAs. If not, the check below will
-	 * kick. A potential alternative would be to detect that
-	 * overflow and switch to an allocation above the idmap.
+	 * page to allocate our VAs. If not, the check in
+	 * __hyp_alloc_private_va_range() will kick. A potential
+	 * alternative would be to detect that overflow and switch
+	 * to an allocation above the idmap.
 	 *
 	 * The allocated size is always a multiple of PAGE_SIZE.
 	 */
-	base = io_map_base - PAGE_ALIGN(size);
-
-	/* Align the allocation based on the order of its size */
-	base = ALIGN_DOWN(base, PAGE_SIZE << get_order(size));
-
-	/*
-	 * Verify that BIT(VA_BITS - 1) hasn't been flipped by
-	 * allocating the new area, as it would indicate we've
-	 * overflowed the idmap/IO address range.
-	 */
-	if ((base ^ io_map_base) & BIT(VA_BITS - 1))
-		ret = -ENOMEM;
-	else
-		*haddr = io_map_base = base;
+	size = PAGE_ALIGN(size);
+	base = io_map_base - size;
+	ret = __hyp_alloc_private_va_range(base);
 
 	mutex_unlock(&kvm_hyp_pgd_mutex);
 
@@ -668,6 +677,48 @@ static int __create_hyp_private_mapping(phys_addr_t phys_addr, size_t size,
 	return ret;
 }
 
+int create_hyp_stack(phys_addr_t phys_addr, unsigned long *haddr)
+{
+	unsigned long base;
+	size_t size;
+	int ret;
+
+	mutex_lock(&kvm_hyp_pgd_mutex);
+	/*
+	 * Efficient stack verification using the PAGE_SHIFT bit implies
+	 * an alignment of our allocation on the order of the size.
+	 */
+	size = PAGE_SIZE * 2;
+	base = ALIGN_DOWN(io_map_base - size, size);
+
+	ret = __hyp_alloc_private_va_range(base);
+
+	mutex_unlock(&kvm_hyp_pgd_mutex);
+
+	if (ret) {
+		kvm_err("Cannot allocate hyp stack guard page\n");
+		return ret;
+	}
+
+	/*
+	 * Since the stack grows downwards, map the stack to the page
+	 * at the higher address and leave the lower guard page
+	 * unbacked.
+	 *
+	 * Any valid stack address now has the PAGE_SHIFT bit as 1
+	 * and addresses corresponding to the guard page have the
+	 * PAGE_SHIFT bit as 0 - this is used for overflow detection.
+	 */
+	ret = __create_hyp_mappings(base + PAGE_SIZE, PAGE_SIZE, phys_addr,
+				    PAGE_HYP);
+	if (ret)
+		kvm_err("Cannot map hyp stack\n");
+
+	*haddr = base + size;
+
+	return ret;
+}
+
 /**
  * create_hyp_io_mappings - Map IO into both kernel and HYP
  * @phys_addr:	The physical start address which gets mapped

base-commit: 52a93d39b17dc7eb98b6aa3edb93943248e03b2f
-- 
2.41.0.640.ga95def55d0-goog

