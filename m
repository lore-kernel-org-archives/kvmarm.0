Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F04EA27C162
	for <kvmarm@lists.linux.dev>; Mon, 28 Jul 2025 17:53:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753725230; cv=none; b=HRs0klIjBl0UWuuH8z/OPAfNrwnaAlvs6zpup4SNDzNUm8Wxd0QiYkZKT4rWljN0G7i5e+9/S2AFihp7hDNTqP7AlFv7CTXkB4h3xfGbFlQJklyj9KTWLsV3kMgVM5Mbvcr1iEvUmqR6GTZeCVLtKOqm5TkX046L+Sv6LIVnRLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753725230; c=relaxed/simple;
	bh=k23bfvplNAwitDDrR+QqOLk2PWGMR1CFi2mAbN802lI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=mnSLr9IxxVtwBbvl10D3YTDJrI7x64V4UkeBuZb+Oc4MSTdG2ldeNFkK53Z7Wzend1dNyogVNqxd9sdJ64ENsl1fJ7nLSpNj3Zk9E4OzUv0JULK4SUzutCl30wcmlnb/pl/p/acT7L7p3dl5JTS7tJqy2vw+HLZvjR8g5ybLnns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=uxR3J9uI; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="uxR3J9uI"
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-3a50049f8eeso1835592f8f.3
        for <kvmarm@lists.linux.dev>; Mon, 28 Jul 2025 10:53:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753725226; x=1754330026; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=rAiqVxZ7mCYV4OWmhh9mR5NXqluabCZXrZLF2m+GiJw=;
        b=uxR3J9uIovSoV0bc96b34gjZtzSy7OYjEL7CC5yEJhU0WV2xXxlK00Jk/aT3rBPjw/
         /9ATdUVHm/weyjYJ8pyHRgj4LmnHcZygUbN1oEcZls9+9FWL3QDhJ3ayCEVSPnMZrft8
         wV1WocRTXH2xYVM+LrunAhkUOXLrJtzAkGtiWTyWyI8tL1c9qNTmkB3F7/6CmyCfQBuL
         g+7zHORhENySssUFA6b0vcNt2zpHcopZZSykM76FVwVHst64y+H01C4CkW/mYr7I8Cug
         M0hD9ZwigTDv0ofgzszWn+M+iWaEbFQW7GBrWj3dLdvkgct1c71vqkZPv5FOgJxfn8SF
         58TA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753725226; x=1754330026;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rAiqVxZ7mCYV4OWmhh9mR5NXqluabCZXrZLF2m+GiJw=;
        b=UbC/i+XrV1XJKl9aPQYXwtj28s+Kv3YL0e59oGcKCZnE9JozqQeayVz09vH8x8jmHI
         pUfM3glPlni9QIFQY67yBqvir5H/C06sOU2q9peuPHsslvcKtJrmP1MFWE3IP37rwYqd
         33sMNt6x+hVQ5JgSWUTfJMVt50BFtjWHAxTJc/6E6VcQcC5wbWYMtjOUdBBcBUHsFs9G
         uDbaKht9Qs63XFfRYOlRyWkiiEh274amq5i5LBOHYr+MJMI9oevEjoYgnuQAYjiXSwnQ
         veKkBJ+tkLapbwLD/0He9sfQQzlxAotSoqXZ98jF3Nf3YFPoqGe7ge45uI3MuTaczd31
         SeoQ==
X-Forwarded-Encrypted: i=1; AJvYcCVxD/wIt/XvON2VeUtjxyznvycuE3M9h3ps+dv8QLnd1OR7FmdQQEEBi6lXSG5S1dmSSKnF4uI=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy7lM6ozEZ0wIMEMCV8E8fgs6MAVfgya7VIsS/Y8ofpChZ+gS+K
	EUqhyTQPWiVs+zj2FuRZMRB7jrRjSpKI40mfH3Dwwo1su0tIcQ7BgOwYwCdO412KN3D2KwVn/QK
	vzVNnumIxVTe3MA==
X-Google-Smtp-Source: AGHT+IGxhcTiKxONEChgJsqLDp77mJTIBJlAgPlupgVaUnKzyizUILcxAuGgCSiYGQ4pyLn0idb1VM879Ws0RA==
X-Received: from wmbje21.prod.google.com ([2002:a05:600c:1f95:b0:456:506:259c])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:5292:b0:43d:46de:b0eb with SMTP id 5b1f17b1804b1-4587d64e83dmr72530965e9.12.1753725226335;
 Mon, 28 Jul 2025 10:53:46 -0700 (PDT)
