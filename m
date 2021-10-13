Return-Path: <SRS0=5TFS=PB=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F414C433F5
	for <kvmarm@archiver.kernel.org>; Wed, 13 Oct 2021 15:59:05 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 20330611AD
	for <kvmarm@archiver.kernel.org>; Wed, 13 Oct 2021 15:59:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 20330611AD
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C88264B16C;
	Wed, 13 Oct 2021 11:59:04 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 6C0WumRf4mDy; Wed, 13 Oct 2021 11:59:03 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 42E6E4B161;
	Wed, 13 Oct 2021 11:59:03 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8CA424A5A0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 Oct 2021 11:59:01 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ALe19vpl-9pA for <kvmarm@lists.cs.columbia.edu>;
 Wed, 13 Oct 2021 11:59:00 -0400 (EDT)
Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com
 [209.85.221.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4571F4B132
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 Oct 2021 11:59:00 -0400 (EDT)
Received: by mail-wr1-f73.google.com with SMTP id
 c4-20020a5d6cc4000000b00160edc8bb28so2350853wrc.9
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 Oct 2021 08:59:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=N96QWZdZyncYqVJDhmcot0tFl0h23Kvk8FR/wEFCCgY=;
 b=en5penu1W+N/HtWXYPks7Gi1SZI7fQ3LHlNjwS6qYmvi4vs4oYrpdhagBwb3mKSqjj
 bnpZZO0p2ZmlZmks+IlNZsVKiFR/IDYI83kf0gKkTZ09wiDTdWfqZ70tDDH/5aBPaZlr
 //NAMZhoWa8LslXCatIH5BD8oCf491HhDXpQHRcNJdS6lRNz/BUrXFsDEJwPRbKB9Wt2
 xVZ6vBx09TRNUg/hw3OzyIHIgWLNZyTcF/aw3zSv/AXHc3B4/l9ThJTT5x9GuoLyc58B
 Y41f9iJ1fi3HOzuFIqi8mL8vrdGgzR6KPbtgCYz5y6yL2OKnMwRgQpx8UetMlgbxuLvL
 XaZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=N96QWZdZyncYqVJDhmcot0tFl0h23Kvk8FR/wEFCCgY=;
 b=iIZKPSNsM07egXsOfAITaFr3lubQD0i0q3Lb9Yn708MmX1tg3qJ7LpGzQWFs+hGm6q
 QaSi31TDgb5HXVxAcCxhqSYEMTrmKT1v+09Vdm6CMNxZ1EZWzpK2y4oJpUgf6ktKxEMS
 xfPm9smY2lc4lG3lpCKCGbNCDDdXOZZvIAN97E228hF4J+IGFrrzY2izvu1s5D9u4irN
 HLhdspDydbyqa6RyZM2l0OtafHt3J9P4xLc/HAyG/I/TAc2MeYziVSt0QB+lYrNnB2JO
 +tI8h91xvLdRUqyMMkKRml+Bc+argpMANekOII7PLHIMURc5J7OpFNv7BPsDB8h3E4Sr
 QyWA==
X-Gm-Message-State: AOAM531yOqUxoHLp4ZxC4jdiBZmOr5VAOoxwbJEdLEte2pKVVHsPRDqH
 shWgBH7TpEzRBp60gcSjQfV0E/0xqrG+
X-Google-Smtp-Source: ABdhPJygQa+wTc4OeeCXl7z9m/R4SJN/4hBuSvsV5o2tDYL3NdUx+8EUeWoWuPNV7alI36ZJ0V6wpG0LZazz
X-Received: from luke.lon.corp.google.com
 ([2a00:79e0:d:210:65b5:73d3:1558:b9ae])
 (user=qperret job=sendgmr) by 2002:a05:6000:1563:: with SMTP id
 3mr3254wrz.152.1634140739504; Wed, 13 Oct 2021 08:58:59 -0700 (PDT)
Date: Wed, 13 Oct 2021 16:58:26 +0100
In-Reply-To: <20211013155831.943476-1-qperret@google.com>
Message-Id: <20211013155831.943476-12-qperret@google.com>
Mime-Version: 1.0
References: <20211013155831.943476-1-qperret@google.com>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
Subject: [PATCH 11/16] KVM: arm64: Back hyp_vmemmap for all of memory
From: Quentin Perret <qperret@google.com>
To: Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>, 
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Fuad Tabba <tabba@google.com>, David Brazdil <dbrazdil@google.com>
Cc: kernel-team@android.com, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

The EL2 vmemmap in nVHE Protected mode is currently very sparse: only
memory pages owned by the hypervisor itself have a matching struct
hyp_page. But since the size of these structs has been reduced
significantly, it appears that we can now afford backing the vmemmap for
all of memory.

This will simplify a lot memory tracking as the hypervisor will have a
place to store metadata (e.g. refcounts) that wouldn't otherwise fit in
the 4 SW bits we have in the host stage-2 page-table.

Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/kvm/hyp/include/nvhe/mm.h | 29 ++++++++++++++++++--------
 arch/arm64/kvm/hyp/nvhe/mm.c         | 31 ++++++++++++++++++++++++----
 arch/arm64/kvm/hyp/nvhe/page_alloc.c |  4 +---
 arch/arm64/kvm/hyp/nvhe/setup.c      |  7 +++----
 arch/arm64/kvm/hyp/reserved_mem.c    | 17 ++-------------
 5 files changed, 53 insertions(+), 35 deletions(-)

diff --git a/arch/arm64/kvm/hyp/include/nvhe/mm.h b/arch/arm64/kvm/hyp/include/nvhe/mm.h
index c9a8f535212e..f5e8582252c3 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/mm.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/mm.h
@@ -20,23 +20,34 @@ extern u64 __io_map_base;
 
 int hyp_create_idmap(u32 hyp_va_bits);
 int hyp_map_vectors(void);
-int hyp_back_vmemmap(phys_addr_t phys, unsigned long size, phys_addr_t back);
+int hyp_back_vmemmap(phys_addr_t back);
 int pkvm_cpu_set_vector(enum arm64_hyp_spectre_vector slot);
 int pkvm_create_mappings(void *from, void *to, enum kvm_pgtable_prot prot);
 int pkvm_create_mappings_locked(void *from, void *to, enum kvm_pgtable_prot prot);
 unsigned long __pkvm_create_private_mapping(phys_addr_t phys, size_t size,
 					    enum kvm_pgtable_prot prot);
 
-static inline void hyp_vmemmap_range(phys_addr_t phys, unsigned long size,
-				     unsigned long *start, unsigned long *end)
+static inline unsigned long hyp_vmemmap_memblock_size(struct memblock_region *reg)
 {
-	unsigned long nr_pages = size >> PAGE_SHIFT;
-	struct hyp_page *p = hyp_phys_to_page(phys);
+	unsigned long nr_pages = reg->size >> PAGE_SHIFT;
+	unsigned long start, end;
 
-	*start = (unsigned long)p;
-	*end = *start + nr_pages * sizeof(struct hyp_page);
-	*start = ALIGN_DOWN(*start, PAGE_SIZE);
-	*end = ALIGN(*end, PAGE_SIZE);
+	start = hyp_phys_to_pfn(reg->base) * sizeof(struct hyp_page);
+	end = start + nr_pages * sizeof(struct hyp_page);
+	start = ALIGN_DOWN(start, PAGE_SIZE);
+	end = ALIGN(end, PAGE_SIZE);
+
+	return end - start;
+}
+
+static inline unsigned long hyp_vmemmap_pages(void)
+{
+	unsigned long res = 0, i;
+
+	for (i = 0; i < kvm_nvhe_sym(hyp_memblock_nr); i++)
+		res += hyp_vmemmap_memblock_size(&kvm_nvhe_sym(hyp_memory)[i]);
+
+	return res >> PAGE_SHIFT;
 }
 
 static inline unsigned long __hyp_pgtable_max_pages(unsigned long nr_pages)
diff --git a/arch/arm64/kvm/hyp/nvhe/mm.c b/arch/arm64/kvm/hyp/nvhe/mm.c
index 2fabeceb889a..65b948cbc0f5 100644
--- a/arch/arm64/kvm/hyp/nvhe/mm.c
+++ b/arch/arm64/kvm/hyp/nvhe/mm.c
@@ -103,13 +103,36 @@ int pkvm_create_mappings(void *from, void *to, enum kvm_pgtable_prot prot)
 	return ret;
 }
 
