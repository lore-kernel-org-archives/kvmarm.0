Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1C4E4611C5
	for <kvmarm@lists.linux.dev>; Wed, 15 Jul 2026 11:59:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784116768; cv=none; b=X4SJdpQQDZm1s6bPX1QAb+oUVNAGPqBxhdStg49rOxe2XIPniPFmwj58M43rpuozvz2n7cWk6fTXSWH7YZA3ZtKH5QyhjtzQvrzzLOC0vI1ut0BGP4T/n46QEtvNtDbgiX8KLcW4SNn8eHbg93mm/ozEgfION7GkQAN1bd9gAnI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784116768; c=relaxed/simple;
	bh=BKXOjPm4HibB0zKKPDg8mVqvFcn5okB02q1ktl64G/I=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=r++mUtKmeslrZkAUnujtHR89dv3xYhZO+OmFeTXjqgrnvjnMkg+RR+uRlS3rzsdBhjBA9tbn80OwtvuUfNMMIj7HTIcXoaLkzTRNMvp6cxdCk7IiRch08PiF2oiSDqyy85qJ3Fs/9/AYgKd+YXoQoh3eUIicuGcMXC5X1d0nH8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=bJNGuYkK; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bJNGuYkK"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-493ce08a6b4so48854685e9.1
        for <kvmarm@lists.linux.dev>; Wed, 15 Jul 2026 04:59:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784116763; x=1784721563; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=4P0vhJSxO+G+Vc4nk48G6MnzTMo1FQyjg7u/hgjKJK4=;
        b=bJNGuYkKFuj1zX1Sq9vkgq3/OxkukYLf/ftu20rnE+N13Ms7iM38ua4aTRvqnNNcJ2
         UkEmShvjYFGk14Bwz9AYiUZLcmAjl9zokzqfjV+R2eN8qFX6NI77DjHj4ThJ7Ta3YWI6
         QOpQRlDkS6VpXIJhNRqKe8LawSKz+suYzFfl66iJdIr9/J4JAWH6KJTxXQP0KhSik1xf
         m9VcoVhI1mQD4QQNPulHUvEf2hZyLMYrhHg7+HCpqvLw7yie+zwBfFFLnV+fKVRa2HhA
         T/1ghYa69XVqqSc2gkFurFmTto0Jva9VDpwb0TYKaOuTrqBDVx7WtAiF4AUwZKCPgiIs
         NKcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784116763; x=1784721563;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=4P0vhJSxO+G+Vc4nk48G6MnzTMo1FQyjg7u/hgjKJK4=;
        b=cSSkFM3Bl35r4EpYUHealTHnRXYTakQALSc0tRtEnFELml024k2a5hGXwvnCXqs7He
         uLyg5lWFQRmNSjbdAs5aeX1WxQDYDV+c7a90+ezw5fwXQ/t/pfE25lkTIjraWGjCKGn1
         G+O23LuQv+ifAUmr8cRtvxkO5QhFO1UGIP+dP+rV5f8EDxuZB+RRP6jXy8EzXcaHVrYa
         BmdPFLrcYos68PPVAqke4bZpcVkBB7oW7x1UEthrY+ddkErJiIw0noLX32xN45yMlC4y
         0U/Ug/8qfOfnUsc+qdqovLHsEZ3m0nc/SdjKHxW3w6Ib0H/zdPg8eQbxAMD3PSlfXgf8
         wnAA==
X-Forwarded-Encrypted: i=1; AHgh+RrzNQk+tRT5knRA2oMpWQjABqw1qdJtm1GVzvuyss05NOSj/Pd/OErniwGTbwXoNzCVoZ4Cc2c=@lists.linux.dev
X-Gm-Message-State: AOJu0YzTN4uyJ5M2dhgq2QKcxJFhdjSbbVghwbgoz0ff5rNTG9rMuhZX
	aRHtfM1CYA2XjAtmY1wSJYUEwm3L47xQYn50zbB0irk6uD9imYChFZdt+77l0HErfqvmbKF+Tx6
	NkWljoX8FJi3Osg==