Date: Mon, 28 Jul 2025 17:53:03 +0000
In-Reply-To: <20250728175316.3706196-1-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250728175316.3706196-1-smostafa@google.com>
X-Mailer: git-send-email 2.50.1.552.g942d659e1b-goog
Message-ID: <20250728175316.3706196-17-smostafa@google.com>
Subject: [PATCH v3 16/29] KVM: arm64: iommu: Add a memory pool
From: Mostafa Saleh <smostafa@google.com>
To: linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, iommu@lists.linux.dev
Cc: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org, robin.murphy@arm.com, jean-philippe@linaro.org, 
	qperret@google.com, tabba@google.com, jgg@ziepe.ca, mark.rutland@arm.com, 
	praan@google.com, Mostafa Saleh <smostafa@google.com>
Content-Type: text/plain; charset="UTF-8"

IOMMU drivers would require to allocate memory for the shadow page
table. Similar to the host stage-2 CPU page table, the IOMMU pool
is allocated early from the carveout and it's memory is added in
a pool which the IOMMU driver can allocate from and reclaim at
run time.

At this point the nr_pages is 0 as there are no driver, in the next
patches when the SMMUv3 driver is added, it will add it's own function
to return the number of pages needed in kvm/iommu.c.
Unfortunately, this part has 2 leak into kvm/iommu as this happens too
early before drivers can have any init calls.

Signed-off-by: Mostafa Saleh <smostafa@google.com>
---
 arch/arm64/include/asm/kvm_host.h       |  2 +-
 arch/arm64/kvm/hyp/include/nvhe/iommu.h |  5 ++++-
 arch/arm64/kvm/hyp/nvhe/iommu/iommu.c   | 20 +++++++++++++++++++-
 arch/arm64/kvm/hyp/nvhe/setup.c         | 10 +++++++++-
 arch/arm64/kvm/iommu.c                  | 11 +++++++++++
 arch/arm64/kvm/pkvm.c                   |  1 +
 6 files changed, 45 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 43f5a64bbd1d..b42e32ff2a84 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -1683,5 +1683,5 @@ struct kvm_iommu_ops;
 int kvm_iommu_register_driver(struct kvm_iommu_driver *kern_ops, struct kvm_iommu_ops *hyp_ops);
 int kvm_iommu_init_driver(void);
 void kvm_iommu_remove_driver(void);
-
+size_t kvm_iommu_pages(void);
 #endif /* __ARM64_KVM_HOST_H__ */
diff --git a/arch/arm64/kvm/hyp/include/nvhe/iommu.h b/arch/arm64/kvm/hyp/include/nvhe/iommu.h
index 219363045b1c..9f4906c6dcc9 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/iommu.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/iommu.h
@@ -10,8 +10,11 @@ struct kvm_iommu_ops {
 	void (*host_stage2_idmap)(phys_addr_t start, phys_addr_t end, int prot);
 };
 
-int kvm_iommu_init(void);
+int kvm_iommu_init(void *pool_base, size_t nr_pages);
 
 void kvm_iommu_host_stage2_idmap(phys_addr_t start, phys_addr_t end,
 				 enum kvm_pgtable_prot prot);
+void *kvm_iommu_donate_pages(u8 order);
+void kvm_iommu_reclaim_pages(void *ptr);
+
 #endif /* __ARM64_KVM_NVHE_IOMMU_H__ */
diff --git a/arch/arm64/kvm/hyp/nvhe/iommu/iommu.c b/arch/arm64/kvm/hyp/nvhe/iommu/iommu.c
index f7d1c8feb358..1673165c7330 100644
--- a/arch/arm64/kvm/hyp/nvhe/iommu/iommu.c
+++ b/arch/arm64/kvm/hyp/nvhe/iommu/iommu.c
@@ -15,6 +15,7 @@ struct kvm_iommu_ops *kvm_iommu_ops;
 
 /* Protected by host_mmu.lock */
 static bool kvm_idmap_initialized;
+static struct hyp_pool iommu_pages_pool;
 
 static inline int pkvm_to_iommu_prot(enum kvm_pgtable_prot prot)
 {
@@ -72,7 +73,7 @@ static int kvm_iommu_snapshot_host_stage2(void)
 	return ret;
 }
 
-int kvm_iommu_init(void)
+int kvm_iommu_init(void *pool_base, size_t nr_pages)
 {
 	int ret;
 
@@ -80,6 +81,13 @@ int kvm_iommu_init(void)
 	    !kvm_iommu_ops->host_stage2_idmap)
 		return -ENODEV;
 
