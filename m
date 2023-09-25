Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BCB11BDE7
	for <kvmarm@lists.linux.dev>; Mon, 25 Sep 2023 17:21:33 +0000 (UTC)
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-32167a4adaaso6704359f8f.1
        for <kvmarm@lists.linux.dev>; Mon, 25 Sep 2023 10:21:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1695662492; x=1696267292; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=CKueK8Rm02o3KZhTn4T7sMZXIEn2MW9NVRpQDGNfYBc=;
        b=qC6OgkSo5yeqcyo4w7c68DCDM8Je3wtVIFesjYFcWFtzQ0CxNWEcR5/wVVwdbmZsam
         Gj2tBvvUQtX+UQME2x/Ut8PzF6CcvmCo+2m0ewMfxYHWnjr9vHi5NiBNA8pBevfO0IEt
         KcR6fKsIshld+Kf7vooUuw6QZxI+2A0/52RikCciZHlO/a5PAlqFPJ/hq14C7B6jDHGC
         5mE1iPGE4wXsrppmhEI8wp/Ewbtbw1yzxSkKlVeAEpBhcGHjWQdNFyi8l75CGZA0SFEl
         upUtC3b3Q05uK4Vee7esghWzyw1zRYfkg/aLpDvbfygjCbEJT0XS3LqUDfVLkSrtZksa
         UGsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695662492; x=1696267292;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CKueK8Rm02o3KZhTn4T7sMZXIEn2MW9NVRpQDGNfYBc=;
        b=LptwDZv7dseK+hXX0benPpqOsL7GTYuB+lAEeFk/0lAFXD0TPwB591uDaQAkVw9qrj
         6F+yikESL7dv7cvUpcG+pAWhtPzsGaNjlpsLK+EVNH+JPaMKjLvupdpWkGINopiD/M+M
         ch1OojLZlLK/aUd8ZoEO0eZpvP3cgswGD03yLXyHt0/srHS+xk0yefNRUbdTpfatK4Kt
         K5JyIo9x7ZkjZoPXwpB8bi1AGNTGSms7rLgJ9J7g1vHNyfIZkmKLcfeZw/W2lWZDb7ma
         LWV2AnsX3BRbv+NtjcnqxMK2zsNs+fVVL7yzDKWK/eWqJBB6VyN6HRKTXPZnrIwGnax6
         HHiQ==
X-Gm-Message-State: AOJu0Yy8ohnRTRUY291xW3HTpKoiRSsE/hXN1b2aPEhAiD5/r6tvBp9L
	7SeJAnpZ4WBI9aTGs/CPyV5F8n/lUwLA/Xo7/ss=
X-Google-Smtp-Source: AGHT+IF71fNqjZ/SbVW3qOa+NaQOb5omx832ExULUgjBi4a1LcPq+SWJ2MIOsdDJ33uR8yb5vsfEfQ==
X-Received: by 2002:adf:f004:0:b0:31a:e376:6bd6 with SMTP id j4-20020adff004000000b0031ae3766bd6mr6023321wro.45.1695662492393;
        Mon, 25 Sep 2023 10:21:32 -0700 (PDT)
Received: from myrica ([2a02:c7c:7290:b00:fd32:2b31:6755:400c])
        by smtp.gmail.com with ESMTPSA id n3-20020adff083000000b003143867d2ebsm12420171wro.63.2023.09.25.10.21.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Sep 2023 10:21:32 -0700 (PDT)
Date: Mon, 25 Sep 2023 18:21:38 +0100
From: Jean-Philippe Brucker <jean-philippe@linaro.org>
To: Mostafa Saleh <smostafa@google.com>
Cc: maz@kernel.org, catalin.marinas@arm.com, will@kernel.org,
	joro@8bytes.org, robin.murphy@arm.com, james.morse@arm.com,
	suzuki.poulose@arm.com, oliver.upton@linux.dev,
	yuzenghui@huawei.com, dbrazdil@google.com, ryan.roberts@arm.com,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	iommu@lists.linux.dev
Subject: Re: [RFC PATCH 20/45] KVM: arm64: iommu: Add map() and unmap()
 operations
Message-ID: <20230925172138.GB2068481@myrica>
References: <20230201125328.2186498-1-jean-philippe@linaro.org>
 <20230201125328.2186498-21-jean-philippe@linaro.org>
 <ZCXRbF0dP7oHT+hl@google.com>
 <20230404160046.GA305012@myrica>
 <ZQscldu3ZjHSutdz@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZQscldu3ZjHSutdz@google.com>

On Wed, Sep 20, 2023 at 04:23:49PM +0000, Mostafa Saleh wrote:
> I have been doing some testing based on the latest updates in
> https://jpbrucker.net/git/linux/log/?h=pkvm/smmu
> 
> I think the unmap here is not enough as it assumes the whole range
> can be unmapped in one call, so we would need something like this
> instead (patch might no directly apply though):

Thanks for testing, the unmap is indeed wrong because io-pgtable doesn't
like clearing empty ptes. Another problem with very large mappings is that
we'll return to host several times to allocate more page tables, removing
and recreating everything from scratch every time. So I changed the
map_pages() call to keep track of what's been mapped so far, see below.

