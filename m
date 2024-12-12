Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D901242EED
	for <kvmarm@lists.linux.dev>; Thu, 12 Dec 2024 18:06:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734026803; cv=none; b=RVXqJ6XjOugzPY2ONCTjLjV/iPX6nrG64b1yBErdJa7ZnWO3KnwoEFWsRxD1z7i1pCRugLMHsfDmb16MCXsVk/Hl1QRmIwu6oZuBxCDi6A9fLf2b6kGMzbCXjIGOh+b4zw8LwnBeJVX8ZnJY6Gp8fv2SQ4eCAfflhevC66sWPm4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734026803; c=relaxed/simple;
	bh=hiVH2C6llEMbjz526V+xYppiQALZW/CAzVLix4VAOkk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=I0iCYUFgnd5GB5PpPuqGpw5OA1vAGyl26c9Q+A368rqt1Yr5br76PHbFvkOViMXvI0ZNRmRZzuK3FFlX3l81xdDKn6NmD/F7BKT53E6yZIbuYocvJbj7lVgUY51BEm7++IP+0ufRpI6pvxOd2RUqf1onYlTIgr2BzkSZOPu6P24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=dvr/IkTC; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="dvr/IkTC"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-4362153dcd6so5635135e9.2
        for <kvmarm@lists.linux.dev>; Thu, 12 Dec 2024 10:06:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1734026800; x=1734631600; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=8LOnKB51DX+hbW0El8jQ5+VtfI8i+DJEmanKBr5IaOc=;
        b=dvr/IkTCy0yl6FEz47n+vM16oO+XxRwh46quuUoFvLNCENy3qcxeRDxEf9mWrSAJQp
         0b9T3VNEyt7pn1JMd5C/hsW9/bjuz6eNNFTtwBcCQ3Jb+bdZYIT0RIkz1mf2IEGpw/26
         bY9+aQskfsf0DVDYNGDLYFfaUDbSKNcMsrs2+UD4ab0Tja2p1Yvz7+CgDmU/UbFrYijy
         RGHZL0Vcw4jkuQGAGwOGMrz8bMSZaD3IahtitVJL54H/Fbkmss+bFE7NBfitZ475MmI6
         g+coqm0Vw9MQsAesr6jJqQR+e9HlYIqbmRRldOj0irxky/2at78Hyw9AxDcaDOgsYuKb
         1EWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734026800; x=1734631600;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8LOnKB51DX+hbW0El8jQ5+VtfI8i+DJEmanKBr5IaOc=;
        b=S8zsHSYiLGH58SfGhwr41gNKDlw9fK8+8Pxq8/VI9RgPZi/oZybhquyoO6izy726OP
         gr4TlC4Vwyu0mYCdgPBSswm4sl+ikV9ff+ImUwKhxFEhSOAm1lSkFbDU6+p9NmuM6cuM
         3WGKz7lSoSpiNaPw97mNveyCoAd92uIR1Q7Gc8ByQ9pF5U0rq3B2ExZhUF8XtfMHO1of
         iq67dUeyZpOu1E8hUhLV38eNf/oyCUfmRQn9gGyb5CS1ay8WDcLMMUtpLJHb5646ykAc
         DIGMf/gG+qzxQ+cOcou8QBhdjxwHVjkgCUrAuMk+z+v5+MSSu7n+Q/dU+3DYRt7kNk8o
         01HQ==
X-Forwarded-Encrypted: i=1; AJvYcCVA7xhAZ+TZzDLGrFlkU8+nwH8IGAwK3V1JMaRVoDz8VaAGO7qM/v5zf4JdQHv0PuU+5UgD14A=@lists.linux.dev
X-Gm-Message-State: AOJu0YyFAhROlS/n+Kv+muUU7HrTtNq+G/Qcae6knJAN9eIChi3uZdBq
	g19Sd/3/4L8uluux4yJtx+d3JoljUsoOBu6EHWuB0D9hO9iVL8KGlQbZZ4OvsKgSroWi+5yctjk
	GFqJ6TmvoDg==
X-Google-Smtp-Source: AGHT+IE8zSOvadgYlQu/oyCrvtp7QB6KNjjif3fcyBgRNu+AsyTgZxEHuVmvUAgeCaCC/YUaZxC98HiuTjTEZA==
X-Received: from wmgg15.prod.google.com ([2002:a05:600d:f:b0:434:feb1:add1])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:3109:b0:434:fafe:edb with SMTP id 5b1f17b1804b1-4361c3e22e7mr61901735e9.24.1734026800793;
 Thu, 12 Dec 2024 10:06:40 -0800 (PST)
Date: Thu, 12 Dec 2024 18:04:20 +0000
In-Reply-To: <20241212180423.1578358-1-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241212180423.1578358-1-smostafa@google.com>
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
Message-ID: <20241212180423.1578358-57-smostafa@google.com>
Subject: [RFC PATCH v2 56/58] KVM: arm64: iommu: Add hypercall for map_sg
From: Mostafa Saleh <smostafa@google.com>
To: iommu@lists.linux.dev, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: catalin.marinas@arm.com, will@kernel.org, maz@kernel.org, 
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, robdclark@gmail.com, joro@8bytes.org, 
	robin.murphy@arm.com, jean-philippe@linaro.org, jgg@ziepe.ca, 
	nicolinc@nvidia.com, vdonnefort@google.com, qperret@google.com, 
	tabba@google.com, danielmentz@google.com, tzukui@google.com, 
	Mostafa Saleh <smostafa@google.com>