X-Received: from wmga19.prod.google.com ([2002:a05:600c:2d53:b0:495:3dd3:e994])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:c16a:b0:493:b89b:9a27 with SMTP id 5b1f17b1804b1-495389d2a9cmr64618175e9.9.1784116762784;
 Wed, 15 Jul 2026 04:59:22 -0700 (PDT)
Date: Wed, 15 Jul 2026 11:58:49 +0000
In-Reply-To: <20260715115906.2664882-1-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260715115906.2664882-1-smostafa@google.com>
X-Mailer: git-send-email 2.55.0.141.g00534a21ce-goog
Message-ID: <20260715115906.2664882-9-smostafa@google.com>
Subject: [PATCH v7 08/24] KVM: arm64: iommu: Add memory pool
From: Mostafa Saleh <smostafa@google.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	kvmarm@lists.linux.dev, iommu@lists.linux.dev
Cc: catalin.marinas@arm.com, will@kernel.org, maz@kernel.org, 
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, joro@8bytes.org, jgg@ziepe.ca, mark.rutland@arm.com, 
	qperret@google.com, tabba@google.com, vdonnefort@google.com, 
	sebastianene@google.com, keirf@google.com, 
	Mostafa Saleh <smostafa@google.com>
Content-Type: text/plain; charset="UTF-8"

IOMMU drivers need to allocate memory for the shadow page table.
Similar to the host stage-2 CPU page table, the IOMMU pool
is allocated early from the carveout and it's memory is added to
a pool which the IOMMU driver can allocate from and reclaim to at
run time.

As this is too early for drivers to use initcalls, the number of
pages allocated is set from command line "kvm-arm.iommu_pgt_mem".

Later when the driver registers, it will pass how many pages it
needs, and if it was less than what was allocated, it will fail
to register.

