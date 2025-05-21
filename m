Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B62DD26C3AF
	for <kvmarm@lists.linux.dev>; Wed, 21 May 2025 12:51:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747831886; cv=none; b=SBRbrKo6sRtXXh6Dxiu+k7XVC9nwKucgpwJUptWhQDTm1Nv5HpSV0xKSTOmVC/mr2TdLbhT0pTAZeD1snRltsuvFfBdcJp8v4q6/TjWPG2WwR7VmsU4lm0B1w4CI8A6iQpL+xsidik+0iU/0OliRwC3mRDLHIFC/OVXXSVRGOT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747831886; c=relaxed/simple;
	bh=FrjjkAPvsmfKvlOlRsbAfJi1psoLqx8eK/erV4N9fAA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=n6xAWWPp/3VVqNTX9aKjzPqjwqhLHHMRyYRP1O7fNxgR5T4m1kmCYxBaDpaWELi0eQ+EtaGy6ujE9Y/VjQ5E88Z3DplX4ZJo3/7aLwSSUKGePeuBP2YXzAjzzpTmrYQTcbdLy/X6gxMQSigog+k1MuvgmcqQFM4FEGSqt4uz+mo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=D8vYPMnM; arc=none smtp.client-ip=209.85.221.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="D8vYPMnM"
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-3a364802ec5so1728371f8f.0
        for <kvmarm@lists.linux.dev>; Wed, 21 May 2025 05:51:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747831882; x=1748436682; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=JPzlBmS/vixQNlnFlLNVTrpyQWywNNSCiH/beuvalSg=;
        b=D8vYPMnM4HlR2snjShpDmi5Iv8fCa8DDrR/LenonIlIqsgrZmutFqeHkSY5HsoAHbA
         u2FnzfRybFA693r19lF5tX1nSH55TiIq5IImXXJ9Pe0yijywnaDyuLqh5aKCYjyjRVpX
         JTQUD23k24edo48HpZ0MpoG7U7uaUgE04SUmEc8WH27halQLFfGl8gBFTHyKYlOKhE8Y
         glSLnxRjyrqZGXm3n3l//wucEpC1NFYE0TbI1UCum61ANrb9VNwv++ItzwFoBsKxA7Q/
         VxlsxbZf91SnyZ9sIJR017Ut8w6fcITWe8e//bOcSX+tDeJU39JDqD4Sylv7oeVJHjTS
         dMhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747831882; x=1748436682;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JPzlBmS/vixQNlnFlLNVTrpyQWywNNSCiH/beuvalSg=;
        b=UtgAntHrVPmfbsbLfZxBohqOXBa+ndCu0pAMl9t2Xq2Xhl22KsrQclL0/NjvnKjVt0
         2/O9fOLPmIFX+cMw7kQ/PN9wXZIc8sqn97bEYr1EqHdcxVtH7M24N8vbS/nlrVkujHSX
         I6Pw+LbTabOFjD2W/53csv4ON5FKtJ6jOe9g9XxZjwjNFAme+DO29yVCFUs5KSo8sxdB
         2NVluvtjhiTKLSw9vzutUt935tkX5VQSuA3pgqhKPuBzxVjXGLXH+ZjkjMPAAtxQ5287
         IDgYQ5uVUj7xrCZdS5MVtOyqyl/0GRP6PUBB3qrkkiGLcY8VeNXNen10eYwxAeuQ2VyI
         rH0w==
X-Forwarded-Encrypted: i=1; AJvYcCXRJpnsT0bQ3zKkjTJEFNFzLbU2/6qazU80Oll3g8Z7vTG2CXUmGamZ08UtgrgvUa2U4j23Ibg=@lists.linux.dev
X-Gm-Message-State: AOJu0YwfLN/zm9W9DWGMMD+t54AlEqdugfQtXXS5BHt5LG0wFVTcmM0M
	4hd+AT94xKNgKF/ro3DDSXRPbgjz8F0KwUcuaCp8N+SjyEmfZT09ZJGz2MBx0mkBLjCuftIMd6Q
	MfWSaDjYsqEHK4DAUYKwlRQ==
X-Google-Smtp-Source: AGHT+IE/jsEpHUOKUoZ6F/+QjPoabXMpV1/0WZAcaBafnmGb5uaRjEjbFBFVLyfZWlGhTulY1NK7gFRGkHiLEeFY
X-Received: from wmbdr13.prod.google.com ([2002:a05:600c:608d:b0:43d:1f28:b8bf])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6000:40ce:b0:3a3:68c7:e486 with SMTP id ffacd0b85a97d-3a368c7e67bmr14514425f8f.51.1747831882368;
 Wed, 21 May 2025 05:51:22 -0700 (PDT)