+	if (nr_pages) {
+		ret = hyp_pool_init(&iommu_pages_pool, hyp_virt_to_pfn(pool_base),
+				    nr_pages, 0);
+		if (ret)
+			return ret;
+	}
+
 	ret = kvm_iommu_ops->init();
 	if (ret)
 		return ret;
@@ -95,3 +103,13 @@ void kvm_iommu_host_stage2_idmap(phys_addr_t start, phys_addr_t end,
 		return;
 	kvm_iommu_ops->host_stage2_idmap(start, end, pkvm_to_iommu_prot(prot));
 }
+
+void *kvm_iommu_donate_pages(u8 order)
+{
+	return hyp_alloc_pages(&iommu_pages_pool, order);
+}
+
+void kvm_iommu_reclaim_pages(void *ptr)
+{
+	hyp_put_page(&iommu_pages_pool, ptr);
+}
diff --git a/arch/arm64/kvm/hyp/nvhe/setup.c b/arch/arm64/kvm/hyp/nvhe/setup.c
index bdbc77395e03..09ecee2cd864 100644
--- a/arch/arm64/kvm/hyp/nvhe/setup.c
+++ b/arch/arm64/kvm/hyp/nvhe/setup.c
@@ -21,6 +21,7 @@
 #include <nvhe/trap_handler.h>
 
 unsigned long hyp_nr_cpus;
+size_t hyp_kvm_iommu_pages;
 
 #define hyp_percpu_size ((unsigned long)__per_cpu_end - \
 			 (unsigned long)__per_cpu_start)
@@ -33,6 +34,7 @@ static void *selftest_base;
 static void *ffa_proxy_pages;
 static struct kvm_pgtable_mm_ops pkvm_pgtable_mm_ops;
 static struct hyp_pool hpool;
+static void *iommu_base;
 
 static int divide_memory_pool(void *virt, unsigned long size)
 {
@@ -70,6 +72,12 @@ static int divide_memory_pool(void *virt, unsigned long size)
 	if (!ffa_proxy_pages)
 		return -ENOMEM;
 
+	if (hyp_kvm_iommu_pages) {
+		iommu_base = hyp_early_alloc_contig(hyp_kvm_iommu_pages);
+		if (!iommu_base)
+			return -ENOMEM;
+	}
+
 	return 0;
 }
 
@@ -321,7 +329,7 @@ void __noreturn __pkvm_init_finalise(void)
 	if (ret)
 		goto out;
 
-	ret = kvm_iommu_init();
+	ret = kvm_iommu_init(iommu_base, hyp_kvm_iommu_pages);
 	if (ret)
 		goto out;
 
diff --git a/arch/arm64/kvm/iommu.c b/arch/arm64/kvm/iommu.c
index 39465101074a..0e52cc0e18de 100644
--- a/arch/arm64/kvm/iommu.c
+++ b/arch/arm64/kvm/iommu.c
@@ -9,6 +9,7 @@
 
 struct kvm_iommu_driver *iommu_driver;
 extern struct kvm_iommu_ops *kvm_nvhe_sym(kvm_iommu_ops);
+extern size_t kvm_nvhe_sym(hyp_kvm_iommu_pages);
 
 int kvm_iommu_register_driver(struct kvm_iommu_driver *kern_ops, struct kvm_iommu_ops *el2_ops)
 {
@@ -47,3 +48,13 @@ void kvm_iommu_remove_driver(void)
 	if (smp_load_acquire(&iommu_driver))
 		iommu_driver->remove_driver();
 }
+
+size_t kvm_iommu_pages(void)
+{
+	/*
+	 * This is called very early during setup_arch() where no initcalls,
+	 * so this has to call specific functions per each KVM driver.
+	 */
+	kvm_nvhe_sym(hyp_kvm_iommu_pages) = 0;
+	return 0;
+}
diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
index fcd70bfe44fb..6098beda36fa 100644
--- a/arch/arm64/kvm/pkvm.c
+++ b/arch/arm64/kvm/pkvm.c
@@ -63,6 +63,7 @@ void __init kvm_hyp_reserve(void)
 	hyp_mem_pages += hyp_vmemmap_pages(STRUCT_HYP_PAGE_SIZE);
 	hyp_mem_pages += pkvm_selftest_pages();
 	hyp_mem_pages += hyp_ffa_proxy_pages();
+	hyp_mem_pages += kvm_iommu_pages();
 
 	/*
 	 * Try to allocate a PMD-aligned region to reduce TLB pressure once
-- 
2.50.1.552.g942d659e1b-goog