Signed-off-by: Mostafa Saleh <smostafa@google.com>
---
 .../admin-guide/kernel-parameters.txt         |  4 ++
 arch/arm64/include/asm/kvm_host.h             |  3 +-
 arch/arm64/kvm/hyp/include/nvhe/iommu.h       |  8 +++-
 arch/arm64/kvm/hyp/nvhe/iommu.c               | 21 +++++++++-
 arch/arm64/kvm/hyp/nvhe/setup.c               | 11 ++++-
 arch/arm64/kvm/iommu.c                        | 42 ++++++++++++++++++-
 arch/arm64/kvm/pkvm.c                         |  1 +
 7 files changed, 85 insertions(+), 5 deletions(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index b5493a7f8f22..5cbac46bc941 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -3253,6 +3253,10 @@ Kernel parameters
 			trap: set WFI instruction trap
 
 			notrap: clear WFI instruction trap
+	kvm-arm.iommu_pgt_mem=nn[KMG]
+			[KVM, ARM, EARLY]
+			Memory allocated for the IOMMU pool from the KVM carveout
+			when running in protected mode.
 
 	kvm_cma_resv_ratio=n [PPC,EARLY]
 			Reserves given percentage from system memory area for
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 43821767ccab..8d3b4500b360 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -1713,7 +1713,8 @@ long kvm_get_cap_for_kvm_ioctl(unsigned int ioctl, long *ext);
 
 #ifndef __KVM_NVHE_HYPERVISOR__
 struct pkvm_iommu_ops;
-int pkvm_iommu_register_driver(struct pkvm_iommu_ops *hyp_ops);
+int pkvm_iommu_register_driver(struct pkvm_iommu_ops *hyp_ops, unsigned int nr_pages);
+unsigned int pkvm_iommu_pages(void);
 #endif
 
 #endif /* __ARM64_KVM_HOST_H__ */
diff --git a/arch/arm64/kvm/hyp/include/nvhe/iommu.h b/arch/arm64/kvm/hyp/include/nvhe/iommu.h
index 857d7dd2ebc3..028e89a3448d 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/iommu.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/iommu.h
@@ -10,8 +10,14 @@ struct pkvm_iommu_ops {
 	int (*host_stage2_idmap)(phys_addr_t start, phys_addr_t end, int prot);
 };
 
-int pkvm_iommu_init(void);
+int pkvm_iommu_init(void *pool_base, unsigned int nr_pages);
 
 int pkvm_iommu_host_stage2_idmap(phys_addr_t start, phys_addr_t end,
 				 enum kvm_pgtable_prot prot);
+
+/* Allocate pages from the IOMMU carveout, returns zeroed memory. */
+void *pkvm_iommu_donate_pages(u8 order);
+/* Free pages from pkvm_iommu_donate_pages(). Must use same size */
+void pkvm_iommu_reclaim_pages(void *ptr);
+
 #endif /* __ARM64_KVM_NVHE_IOMMU_H__ */
diff --git a/arch/arm64/kvm/hyp/nvhe/iommu.c b/arch/arm64/kvm/hyp/nvhe/iommu.c
index 08009609ec59..8891cb7920c4 100644
--- a/arch/arm64/kvm/hyp/nvhe/iommu.c
+++ b/arch/arm64/kvm/hyp/nvhe/iommu.c
@@ -16,6 +16,7 @@ struct pkvm_iommu_ops *pkvm_iommu_ops;
 
 /* Protected by host_mmu.lock */
 static bool pkvm_idmap_initialized;
+static struct hyp_pool iommu_pages_pool;
 
 static inline int pkvm_to_iommu_prot(enum kvm_pgtable_prot prot)
 {
@@ -112,7 +113,7 @@ static int pkvm_iommu_snapshot_host_stage2(void)
 	return ret;
 }
 
-int pkvm_iommu_init(void)
+int pkvm_iommu_init(void *pool_base, unsigned int nr_pages)
 {
 	int ret;
 
@@ -121,6 +122,14 @@ int pkvm_iommu_init(void)
 	    !pkvm_iommu_ops->host_stage2_idmap)
 		return 0;
 
+	if (!nr_pages)
+		return -ENOMEM;
+
+	ret = hyp_pool_init(&iommu_pages_pool, hyp_virt_to_pfn(pool_base),
+			    nr_pages, 0);
+	if (ret)
+		return ret;
+
 	ret = pkvm_iommu_ops->init();
 	if (ret)
 		return ret;
@@ -138,3 +147,13 @@ int pkvm_iommu_host_stage2_idmap(phys_addr_t start, phys_addr_t end,
 
 	return pkvm_iommu_ops->host_stage2_idmap(start, end, pkvm_to_iommu_prot(prot));
 }
+
+void *pkvm_iommu_donate_pages(u8 order)
+{
+	return hyp_alloc_pages(&iommu_pages_pool, order);
+}
+
+void pkvm_iommu_reclaim_pages(void *ptr)
+{
+	hyp_put_page(&iommu_pages_pool, ptr);
+}
diff --git a/arch/arm64/kvm/hyp/nvhe/setup.c b/arch/arm64/kvm/hyp/nvhe/setup.c
index c6698ecea4a2..39d59ff30f34 100644
--- a/arch/arm64/kvm/hyp/nvhe/setup.c
+++ b/arch/arm64/kvm/hyp/nvhe/setup.c
@@ -23,6 +23,8 @@
 
 unsigned long hyp_nr_cpus;
 
+unsigned int hyp_kvm_iommu_pages;
+
 #define hyp_percpu_size ((unsigned long)__per_cpu_end - \
 			 (unsigned long)__per_cpu_start)
 
@@ -34,6 +36,7 @@ static void *selftest_base;
 static void *ffa_proxy_pages;
 static struct kvm_pgtable_mm_ops pkvm_pgtable_mm_ops;
 static struct hyp_pool hpool;