Date: Wed, 21 May 2025 13:48:34 +0100
In-Reply-To: <20250521124834.1070650-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250521124834.1070650-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.49.0.1112.g889b7c5bd8-goog
Message-ID: <20250521124834.1070650-11-vdonnefort@google.com>
Subject: [PATCH v6 10/10] KVM: arm64: np-guest CMOs with PMD_SIZE fixmap
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org
Cc: qperret@google.com, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, kernel-team@android.com, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

With the introduction of stage-2 huge mappings in the pKVM hypervisor,
guest pages CMO is needed for PMD_SIZE size. Fixmap only supports
PAGE_SIZE and iterating over the huge-page is time consuming (mostly due
to TLBI on hyp_fixmap_unmap) which is a problem for EL2 latency.

Introduce a shared PMD_SIZE fixmap (hyp_fixblock_map/hyp_fixblock_unmap)
to improve guest page CMOs when stage-2 huge mappings are installed.

On a Pixel6, the iterative solution resulted in a latency of ~700us,
while the PMD_SIZE fixmap reduces it to ~100us.

Because of the horrendous private range allocation that would be
necessary, this is disabled for 64KiB pages systems.

Suggested-by: Quentin Perret <qperret@google.com>
Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
Signed-off-by: Quentin Perret <qperret@google.com>

diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index 1b43bcd2a679..2888b5d03757 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -59,6 +59,11 @@ typedef u64 kvm_pte_t;
 
 #define KVM_PHYS_INVALID		(-1ULL)
 
+#define KVM_PTE_TYPE			BIT(1)
+#define KVM_PTE_TYPE_BLOCK		0
+#define KVM_PTE_TYPE_PAGE		1
+#define KVM_PTE_TYPE_TABLE		1
+
 #define KVM_PTE_LEAF_ATTR_LO		GENMASK(11, 2)
 
 #define KVM_PTE_LEAF_ATTR_LO_S1_ATTRIDX	GENMASK(4, 2)
diff --git a/arch/arm64/kvm/hyp/include/nvhe/mm.h b/arch/arm64/kvm/hyp/include/nvhe/mm.h
index 230e4f2527de..6e83ce35c2f2 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/mm.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/mm.h
@@ -13,9 +13,11 @@
 extern struct kvm_pgtable pkvm_pgtable;
 extern hyp_spinlock_t pkvm_pgd_lock;
 
-int hyp_create_pcpu_fixmap(void);
+int hyp_create_fixmap(void);
 void *hyp_fixmap_map(phys_addr_t phys);
 void hyp_fixmap_unmap(void);
+void *hyp_fixblock_map(phys_addr_t phys, size_t *size);
+void hyp_fixblock_unmap(void);
 
 int hyp_create_idmap(u32 hyp_va_bits);
 int hyp_map_vectors(void);
diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index 1c18fca82209..f67c1a91e4eb 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -216,34 +216,42 @@ static void guest_s2_put_page(void *addr)
 	hyp_put_page(&current_vm->pool, addr);
 }
 
-static void clean_dcache_guest_page(void *va, size_t size)
+static void __apply_guest_page(void *va, size_t size,
+			       void (*func)(void *addr, size_t size))
 {
 	size += va - PTR_ALIGN_DOWN(va, PAGE_SIZE);
 	va = PTR_ALIGN_DOWN(va, PAGE_SIZE);
 	size = PAGE_ALIGN(size);
 
 	while (size) {
-		__clean_dcache_guest_page(hyp_fixmap_map(__hyp_pa(va)),
-					  PAGE_SIZE);
-		hyp_fixmap_unmap();
-		va += PAGE_SIZE;
-		size -= PAGE_SIZE;
+		size_t map_size = PAGE_SIZE;
+		void *map;
+
+		if (IS_ALIGNED((unsigned long)va, PMD_SIZE) && size >= PMD_SIZE)
+			map = hyp_fixblock_map(__hyp_pa(va), &map_size);
+		else
+			map = hyp_fixmap_map(__hyp_pa(va));
+
+		func(map, map_size);
+
+		if (map_size == PMD_SIZE)
+			hyp_fixblock_unmap();
+		else
+			hyp_fixmap_unmap();
+
+		size -= map_size;
+		va += map_size;
 	}
 }
 
