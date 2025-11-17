Received: from mail-ej1-f74.google.com (mail-ej1-f74.google.com [209.85.218.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A51E336EE1
	for <kvmarm@lists.linux.dev>; Mon, 17 Nov 2025 18:48:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763405321; cv=none; b=Tc/F3zF/jgE+Ke44tVTFxdeVplJ2ClHCz5v0viwWxhVI73ZMfBD+2dj1SX9m+/krZIfyqh45XKC+YpDUWUxQb+tWUXgk+EZt+mAFtDj6aTpRdhKWDoabhNlK9uFZSVyMz71WLbgdN0I+bEMTwIW9YD5AUSRxK9Ibc9FJ3n43Ksk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763405321; c=relaxed/simple;
	bh=NAMroDrXjFET8e/V1jEPHTmEuoxT2nPqbJIpZ7VUQF4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=dfXxLe5w/brHhX/pDTUgBzRgCzPEyYl6YVaTv+c9r6x9ohSf6qVmw1zsBukdI9K1X7VK5N3BrSjagalQsSpQDrDVX6AchE3O3pSSHBhel9fJzn98/JtnpxJpZck9epbBXHmxLeTKDSwt3FED2B9LjhMeIrniGSwNHd1FqYmFcsk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=QJMRjm/4; arc=none smtp.client-ip=209.85.218.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="QJMRjm/4"
Received: by mail-ej1-f74.google.com with SMTP id a640c23a62f3a-b72de28c849so405684466b.1
        for <kvmarm@lists.linux.dev>; Mon, 17 Nov 2025 10:48:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763405316; x=1764010116; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Rk1fl88JutZZYCoKcXxRTtxtyt/5+rf5iGOfbus1BTk=;
        b=QJMRjm/4A/iPDQCKlzyAZh35h/3FE8sy+ZD7pzm25SCgjzdtJT1+eXgPlttakPPimy
         qIKf5ad32FeO3CX9FZvwNrbKtRiQAnAzHWsNRVEMlbNQwUbMyUbP+V3Y4iWcFihU2ra0
         EcVvc/verkbnc9mQ+yMdvHM7S80aT+U+pcCmmUuZVxeLVv556cv3OlFg26ryx3CJzTUe
         H44NKo5ozXGcOWT3CxnGnPaASMcUxeWoIzkPZkq1RmY4nqDKTh+zCbR5XVxjACRyyhul
         9WOL3s2pjlsct8wF2bf1vGn1KH043W5E1qk0UCqhdcrDXgSoVJyS2NiLoalJ1J5ahhmw
         Kqhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763405316; x=1764010116;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Rk1fl88JutZZYCoKcXxRTtxtyt/5+rf5iGOfbus1BTk=;
        b=SDAKWOMBr3grexjT2TAL0jSRAUScK/03oRbfYbbhYLQNGe34YQ0SmOakAH8w4a5/YL
         KrHJbQEVjVb2rg/dKAIoN+qES89nfFbCK8RQm26JV/OPYKJRjcPF8QJm1Snfxc+14yor
         aP2IdjGily4NY/I0zhUvEnk4+rLheMt1kgZowCZzjxmxbAbXieaDEJv6Nw8l/CiMX07B
         CXzBa/O63dcIVecaG143wDwYJBYqNzo3oH/0u6/fIwZmmVl5F20L10z2krbY9P76RXM+
         FS4P5LQoVtP6htH8W5rWPJGI/FkF++Pyh4er+k5b+2fvvJZvfltzZQvKUKKb+UJOQ3ER
         4k6Q==
X-Forwarded-Encrypted: i=1; AJvYcCUsx+3MvwU4x5/S+ZAHfadkAopcKLxETB/Q4n0lL5m7/e+bvfdLU4GgJgx5MqBgiXTEbDayOK0=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx80rsFQ3FT+i+hL05tktOYXsL1qcyVuFycnsI3aa8FQOQFQZS4
	nHhy7d7vnlzBW710C/SVx86t1iGVV+rNNtRg56xsPlqaowVp+VhTMBb6PDqHELk+4VvqA+xls2s
	GqoNM0FE3dvAONg==
X-Google-Smtp-Source: AGHT+IFK6mFtucBRLiWaaV+YANl4dQaIe6ZXNzcjcMCQe/1qsUgD5bMWkFpnXRoT7wZjLhUKC6CSylQU/X+dYw==
X-Received: from ejcvd5.prod.google.com ([2002:a17:907:d205:b0:b73:7a81:20af])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:907:3c82:b0:b73:16fc:d469 with SMTP id a640c23a62f3a-b736793dcdcmr1369485766b.51.1763405316436;
 Mon, 17 Nov 2025 10:48:36 -0800 (PST)
Date: Mon, 17 Nov 2025 18:47:57 +0000
In-Reply-To: <20251117184815.1027271-1-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251117184815.1027271-1-smostafa@google.com>
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
Message-ID: <20251117184815.1027271-11-smostafa@google.com>
Subject: [PATCH v5 10/27] KVM: arm64: iommu: Add memory pool
From: Mostafa Saleh <smostafa@google.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	kvmarm@lists.linux.dev, iommu@lists.linux.dev
Cc: catalin.marinas@arm.com, will@kernel.org, maz@kernel.org, 
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, joro@8bytes.org, jean-philippe@linaro.org, jgg@ziepe.ca, 
	praan@google.com, danielmentz@google.com, mark.rutland@arm.com, 
	qperret@google.com, tabba@google.com, Mostafa Saleh <smostafa@google.com>
Content-Type: text/plain; charset="UTF-8"

IOMMU drivers would require to allocate memory for the shadow page
table. Similar to the host stage-2 CPU page table, the IOMMU pool
is allocated early from the carveout and it's memory is added in
a pool which the IOMMU driver can allocate from and reclaim at
run time.

As this is too early for drivers to use init calls, a default value
can be set in the kernel config through IOMMU_POOL_PAGES, which
then can be overridden later from the kernel command line:
"kvm-arm.hyp_iommu_pages".

Later when the driver registers, it will pass how many pages it
needs, and if it was less than what was allocated, it will fail
to register.

Signed-off-by: Mostafa Saleh <smostafa@google.com>
---
 .../admin-guide/kernel-parameters.txt         |  4 +++
 arch/arm64/include/asm/kvm_host.h             |  3 +-
 arch/arm64/kvm/Kconfig                        |  7 +++++
 arch/arm64/kvm/hyp/include/nvhe/iommu.h       |  5 ++-
 arch/arm64/kvm/hyp/nvhe/iommu/iommu.c         | 20 +++++++++++-
 arch/arm64/kvm/hyp/nvhe/setup.c               | 16 +++++++++-
 arch/arm64/kvm/iommu.c                        | 31 ++++++++++++++++++-
 arch/arm64/kvm/pkvm.c                         |  1 +
 8 files changed, 82 insertions(+), 5 deletions(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 6c42061ca20e..f843d10a3dfc 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -3059,6 +3059,10 @@
 			trap: set WFI instruction trap
 
 			notrap: clear WFI instruction trap
+	kvm-arm.hyp_iommu_pages=
+			[KVM, ARM, EARLY]
+			Number of pages allocated for the IOMMU pool from the
+			KVM carveout when running in protected mode.
 
 	kvm_cma_resv_ratio=n [PPC,EARLY]
 			Reserves given percentage from system memory area for
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index fb2551ba8798..5496c52d0163 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -1654,7 +1654,8 @@ static __always_inline enum fgt_group_id __fgt_reg_to_group_id(enum vcpu_sysreg
 
 #ifndef __KVM_NVHE_HYPERVISOR__
 struct kvm_iommu_ops;
-int kvm_iommu_register_driver(struct kvm_iommu_ops *hyp_ops);
+int kvm_iommu_register_driver(struct kvm_iommu_ops *hyp_ops, size_t pool_pages);
+size_t kvm_iommu_pages(void);
 #endif
 
 #endif /* __ARM64_KVM_HOST_H__ */
diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
index 4f803fd1c99a..6a1bd82a0d07 100644
--- a/arch/arm64/kvm/Kconfig
+++ b/arch/arm64/kvm/Kconfig
@@ -83,4 +83,11 @@ config PTDUMP_STAGE2_DEBUGFS
 
 	  If in doubt, say N.
 
+config IOMMU_POOL_PAGES
+	hex "Number of pages reserved for IOMMU pool"
+	depends on KVM && IOMMU_SUPPORT
+	default 0x0
+	help
+	  IOMMU pool is used with protected mode to allocated IOMMU drivers page tables.
+
 endif # VIRTUALIZATION
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
index 414bd4c97690..a0df34ecf6b0 100644
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
index de79803e7439..c245ea88c480 100644
--- a/arch/arm64/kvm/hyp/nvhe/setup.c
+++ b/arch/arm64/kvm/hyp/nvhe/setup.c
@@ -22,6 +22,13 @@
 
 unsigned long hyp_nr_cpus;
 
+/* See kvm_iommu_pages() */
+#ifdef CONFIG_IOMMU_POOL_PAGES
+size_t hyp_kvm_iommu_pages = CONFIG_IOMMU_POOL_PAGES;
+#else
+size_t hyp_kvm_iommu_pages;
+#endif
+
 #define hyp_percpu_size ((unsigned long)__per_cpu_end - \
 			 (unsigned long)__per_cpu_start)
 
@@ -33,6 +40,7 @@ static void *selftest_base;
 static void *ffa_proxy_pages;
 static struct kvm_pgtable_mm_ops pkvm_pgtable_mm_ops;
 static struct hyp_pool hpool;
+static void *iommu_base;
 
 static int divide_memory_pool(void *virt, unsigned long size)
 {
@@ -70,6 +78,12 @@ static int divide_memory_pool(void *virt, unsigned long size)
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
 
@@ -329,7 +343,7 @@ void __noreturn __pkvm_init_finalise(void)
 	if (ret)
 		goto out;
 
-	ret = kvm_iommu_init();
+	ret = kvm_iommu_init(iommu_base, hyp_kvm_iommu_pages);
 	if (ret)
 		goto out;
 
diff --git a/arch/arm64/kvm/iommu.c b/arch/arm64/kvm/iommu.c
index c9041dcb6c57..6143fd3e1de3 100644
--- a/arch/arm64/kvm/iommu.c
+++ b/arch/arm64/kvm/iommu.c
@@ -7,9 +7,38 @@
 #include <linux/kvm_host.h>
 
 extern struct kvm_iommu_ops *kvm_nvhe_sym(kvm_iommu_ops);
+extern size_t kvm_nvhe_sym(hyp_kvm_iommu_pages);
 
-int kvm_iommu_register_driver(struct kvm_iommu_ops *hyp_ops)
+int kvm_iommu_register_driver(struct kvm_iommu_ops *hyp_ops, size_t pool_pages)
 {
+	/* See kvm_iommu_pages() */
+	if (pool_pages > kvm_nvhe_sym(hyp_kvm_iommu_pages)) {
+		kvm_err("Missing memory for the IOMMU pool, need 0x%zx pages, check kvm-arm.hyp_iommu_pages",
+			 pool_pages);
+		return -ENOMEM;
+	}
+
 	kvm_nvhe_sym(kvm_iommu_ops) = hyp_ops;
 	return 0;
 }
+
+size_t kvm_iommu_pages(void)
+{
+	/*
+	 * This is called very early during setup_arch() where no initcalls,
+	 * so this has to call specific functions per each KVM driver.
+	 * So we allow a config option that can set the defaul value for
+	 * the IOMMU pool that can overridden by a command line option.
+	 * When the driver registers it will pass the number pages needed
+	 * for it's page tables, if less that what the system has already
+	 * allocated we fail.
+	 */
+	return kvm_nvhe_sym(hyp_kvm_iommu_pages);
+}
+
+/* Number of pages to reserve for iommu pool*/
+static int __init early_hyp_iommu_pages(char *arg)
+{
+	return kstrtoul(arg, 10, &kvm_nvhe_sym(hyp_kvm_iommu_pages));
+}
+early_param("kvm-arm.hyp_iommu_pages", early_hyp_iommu_pages);
diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
index 24f0f8a8c943..b9d212b48c04 100644
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
2.52.0.rc1.455.g30608eb744-goog

