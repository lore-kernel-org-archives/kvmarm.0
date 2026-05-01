Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F357939F166
	for <kvmarm@lists.linux.dev>; Fri,  1 May 2026 11:20:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777634415; cv=none; b=j0gCpPmL0QhE+IWcDmRZM945H8Sau3s1X7HMloO2jq3HE+V6QqQRCDFtIMKSEYAe9lja2tJz6RwVJHzP6OA35F0iBADNuNqsir/0NF7HXD0AE9GRAbN6Y4EFYnMkD1FvUaBINR1v4VHMwcvvDha0dkgQahedLzvFxD87e2l08pk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777634415; c=relaxed/simple;
	bh=qxqKnqxfNJ7XYWVGc81dtZPlQ0S/fgywNS1fFSbtZeI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=WsUeHon8GSGZgtausU3IDH3oRTVmI3uYJ1Tc7IEF6WvA5la2gQcGsbYklXH/CoeQStm7aQvs5iWgCyJWykgqlwGF0AZ7qoZrEdZGZx87sOAF7GJ3wo10ayPSWbalaMqd02De8GjXpiX5nmG4R64UtDfquoEl0LRAtJRw5Svl1k4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=BxsE/t0k; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="BxsE/t0k"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-4836abfc742so14273375e9.0
        for <kvmarm@lists.linux.dev>; Fri, 01 May 2026 04:20:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777634410; x=1778239210; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Rodgv7A+aYOiGQUhnQ9CHMotwYGD2z3moCBzLHWH+C4=;
        b=BxsE/t0kt6fgNBnxW0ay9WTvbhWRcKKQNDCot3jTHO8zzyg+AzMf2653HN06Vj7VRi
         28S0SXlqV/i2EjjI1SBp5E8Oe+3jZJbVUrl8zujmycxR79GWYCNoABWrvNlzawcMye+c
         6HIjnrPxHGd71fQil4UITyLyHI79LTE6ekD7PERCDfUgb/o9CbJGRV4RT78UK5giCy3j
         nFksQPpnLORsRpMxcY0AyIoj1dcmtKfmD3ytAhPu1XgYHraHUwqVPULSrDdO0QVZY7RH
         Mi9YZNQe1fl9e6XxoWgbkd0KUteP6OlddyHrHm2HOgVFgX+cRLhsMZ5O/NFUuBofbHBh
         fw5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777634410; x=1778239210;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Rodgv7A+aYOiGQUhnQ9CHMotwYGD2z3moCBzLHWH+C4=;
        b=DbW/W3sXfWWfrb8K7+WABlyX9c35mMhU4a6rHITil4PJB6awHRR9rLlx/YB9zoQdjc
         XCfXEPRfldHRtZu5b4j0EUdbCQM85SRkOLTPYDeKd0x1sThNwH6Tlyvcw9tP9I2zKZo9
         1+ozdC2CcTqUkfUKwTHKkmlOPurtbYYEH5Dvz+9chwJB6jEi38VCWMTKvk7QOvW0kbkl
         /BFqf+r/NZRPGfmvlPN5OD2Jy7PPCc02aZ1kX4re52MEl+tS8p1NHXMaugm9IJWeYQop
         cqt+MjuIIkoUUyYo2cdFqBpOJO5BYJ+mKDNt/rGdtTNZU4DdZE9n0F30M4ZUIlEVxmPu
         GtiA==
X-Forwarded-Encrypted: i=1; AFNElJ9ypXX1PazEdOcOhpQlvHV98xi8ooouY/skRxmzvMeDkUYQ4bM7vXhMOWVdF0TYNH1T1cZQND4=@lists.linux.dev
X-Gm-Message-State: AOJu0Yzk4/UY5iLTGfU5lKq3i+UK2k3tYhD44djmUaJiuVEWP6Eekb+H
	SxKB7BdGDY2WH0qo4+fCyT4KoZYy3sQP53u97pvlX4Pw+LsWPBlCf702aBmvRs8rz3CMnv4kHFd
	8A/MhR+8WO2HcHA==
X-Received: from wmbf9.prod.google.com ([2002:a05:600c:5949:b0:48a:79a9:335c])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:3e10:b0:488:ffb1:494c with SMTP id 5b1f17b1804b1-48a84456732mr106489765e9.12.1777634410490;
 Fri, 01 May 2026 04:20:10 -0700 (PDT)