-static void invalidate_icache_guest_page(void *va, size_t size)
+static void clean_dcache_guest_page(void *va, size_t size)
 {
-	size += va - PTR_ALIGN_DOWN(va, PAGE_SIZE);
-	va = PTR_ALIGN_DOWN(va, PAGE_SIZE);
-	size = PAGE_ALIGN(size);
+	__apply_guest_page(va, size, __clean_dcache_guest_page);
+}
 
-	while (size) {
-		__invalidate_icache_guest_page(hyp_fixmap_map(__hyp_pa(va)),
-					       PAGE_SIZE);
-		hyp_fixmap_unmap();
-		va += PAGE_SIZE;
-		size -= PAGE_SIZE;
-	}
+static void invalidate_icache_guest_page(void *va, size_t size)
+{
+	__apply_guest_page(va, size, __invalidate_icache_guest_page);
 }
 
 int kvm_guest_prepare_stage2(struct pkvm_hyp_vm *vm, void *pgd)
diff --git a/arch/arm64/kvm/hyp/nvhe/mm.c b/arch/arm64/kvm/hyp/nvhe/mm.c
index f41c7440b34b..ae8391baebc3 100644
--- a/arch/arm64/kvm/hyp/nvhe/mm.c
+++ b/arch/arm64/kvm/hyp/nvhe/mm.c
@@ -229,9 +229,8 @@ int hyp_map_vectors(void)
 	return 0;
 }
 
-void *hyp_fixmap_map(phys_addr_t phys)
+static void *fixmap_map_slot(struct hyp_fixmap_slot *slot, phys_addr_t phys)
 {
-	struct hyp_fixmap_slot *slot = this_cpu_ptr(&fixmap_slots);
 	kvm_pte_t pte, *ptep = slot->ptep;
 
 	pte = *ptep;
@@ -243,10 +242,21 @@ void *hyp_fixmap_map(phys_addr_t phys)
 	return (void *)slot->addr;
 }
 
+void *hyp_fixmap_map(phys_addr_t phys)
+{
+	return fixmap_map_slot(this_cpu_ptr(&fixmap_slots), phys);
+}
+
 static void fixmap_clear_slot(struct hyp_fixmap_slot *slot)
 {
 	kvm_pte_t *ptep = slot->ptep;
 	u64 addr = slot->addr;
+	u32 level;
+
+	if (FIELD_GET(KVM_PTE_TYPE, *ptep) == KVM_PTE_TYPE_PAGE)
+		level = KVM_PGTABLE_LAST_LEVEL;
+	else
+		level = KVM_PGTABLE_LAST_LEVEL - 1; /* create_fixblock() guarantees PMD level */
 
 	WRITE_ONCE(*ptep, *ptep & ~KVM_PTE_VALID);
 
@@ -260,7 +270,7 @@ static void fixmap_clear_slot(struct hyp_fixmap_slot *slot)
 	 * https://lore.kernel.org/kvm/20221017115209.2099-1-will@kernel.org/T/#mf10dfbaf1eaef9274c581b81c53758918c1d0f03
 	 */
 	dsb(ishst);
-	__tlbi_level(vale2is, __TLBI_VADDR(addr, 0), KVM_PGTABLE_LAST_LEVEL);
+	__tlbi_level(vale2is, __TLBI_VADDR(addr, 0), level);
 	dsb(ish);
 	isb();
 }
@@ -273,9 +283,9 @@ void hyp_fixmap_unmap(void)
 static int __create_fixmap_slot_cb(const struct kvm_pgtable_visit_ctx *ctx,
 				   enum kvm_pgtable_walk_flags visit)
 {
-	struct hyp_fixmap_slot *slot = per_cpu_ptr(&fixmap_slots, (u64)ctx->arg);
+	struct hyp_fixmap_slot *slot = (struct hyp_fixmap_slot *)ctx->arg;
 
-	if (!kvm_pte_valid(ctx->old) || ctx->level != KVM_PGTABLE_LAST_LEVEL)
+	if (!kvm_pte_valid(ctx->old) || (ctx->end - ctx->start) != kvm_granule_size(ctx->level))
 		return -EINVAL;
 
 	slot->addr = ctx->addr;
@@ -296,13 +306,84 @@ static int create_fixmap_slot(u64 addr, u64 cpu)
 	struct kvm_pgtable_walker walker = {
 		.cb	= __create_fixmap_slot_cb,
 		.flags	= KVM_PGTABLE_WALK_LEAF,
-		.arg = (void *)cpu,
+		.arg	= per_cpu_ptr(&fixmap_slots, cpu),
 	};
 
 	return kvm_pgtable_walk(&pkvm_pgtable, addr, PAGE_SIZE, &walker);
 }
 