Content-Type: text/plain; charset="UTF-8"

Add a new type struct kvm_iommu_sg, that describes a simple sglist,
and a hypercall that can consume it while calling the map_pages ops.

Signed-off-by: Mostafa Saleh <smostafa@google.com>
---
 arch/arm64/include/asm/kvm_asm.h        |  1 +
 arch/arm64/include/asm/kvm_host.h       | 19 ++++++++
 arch/arm64/kvm/hyp/include/nvhe/iommu.h |  2 +
 arch/arm64/kvm/hyp/nvhe/hyp-main.c      | 14 ++++++
 arch/arm64/kvm/hyp/nvhe/iommu/iommu.c   | 58 +++++++++++++++++++++++++
 arch/arm64/kvm/iommu.c                  | 32 ++++++++++++++
 6 files changed, 126 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index 3dbf30cd10f3..f2b86d1a62ed 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -115,6 +115,7 @@ enum __kvm_host_smccc_func {
 	__KVM_HOST_SMCCC_FUNC___pkvm_host_iommu_unmap_pages,
 	__KVM_HOST_SMCCC_FUNC___pkvm_host_iommu_iova_to_phys,
 	__KVM_HOST_SMCCC_FUNC___pkvm_host_hvc_pd,
+	__KVM_HOST_SMCCC_FUNC___pkvm_host_iommu_map_sg,
 
 	/*
 	 * Start of the dynamically registered hypercalls. Start a bit
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 3cdc99ebdd0d..704648619d28 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -1655,4 +1655,23 @@ int kvm_iommu_register_driver(struct kvm_iommu_driver *kern_ops,
 int kvm_iommu_init_driver(void);
 void kvm_iommu_remove_driver(void);
 
+struct kvm_iommu_sg {
+	phys_addr_t phys;
+	size_t pgsize;
+	unsigned int pgcount;
+};
+
+static inline struct kvm_iommu_sg *kvm_iommu_sg_alloc(unsigned int nents, gfp_t gfp)
+{
+	return alloc_pages_exact(PAGE_ALIGN(nents * sizeof(struct kvm_iommu_sg)), gfp);
+}
+
+static inline void kvm_iommu_sg_free(struct kvm_iommu_sg *sg, unsigned int nents)
+{
+	free_pages_exact(sg, PAGE_ALIGN(nents * sizeof(struct kvm_iommu_sg)));
+}
+
+int kvm_iommu_share_hyp_sg(struct kvm_iommu_sg *sg, unsigned int nents);
+int kvm_iommu_unshare_hyp_sg(struct kvm_iommu_sg *sg, unsigned int nents);
+
 #endif /* __ARM64_KVM_HOST_H__ */
diff --git a/arch/arm64/kvm/hyp/include/nvhe/iommu.h b/arch/arm64/kvm/hyp/include/nvhe/iommu.h
index cff75d67d807..1004465b680a 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/iommu.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/iommu.h
@@ -22,6 +22,8 @@ size_t kvm_iommu_unmap_pages(pkvm_handle_t domain_id, unsigned long iova,
 			     size_t pgsize, size_t pgcount);
 phys_addr_t kvm_iommu_iova_to_phys(pkvm_handle_t domain_id, unsigned long iova);
 bool kvm_iommu_host_dabt_handler(struct kvm_cpu_context *host_ctxt, u64 esr, u64 addr);
+size_t kvm_iommu_map_sg(pkvm_handle_t domain, unsigned long iova, struct kvm_iommu_sg *sg,
+			unsigned int nent, unsigned int prot);
 
 /* Flags for memory allocation for IOMMU drivers */
 #define IOMMU_PAGE_NOCACHE				BIT(0)
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index 1ab8e5507825..5659aae0c758 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -1682,6 +1682,19 @@ static void handle___pkvm_host_hvc_pd(struct kvm_cpu_context *host_ctxt)
 	cpu_reg(host_ctxt, 1) = pkvm_host_hvc_pd(device_id, on);
 }
 
+static void handle___pkvm_host_iommu_map_sg(struct kvm_cpu_context *host_ctxt)
+{
+	unsigned long ret;
+	DECLARE_REG(pkvm_handle_t, domain, host_ctxt, 1);
+	DECLARE_REG(unsigned long, iova, host_ctxt, 2);
+	DECLARE_REG(struct kvm_iommu_sg *, sg, host_ctxt, 3);
+	DECLARE_REG(unsigned int, nent, host_ctxt, 4);
+	DECLARE_REG(unsigned int, prot, host_ctxt, 5);
+
+	ret = kvm_iommu_map_sg(domain, iova, kern_hyp_va(sg), nent, prot);
+	hyp_reqs_smccc_encode(ret, host_ctxt, this_cpu_ptr(&host_hyp_reqs));
+}
+
 typedef void (*hcall_t)(struct kvm_cpu_context *);
 
 #define HANDLE_FUNC(x)	[__KVM_HOST_SMCCC_FUNC_##x] = (hcall_t)handle_##x
