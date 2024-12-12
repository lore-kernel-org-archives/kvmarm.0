Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD0F422FE13
	for <kvmarm@lists.linux.dev>; Thu, 12 Dec 2024 18:05:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734026724; cv=none; b=rgefAy2TCqPr3JkwmiagtMZ3J4Rw47qSyqEHA3Oy8D8cFwxk0Q9A7aM1W6m3Oi8uANa5KQwTpFWOD4f4dYbqTZ4inJlDH4vzrrKBaWDzX34AfMcRKAHyIipYdKfq3BmAbgUlXE/pV+MlEr6P6nFzuxNbD8NFB/IDQSn0HkNhWKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734026724; c=relaxed/simple;
	bh=8/JR72FsO9ooIjOLkT1P8qfkZvbDSIe4qDlXrNLBT5E=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=AwwdwzXBppWEoAu8fz6+U/wod9dlW4ew0qsNOXcXD6KrXMf83+w9OTHG7v12SthlkNrJGo8720xN6d6l4+bFWMWLBM4x0a0aWYiZTsb5DpbgIaZ+S4wBVaxq0hhP0z+RYaKQrOZLABoz64lFWGWbpU4NfaQ63ysUX2DdPpWGFRY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=AQOF4hAx; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="AQOF4hAx"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-4359eb032c9so7197995e9.2
        for <kvmarm@lists.linux.dev>; Thu, 12 Dec 2024 10:05:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1734026721; x=1734631521; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ZW1+nydU55G8nQ9hrqIcRZ7rSjcAUC8BJY9QSeiwFSI=;
        b=AQOF4hAxz0c3d5+fAC4fj1EsKk01iSrfVbqoSP64lhGpaE0DgR6tkNwBpxDG/1oFaA
         kAzRvvb83o/003UydRF6A3UYY4K/15y7o0wefl7mAH7FRiGY0pFXyf4lGnlEjD8iaiRr
         10jJPee+cxWbRBKb71SO72rvNDoxXhkR1vcv2WbPYjrN6U/aI6O5hMVUj70Fc4RYoCPd
         QTbfZpfecl9sjgcFWk35qq+oQ9GhML5u5Z1pcygfOxE7ywuVbGTWvBszQpTLt9Skf6WU
         HIK4a/CZ9JG5xfJFYqZuuUSlT+H9PRFxG9cg/SNx5ReHLvLMDGYwU75OXjVPSLJshLnf
         gJtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734026721; x=1734631521;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZW1+nydU55G8nQ9hrqIcRZ7rSjcAUC8BJY9QSeiwFSI=;
        b=iqJ82SCzSjn1cYlYv2fSe1sPkDZdaVHg2sfA/24IsQqC7sGE8BgmywRGtlZJJ7WGrM
         lgeUDra55S9vQmqUy2lGRdfW39A8mNdhfQuW14gNMxyDaXa4p0xcBr8/KQ+n316KNoC+
         T4P1jyA7Krj2fUNRcjTQKxwlUBLq8pmr1yRh7UMcHvAJxNvnANN5A+6JopZ9P875n6is
         LJFOKjNapBEgTSo6M8MSPg9zMtLYHLjAaxKS4V9fQ2Zfvk48uavFejYxPLH0AOHfvcFk
         HKIpbkR4CGJNrb1NVYCqZ5I3G0xnldF3hKw2NvlZWPdhWRKj0nYbx+FSmGz722X8ZjNA
         gpUA==
X-Forwarded-Encrypted: i=1; AJvYcCWAmva3ruQxnqRl7H0doLLMNmjkbyppr9h5KX553XodjE8RtuX4NDeZhPdyzwQHPLLi3qJo3gQ=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy2E2AwmiQ+jKARZOYt0aUkwLr6ZwNlUJg7TOzolty6xjcWGJKn
	Q0qoRXF6hcm/YVJEALIBW4zbh3FSmkLhBRNkdD3ZRDw02KqwGZDk/5y6gOg9XgMt4w+67I0FVdF
	1Un4jncJkaQ==
X-Google-Smtp-Source: AGHT+IF/eVrE/BNFHjZA31UXBb9BGDdvQQjzrDNU0uCStoSMr927atSRKA4GQ6BWli6UKC37YTy5oYGnkZ5VOA==
X-Received: from wmpl36.prod.google.com ([2002:a05:600c:8a4:b0:434:f0d4:cbaf])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:19ca:b0:434:a75b:5f59 with SMTP id 5b1f17b1804b1-43622823a73mr44642205e9.3.1734026721375;
 Thu, 12 Dec 2024 10:05:21 -0800 (PST)
Date: Thu, 12 Dec 2024 18:03:42 +0000
In-Reply-To: <20241212180423.1578358-1-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241212180423.1578358-1-smostafa@google.com>
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
Message-ID: <20241212180423.1578358-19-smostafa@google.com>
Subject: [RFC PATCH v2 18/58] KVM: arm64: iommu: Add map/unmap() operations
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

Handle map(), unmap() and iova_to_phys() hypercalls.

In addition to map/unmap, the hypervisor has to ensure that all
mapped pages are tracked, so be before each map()
__pkvm_host_use_dma() would be called to ensure that.

Similarly, on unmap() we need to decrement the refcount using
__pkvm_host_unuse_dma().

However, doing this in standard way as mentioned in the comments is
challenging, so we leave that to the driver.

Also, the hypervisor only guarantees that there are no races
between alloc/free domain operations using the domain refcount to
avoid using extra locks.