-int hyp_back_vmemmap(phys_addr_t phys, unsigned long size, phys_addr_t back)
+int hyp_back_vmemmap(phys_addr_t back)
 {
-	unsigned long start, end;
+	unsigned long i, start, size, end = 0;
+	int ret;
 
-	hyp_vmemmap_range(phys, size, &start, &end);
+	for (i = 0; i < hyp_memblock_nr; i++) {
+		start = hyp_memory[i].base;
+		start = ALIGN_DOWN((u64)hyp_phys_to_page(start), PAGE_SIZE);
+		/*
+		 * The beginning of the hyp_vmemmap region for the current
+		 * memblock may already be backed by the page backing the end
+		 * the previous region, so avoid mapping it twice.
+		 */
+		start = max(start, end);
+
+		end = hyp_memory[i].base + hyp_memory[i].size;
+		end = PAGE_ALIGN((u64)hyp_phys_to_page(end));
+		if (start >= end)
+			continue;
+
+		size = end - start;
+		ret = __pkvm_create_mappings(start, size, back, PAGE_HYP);
+		if (ret)
+			return ret;
+
+		memset(hyp_phys_to_virt(back), 0, size);
+		back += size;
+	}
 
-	return __pkvm_create_mappings(start, end - start, back, PAGE_HYP);
+	return 0;
 }
 
 static void *__hyp_bp_vect_base;