@@ -1747,6 +1760,7 @@ static const hcall_t host_hcall[] = {
 	HANDLE_FUNC(__pkvm_host_iommu_unmap_pages),
 	HANDLE_FUNC(__pkvm_host_iommu_iova_to_phys),
 	HANDLE_FUNC(__pkvm_host_hvc_pd),
+	HANDLE_FUNC(__pkvm_host_iommu_map_sg),
 };
 
 static void handle_host_hcall(struct kvm_cpu_context *host_ctxt)
diff --git a/arch/arm64/kvm/hyp/nvhe/iommu/iommu.c b/arch/arm64/kvm/hyp/nvhe/iommu/iommu.c
index e45dadd0c4aa..b0c9b9086fd1 100644
--- a/arch/arm64/kvm/hyp/nvhe/iommu/iommu.c
+++ b/arch/arm64/kvm/hyp/nvhe/iommu/iommu.c
@@ -392,6 +392,64 @@ bool kvm_iommu_host_dabt_handler(struct kvm_cpu_context *host_ctxt, u64 esr, u64
 	return ret;
 }
 
+size_t kvm_iommu_map_sg(pkvm_handle_t domain_id, unsigned long iova, struct kvm_iommu_sg *sg,
+			unsigned int nent, unsigned int prot)
+{
+	int ret;
+	size_t total_mapped = 0, mapped;
+	struct kvm_hyp_iommu_domain *domain;
+	phys_addr_t phys;
+	size_t size, pgsize, pgcount;
+	unsigned int orig_nent = nent;
+	struct kvm_iommu_sg *orig_sg = sg;
+
+	if (!kvm_iommu_ops || !kvm_iommu_ops->map_pages)
+		return 0;
+
+	if (prot & ~IOMMU_PROT_MASK)
+		return 0;
+
+	domain = handle_to_domain(domain_id);
+	if (!domain || domain_get(domain))
+		return 0;
+
+	ret = hyp_pin_shared_mem(sg, sg + nent);
+	if (ret)
+		goto out_put_domain;
+
+	while (nent--) {
+		phys = sg->phys;
+		pgsize = sg->pgsize;
+		pgcount = sg->pgcount;
+
+		if (__builtin_mul_overflow(pgsize, pgcount, &size) ||
+		    iova + size < iova)
+			goto out_unpin_sg;
+
+		ret = __pkvm_host_use_dma(phys, size);
+		if (ret)
+			goto out_unpin_sg;
+
+		mapped = 0;
+		kvm_iommu_ops->map_pages(domain, iova, phys, pgsize, pgcount, prot, &mapped);
+		total_mapped += mapped;
+		phys += mapped;
+		iova += mapped;
+		/* Might need memory */
+		if (mapped != size) {
+			__pkvm_host_unuse_dma(phys, size - mapped);
+			break;
+		}
+		sg++;
+	}
+
+out_unpin_sg:
+	hyp_unpin_shared_mem(orig_sg, orig_sg + orig_nent);
+out_put_domain:
+	domain_put(domain);
+	return total_mapped;
+}
+
 static int iommu_power_on(struct kvm_power_domain *pd)
 {
 	struct kvm_hyp_iommu *iommu = container_of(pd, struct kvm_hyp_iommu,
diff --git a/arch/arm64/kvm/iommu.c b/arch/arm64/kvm/iommu.c
index af3417e6259d..99718af0cba6 100644
--- a/arch/arm64/kvm/iommu.c
+++ b/arch/arm64/kvm/iommu.c
@@ -55,3 +55,35 @@ void kvm_iommu_remove_driver(void)
 	if (smp_load_acquire(&iommu_driver))
 		iommu_driver->remove_driver();
 }
+
+int kvm_iommu_share_hyp_sg(struct kvm_iommu_sg *sg, unsigned int nents)
+{
+	size_t nr_pages = PAGE_ALIGN(sizeof(*sg) * nents) >> PAGE_SHIFT;
+	phys_addr_t sg_pfn = virt_to_phys(sg) >> PAGE_SHIFT;
+	int i;
+	int ret;
+
+	for (i = 0 ; i < nr_pages ; ++i) {
+		ret = kvm_call_hyp_nvhe(__pkvm_host_share_hyp, sg_pfn + i);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+
+int kvm_iommu_unshare_hyp_sg(struct kvm_iommu_sg *sg, unsigned int nents)
+{
+	size_t nr_pages = PAGE_ALIGN(sizeof(*sg) * nents) >> PAGE_SHIFT;
+	phys_addr_t sg_pfn = virt_to_phys(sg) >> PAGE_SHIFT;
+	int i;
+	int ret;
+
+	for (i = 0 ; i < nr_pages ; ++i) {
+		ret = kvm_call_hyp_nvhe(__pkvm_host_unshare_hyp, sg_pfn + i);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
-- 
2.47.0.338.g60cca15819-goog