I pushed these fixes to the pkvm/smmu branch

Thanks,
Jean

---
diff --git a/arch/arm64/kvm/hyp/include/nvhe/iommu.h b/arch/arm64/kvm/hyp/include/nvhe/iommu.h
index f522ec0002f10..254df53e04783 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/iommu.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/iommu.h
@@ -37,9 +37,9 @@ int kvm_iommu_attach_dev(pkvm_handle_t iommu_id, pkvm_handle_t domain_id,
 			 u32 endpoint_id);
 int kvm_iommu_detach_dev(pkvm_handle_t iommu_id, pkvm_handle_t domain_id,
 			 u32 endpoint_id);
-int kvm_iommu_map_pages(pkvm_handle_t iommu_id, pkvm_handle_t domain_id,
-			unsigned long iova, phys_addr_t paddr, size_t pgsize,
-			size_t pgcount, int prot);
+size_t kvm_iommu_map_pages(pkvm_handle_t iommu_id, pkvm_handle_t domain_id,
+			   unsigned long iova, phys_addr_t paddr, size_t pgsize,
+			   size_t pgcount, int prot);
 size_t kvm_iommu_unmap_pages(pkvm_handle_t iommu_id, pkvm_handle_t domain_id,
 			     unsigned long iova, size_t pgsize, size_t pgcount);
 phys_addr_t kvm_iommu_iova_to_phys(pkvm_handle_t iommu_id,
@@ -72,12 +72,12 @@ static inline int kvm_iommu_detach_dev(pkvm_handle_t iommu_id,
 	return -ENODEV;
 }

-static inline int kvm_iommu_map_pages(pkvm_handle_t iommu_id,
-				      pkvm_handle_t domain_id,
-				      unsigned long iova, phys_addr_t paddr,
-				      size_t pgsize, size_t pgcount, int prot)
+static inline size_t kvm_iommu_map_pages(pkvm_handle_t iommu_id,
+					 pkvm_handle_t domain_id,
+					 unsigned long iova, phys_addr_t paddr,
+					 size_t pgsize, size_t pgcount, int prot)
 {
-	return -ENODEV;
+	return 0;
 }

 static inline size_t kvm_iommu_unmap_pages(pkvm_handle_t iommu_id,
diff --git a/arch/arm64/kvm/hyp/nvhe/iommu/iommu.c b/arch/arm64/kvm/hyp/nvhe/iommu/iommu.c
index ad8c7b073de46..a69247c861d51 100644
--- a/arch/arm64/kvm/hyp/nvhe/iommu/iommu.c
+++ b/arch/arm64/kvm/hyp/nvhe/iommu/iommu.c
@@ -190,31 +190,29 @@ int kvm_iommu_detach_dev(pkvm_handle_t iommu_id, pkvm_handle_t domain_id,
 #define IOMMU_PROT_MASK (IOMMU_READ | IOMMU_WRITE | IOMMU_CACHE |\
 			 IOMMU_NOEXEC | IOMMU_MMIO)

-int kvm_iommu_map_pages(pkvm_handle_t iommu_id, pkvm_handle_t domain_id,
-			unsigned long iova, phys_addr_t paddr, size_t pgsize,
-			size_t pgcount, int prot)
+size_t kvm_iommu_map_pages(pkvm_handle_t iommu_id, pkvm_handle_t domain_id,
+			   unsigned long iova, phys_addr_t paddr, size_t pgsize,
+			   size_t pgcount, int prot)
 {
 	size_t size;
 	size_t mapped;
 	size_t granule;
 	int ret = -EINVAL;
 	struct io_pgtable iopt;
+	size_t total_mapped = 0;
 	struct kvm_hyp_iommu *iommu;
-	size_t pgcount_orig = pgcount;
-	phys_addr_t paddr_orig = paddr;
-	unsigned long iova_orig = iova;
 	struct kvm_hyp_iommu_domain *domain;

 	if (prot & ~IOMMU_PROT_MASK)
-		return -EINVAL;
+		return 0;

 	if (__builtin_mul_overflow(pgsize, pgcount, &size) ||
 	    iova + size < iova || paddr + size < paddr)
-		return -EOVERFLOW;
+		return 0;

 	iommu = kvm_iommu_ops.get_iommu_by_id(iommu_id);
 	if (!iommu)
-		return -EINVAL;
+		return 0;

 	hyp_spin_lock(&iommu->lock);
 	domain = handle_to_domain(iommu, domain_id);
@@ -230,29 +228,29 @@ int kvm_iommu_map_pages(pkvm_handle_t iommu_id, pkvm_handle_t domain_id,
 		goto err_unlock;

 	iopt = domain_to_iopt(iommu, domain, domain_id);
-	while (pgcount) {
+	while (pgcount && !ret) {
 		mapped = 0;
 		ret = iopt_map_pages(&iopt, iova, paddr, pgsize, pgcount, prot,
 				     0, &mapped);
 		WARN_ON(!IS_ALIGNED(mapped, pgsize));
+		WARN_ON(mapped > pgcount * pgsize);
+
 		pgcount -= mapped / pgsize;
-		if (ret)
-			goto err_unmap;
+		total_mapped += mapped;
 		iova += mapped;
 		paddr += mapped;
 	}

-	hyp_spin_unlock(&iommu->lock);
-	return 0;
-
-err_unmap:
-	pgcount = pgcount_orig - pgcount;
+	/*
+	 * Unshare the bits that haven't been mapped yet. The host calls back
+	 * either to continue mapping, or to unmap and unshare what's been done
+	 * so far.
+	 */
 	if (pgcount)
-		iopt_unmap_pages(&iopt, iova_orig, pgsize, pgcount, NULL);
-	__pkvm_host_unshare_dma(paddr_orig, size);
+		__pkvm_host_unshare_dma(paddr, pgcount * pgsize);
 err_unlock:
 	hyp_spin_unlock(&iommu->lock);
-	return ret;
+	return total_mapped;
 }

 size_t kvm_iommu_unmap_pages(pkvm_handle_t iommu_id, pkvm_handle_t domain_id,
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-kvm.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-kvm.c
index e67cd7485dfd4..0ffe3e32cf419 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-kvm.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-kvm.c
@@ -369,23 +369,32 @@ static int kvm_arm_smmu_attach_dev(struct iommu_domain *domain,
 static int kvm_arm_smmu_map_pages(struct iommu_domain *domain,
 				  unsigned long iova, phys_addr_t paddr,
 				  size_t pgsize, size_t pgcount, int prot,
-				  gfp_t gfp, size_t *mapped)
+				  gfp_t gfp, size_t *total_mapped)
 {
-	int ret;
+	size_t mapped;
 	unsigned long irqflags;
+	size_t size = pgsize * pgcount;
 	struct kvm_arm_smmu_domain *kvm_smmu_domain = to_kvm_smmu_domain(domain);
 	struct arm_smmu_device *smmu = kvm_smmu_domain->smmu;
 	struct host_arm_smmu_device *host_smmu = smmu_to_host(smmu);

 	local_lock_irqsave(&memcache_lock, irqflags);
-	ret = kvm_call_hyp_nvhe_mc(smmu, __pkvm_host_iommu_map_pages,
-				   host_smmu->id, kvm_smmu_domain->id, iova,
-				   paddr, pgsize, pgcount, prot);
+	do {
+		mapped = kvm_call_hyp_nvhe(__pkvm_host_iommu_map_pages,
+					   host_smmu->id, kvm_smmu_domain->id,
+					   iova, paddr, pgsize, pgcount, prot);
+		iova += mapped;
+		paddr += mapped;
+		WARN_ON(mapped % pgsize);
+		WARN_ON(mapped > pgcount * pgsize);
+		pgcount -= mapped / pgsize;
+		*total_mapped += mapped;
+	} while (*total_mapped < size && !kvm_arm_smmu_topup_memcache(smmu));
+	kvm_arm_smmu_reclaim_memcache();
 	local_unlock_irqrestore(&memcache_lock, irqflags);
-	if (ret)
-		return ret;
+	if (*total_mapped < size)
+		return -EINVAL;

-	*mapped = pgsize * pgcount;
 	return 0;
 }

----

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-kvm.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-kvm.c
index 0ffe3e32cf419..0055ecd75990e 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-kvm.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-kvm.c
@@ -405,6 +405,8 @@ static size_t kvm_arm_smmu_unmap_pages(struct iommu_domain *domain,
 {
 	size_t unmapped;
 	unsigned long irqflags;
+	size_t total_unmapped = 0;
+	size_t size = pgsize * pgcount;
 	struct kvm_arm_smmu_domain *kvm_smmu_domain = to_kvm_smmu_domain(domain);
 	struct arm_smmu_device *smmu = kvm_smmu_domain->smmu;
 	struct host_arm_smmu_device *host_smmu = smmu_to_host(smmu);
@@ -414,11 +416,23 @@ static size_t kvm_arm_smmu_unmap_pages(struct iommu_domain *domain,
 		unmapped = kvm_call_hyp_nvhe(__pkvm_host_iommu_unmap_pages,
 					     host_smmu->id, kvm_smmu_domain->id,
 					     iova, pgsize, pgcount);
-	} while (!unmapped && !kvm_arm_smmu_topup_memcache(smmu));
+		total_unmapped += unmapped;
+		iova += unmapped;
+		WARN_ON(unmapped % pgsize);
+		pgcount -= unmapped / pgsize;
+
+		/*
+		 * The page table driver can unmap less than we asked for. If it
+		 * didn't unmap anything at all, then it either reached the end
+		 * of the range, or it needs a page in the memcache to break a
+		 * block mapping.
+		 */
+	} while (total_unmapped < size &&
+		 (unmapped || !kvm_arm_smmu_topup_memcache(smmu)));
 	kvm_arm_smmu_reclaim_memcache();
 	local_unlock_irqrestore(&memcache_lock, irqflags);
 
-	return unmapped;
+	return total_unmapped;
 }
 
 static phys_addr_t kvm_arm_smmu_iova_to_phys(struct iommu_domain *domain,