Date: Fri,  1 May 2026 11:19:11 +0000
In-Reply-To: <20260501111928.259252-1-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260501111928.259252-1-smostafa@google.com>
X-Mailer: git-send-email 2.54.0.545.g6539524ca2-goog
Message-ID: <20260501111928.259252-10-smostafa@google.com>
Subject: [PATCH v6 09/25] KVM: arm64: iommu: Add memory pool
From: Mostafa Saleh <smostafa@google.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	kvmarm@lists.linux.dev, iommu@lists.linux.dev
Cc: catalin.marinas@arm.com, will@kernel.org, maz@kernel.org, 
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, joro@8bytes.org, jean-philippe@linaro.org, jgg@ziepe.ca, 
	mark.rutland@arm.com, qperret@google.com, tabba@google.com, 
	vdonnefort@google.com, sebastianene@google.com, keirf@google.com, 
	Mostafa Saleh <smostafa@google.com>
Content-Type: text/plain; charset="UTF-8"

IOMMU drivers would require to allocate memory for the shadow page
table. Similar to the host stage-2 CPU page table, the IOMMU pool
is allocated early from the carveout and it's memory is added in
a pool which the IOMMU driver can allocate from and reclaim at
run time.

As this is too early for drivers to use init calls, set the number of
page allocated from the kernel command line "kvm-arm.hyp_iommu_pages".

Later when the driver registers, it will pass how many pages it
needs, and if it was less than what was allocated, it will fail
to register.