Signed-off-by: Mostafa Saleh <smostafa@google.com>
Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
---
 arch/arm64/kvm/hyp/include/nvhe/iommu.h |  7 +++
 arch/arm64/kvm/hyp/nvhe/iommu/iommu.c   | 80 ++++++++++++++++++++++++-
 2 files changed, 84 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/hyp/include/nvhe/iommu.h b/arch/arm64/kvm/hyp/include/nvhe/iommu.h
index d6d7447fbac8..17f24a8eb1b9 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/iommu.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/iommu.h
@@ -40,6 +40,13 @@ struct kvm_iommu_ops {
 			  u32 endpoint_id, u32 pasid, u32 pasid_bits);
 	int (*detach_dev)(struct kvm_hyp_iommu *iommu, struct kvm_hyp_iommu_domain *domain,
 			  u32 endpoint_id, u32 pasid);
+	int (*map_pages)(struct kvm_hyp_iommu_domain *domain, unsigned long iova,
+			 phys_addr_t paddr, size_t pgsize,
+			 size_t pgcount, int prot, size_t *total_mapped);
+	size_t (*unmap_pages)(struct kvm_hyp_iommu_domain *domain, unsigned long iova,
+			      size_t pgsize, size_t pgcount);
+	phys_addr_t (*iova_to_phys)(struct kvm_hyp_iommu_domain *domain, unsigned long iova);
+
 };
 
 int kvm_iommu_init(void);
diff --git a/arch/arm64/kvm/hyp/nvhe/iommu/iommu.c b/arch/arm64/kvm/hyp/nvhe/iommu/iommu.c
index df2dbe4c0121..83321cc5f466 100644
--- a/arch/arm64/kvm/hyp/nvhe/iommu/iommu.c
+++ b/arch/arm64/kvm/hyp/nvhe/iommu/iommu.c
@@ -263,22 +263,96 @@ int kvm_iommu_detach_dev(pkvm_handle_t iommu_id, pkvm_handle_t domain_id,
 	return ret;
 }
 
+#define IOMMU_PROT_MASK (IOMMU_READ | IOMMU_WRITE | IOMMU_CACHE |\
+			 IOMMU_NOEXEC | IOMMU_MMIO | IOMMU_PRIV)
+
 size_t kvm_iommu_map_pages(pkvm_handle_t domain_id,
 			   unsigned long iova, phys_addr_t paddr, size_t pgsize,
 			   size_t pgcount, int prot)
 {
-	return 0;
+	size_t size;
+	int ret;
+	size_t total_mapped = 0;
+	struct kvm_hyp_iommu_domain *domain;
+
+	if (prot & ~IOMMU_PROT_MASK)
+		return 0;
+
+	if (__builtin_mul_overflow(pgsize, pgcount, &size) ||
+	    iova + size < iova || paddr + size < paddr)
+		return 0;
+
+	domain = handle_to_domain(domain_id);
+	if (!domain || domain_get(domain))
+		return 0;
+
+	ret = __pkvm_host_use_dma(paddr, size);
+	if (ret)
+		return 0;
+
+	kvm_iommu_ops->map_pages(domain, iova, paddr, pgsize, pgcount, prot, &total_mapped);
+
+	pgcount -= total_mapped / pgsize;
+	/*
+	 * unuse the bits that haven't been mapped yet. The host calls back
+	 * either to continue mapping, or to unmap and unuse what's been done
+	 * so far.
+	 */
+	if (pgcount)
+		__pkvm_host_unuse_dma(paddr + total_mapped, pgcount * pgsize);
+
+	domain_put(domain);
+	return total_mapped;
 }
 
 size_t kvm_iommu_unmap_pages(pkvm_handle_t domain_id, unsigned long iova,
 			     size_t pgsize, size_t pgcount)
 {
-	return 0;
+	size_t size;
+	size_t unmapped;
+	struct kvm_hyp_iommu_domain *domain;
+
+	if (!pgsize || !pgcount)
+		return 0;
+
+	if (__builtin_mul_overflow(pgsize, pgcount, &size) ||
+	    iova + size < iova)
+		return 0;
+
+	domain = handle_to_domain(domain_id);
+	if (!domain || domain_get(domain))
+		return 0;
+
+	/*
+	 * Unlike map, the common code doesn't call the __pkvm_host_unuse_dma,
+	 * because this means that we need either walk the table using iova_to_phys
+	 * similar to VFIO then unmap and call this function, or unmap leaf (page or
+	 * block) at a time, where both might be suboptimal.
+	 * For some IOMMU, we can do 2 walks where one only invalidate the pages
+	 * and the other decrement the refcount.
+	 * As, semantics for this might differ between IOMMUs and it's hard to
+	 * standardized, we leave that to the driver.
+	 */
+	unmapped = kvm_iommu_ops->unmap_pages(domain, iova, pgsize,
+						pgcount);
+
+	domain_put(domain);
+	return unmapped;
 }
 
 phys_addr_t kvm_iommu_iova_to_phys(pkvm_handle_t domain_id, unsigned long iova)
 {
-	return 0;
+	phys_addr_t phys = 0;
+	struct kvm_hyp_iommu_domain *domain;
+
+	domain = handle_to_domain( domain_id);
+
+	if (!domain || domain_get(domain))
+		return 0;
+
+	phys = kvm_iommu_ops->iova_to_phys(domain, iova);
+	domain_put(domain);
+	return phys;
 }
 
 /* Must be called from the IOMMU driver per IOMMU */
-- 
2.47.0.338.g60cca15819-goog

