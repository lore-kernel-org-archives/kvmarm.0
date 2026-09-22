Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com [209.85.128.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4484A54B1CA
	for <kvmarm@lists.linux.dev>; Tue, 22 Sep 2026 13:13:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790082797; cv=none; b=ol+u2btqJg4SZR4znHMfjHCQ5wdjuOlHj1LLYyCle1QOWjsinJtTAhcFR/qKxnzt0IVPru8QrQ4qA92hp/nFC+aZme9StC9VZJVeoN7VTbmVe5bAEg8EdJm2oK3AezAIk4PYM0db7aPFisbwmAUgA9mPTeqDKv3pIMtDKiPBo0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790082797; c=relaxed/simple;
	bh=vNTsJZetYDa7t+L0vDWHd6ocCjTKcqe8IWEqnXFaEHY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=bKKUMsxdmVWO1Uw3gNfcWTSwzaRRnSrMt1diHgLLWwzQ+azn+m/WiqMVk6KiGIQDqYQPTz3LYqrzPS8LttiI2gkd85PEsKyYI2R7ENwSJYAE6O0YKMnl6yystLkrunLIoxtSklwPx7kUUhd4K/N5vQ4idMM3VPIxvUUonY23tk0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=GYH1zU1x; arc=none smtp.client-ip=209.85.128.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="GYH1zU1x"
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-49e735659b7so33339005e9.3
        for <kvmarm@lists.linux.dev>; Tue, 22 Sep 2026 06:13:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790082792; x=1790687592; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Uct3Ludpq24IkXvn9l1jjsC5bWb0ebUeANTGai6zz7w=;
        b=GYH1zU1x+h51+43lUvLmpgXJ7W2MeWNgOLqhFwGM5ITcb6XHqLzCGFqygawtVNJkw0
         exBohkQ8ZSWSsF7LsUpy/14oUFCP23sHRrViXuqDuohzSBbACu1xqwa+uChhHuRXSAN8
         rZGDDpIkS4wfrfV/hDz2cvkIZhBdGLfchoPKdDwSzlzFeoRmOvN/796vQnVN2RwbPp71
         Aw2wr/tLyjs4uvLof4wYBPw3TFodqKmzXQlVf6d9f31ftBZvzWb3j23u02t4xpWZbCj7
         OGKCj66KdSZ+2h0P0svuI6pufdP071a8U6uiwoxqcofmh9mYnyBhmPKJ+CMuz39KU6yP
         Yojw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790082792; x=1790687592;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Uct3Ludpq24IkXvn9l1jjsC5bWb0ebUeANTGai6zz7w=;
        b=Y0AyZ1g8OX2DAbFxm/07w5IFs8YfqAsTObmN7w/mFk4mxNhyrzKI1dOveMQjaow9XC
         by8O4nHkHI3jq+x+iEvOnfH8Bw85LjIIyXmtNoSpkP1kzmTQt0kzLuymH9yqdLu6p9Bh
         mIRV+GHs39ss9J097cIQxHAYNzUYuicf89PgaN/GrmkvU02tKNb8aNos3+iqWe5782Pq
         Cqhy32Sos+aKj1UQQdNK1Klo05X/66ZPCtzl9dySuzzpx+E99cjqtsVvjYDcaKtcfV6o
         eCdis5ICY+zeMZPXRq6b0Fs8VLILYT48cZWTXrnMob3WtwKJgzSOmJiot6II/Q8PI0O5
         Q6XQ==
X-Forwarded-Encrypted: i=1; AKwUvBzoa+8W5w+2b8as//8ILnPavw07ywfe5vgg8y/LXWGTvhtjp2hMOttjmeN+HpM2kiFbqEssFE8=@lists.linux.dev
X-Gm-Message-State: AFuF++maT5fQObHy5Cs41BjgP0VLETIljwefr+j9uaX1BVnxbUQ1jwWi
	7R4M4LbZTVIDVxMe90koqefI9Ev1nxUVgYE0jP5GHuSe5IpbFVRN2Anx+TV+xWlUyrLWEilEYZ+
	dYoVYW32/wnOjPw==
X-Received: from wmix24-n1.prod.google.com ([2002:a05:600c:e558:10b0:49e:6019:d6a])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:a0a:b0:49e:84bf:6110 with SMTP id 5b1f17b1804b1-49fc56dbb49mr208095955e9.6.1790082791905;
 Tue, 22 Sep 2026 06:13:11 -0700 (PDT)
Date: Tue, 22 Sep 2026 13:12:41 +0000
In-Reply-To: <20260922131259.2975334-1-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260922131259.2975334-1-smostafa@google.com>
X-Mailer: git-send-email 2.55.0.1082.g2b9226bbc0-goog
Message-ID: <20260922131259.2975334-9-smostafa@google.com>
Subject: [PATCH v8 08/25] KVM: arm64: iommu: Add memory pool
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
is allocated early from the carveout and its memory is added to
a pool which the IOMMU driver can allocate from and reclaim to at
run time.

As this is too early for drivers to use initcalls, the number of
pages allocated is set from command line "kvm-arm.iommu_pgt_mem".

Later when the driver registers, it will pass how many pages it
needs, and if it was more than what was allocated, it will fail
to register.

Signed-off-by: Mostafa Saleh <smostafa@google.com>
---
 .../admin-guide/kernel-parameters.txt         |  5 +++
 arch/arm64/include/asm/kvm_host.h             |  3 +-
 arch/arm64/kvm/hyp/include/nvhe/iommu.h       |  8 +++-
 arch/arm64/kvm/hyp/nvhe/iommu.c               | 21 +++++++++-
 arch/arm64/kvm/hyp/nvhe/setup.c               | 11 ++++-
 arch/arm64/kvm/iommu.c                        | 41 ++++++++++++++++++-
 arch/arm64/kvm/pkvm.c                         |  1 +
 7 files changed, 85 insertions(+), 5 deletions(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 33cd30996e47..408a1f431782 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -3240,6 +3240,11 @@ Kernel parameters
 			max_snp_asid == min_sev_asid-1, will effectively make
 			SEV-ES unusable.
 
+	kvm-arm.iommu_pgt_mem=nn[KMG]
+			[KVM,ARM,EARLY]
+			Memory allocated for the IOMMU pool from the KVM carveout
+			when running in protected mode (See kvm-arm.mode=).
+
 	kvm-arm.mode=
 			[KVM,ARM,EARLY] Select one of KVM/arm64's modes of
 			operation.
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 7ba7d384889e..743d812e8ee0 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -1719,7 +1719,8 @@ long kvm_get_cap_for_kvm_ioctl(unsigned int ioctl, long *ext);
 
 #ifndef __KVM_NVHE_HYPERVISOR__
 struct pkvm_iommu_ops;
-int pkvm_iommu_register_driver(struct pkvm_iommu_ops *hyp_ops);
+int pkvm_iommu_register_driver(struct pkvm_iommu_ops *hyp_ops, unsigned int nr_pages);
+unsigned int pkvm_iommu_pages(void);
 #endif
 
 #endif /* __ARM64_KVM_HOST_H__ */
diff --git a/arch/arm64/kvm/hyp/include/nvhe/iommu.h b/arch/arm64/kvm/hyp/include/nvhe/iommu.h
index 2e35ec01c75d..1fa728ab47d4 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/iommu.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/iommu.h
@@ -9,8 +9,14 @@ struct pkvm_iommu_ops {
 	int (*host_stage2_idmap)(phys_addr_t start, phys_addr_t end, int prot);
 };
 
-int pkvm_iommu_init(void);
+int pkvm_iommu_init(void *pool_base, unsigned int nr_pages);
 
 int pkvm_iommu_host_stage2_idmap(phys_addr_t start, phys_addr_t end,
 				 enum kvm_pgtable_prot prot);
+
+/* Allocate pages from the IOMMU carveout, returns zeroed memory. */
+void *pkvm_iommu_alloc_pages(u8 order);
+/* Free pages from pkvm_iommu_alloc_pages(). */
+void pkvm_iommu_free_pages(void *ptr);
+
 #endif /* __ARM64_KVM_NVHE_IOMMU_H__ */
diff --git a/arch/arm64/kvm/hyp/nvhe/iommu.c b/arch/arm64/kvm/hyp/nvhe/iommu.c
index 3637b0327d9e..cacab0dc462a 100644
--- a/arch/arm64/kvm/hyp/nvhe/iommu.c
+++ b/arch/arm64/kvm/hyp/nvhe/iommu.c
@@ -16,6 +16,7 @@ struct pkvm_iommu_ops *pkvm_iommu_ops;
 
 /* Protected by host_mmu.lock */
 static bool pkvm_idmap_initialized;
+static struct hyp_pool iommu_pages_pool;
 
 static inline int pkvm_to_iommu_prot(enum kvm_pgtable_prot prot)
 {
@@ -113,7 +114,7 @@ static int pkvm_iommu_snapshot_host_stage2(void)
 	return ret;
 }
 
-int pkvm_iommu_init(void)
+int pkvm_iommu_init(void *pool_base, unsigned int nr_pages)
 {
 	int ret;
 
@@ -122,6 +123,14 @@ int pkvm_iommu_init(void)
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
@@ -139,3 +148,13 @@ int pkvm_iommu_host_stage2_idmap(phys_addr_t start, phys_addr_t end,
 
 	return pkvm_iommu_ops->host_stage2_idmap(start, end, pkvm_to_iommu_prot(prot));
 }
+
+void *pkvm_iommu_alloc_pages(u8 order)
+{
+	return hyp_alloc_pages(&iommu_pages_pool, order);
+}
+
+void pkvm_iommu_free_pages(void *ptr)
+{
+	hyp_put_page(&iommu_pages_pool, ptr);
+}
diff --git a/arch/arm64/kvm/hyp/nvhe/setup.c b/arch/arm64/kvm/hyp/nvhe/setup.c
index 9607d1b18a88..7ce1fc2232da 100644
--- a/arch/arm64/kvm/hyp/nvhe/setup.c
+++ b/arch/arm64/kvm/hyp/nvhe/setup.c
@@ -22,6 +22,8 @@
 
 unsigned long hyp_nr_cpus;
 
+unsigned int hyp_kvm_iommu_pages;
+
 #define hyp_percpu_size ((unsigned long)__per_cpu_end - \
 			 (unsigned long)__per_cpu_start)
 
@@ -33,6 +35,7 @@ static void *selftest_base;
 static void *ffa_proxy_pages;
 static struct kvm_pgtable_mm_ops pkvm_pgtable_mm_ops;
 static struct hyp_pool hpool;
+static void *iommu_base;
 
 static int divide_memory_pool(void *virt, unsigned long size)
 {
@@ -70,6 +73,12 @@ static int divide_memory_pool(void *virt, unsigned long size)
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
 
@@ -334,7 +343,7 @@ void __noreturn __pkvm_init_finalise(void)
 	 * resources that would be leaked if the hypervisor fails after as there
 	 * is no remove_iommu_driver() at the moment.
 	 */
-	ret = pkvm_iommu_init();
+	ret = pkvm_iommu_init(iommu_base, hyp_kvm_iommu_pages);
 	if (ret)
 		goto out;
 
diff --git a/arch/arm64/kvm/iommu.c b/arch/arm64/kvm/iommu.c
index 30a3862e93d7..f008f68eee40 100644
--- a/arch/arm64/kvm/iommu.c
+++ b/arch/arm64/kvm/iommu.c
@@ -7,10 +7,11 @@
 #include <linux/kvm_host.h>
 
 extern struct pkvm_iommu_ops *kvm_nvhe_sym(pkvm_iommu_ops);
+extern unsigned int kvm_nvhe_sym(hyp_kvm_iommu_pages);
 
 static DEFINE_MUTEX(pkvm_iommu_reg_lock);
 
-int pkvm_iommu_register_driver(struct pkvm_iommu_ops *hyp_ops)
+int pkvm_iommu_register_driver(struct pkvm_iommu_ops *hyp_ops, unsigned int nr_pages)
 {
 	guard(mutex)(&pkvm_iommu_reg_lock);
 
@@ -20,6 +21,44 @@ int pkvm_iommu_register_driver(struct pkvm_iommu_ops *hyp_ops)
 	if (kvm_nvhe_sym(pkvm_iommu_ops))
 		return -EBUSY;
 
+	/* See pkvm_iommu_pages() */
+	if (nr_pages > kvm_nvhe_sym(hyp_kvm_iommu_pages)) {
+		kvm_err("IOMMU pool needs 0x%x pages, check kvm-arm.iommu_pgt_mem\n", nr_pages);
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
+	kvm_nvhe_sym(hyp_kvm_iommu_pages) = DIV_ROUND_UP(requested_size, PAGE_SIZE);
+	return 0;
+}
+early_param("kvm-arm.iommu_pgt_mem", early_iommu_pgt_mem);
diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
index 8e4c6e4bec12..b6cf01e00f6b 100644
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
2.55.0.1082.g2b9226bbc0-goog