-int hyp_create_pcpu_fixmap(void)
+#if PAGE_SHIFT < 16
+#define HAS_FIXBLOCK
+static struct hyp_fixmap_slot hyp_fixblock_slot;
+static DEFINE_HYP_SPINLOCK(hyp_fixblock_lock);
+#endif
+
+static int create_fixblock(void)
+{
+#ifdef HAS_FIXBLOCK
+	struct kvm_pgtable_walker walker = {
+		.cb	= __create_fixmap_slot_cb,
+		.flags	= KVM_PGTABLE_WALK_LEAF,
+		.arg	= &hyp_fixblock_slot,
+	};
+	unsigned long addr;
+	phys_addr_t phys;
+	int ret, i;
+
+	/* Find a RAM phys address, PMD aligned */
+	for (i = 0; i < hyp_memblock_nr; i++) {
+		phys = ALIGN(hyp_memory[i].base, PMD_SIZE);
+		if (phys + PMD_SIZE < (hyp_memory[i].base + hyp_memory[i].size))
+			break;
+	}
+
+	if (i >= hyp_memblock_nr)
+		return -EINVAL;
+
+	hyp_spin_lock(&pkvm_pgd_lock);
+	addr = ALIGN(__io_map_base, PMD_SIZE);
+	ret = __pkvm_alloc_private_va_range(addr, PMD_SIZE);
+	if (ret)
+		goto unlock;
+
+	ret = kvm_pgtable_hyp_map(&pkvm_pgtable, addr, PMD_SIZE, phys, PAGE_HYP);
+	if (ret)
+		goto unlock;
+
+	ret = kvm_pgtable_walk(&pkvm_pgtable, addr, PMD_SIZE, &walker);
+
+unlock:
+	hyp_spin_unlock(&pkvm_pgd_lock);
+
+	return ret;
+#else
+	return 0;
+#endif
+}
+
+void *hyp_fixblock_map(phys_addr_t phys, size_t *size)
+{
+#ifdef HAS_FIXBLOCK
+	*size = PMD_SIZE;
+	hyp_spin_lock(&hyp_fixblock_lock);
+	return fixmap_map_slot(&hyp_fixblock_slot, phys);
+#else
+	*size = PAGE_SIZE;
+	return hyp_fixmap_map(phys);
+#endif
+}
+
+void hyp_fixblock_unmap(void)
+{
+#ifdef HAS_FIXBLOCK
+	fixmap_clear_slot(&hyp_fixblock_slot);
+	hyp_spin_unlock(&hyp_fixblock_lock);
+#else
+	hyp_fixmap_unmap();
+#endif
+}
+
+int hyp_create_fixmap(void)
 {
 	unsigned long addr, i;
 	int ret;
@@ -322,7 +403,7 @@ int hyp_create_pcpu_fixmap(void)
 			return ret;
 	}
 
-	return 0;
+	return create_fixblock();
 }
 
 int hyp_create_idmap(u32 hyp_va_bits)
diff --git a/arch/arm64/kvm/hyp/nvhe/setup.c b/arch/arm64/kvm/hyp/nvhe/setup.c
index c19860fc8183..a48d3f5a5afb 100644
--- a/arch/arm64/kvm/hyp/nvhe/setup.c
+++ b/arch/arm64/kvm/hyp/nvhe/setup.c
@@ -312,7 +312,7 @@ void __noreturn __pkvm_init_finalise(void)
 	if (ret)
 		goto out;
 
-	ret = hyp_create_pcpu_fixmap();
+	ret = hyp_create_fixmap();
 	if (ret)
 		goto out;
 
diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index df5cc74a7dd0..c351b4abd5db 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -11,12 +11,6 @@
 #include <asm/kvm_pgtable.h>
 #include <asm/stage2_pgtable.h>
 
-
-#define KVM_PTE_TYPE			BIT(1)
-#define KVM_PTE_TYPE_BLOCK		0
-#define KVM_PTE_TYPE_PAGE		1
-#define KVM_PTE_TYPE_TABLE		1
-
 struct kvm_pgtable_walk_data {
 	struct kvm_pgtable_walker	*walker;
 
-- 
2.49.0.1112.g889b7c5bd8-goog