+static void *iommu_base;
 
 static int divide_memory_pool(void *virt, unsigned long size)
 {
@@ -71,6 +74,12 @@ static int divide_memory_pool(void *virt, unsigned long size)
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
 
@@ -339,7 +348,7 @@ void __noreturn __pkvm_init_finalise(void)
 	 * that would be leaked if the hypervisor fails after as there is no
 	 * remove_iommu_driver() ops at the moment, that can be added later if necessary.
 	 */
-	ret = pkvm_iommu_init();
+	ret = pkvm_iommu_init(iommu_base, hyp_kvm_iommu_pages);
 	if (ret)
 		goto out;
 
diff --git a/arch/arm64/kvm/iommu.c b/arch/arm64/kvm/iommu.c
index 6492285012a4..c80663b506c0 100644
--- a/arch/arm64/kvm/iommu.c
+++ b/arch/arm64/kvm/iommu.c
@@ -7,10 +7,11 @@
 #include <linux/kvm_host.h>
 
 extern struct pkvm_iommu_ops *kvm_nvhe_sym(pkvm_iommu_ops);
+extern unsigned int kvm_nvhe_sym(hyp_kvm_iommu_pages);
 
 static DEFINE_MUTEX(pkvm_iommu_reg_lock);
 
-int __init pkvm_iommu_register_driver(struct pkvm_iommu_ops *hyp_ops)
+int pkvm_iommu_register_driver(struct pkvm_iommu_ops *hyp_ops, unsigned int nr_pages)
 {
 	guard(mutex)(&pkvm_iommu_reg_lock);
 
@@ -20,6 +21,45 @@ int __init pkvm_iommu_register_driver(struct pkvm_iommu_ops *hyp_ops)
 	if (kvm_nvhe_sym(pkvm_iommu_ops))
 		return -EBUSY;
 
+	/* See kvm_iommu_pages() */
+	if (nr_pages > kvm_nvhe_sym(hyp_kvm_iommu_pages)) {
+		kvm_err("IOMMU pool needs 0x%x pages, check kvm-arm.iommu_pgt_mem", nr_pages);
+		return -ENOMEM;
+	}
+
 	kvm_nvhe_sym(pkvm_iommu_ops) = hyp_ops;
 	return 0;
 }
+
+unsigned int pkvm_iommu_pages(void)
+{
+	/*
+	 * This is used very early during setup_arch() before any initcalls
+	 * or any drivers are registered.
+	 * This value is set by a command line option.
+	 * Later, when the driver is registered, it will pass the number
+	 * pages needed for it's page tables, if it was more than what
+	 * the system has already allocated, it will fail registration.
+	 */
+	return kvm_nvhe_sym(hyp_kvm_iommu_pages);
+}
+
+/* Number of pages to reserve for iommu pool*/
+static int __init early_iommu_pgt_mem(char *arg)
+{
+	unsigned long long requested_size;
+
+	if (!arg)
+		return -EINVAL;
+
+	requested_size = memparse(arg, NULL);
+
+	if (requested_size > UINT_MAX) {
+		kvm_err("kvm-arm.iommu_pgt_mem is too large\n");
+		return -EINVAL;
+	}
+
+	kvm_nvhe_sym(hyp_kvm_iommu_pages) = requested_size >> PAGE_SHIFT;
+	return 0;
+}
+early_param("kvm-arm.iommu_pgt_mem", early_iommu_pgt_mem);
diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
index 053e4f733e4b..72ca1393c504 100644
--- a/arch/arm64/kvm/pkvm.c
+++ b/arch/arm64/kvm/pkvm.c
@@ -63,6 +63,7 @@ void __init kvm_hyp_reserve(void)
 	hyp_mem_pages += hyp_vmemmap_pages(STRUCT_HYP_PAGE_SIZE);
 	hyp_mem_pages += pkvm_selftest_pages();
 	hyp_mem_pages += hyp_ffa_proxy_pages();
+	hyp_mem_pages += pkvm_iommu_pages();
 
 	/*
 	 * Try to allocate a PMD-aligned region to reduce TLB pressure once
-- 
2.55.0.141.g00534a21ce-goog