diff --git a/arch/arm64/kvm/hyp/nvhe/page_alloc.c b/arch/arm64/kvm/hyp/nvhe/page_alloc.c
index 41fc25bdfb34..38accc2e23e3 100644
--- a/arch/arm64/kvm/hyp/nvhe/page_alloc.c
+++ b/arch/arm64/kvm/hyp/nvhe/page_alloc.c
@@ -234,10 +234,8 @@ int hyp_pool_init(struct hyp_pool *pool, u64 pfn, unsigned int nr_pages,
 
 	/* Init the vmemmap portion */
 	p = hyp_phys_to_page(phys);
-	for (i = 0; i < nr_pages; i++) {
-		p[i].order = 0;
+	for (i = 0; i < nr_pages; i++)
 		hyp_set_page_refcounted(&p[i]);
-	}
 
 	/* Attach the unused pages to the buddy tree */
 	for (i = reserved_pages; i < nr_pages; i++)
diff --git a/arch/arm64/kvm/hyp/nvhe/setup.c b/arch/arm64/kvm/hyp/nvhe/setup.c
index 98b39facae04..98441e4039b9 100644
--- a/arch/arm64/kvm/hyp/nvhe/setup.c
+++ b/arch/arm64/kvm/hyp/nvhe/setup.c
@@ -29,12 +29,11 @@ static struct kvm_pgtable_mm_ops pkvm_pgtable_mm_ops;
 
 static int divide_memory_pool(void *virt, unsigned long size)
 {
-	unsigned long vstart, vend, nr_pages;
+	unsigned long nr_pages;
 
 	hyp_early_alloc_init(virt, size);
 
-	hyp_vmemmap_range(__hyp_pa(virt), size, &vstart, &vend);
-	nr_pages = (vend - vstart) >> PAGE_SHIFT;
+	nr_pages = hyp_vmemmap_pages();
 	vmemmap_base = hyp_early_alloc_contig(nr_pages);
 	if (!vmemmap_base)
 		return -ENOMEM;
@@ -76,7 +75,7 @@ static int recreate_hyp_mappings(phys_addr_t phys, unsigned long size,
 	if (ret)
 		return ret;
 
-	ret = hyp_back_vmemmap(phys, size, hyp_virt_to_phys(vmemmap_base));
+	ret = hyp_back_vmemmap(hyp_virt_to_phys(vmemmap_base));
 	if (ret)
 		return ret;
 
diff --git a/arch/arm64/kvm/hyp/reserved_mem.c b/arch/arm64/kvm/hyp/reserved_mem.c
index 578670e3f608..81db85bfdbad 100644
--- a/arch/arm64/kvm/hyp/reserved_mem.c
+++ b/arch/arm64/kvm/hyp/reserved_mem.c
@@ -54,7 +54,7 @@ static int __init register_memblock_regions(void)
 
 void __init kvm_hyp_reserve(void)
 {
-	u64 nr_pages, prev, hyp_mem_pages = 0;
+	u64 hyp_mem_pages = 0;
 	int ret;
 
 	if (!is_hyp_mode_available() || is_kernel_in_hyp_mode())
@@ -72,20 +72,7 @@ void __init kvm_hyp_reserve(void)
 
 	hyp_mem_pages += hyp_s1_pgtable_pages();
 	hyp_mem_pages += host_s2_pgtable_pages();
-
-	/*
-	 * The hyp_vmemmap needs to be backed by pages, but these pages
-	 * themselves need to be present in the vmemmap, so compute the number
-	 * of pages needed by looking for a fixed point.
-	 */
-	nr_pages = 0;
-	do {
-		prev = nr_pages;
-		nr_pages = hyp_mem_pages + prev;
-		nr_pages = DIV_ROUND_UP(nr_pages * sizeof(struct hyp_page), PAGE_SIZE);
-		nr_pages += __hyp_pgtable_max_pages(nr_pages);
-	} while (nr_pages != prev);
-	hyp_mem_pages += nr_pages;
+	hyp_mem_pages += hyp_vmemmap_pages();
 
 	/*
 	 * Try to allocate a PMD-aligned region to reduce TLB pressure once
-- 
2.33.0.882.g93a45727a2-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