Signed-off-by: Mostafa Saleh <smostafa@google.com>
---
 .../admin-guide/kernel-parameters.txt         |  4 +++
 arch/arm64/include/asm/kvm_host.h             |  3 +-
 arch/arm64/kvm/hyp/include/nvhe/iommu.h       |  7 +++-
 arch/arm64/kvm/hyp/nvhe/iommu/iommu.c         | 21 +++++++++++-
 arch/arm64/kvm/hyp/nvhe/setup.c               | 12 ++++++-
 arch/arm64/kvm/iommu.c                        | 33 ++++++++++++++++++-
 arch/arm64/kvm/pkvm.c                         |  1 +
 7 files changed, 76 insertions(+), 5 deletions(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index cf3807641d89..5e49946ff7ed 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -3283,6 +3283,10 @@ Kernel parameters
 			trap: set WFI instruction trap
 
 			notrap: clear WFI instruction trap
+	kvm-arm.hyp_iommu_pages=
+			[KVM, ARM, EARLY]
+			Number of pages allocated for the IOMMU pool from the
+			KVM carveout when running in protected mode.
 
 	kvm_cma_resv_ratio=n [PPC,EARLY]
 			Reserves given percentage from system memory area for
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 52898d2a3ec6..17f4cce86ec3 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -1735,7 +1735,8 @@ long kvm_get_cap_for_kvm_ioctl(unsigned int ioctl, long *ext);
 
 #ifndef __KVM_NVHE_HYPERVISOR__
 struct kvm_iommu_ops;
-int kvm_iommu_register_driver(struct kvm_iommu_ops *hyp_ops);
+int kvm_iommu_register_driver(struct kvm_iommu_ops *hyp_ops, unsigned int pool_pages);
+unsigned int kvm_iommu_pages(void);
 #endif
 
 #endif /* __ARM64_KVM_HOST_H__ */
diff --git a/arch/arm64/kvm/hyp/include/nvhe/iommu.h b/arch/arm64/kvm/hyp/include/nvhe/iommu.h
index 6277d845cdcf..eba94b4f6050 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/iommu.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/iommu.h
@@ -10,8 +10,13 @@ struct kvm_iommu_ops {
 	int (*host_stage2_idmap)(phys_addr_t start, phys_addr_t end, int prot);
 };
 
-int kvm_iommu_init(void);
+int kvm_iommu_init(void *pool_base, unsigned int nr_pages);
 
 int kvm_iommu_host_stage2_idmap(phys_addr_t start, phys_addr_t end,
 				enum kvm_pgtable_prot prot);
+
+/* Returns zeroed memory. */
+void *kvm_iommu_donate_pages(u8 order);
+void kvm_iommu_reclaim_pages(void *ptr);
+
 #endif /* __ARM64_KVM_NVHE_IOMMU_H__ */
diff --git a/arch/arm64/kvm/hyp/nvhe/iommu/iommu.c b/arch/arm64/kvm/hyp/nvhe/iommu/iommu.c
index 1db52bd87c38..53cb5e4b0aac 100644
--- a/arch/arm64/kvm/hyp/nvhe/iommu/iommu.c
+++ b/arch/arm64/kvm/hyp/nvhe/iommu/iommu.c
@@ -15,6 +15,7 @@ struct kvm_iommu_ops *kvm_iommu_ops;
 
 /* Protected by host_mmu.lock */
 static bool kvm_idmap_initialized;
+static struct hyp_pool iommu_pages_pool;
 
 static inline int pkvm_to_iommu_prot(enum kvm_pgtable_prot prot)
 {
@@ -95,7 +96,7 @@ static int kvm_iommu_snapshot_host_stage2(void)
 	return ret;
 }
 
-int kvm_iommu_init(void)
+int kvm_iommu_init(void *pool_base, unsigned int nr_pages)
 {
 	int ret;
 
@@ -103,6 +104,14 @@ int kvm_iommu_init(void)
 	    !kvm_iommu_ops->host_stage2_idmap)
 		return 0;
 
+	if (!nr_pages)
+		return -ENOMEM;
+
+	ret = hyp_pool_init(&iommu_pages_pool, hyp_virt_to_pfn(pool_base),
+			    nr_pages, 0);
+	if (ret)
+		return ret;
+
 	ret = kvm_iommu_ops->init();
 	if (ret)
 		return ret;
@@ -120,3 +129,13 @@ int kvm_iommu_host_stage2_idmap(phys_addr_t start, phys_addr_t end,
 
 	return kvm_iommu_ops->host_stage2_idmap(start, end, pkvm_to_iommu_prot(prot));
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
index 1f6b221db9a0..215014e42c27 100644
--- a/arch/arm64/kvm/hyp/nvhe/setup.c
+++ b/arch/arm64/kvm/hyp/nvhe/setup.c
@@ -23,6 +23,9 @@
 
 unsigned long hyp_nr_cpus;
 
+/* See kvm_iommu_pages() */
+unsigned int hyp_kvm_iommu_pages;
+
 #define hyp_percpu_size ((unsigned long)__per_cpu_end - \
 			 (unsigned long)__per_cpu_start)
 
@@ -34,6 +37,7 @@ static void *selftest_base;
 static void *ffa_proxy_pages;
 static struct kvm_pgtable_mm_ops pkvm_pgtable_mm_ops;
 static struct hyp_pool hpool;
+static void *iommu_base;
 
 static int divide_memory_pool(void *virt, unsigned long size)
 {
@@ -71,6 +75,12 @@ static int divide_memory_pool(void *virt, unsigned long size)
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
 
@@ -330,7 +340,7 @@ void __noreturn __pkvm_init_finalise(void)
 	if (ret)
 		goto out;
 
-	ret = kvm_iommu_init();
+	ret = kvm_iommu_init(iommu_base, hyp_kvm_iommu_pages);
 	if (ret)
 		goto out;
 
diff --git a/arch/arm64/kvm/iommu.c b/arch/arm64/kvm/iommu.c
index f247384fa193..213429ceb549 100644
--- a/arch/arm64/kvm/iommu.c
+++ b/arch/arm64/kvm/iommu.c
@@ -7,10 +7,11 @@
 #include <linux/kvm_host.h>
 
 extern struct kvm_iommu_ops *kvm_nvhe_sym(kvm_iommu_ops);
+extern unsigned int kvm_nvhe_sym(hyp_kvm_iommu_pages);
 
 static DEFINE_MUTEX(kvm_iommu_reg_lock);
 
-int kvm_iommu_register_driver(struct kvm_iommu_ops *hyp_ops)
+int kvm_iommu_register_driver(struct kvm_iommu_ops *hyp_ops, unsigned int pool_pages)
 {
 	guard(mutex)(&kvm_iommu_reg_lock);
 
@@ -21,6 +22,36 @@ int kvm_iommu_register_driver(struct kvm_iommu_ops *hyp_ops)
 	if (kvm_nvhe_sym(kvm_iommu_ops))
 		return -EBUSY;
 
+	/* See kvm_iommu_pages() */
+	if (pool_pages > kvm_nvhe_sym(hyp_kvm_iommu_pages)) {
+		kvm_err("Not enough memory for the IOMMU pool, need 0x%x pages, check kvm-arm.hyp_iommu_pages",
+			pool_pages);
+		return -ENOMEM;
+	}
+
 	kvm_nvhe_sym(kvm_iommu_ops) = hyp_ops;
 	return 0;
 }
+
+unsigned int kvm_iommu_pages(void)
+{
+	/*
+	 * This is used very early during setup_arch() before any initcalls
+	 * or any drivers are registered.
+	 * This value is set by a command line option.
+	 * Later, when the driver is registered, it will pass the number
+	 * pages needed for it's page tables, if it was less that what
+	 * the system has already allocated, the registration will fail.
+	 */
+	return kvm_nvhe_sym(hyp_kvm_iommu_pages);
+}
+
+/* Number of pages to reserve for iommu pool*/
+static int __init early_hyp_iommu_pages(char *arg)
+{
+	if (!arg)
+		return -EINVAL;
+
+	return kstrtouint(arg, 0, &kvm_nvhe_sym(hyp_kvm_iommu_pages));
+}
+early_param("kvm-arm.hyp_iommu_pages", early_hyp_iommu_pages);
diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
index 053e4f733e4b..79dd14db4919 100644
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
2.54.0.545.g6539524ca2-goog

