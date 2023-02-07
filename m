Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3E9E28EA
	for <kvmarm@lists.linux.dev>; Tue,  7 Feb 2023 12:16:42 +0000 (UTC)
Received: by mail-wm1-f48.google.com with SMTP id bg13-20020a05600c3c8d00b003d9712b29d2so13031928wmb.2
        for <kvmarm@lists.linux.dev>; Tue, 07 Feb 2023 04:16:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=/0VDPVjwN4C1UpNiA+Kw1dsa0k81hMpDp7dA75y9Gb8=;
        b=C/rD/N7S49+3JM/Xyp6lHXTAZHVyKpifzAWLb7pliJvHUaC1pillhmUNBgJ9R4MxtW
         2YdOKWKq4UPHG1aFBb+qOPePRfF7G9603mOUtqR7qo7Lbes774A6JhiMCj7t2LIWVBKb
         ByzDlPRse39p+1l/I4mpioI7pqvshNjKrwYdS/NLXrSDbvXI9IZ9bvR+lEnEUI01B10X
         eauwAh6JzcBylQ51n0cp45X5VB+VJyvtOWc+IqfSl2Fnsnu7WYUBpIMxpr+uvHrvZ3GU
         eVXR3gn89hNSWDNzxHq8SIYXqkOmSKox/bwPEor9mjGeh9v1uxVxXzvxqyT1VcKy/iZ6
         kWDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/0VDPVjwN4C1UpNiA+Kw1dsa0k81hMpDp7dA75y9Gb8=;
        b=dznV+92S0aR8LMGHeKaVOkciDw3oCPlTOn60lWLAXrLrBct/1fnYcLrSlMakq0mcuU
         psQ1kzGiWBwMhG2SLBCg4VFuKt/yGjFHF/SkpiVDsjt+Bu6Cwap+3WWmkmQpNxREnVmr
         7ivA84rCHhqEyLeconGaKeuiH9ej3/uwNhO4L//q1WfnzfSW2NFtVOEDM5y0sjxCBUU4
         oNZuzRqvezbeMEsMHrd1CGRcjv0vNBfDqCoaroxj0qKvO006Z6ZFBjSwZwntZ00QuLd+
         XT2kM1e47wjGsBB70sBK88dZFV0KUlMPdaLYdsYwOji32LPAIndWOoIfeyxTeOturgGz
         nYUA==
X-Gm-Message-State: AO0yUKV0ESIb9FtNxe3PH+er08io+PEwSWmYr82+K5/d8B6VOEslYQ8N
	NHZ7pqUpwATMUItncQFq+SMdLw==
X-Google-Smtp-Source: AK7set9/Dj2APvDP3+3vwyl0VWDraNTVS1hwpkLxEBBY5/XwV9y9BCFuRJ172s4nhFfQFvHOf8un7A==
X-Received: by 2002:a05:600c:468e:b0:3dc:434b:39b4 with SMTP id p14-20020a05600c468e00b003dc434b39b4mr159766wmo.2.1675772200523;
        Tue, 07 Feb 2023 04:16:40 -0800 (PST)
Received: from google.com (44.232.78.34.bc.googleusercontent.com. [34.78.232.44])
        by smtp.gmail.com with ESMTPSA id d3-20020adfef83000000b002c3daf229b1sm9648284wro.55.2023.02.07.04.16.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Feb 2023 04:16:40 -0800 (PST)
Date: Tue, 7 Feb 2023 12:16:12 +0000
From: Mostafa Saleh <smostafa@google.com>
To: Jean-Philippe Brucker <jean-philippe@linaro.org>
Cc: maz@kernel.org, catalin.marinas@arm.com, will@kernel.org,
	joro@8bytes.org, robin.murphy@arm.com, james.morse@arm.com,
	suzuki.poulose@arm.com, oliver.upton@linux.dev,
	yuzenghui@huawei.com, dbrazdil@google.com, ryan.roberts@arm.com,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	iommu@lists.linux.dev, Abhinav Kumar <quic_abhinavk@quicinc.com>,
	Alyssa Rosenzweig <alyssa.rosenzweig@collabora.com>,
	Andy Gross <agross@kernel.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Daniel Vetter <daniel@ffwll.ch>, David Airlie <airlied@gmail.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Hector Martin <marcan@marcan.st>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	Rob Clark <robdclark@gmail.com>, Rob Herring <robh@kernel.org>,
	Sean Paul <sean@poorly.run>, Steven Price <steven.price@arm.com>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Sven Peter <sven@svenpeter.dev>,
	Tomeu Vizoso <tomeu.vizoso@collabora.com>,
	Yong Wu <yong.wu@mediatek.com>
Subject: Re: [RFC PATCH 05/45] iommu/io-pgtable: Split io_pgtable structure
Message-ID: <Y+JBDIF+IaEPiwR8@google.com>
References: <20230201125328.2186498-1-jean-philippe@linaro.org>
 <20230201125328.2186498-6-jean-philippe@linaro.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230201125328.2186498-6-jean-philippe@linaro.org>

Hi Jean,

On Wed, Feb 01, 2023 at 12:52:49PM +0000, Jean-Philippe Brucker wrote:
> The io_pgtable structure contains all information needed for io-pgtable
> ops map() and unmap(), including a static configuration, driver-facing
> ops, TLB callbacks and the PGD pointer. Most of these are common to all
> sets of page tables for a given configuration, and really only need one
> instance.
> 
> Split the structure in two:
> 
> * io_pgtable_params contains information that is common to all sets of
>   page tables for a given io_pgtable_cfg.
> * io_pgtable contains information that is different for each set of page
>   tables, namely the PGD and the IOMMU driver cookie passed to TLB
>   callbacks.
> 
> Keep essentially the same interface for IOMMU drivers, but move it
> behind a set of helpers.
> 
> The goal is to optimize for space, in order to allocate less memory in
> the KVM SMMU driver. While storing 64k io-pgtables with identical
> configuration would previously require 10MB, it is now 512kB because the
> driver only needs to store the pgd for each domain.
> 
> Note that the io_pgtable_cfg still contains the TTBRs, which are
> specific to a set of page tables. Most of them can be removed, since
> IOMMU drivers can trivially obtain them with virt_to_phys(iop->pgd).
> Some architectures do have static configuration bits in the TTBR that
> need to be kept.
> 
> Unfortunately the split does add an additional dereference which
> degrades performance slightly. Running a single-threaded dma-map
> benchmark on a server with SMMUv3, I measured a regression of 7-9ns for
> map() and 32-78ns for unmap(), which is a slowdown of about 4% and 8%
> respectively.
> 
> Cc: Abhinav Kumar <quic_abhinavk@quicinc.com>
> Cc: Alyssa Rosenzweig <alyssa.rosenzweig@collabora.com>
> Cc: Andy Gross <agross@kernel.org>
> Cc: Bjorn Andersson <andersson@kernel.org>
> Cc: Daniel Vetter <daniel@ffwll.ch>
> Cc: David Airlie <airlied@gmail.com>
> Cc: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
> Cc: Hector Martin <marcan@marcan.st>
> Cc: Konrad Dybcio <konrad.dybcio@linaro.org>
> Cc: Matthias Brugger <matthias.bgg@gmail.com>
> Cc: Rob Clark <robdclark@gmail.com>
> Cc: Rob Herring <robh@kernel.org>
> Cc: Sean Paul <sean@poorly.run>
> Cc: Steven Price <steven.price@arm.com>
> Cc: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
> Cc: Sven Peter <sven@svenpeter.dev>
> Cc: Tomeu Vizoso <tomeu.vizoso@collabora.com>
> Cc: Yong Wu <yong.wu@mediatek.com>
> Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
> ---
>  drivers/gpu/drm/panfrost/panfrost_device.h  |   2 +-
>  drivers/iommu/amd/amd_iommu_types.h         |  17 +-
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h |   3 +-
>  drivers/iommu/arm/arm-smmu/arm-smmu.h       |   2 +-
>  include/linux/io-pgtable-arm.h              |  12 +-
>  include/linux/io-pgtable.h                  |  94 +++++++---
>  drivers/gpu/drm/msm/msm_iommu.c             |  21 ++-
>  drivers/gpu/drm/panfrost/panfrost_mmu.c     |  20 +--
>  drivers/iommu/amd/io_pgtable.c              |  26 +--
>  drivers/iommu/amd/io_pgtable_v2.c           |  43 ++---
>  drivers/iommu/amd/iommu.c                   |  28 ++-
>  drivers/iommu/apple-dart.c                  |  36 ++--
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c |  34 ++--
>  drivers/iommu/arm/arm-smmu/arm-smmu-qcom.c  |   7 +-
>  drivers/iommu/arm/arm-smmu/arm-smmu.c       |  40 ++---
>  drivers/iommu/arm/arm-smmu/qcom_iommu.c     |  40 ++---
>  drivers/iommu/io-pgtable-arm-common.c       |  80 +++++----
>  drivers/iommu/io-pgtable-arm-v7s.c          | 189 ++++++++++----------
>  drivers/iommu/io-pgtable-arm.c              | 158 ++++++++--------
>  drivers/iommu/io-pgtable-dart.c             |  97 +++++-----
>  drivers/iommu/io-pgtable.c                  |  36 ++--
>  drivers/iommu/ipmmu-vmsa.c                  |  18 +-
>  drivers/iommu/msm_iommu.c                   |  17 +-
>  drivers/iommu/mtk_iommu.c                   |  13 +-
>  24 files changed, 519 insertions(+), 514 deletions(-)
> 
> diff --git a/drivers/gpu/drm/panfrost/panfrost_device.h b/drivers/gpu/drm/panfrost/panfrost_device.h
> index 8b25278f34c8..8a610c4b8f03 100644
> --- a/drivers/gpu/drm/panfrost/panfrost_device.h
> +++ b/drivers/gpu/drm/panfrost/panfrost_device.h
> @@ -126,7 +126,7 @@ struct panfrost_mmu {
>  	struct panfrost_device *pfdev;
>  	struct kref refcount;
>  	struct io_pgtable_cfg pgtbl_cfg;
> -	struct io_pgtable_ops *pgtbl_ops;
> +	struct io_pgtable pgtbl;
>  	struct drm_mm mm;
>  	spinlock_t mm_lock;
>  	int as;
> diff --git a/drivers/iommu/amd/amd_iommu_types.h b/drivers/iommu/amd/amd_iommu_types.h
> index 3d684190b4d5..5920a556f7ec 100644
> --- a/drivers/iommu/amd/amd_iommu_types.h
> +++ b/drivers/iommu/amd/amd_iommu_types.h
> @@ -516,10 +516,10 @@ struct amd_irte_ops;
>  #define AMD_IOMMU_FLAG_TRANS_PRE_ENABLED      (1 << 0)
>  
>  #define io_pgtable_to_data(x) \
> -	container_of((x), struct amd_io_pgtable, iop)
> +	container_of((x), struct amd_io_pgtable, iop_params)
>  
>  #define io_pgtable_ops_to_data(x) \
> -	io_pgtable_to_data(io_pgtable_ops_to_pgtable(x))
> +	io_pgtable_to_data(io_pgtable_ops_to_params(x))
>  
>  #define io_pgtable_ops_to_domain(x) \
>  	container_of(io_pgtable_ops_to_data(x), \
> @@ -529,12 +529,13 @@ struct amd_irte_ops;
>  	container_of((x), struct amd_io_pgtable, pgtbl_cfg)
>  
>  struct amd_io_pgtable {
> -	struct io_pgtable_cfg	pgtbl_cfg;
> -	struct io_pgtable	iop;
> -	int			mode;
> -	u64			*root;
> -	atomic64_t		pt_root;	/* pgtable root and pgtable mode */
> -	u64			*pgd;		/* v2 pgtable pgd pointer */
> +	struct io_pgtable_cfg		pgtbl_cfg;
> +	struct io_pgtable		iop;
> +	struct io_pgtable_params	iop_params;
> +	int				mode;
> +	u64				*root;
> +	atomic64_t			pt_root;	/* pgtable root and pgtable mode */
> +	u64				*pgd;		/* v2 pgtable pgd pointer */
>  };
>  
>  /*
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
> index 8d772ea8a583..cec3c8103404 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
> @@ -10,6 +10,7 @@
>  
>  #include <linux/bitfield.h>
>  #include <linux/iommu.h>
> +#include <linux/io-pgtable.h>
>  #include <linux/kernel.h>
>  #include <linux/mmzone.h>
>  #include <linux/sizes.h>
> @@ -710,7 +711,7 @@ struct arm_smmu_domain {
>  	struct arm_smmu_device		*smmu;
>  	struct mutex			init_mutex; /* Protects smmu pointer */
>  
> -	struct io_pgtable_ops		*pgtbl_ops;
> +	struct io_pgtable		pgtbl;
>  	bool				stall_enabled;
>  	atomic_t			nr_ats_masters;
>  
> diff --git a/drivers/iommu/arm/arm-smmu/arm-smmu.h b/drivers/iommu/arm/arm-smmu/arm-smmu.h
> index 703fd5817ec1..249825fc71ac 100644
> --- a/drivers/iommu/arm/arm-smmu/arm-smmu.h
> +++ b/drivers/iommu/arm/arm-smmu/arm-smmu.h
> @@ -366,7 +366,7 @@ enum arm_smmu_domain_stage {
>  
>  struct arm_smmu_domain {
>  	struct arm_smmu_device		*smmu;
> -	struct io_pgtable_ops		*pgtbl_ops;
> +	struct io_pgtable		pgtbl;
>  	unsigned long			pgtbl_quirks;
>  	const struct iommu_flush_ops	*flush_ops;
>  	struct arm_smmu_cfg		cfg;
> diff --git a/include/linux/io-pgtable-arm.h b/include/linux/io-pgtable-arm.h
> index 42202bc0ffa2..5199bd9851b6 100644
> --- a/include/linux/io-pgtable-arm.h
> +++ b/include/linux/io-pgtable-arm.h
> @@ -9,13 +9,11 @@ extern bool selftest_running;
>  typedef u64 arm_lpae_iopte;
>  
>  struct arm_lpae_io_pgtable {
> -	struct io_pgtable	iop;
> +	struct io_pgtable_params	iop;
>  
> -	int			pgd_bits;
> -	int			start_level;
> -	int			bits_per_level;
> -
> -	void			*pgd;
> +	int				pgd_bits;
> +	int				start_level;
> +	int				bits_per_level;
>  };
>  
>  /* Struct accessors */
> @@ -23,7 +21,7 @@ struct arm_lpae_io_pgtable {
>  	container_of((x), struct arm_lpae_io_pgtable, iop)
>  
>  #define io_pgtable_ops_to_data(x)					\
> -	io_pgtable_to_data(io_pgtable_ops_to_pgtable(x))
> +	io_pgtable_to_data(io_pgtable_ops_to_params(x))
>  
>  /*
>   * Calculate the right shift amount to get to the portion describing level l
> diff --git a/include/linux/io-pgtable.h b/include/linux/io-pgtable.h
> index ee6484d7a5e0..cce5ddbf71c7 100644
> --- a/include/linux/io-pgtable.h
> +++ b/include/linux/io-pgtable.h
> @@ -149,6 +149,20 @@ struct io_pgtable_cfg {
>  	};
>  };
>  
> +/**
> + * struct io_pgtable - Structure describing a set of page tables.
> + *
> + * @ops:	The page table operations in use for this set of page tables.
> + * @cookie:	An opaque token provided by the IOMMU driver and passed back to
> + *		any callback routines.
> + * @pgd:	Virtual address of the page directory.
> + */
> +struct io_pgtable {
> +	struct io_pgtable_ops	*ops;
> +	void			*cookie;
> +	void			*pgd;
> +};
> +
>  /**
>   * struct io_pgtable_ops - Page table manipulation API for IOMMU drivers.
>   *
> @@ -160,36 +174,64 @@ struct io_pgtable_cfg {
>   * the same names.
>   */
>  struct io_pgtable_ops {
> -	int (*map_pages)(struct io_pgtable_ops *ops, unsigned long iova,
> +	int (*map_pages)(struct io_pgtable *iop, unsigned long iova,
>  			 phys_addr_t paddr, size_t pgsize, size_t pgcount,
>  			 int prot, gfp_t gfp, size_t *mapped);
> -	size_t (*unmap_pages)(struct io_pgtable_ops *ops, unsigned long iova,
> +	size_t (*unmap_pages)(struct io_pgtable *iop, unsigned long iova,
>  			      size_t pgsize, size_t pgcount,
>  			      struct iommu_iotlb_gather *gather);
> -	phys_addr_t (*iova_to_phys)(struct io_pgtable_ops *ops,
> -				    unsigned long iova);
> +	phys_addr_t (*iova_to_phys)(struct io_pgtable *iop, unsigned long iova);
>  };
>  
> +static inline int
> +iopt_map_pages(struct io_pgtable *iop, unsigned long iova, phys_addr_t paddr,
> +	       size_t pgsize, size_t pgcount, int prot, gfp_t gfp,
> +	       size_t *mapped)
> +{
> +	if (!iop->ops || !iop->ops->map_pages)
> +		return -EINVAL;
> +	return iop->ops->map_pages(iop, iova, paddr, pgsize, pgcount, prot, gfp,
> +				   mapped);
> +}
> +
> +static inline size_t
> +iopt_unmap_pages(struct io_pgtable *iop, unsigned long iova, size_t pgsize,
> +		 size_t pgcount, struct iommu_iotlb_gather *gather)
> +{
> +	if (!iop->ops || !iop->ops->map_pages)
Should this be !iop->ops->unmap_pages?


> +		return 0;
> +	return iop->ops->unmap_pages(iop, iova, pgsize, pgcount, gather);
> +}
> +
> +static inline phys_addr_t
> +iopt_iova_to_phys(struct io_pgtable *iop, unsigned long iova)
> +{
> +	if (!iop->ops || !iop->ops->iova_to_phys)
> +		return 0;
> +	return iop->ops->iova_to_phys(iop, iova);
> +}
> +
>  /**
>   * alloc_io_pgtable_ops() - Allocate a page table allocator for use by an IOMMU.
>   *
> + * @iop:    The page table object, filled with the allocated ops on success
>   * @cfg:    The page table configuration. This will be modified to represent
>   *          the configuration actually provided by the allocator (e.g. the
>   *          pgsize_bitmap may be restricted).
>   * @cookie: An opaque token provided by the IOMMU driver and passed back to
>   *          the callback routines in cfg->tlb.
>   */
> -struct io_pgtable_ops *alloc_io_pgtable_ops(struct io_pgtable_cfg *cfg,
> -					    void *cookie);
> +int alloc_io_pgtable_ops(struct io_pgtable *iop, struct io_pgtable_cfg *cfg,
> +			 void *cookie);
>  
>  /**
> - * free_io_pgtable_ops() - Free an io_pgtable_ops structure. The caller
> + * free_io_pgtable_ops() - Free the page table. The caller
>   *                         *must* ensure that the page table is no longer
>   *                         live, but the TLB can be dirty.
>   *
> - * @ops: The ops returned from alloc_io_pgtable_ops.
> + * @iop: The iop object passed to alloc_io_pgtable_ops
>   */
> -void free_io_pgtable_ops(struct io_pgtable_ops *ops);
> +void free_io_pgtable_ops(struct io_pgtable *iop);
>  
>  /**
>   * io_pgtable_configure - Create page table config
> @@ -209,42 +251,41 @@ int io_pgtable_configure(struct io_pgtable_cfg *cfg, size_t *pgd_size);
>   */
>  
>  /**
> - * struct io_pgtable - Internal structure describing a set of page tables.
> + * struct io_pgtable_params - Internal structure describing parameters for a
> + *			      given page table configuration
>   *
> - * @cookie: An opaque token provided by the IOMMU driver and passed back to
> - *          any callback routines.
>   * @cfg:    A copy of the page table configuration.
>   * @ops:    The page table operations in use for this set of page tables.
>   */
> -struct io_pgtable {
> -	void			*cookie;
> +struct io_pgtable_params {
>  	struct io_pgtable_cfg	cfg;
>  	struct io_pgtable_ops	ops;
>  };
>  
> -#define io_pgtable_ops_to_pgtable(x) container_of((x), struct io_pgtable, ops)
> +#define io_pgtable_ops_to_params(x) container_of((x), struct io_pgtable_params, ops)
>  
> -static inline void io_pgtable_tlb_flush_all(struct io_pgtable *iop)
> +static inline void io_pgtable_tlb_flush_all(struct io_pgtable_cfg *cfg,
> +					    struct io_pgtable *iop)
>  {
> -	if (iop->cfg.tlb && iop->cfg.tlb->tlb_flush_all)
> -		iop->cfg.tlb->tlb_flush_all(iop->cookie);
> +	if (cfg->tlb && cfg->tlb->tlb_flush_all)
> +		cfg->tlb->tlb_flush_all(iop->cookie);
>  }
>  
>  static inline void
> -io_pgtable_tlb_flush_walk(struct io_pgtable *iop, unsigned long iova,
> -			  size_t size, size_t granule)
> +io_pgtable_tlb_flush_walk(struct io_pgtable_cfg *cfg, struct io_pgtable *iop,
> +			  unsigned long iova, size_t size, size_t granule)
>  {
> -	if (iop->cfg.tlb && iop->cfg.tlb->tlb_flush_walk)
> -		iop->cfg.tlb->tlb_flush_walk(iova, size, granule, iop->cookie);
> +	if (cfg->tlb && cfg->tlb->tlb_flush_walk)
> +		cfg->tlb->tlb_flush_walk(iova, size, granule, iop->cookie);
>  }
>  
>  static inline void
> -io_pgtable_tlb_add_page(struct io_pgtable *iop,
> +io_pgtable_tlb_add_page(struct io_pgtable_cfg *cfg, struct io_pgtable *iop,
>  			struct iommu_iotlb_gather * gather, unsigned long iova,
>  			size_t granule)
>  {
> -	if (iop->cfg.tlb && iop->cfg.tlb->tlb_add_page)
> -		iop->cfg.tlb->tlb_add_page(gather, iova, granule, iop->cookie);
> +	if (cfg->tlb && cfg->tlb->tlb_add_page)
> +		cfg->tlb->tlb_add_page(gather, iova, granule, iop->cookie);
>  }
>  
>  /**
> @@ -256,7 +297,8 @@ io_pgtable_tlb_add_page(struct io_pgtable *iop,
>   * @configure: Create the configuration without allocating anything. Optional.
>   */
>  struct io_pgtable_init_fns {
> -	struct io_pgtable *(*alloc)(struct io_pgtable_cfg *cfg, void *cookie);
> +	int (*alloc)(struct io_pgtable *iop, struct io_pgtable_cfg *cfg,
> +		     void *cookie);
>  	void (*free)(struct io_pgtable *iop);
>  	int (*configure)(struct io_pgtable_cfg *cfg, size_t *pgd_size);
>  };
> diff --git a/drivers/gpu/drm/msm/msm_iommu.c b/drivers/gpu/drm/msm/msm_iommu.c
> index e9c6f281e3dd..e372ca6cd79c 100644
> --- a/drivers/gpu/drm/msm/msm_iommu.c
> +++ b/drivers/gpu/drm/msm/msm_iommu.c
> @@ -20,7 +20,7 @@ struct msm_iommu {
>  struct msm_iommu_pagetable {
>  	struct msm_mmu base;
>  	struct msm_mmu *parent;
> -	struct io_pgtable_ops *pgtbl_ops;
> +	struct io_pgtable pgtbl;
>  	unsigned long pgsize_bitmap;	/* Bitmap of page sizes in use */
>  	phys_addr_t ttbr;
>  	u32 asid;
> @@ -90,14 +90,14 @@ static int msm_iommu_pagetable_unmap(struct msm_mmu *mmu, u64 iova,
>  		size_t size)
>  {
>  	struct msm_iommu_pagetable *pagetable = to_pagetable(mmu);
> -	struct io_pgtable_ops *ops = pagetable->pgtbl_ops;
>  
>  	while (size) {
>  		size_t unmapped, pgsize, count;
>  
>  		pgsize = calc_pgsize(pagetable, iova, iova, size, &count);
>  
> -		unmapped = ops->unmap_pages(ops, iova, pgsize, count, NULL);
> +		unmapped = iopt_unmap_pages(&pagetable->pgtbl, iova, pgsize,
> +					    count, NULL);
>  		if (!unmapped)
>  			break;
>  
> @@ -114,7 +114,7 @@ static int msm_iommu_pagetable_map(struct msm_mmu *mmu, u64 iova,
>  		struct sg_table *sgt, size_t len, int prot)
>  {
>  	struct msm_iommu_pagetable *pagetable = to_pagetable(mmu);
> -	struct io_pgtable_ops *ops = pagetable->pgtbl_ops;
> +	struct io_pgtable *iop = &pagetable->pgtbl;
>  	struct scatterlist *sg;
>  	u64 addr = iova;
>  	unsigned int i;
> @@ -129,7 +129,7 @@ static int msm_iommu_pagetable_map(struct msm_mmu *mmu, u64 iova,
>  
>  			pgsize = calc_pgsize(pagetable, addr, phys, size, &count);
>  
> -			ret = ops->map_pages(ops, addr, phys, pgsize, count,
> +			ret = iopt_map_pages(iop, addr, phys, pgsize, count,
>  					     prot, GFP_KERNEL, &mapped);
>  
>  			/* map_pages could fail after mapping some of the pages,
> @@ -163,7 +163,7 @@ static void msm_iommu_pagetable_destroy(struct msm_mmu *mmu)
>  	if (atomic_dec_return(&iommu->pagetables) == 0)
>  		adreno_smmu->set_ttbr0_cfg(adreno_smmu->cookie, NULL);
>  
> -	free_io_pgtable_ops(pagetable->pgtbl_ops);
> +	free_io_pgtable_ops(&pagetable->pgtbl);
>  	kfree(pagetable);
>  }
>  
> @@ -258,11 +258,10 @@ struct msm_mmu *msm_iommu_pagetable_create(struct msm_mmu *parent)
>  	ttbr0_cfg.quirks &= ~IO_PGTABLE_QUIRK_ARM_TTBR1;
>  	ttbr0_cfg.tlb = &null_tlb_ops;
>  
> -	pagetable->pgtbl_ops = alloc_io_pgtable_ops(&ttbr0_cfg, iommu->domain);
> -
> -	if (!pagetable->pgtbl_ops) {
> +	ret = alloc_io_pgtable_ops(&pagetable->pgtbl, &ttbr0_cfg, iommu->domain);
> +	if (ret) {
>  		kfree(pagetable);
> -		return ERR_PTR(-ENOMEM);
> +		return ERR_PTR(ret);
>  	}
>  
>  	/*
> @@ -275,7 +274,7 @@ struct msm_mmu *msm_iommu_pagetable_create(struct msm_mmu *parent)
>  
>  		ret = adreno_smmu->set_ttbr0_cfg(adreno_smmu->cookie, &ttbr0_cfg);
>  		if (ret) {
> -			free_io_pgtable_ops(pagetable->pgtbl_ops);
> +			free_io_pgtable_ops(&pagetable->pgtbl);
>  			kfree(pagetable);
>  			return ERR_PTR(ret);
>  		}
> diff --git a/drivers/gpu/drm/panfrost/panfrost_mmu.c b/drivers/gpu/drm/panfrost/panfrost_mmu.c
> index 31bdb5d46244..118b49ab120f 100644
> --- a/drivers/gpu/drm/panfrost/panfrost_mmu.c
> +++ b/drivers/gpu/drm/panfrost/panfrost_mmu.c
> @@ -290,7 +290,6 @@ static int mmu_map_sg(struct panfrost_device *pfdev, struct panfrost_mmu *mmu,
>  {
>  	unsigned int count;
>  	struct scatterlist *sgl;
> -	struct io_pgtable_ops *ops = mmu->pgtbl_ops;
>  	u64 start_iova = iova;
>  
>  	for_each_sgtable_dma_sg(sgt, sgl, count) {
> @@ -303,8 +302,8 @@ static int mmu_map_sg(struct panfrost_device *pfdev, struct panfrost_mmu *mmu,
>  			size_t pgcount, mapped = 0;
>  			size_t pgsize = get_pgsize(iova | paddr, len, &pgcount);
>  
> -			ops->map_pages(ops, iova, paddr, pgsize, pgcount, prot,
> -				       GFP_KERNEL, &mapped);
> +			iopt_map_pages(&mmu->pgtbl, iova, paddr, pgsize,
> +				       pgcount, prot, GFP_KERNEL, &mapped);
>  			/* Don't get stuck if things have gone wrong */
>  			mapped = max(mapped, pgsize);
>  			iova += mapped;
> @@ -349,7 +348,7 @@ void panfrost_mmu_unmap(struct panfrost_gem_mapping *mapping)
>  	struct panfrost_gem_object *bo = mapping->obj;
>  	struct drm_gem_object *obj = &bo->base.base;
>  	struct panfrost_device *pfdev = to_panfrost_device(obj->dev);
> -	struct io_pgtable_ops *ops = mapping->mmu->pgtbl_ops;
> +	struct io_pgtable *iop = &mapping->mmu->pgtbl;
>  	u64 iova = mapping->mmnode.start << PAGE_SHIFT;
>  	size_t len = mapping->mmnode.size << PAGE_SHIFT;
>  	size_t unmapped_len = 0;
> @@ -366,8 +365,8 @@ void panfrost_mmu_unmap(struct panfrost_gem_mapping *mapping)
>  
>  		if (bo->is_heap)
>  			pgcount = 1;
> -		if (!bo->is_heap || ops->iova_to_phys(ops, iova)) {
> -			unmapped_page = ops->unmap_pages(ops, iova, pgsize, pgcount, NULL);
> +		if (!bo->is_heap || iopt_iova_to_phys(iop, iova)) {
> +			unmapped_page = iopt_unmap_pages(iop, iova, pgsize, pgcount, NULL);
>  			WARN_ON(unmapped_page != pgsize * pgcount);
>  		}
>  		iova += pgsize * pgcount;
> @@ -560,7 +559,7 @@ static void panfrost_mmu_release_ctx(struct kref *kref)
>  	}
>  	spin_unlock(&pfdev->as_lock);
>  
> -	free_io_pgtable_ops(mmu->pgtbl_ops);
> +	free_io_pgtable_ops(&mmu->pgtbl);
>  	drm_mm_takedown(&mmu->mm);
>  	kfree(mmu);
>  }
> @@ -605,6 +604,7 @@ static void panfrost_drm_mm_color_adjust(const struct drm_mm_node *node,
>  
>  struct panfrost_mmu *panfrost_mmu_ctx_create(struct panfrost_device *pfdev)
>  {
> +	int ret;
>  	struct panfrost_mmu *mmu;
>  
>  	mmu = kzalloc(sizeof(*mmu), GFP_KERNEL);
> @@ -631,10 +631,10 @@ struct panfrost_mmu *panfrost_mmu_ctx_create(struct panfrost_device *pfdev)
>  		.iommu_dev	= pfdev->dev,
>  	};
>  
> -	mmu->pgtbl_ops = alloc_io_pgtable_ops(&mmu->pgtbl_cfg, mmu);
> -	if (!mmu->pgtbl_ops) {
> +	ret = alloc_io_pgtable_ops(&mmu->pgtbl, &mmu->pgtbl_cfg, mmu);
> +	if (ret) {
>  		kfree(mmu);
> -		return ERR_PTR(-EINVAL);
> +		return ERR_PTR(ret);
>  	}
>  
>  	kref_init(&mmu->refcount);
> diff --git a/drivers/iommu/amd/io_pgtable.c b/drivers/iommu/amd/io_pgtable.c
> index ace0e9b8b913..f9ea551404ba 100644
> --- a/drivers/iommu/amd/io_pgtable.c
> +++ b/drivers/iommu/amd/io_pgtable.c
> @@ -360,11 +360,11 @@ static void free_clear_pte(u64 *pte, u64 pteval, struct list_head *freelist)
>   * supporting all features of AMD IOMMU page tables like level skipping
>   * and full 64 bit address spaces.
>   */
> -static int iommu_v1_map_pages(struct io_pgtable_ops *ops, unsigned long iova,
> +static int iommu_v1_map_pages(struct io_pgtable *iop, unsigned long iova,
>  			      phys_addr_t paddr, size_t pgsize, size_t pgcount,
>  			      int prot, gfp_t gfp, size_t *mapped)
>  {
> -	struct protection_domain *dom = io_pgtable_ops_to_domain(ops);
> +	struct protection_domain *dom = io_pgtable_ops_to_domain(iop->ops);
>  	LIST_HEAD(freelist);
>  	bool updated = false;
>  	u64 __pte, *pte;
> @@ -435,12 +435,12 @@ static int iommu_v1_map_pages(struct io_pgtable_ops *ops, unsigned long iova,
>  	return ret;
>  }
>  
> -static unsigned long iommu_v1_unmap_pages(struct io_pgtable_ops *ops,
> +static unsigned long iommu_v1_unmap_pages(struct io_pgtable *iop,
>  					  unsigned long iova,
>  					  size_t pgsize, size_t pgcount,
>  					  struct iommu_iotlb_gather *gather)
>  {
> -	struct amd_io_pgtable *pgtable = io_pgtable_ops_to_data(ops);
> +	struct amd_io_pgtable *pgtable = io_pgtable_ops_to_data(iop->ops);
>  	unsigned long long unmapped;
>  	unsigned long unmap_size;
>  	u64 *pte;
> @@ -469,9 +469,9 @@ static unsigned long iommu_v1_unmap_pages(struct io_pgtable_ops *ops,
>  	return unmapped;
>  }
>  
> -static phys_addr_t iommu_v1_iova_to_phys(struct io_pgtable_ops *ops, unsigned long iova)
> +static phys_addr_t iommu_v1_iova_to_phys(struct io_pgtable *iop, unsigned long iova)
>  {
> -	struct amd_io_pgtable *pgtable = io_pgtable_ops_to_data(ops);
> +	struct amd_io_pgtable *pgtable = io_pgtable_ops_to_data(iop->ops);
>  	unsigned long offset_mask, pte_pgsize;
>  	u64 *pte, __pte;
>  
> @@ -491,7 +491,7 @@ static phys_addr_t iommu_v1_iova_to_phys(struct io_pgtable_ops *ops, unsigned lo
>   */
>  static void v1_free_pgtable(struct io_pgtable *iop)
>  {
> -	struct amd_io_pgtable *pgtable = container_of(iop, struct amd_io_pgtable, iop);
> +	struct amd_io_pgtable *pgtable = io_pgtable_ops_to_data(iop->ops);
>  	struct protection_domain *dom;
>  	LIST_HEAD(freelist);
>  
> @@ -515,7 +515,8 @@ static void v1_free_pgtable(struct io_pgtable *iop)
>  	put_pages_list(&freelist);
>  }
>  
> -static struct io_pgtable *v1_alloc_pgtable(struct io_pgtable_cfg *cfg, void *cookie)
> +int v1_alloc_pgtable(struct io_pgtable *iop, struct io_pgtable_cfg *cfg,
> +		     void *cookie)
>  {
>  	struct amd_io_pgtable *pgtable = io_pgtable_cfg_to_data(cfg);
>  
> @@ -524,11 +525,12 @@ static struct io_pgtable *v1_alloc_pgtable(struct io_pgtable_cfg *cfg, void *coo
>  	cfg->oas            = IOMMU_OUT_ADDR_BIT_SIZE,
>  	cfg->tlb            = &v1_flush_ops;
>  
> -	pgtable->iop.ops.map_pages    = iommu_v1_map_pages;
> -	pgtable->iop.ops.unmap_pages  = iommu_v1_unmap_pages;
> -	pgtable->iop.ops.iova_to_phys = iommu_v1_iova_to_phys;
> +	pgtable->iop_params.ops.map_pages    = iommu_v1_map_pages;
> +	pgtable->iop_params.ops.unmap_pages  = iommu_v1_unmap_pages;
> +	pgtable->iop_params.ops.iova_to_phys = iommu_v1_iova_to_phys;
> +	iop->ops = &pgtable->iop_params.ops;
>  
> -	return &pgtable->iop;
> +	return 0;
>  }
>  
>  struct io_pgtable_init_fns io_pgtable_amd_iommu_v1_init_fns = {
> diff --git a/drivers/iommu/amd/io_pgtable_v2.c b/drivers/iommu/amd/io_pgtable_v2.c
> index 8638ddf6fb3b..52acb8f11a27 100644
> --- a/drivers/iommu/amd/io_pgtable_v2.c
> +++ b/drivers/iommu/amd/io_pgtable_v2.c
> @@ -239,12 +239,12 @@ static u64 *fetch_pte(struct amd_io_pgtable *pgtable,
>  	return pte;
>  }
>  
> -static int iommu_v2_map_pages(struct io_pgtable_ops *ops, unsigned long iova,
> +static int iommu_v2_map_pages(struct io_pgtable *iop, unsigned long iova,
>  			      phys_addr_t paddr, size_t pgsize, size_t pgcount,
>  			      int prot, gfp_t gfp, size_t *mapped)
>  {
> -	struct protection_domain *pdom = io_pgtable_ops_to_domain(ops);
> -	struct io_pgtable_cfg *cfg = &pdom->iop.iop.cfg;
> +	struct protection_domain *pdom = io_pgtable_ops_to_domain(iop->ops);
> +	struct io_pgtable_cfg *cfg = &pdom->iop.iop_params.cfg;
>  	u64 *pte;
>  	unsigned long map_size;
>  	unsigned long mapped_size = 0;
> @@ -290,13 +290,13 @@ static int iommu_v2_map_pages(struct io_pgtable_ops *ops, unsigned long iova,
>  	return ret;
>  }
>  
> -static unsigned long iommu_v2_unmap_pages(struct io_pgtable_ops *ops,
> +static unsigned long iommu_v2_unmap_pages(struct io_pgtable *iop,
>  					  unsigned long iova,
>  					  size_t pgsize, size_t pgcount,
>  					  struct iommu_iotlb_gather *gather)
>  {
> -	struct amd_io_pgtable *pgtable = io_pgtable_ops_to_data(ops);
> -	struct io_pgtable_cfg *cfg = &pgtable->iop.cfg;
> +	struct amd_io_pgtable *pgtable = io_pgtable_ops_to_data(iop->ops);
> +	struct io_pgtable_cfg *cfg = &pgtable->iop_params.cfg;
>  	unsigned long unmap_size;
>  	unsigned long unmapped = 0;
>  	size_t size = pgcount << __ffs(pgsize);
> @@ -319,9 +319,9 @@ static unsigned long iommu_v2_unmap_pages(struct io_pgtable_ops *ops,
>  	return unmapped;
>  }
>  
> -static phys_addr_t iommu_v2_iova_to_phys(struct io_pgtable_ops *ops, unsigned long iova)
> +static phys_addr_t iommu_v2_iova_to_phys(struct io_pgtable *iop, unsigned long iova)
>  {
> -	struct amd_io_pgtable *pgtable = io_pgtable_ops_to_data(ops);
> +	struct amd_io_pgtable *pgtable = io_pgtable_ops_to_data(iop->ops);
>  	unsigned long offset_mask, pte_pgsize;
>  	u64 *pte, __pte;
>  
> @@ -362,7 +362,7 @@ static const struct iommu_flush_ops v2_flush_ops = {
>  static void v2_free_pgtable(struct io_pgtable *iop)
>  {
>  	struct protection_domain *pdom;
> -	struct amd_io_pgtable *pgtable = container_of(iop, struct amd_io_pgtable, iop);
> +	struct amd_io_pgtable *pgtable = io_pgtable_ops_to_data(iop->ops);
>  
>  	pdom = container_of(pgtable, struct protection_domain, iop);
>  	if (!(pdom->flags & PD_IOMMUV2_MASK))
> @@ -375,38 +375,39 @@ static void v2_free_pgtable(struct io_pgtable *iop)
>  	amd_iommu_domain_update(pdom);
>  
>  	/* Free page table */
> -	free_pgtable(pgtable->pgd, get_pgtable_level());
> +	free_pgtable(iop->pgd, get_pgtable_level());
>  }
>  
> -static struct io_pgtable *v2_alloc_pgtable(struct io_pgtable_cfg *cfg, void *cookie)
> +int v2_alloc_pgtable(struct io_pgtable *iop, struct io_pgtable_cfg *cfg, void *cookie)
>  {
>  	struct amd_io_pgtable *pgtable = io_pgtable_cfg_to_data(cfg);
>  	struct protection_domain *pdom = (struct protection_domain *)cookie;
>  	int ret;
>  
> -	pgtable->pgd = alloc_pgtable_page();
> -	if (!pgtable->pgd)
> -		return NULL;
> +	iop->pgd = alloc_pgtable_page();
> +	if (!iop->pgd)
> +		return -ENOMEM;
>  
> -	ret = amd_iommu_domain_set_gcr3(&pdom->domain, 0, iommu_virt_to_phys(pgtable->pgd));
> +	ret = amd_iommu_domain_set_gcr3(&pdom->domain, 0, iommu_virt_to_phys(iop->pgd));
>  	if (ret)
>  		goto err_free_pgd;
>  
> -	pgtable->iop.ops.map_pages    = iommu_v2_map_pages;
> -	pgtable->iop.ops.unmap_pages  = iommu_v2_unmap_pages;
> -	pgtable->iop.ops.iova_to_phys = iommu_v2_iova_to_phys;
> +	pgtable->iop_params.ops.map_pages    = iommu_v2_map_pages;
> +	pgtable->iop_params.ops.unmap_pages  = iommu_v2_unmap_pages;
> +	pgtable->iop_params.ops.iova_to_phys = iommu_v2_iova_to_phys;
> +	iop->ops = &pgtable->iop_params.ops;
>  
>  	cfg->pgsize_bitmap = AMD_IOMMU_PGSIZES_V2,
>  	cfg->ias           = IOMMU_IN_ADDR_BIT_SIZE,
>  	cfg->oas           = IOMMU_OUT_ADDR_BIT_SIZE,
>  	cfg->tlb           = &v2_flush_ops;
>  
> -	return &pgtable->iop;
> +	return 0;
>  
>  err_free_pgd:
> -	free_pgtable_page(pgtable->pgd);
> +	free_pgtable_page(iop->pgd);
>  
> -	return NULL;
> +	return ret;
>  }
>  
>  struct io_pgtable_init_fns io_pgtable_amd_iommu_v2_init_fns = {
> diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
> index 7efb6b467041..51f9cecdcb6b 100644
> --- a/drivers/iommu/amd/iommu.c
> +++ b/drivers/iommu/amd/iommu.c
> @@ -1984,7 +1984,7 @@ static void protection_domain_free(struct protection_domain *domain)
>  		return;
>  
>  	if (domain->iop.pgtbl_cfg.tlb)
> -		free_io_pgtable_ops(&domain->iop.iop.ops);
> +		free_io_pgtable_ops(&domain->iop.iop);
>  
>  	if (domain->id)
>  		domain_id_free(domain->id);
> @@ -2037,7 +2037,6 @@ static int protection_domain_init_v2(struct protection_domain *domain)
>  
>  static struct protection_domain *protection_domain_alloc(unsigned int type)
>  {
> -	struct io_pgtable_ops *pgtbl_ops;
>  	struct protection_domain *domain;
>  	int pgtable = amd_iommu_pgtable;
>  	int mode = DEFAULT_PGTABLE_LEVEL;
> @@ -2073,8 +2072,9 @@ static struct protection_domain *protection_domain_alloc(unsigned int type)
>  		goto out_err;
>  
>  	domain->iop.pgtbl_cfg.fmt = pgtable;
> -	pgtbl_ops = alloc_io_pgtable_ops(&domain->iop.pgtbl_cfg, domain);
> -	if (!pgtbl_ops) {
> +	ret = alloc_io_pgtable_ops(&domain->iop.iop, &domain->iop.pgtbl_cfg,
> +				   domain);
> +	if (ret) {
>  		domain_id_free(domain->id);
>  		goto out_err;
>  	}
> @@ -2185,7 +2185,7 @@ static void amd_iommu_iotlb_sync_map(struct iommu_domain *dom,
>  				     unsigned long iova, size_t size)
>  {
>  	struct protection_domain *domain = to_pdomain(dom);
> -	struct io_pgtable_ops *ops = &domain->iop.iop.ops;
> +	struct io_pgtable_ops *ops = domain->iop.iop.ops;
>  
>  	if (ops->map_pages)
>  		domain_flush_np_cache(domain, iova, size);
> @@ -2196,9 +2196,7 @@ static int amd_iommu_map_pages(struct iommu_domain *dom, unsigned long iova,
>  			       int iommu_prot, gfp_t gfp, size_t *mapped)
>  {
>  	struct protection_domain *domain = to_pdomain(dom);
> -	struct io_pgtable_ops *ops = &domain->iop.iop.ops;
>  	int prot = 0;
> -	int ret = -EINVAL;
>  
>  	if ((amd_iommu_pgtable == AMD_IOMMU_V1) &&
>  	    (domain->iop.mode == PAGE_MODE_NONE))
> @@ -2209,12 +2207,8 @@ static int amd_iommu_map_pages(struct iommu_domain *dom, unsigned long iova,
>  	if (iommu_prot & IOMMU_WRITE)
>  		prot |= IOMMU_PROT_IW;
>  
> -	if (ops->map_pages) {
> -		ret = ops->map_pages(ops, iova, paddr, pgsize,
> -				     pgcount, prot, gfp, mapped);
> -	}
> -
> -	return ret;
> +	return iopt_map_pages(&domain->iop.iop, iova, paddr, pgsize, pgcount,
> +			      prot, gfp, mapped);
>  }
>  
>  static void amd_iommu_iotlb_gather_add_page(struct iommu_domain *domain,
> @@ -2243,14 +2237,13 @@ static size_t amd_iommu_unmap_pages(struct iommu_domain *dom, unsigned long iova
>  				    struct iommu_iotlb_gather *gather)
>  {
>  	struct protection_domain *domain = to_pdomain(dom);
> -	struct io_pgtable_ops *ops = &domain->iop.iop.ops;
>  	size_t r;
>  
>  	if ((amd_iommu_pgtable == AMD_IOMMU_V1) &&
>  	    (domain->iop.mode == PAGE_MODE_NONE))
>  		return 0;
>  
> -	r = (ops->unmap_pages) ? ops->unmap_pages(ops, iova, pgsize, pgcount, NULL) : 0;
> +	r = iopt_unmap_pages(&domain->iop.iop, iova, pgsize, pgcount, NULL);
>  
>  	if (r)
>  		amd_iommu_iotlb_gather_add_page(dom, gather, iova, r);
> @@ -2262,9 +2255,8 @@ static phys_addr_t amd_iommu_iova_to_phys(struct iommu_domain *dom,
>  					  dma_addr_t iova)
>  {
>  	struct protection_domain *domain = to_pdomain(dom);
> -	struct io_pgtable_ops *ops = &domain->iop.iop.ops;
>  
> -	return ops->iova_to_phys(ops, iova);
> +	return iopt_iova_to_phys(&domain->iop.iop, iova);
>  }
>  
>  static bool amd_iommu_capable(struct device *dev, enum iommu_cap cap)
> @@ -2460,7 +2452,7 @@ void amd_iommu_domain_direct_map(struct iommu_domain *dom)
>  	spin_lock_irqsave(&domain->lock, flags);
>  
>  	if (domain->iop.pgtbl_cfg.tlb)
> -		free_io_pgtable_ops(&domain->iop.iop.ops);
> +		free_io_pgtable_ops(&domain->iop.iop);
>  
>  	spin_unlock_irqrestore(&domain->lock, flags);
>  }
> diff --git a/drivers/iommu/apple-dart.c b/drivers/iommu/apple-dart.c
> index 571f948add7c..b806019f925b 100644
> --- a/drivers/iommu/apple-dart.c
> +++ b/drivers/iommu/apple-dart.c
> @@ -150,14 +150,14 @@ struct apple_dart_atomic_stream_map {
>  /*
>   * This structure is attached to each iommu domain handled by a DART.
>   *
> - * @pgtbl_ops: pagetable ops allocated by io-pgtable
> + * @pgtbl: pagetable allocated by io-pgtable
>   * @finalized: true if the domain has been completely initialized
>   * @init_lock: protects domain initialization
>   * @stream_maps: streams attached to this domain (valid for DMA/UNMANAGED only)
>   * @domain: core iommu domain pointer
>   */
>  struct apple_dart_domain {
> -	struct io_pgtable_ops *pgtbl_ops;
> +	struct io_pgtable pgtbl;
>  
>  	bool finalized;
>  	struct mutex init_lock;
> @@ -354,12 +354,8 @@ static phys_addr_t apple_dart_iova_to_phys(struct iommu_domain *domain,
>  					   dma_addr_t iova)
>  {
>  	struct apple_dart_domain *dart_domain = to_dart_domain(domain);
> -	struct io_pgtable_ops *ops = dart_domain->pgtbl_ops;
>  
> -	if (!ops)
> -		return 0;
> -
> -	return ops->iova_to_phys(ops, iova);
> +	return iopt_iova_to_phys(&dart_domain->pgtbl, iova);
>  }
>  
>  static int apple_dart_map_pages(struct iommu_domain *domain, unsigned long iova,
> @@ -368,13 +364,9 @@ static int apple_dart_map_pages(struct iommu_domain *domain, unsigned long iova,
>  				size_t *mapped)
>  {
>  	struct apple_dart_domain *dart_domain = to_dart_domain(domain);
> -	struct io_pgtable_ops *ops = dart_domain->pgtbl_ops;
> -
> -	if (!ops)
> -		return -ENODEV;
>  
> -	return ops->map_pages(ops, iova, paddr, pgsize, pgcount, prot, gfp,
> -			      mapped);
> +	return iopt_map_pages(&dart_domain->pgtbl, iova, paddr, pgsize, pgcount,
> +			      prot, gfp, mapped);
>  }
>  
>  static size_t apple_dart_unmap_pages(struct iommu_domain *domain,
> @@ -383,9 +375,9 @@ static size_t apple_dart_unmap_pages(struct iommu_domain *domain,
>  				     struct iommu_iotlb_gather *gather)
>  {
>  	struct apple_dart_domain *dart_domain = to_dart_domain(domain);
> -	struct io_pgtable_ops *ops = dart_domain->pgtbl_ops;
>  
> -	return ops->unmap_pages(ops, iova, pgsize, pgcount, gather);
> +	return iopt_unmap_pages(&dart_domain->pgtbl, iova, pgsize, pgcount,
> +				gather);
>  }
>  
>  static void
> @@ -394,7 +386,7 @@ apple_dart_setup_translation(struct apple_dart_domain *domain,
>  {
>  	int i;
>  	struct io_pgtable_cfg *pgtbl_cfg =
> -		&io_pgtable_ops_to_pgtable(domain->pgtbl_ops)->cfg;
> +		&io_pgtable_ops_to_params(domain->pgtbl.ops)->cfg;
>  
>  	for (i = 0; i < pgtbl_cfg->apple_dart_cfg.n_ttbrs; ++i)
>  		apple_dart_hw_set_ttbr(stream_map, i,
> @@ -435,11 +427,9 @@ static int apple_dart_finalize_domain(struct iommu_domain *domain,
>  		.iommu_dev = dart->dev,
>  	};
>  
> -	dart_domain->pgtbl_ops = alloc_io_pgtable_ops(&pgtbl_cfg, domain);
> -	if (!dart_domain->pgtbl_ops) {
> -		ret = -ENOMEM;
> +	ret = alloc_io_pgtable_ops(&dart_domain->pgtbl, &pgtbl_cfg, domain);
> +	if (ret)
>  		goto done;
> -	}
>  
>  	domain->pgsize_bitmap = pgtbl_cfg.pgsize_bitmap;
>  	domain->geometry.aperture_start = 0;
> @@ -590,7 +580,7 @@ static struct iommu_domain *apple_dart_domain_alloc(unsigned int type)
>  
>  	mutex_init(&dart_domain->init_lock);
>  
> -	/* no need to allocate pgtbl_ops or do any other finalization steps */
> +	/* no need to allocate pgtbl or do any other finalization steps */
>  	if (type == IOMMU_DOMAIN_IDENTITY || type == IOMMU_DOMAIN_BLOCKED)
>  		dart_domain->finalized = true;
>  
> @@ -601,8 +591,8 @@ static void apple_dart_domain_free(struct iommu_domain *domain)
>  {
>  	struct apple_dart_domain *dart_domain = to_dart_domain(domain);
>  
> -	if (dart_domain->pgtbl_ops)
> -		free_io_pgtable_ops(dart_domain->pgtbl_ops);
> +	if (dart_domain->pgtbl.ops)
> +		free_io_pgtable_ops(&dart_domain->pgtbl);
>  
>  	kfree(dart_domain);
>  }
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> index c033b23ca4b2..97d24ee5c14d 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> @@ -2058,7 +2058,7 @@ static void arm_smmu_domain_free(struct iommu_domain *domain)
>  	struct arm_smmu_domain *smmu_domain = to_smmu_domain(domain);
>  	struct arm_smmu_device *smmu = smmu_domain->smmu;
>  
> -	free_io_pgtable_ops(smmu_domain->pgtbl_ops);
> +	free_io_pgtable_ops(&smmu_domain->pgtbl);
>  
>  	/* Free the CD and ASID, if we allocated them */
>  	if (smmu_domain->stage == ARM_SMMU_DOMAIN_S1) {
> @@ -2171,7 +2171,6 @@ static int arm_smmu_domain_finalise(struct iommu_domain *domain,
>  	unsigned long ias, oas;
>  	enum io_pgtable_fmt fmt;
>  	struct io_pgtable_cfg pgtbl_cfg;
> -	struct io_pgtable_ops *pgtbl_ops;
>  	int (*finalise_stage_fn)(struct arm_smmu_domain *,
>  				 struct arm_smmu_master *,
>  				 struct io_pgtable_cfg *);
> @@ -2218,9 +2217,9 @@ static int arm_smmu_domain_finalise(struct iommu_domain *domain,
>  		.iommu_dev	= smmu->dev,
>  	};
>  
> -	pgtbl_ops = alloc_io_pgtable_ops(&pgtbl_cfg, smmu_domain);
> -	if (!pgtbl_ops)
> -		return -ENOMEM;
> +	ret = alloc_io_pgtable_ops(&smmu_domain->pgtbl, &pgtbl_cfg, smmu_domain);
> +	if (ret)
> +		return ret;
>  
>  	domain->pgsize_bitmap = pgtbl_cfg.pgsize_bitmap;
>  	domain->geometry.aperture_end = (1UL << pgtbl_cfg.ias) - 1;
> @@ -2228,11 +2227,10 @@ static int arm_smmu_domain_finalise(struct iommu_domain *domain,
>  
>  	ret = finalise_stage_fn(smmu_domain, master, &pgtbl_cfg);
>  	if (ret < 0) {
> -		free_io_pgtable_ops(pgtbl_ops);
> +		free_io_pgtable_ops(&smmu_domain->pgtbl);
>  		return ret;
>  	}
>  
> -	smmu_domain->pgtbl_ops = pgtbl_ops;
>  	return 0;
>  }
>  
> @@ -2468,12 +2466,10 @@ static int arm_smmu_map_pages(struct iommu_domain *domain, unsigned long iova,
>  			      phys_addr_t paddr, size_t pgsize, size_t pgcount,
>  			      int prot, gfp_t gfp, size_t *mapped)
>  {
> -	struct io_pgtable_ops *ops = to_smmu_domain(domain)->pgtbl_ops;
> -
> -	if (!ops)
> -		return -ENODEV;
> +	struct arm_smmu_domain *smmu_domain = to_smmu_domain(domain);
>  
> -	return ops->map_pages(ops, iova, paddr, pgsize, pgcount, prot, gfp, mapped);
> +	return iopt_map_pages(&smmu_domain->pgtbl, iova, paddr, pgsize, pgcount,
> +			      prot, gfp, mapped);
>  }
>  
>  static size_t arm_smmu_unmap_pages(struct iommu_domain *domain, unsigned long iova,
> @@ -2481,12 +2477,9 @@ static size_t arm_smmu_unmap_pages(struct iommu_domain *domain, unsigned long io
>  				   struct iommu_iotlb_gather *gather)
>  {
>  	struct arm_smmu_domain *smmu_domain = to_smmu_domain(domain);
> -	struct io_pgtable_ops *ops = smmu_domain->pgtbl_ops;
>  
> -	if (!ops)
> -		return 0;
> -
> -	return ops->unmap_pages(ops, iova, pgsize, pgcount, gather);
> +	return iopt_unmap_pages(&smmu_domain->pgtbl, iova, pgsize, pgcount,
> +				gather);
>  }
>  
>  static void arm_smmu_flush_iotlb_all(struct iommu_domain *domain)
> @@ -2513,12 +2506,9 @@ static void arm_smmu_iotlb_sync(struct iommu_domain *domain,
>  static phys_addr_t
>  arm_smmu_iova_to_phys(struct iommu_domain *domain, dma_addr_t iova)
>  {
> -	struct io_pgtable_ops *ops = to_smmu_domain(domain)->pgtbl_ops;
> -
> -	if (!ops)
> -		return 0;
> +	struct arm_smmu_domain *smmu_domain = to_smmu_domain(domain);
>  
> -	return ops->iova_to_phys(ops, iova);
> +	return iopt_iova_to_phys(&smmu_domain->pgtbl, iova);
>  }
>  
>  static struct platform_driver arm_smmu_driver;
> diff --git a/drivers/iommu/arm/arm-smmu/arm-smmu-qcom.c b/drivers/iommu/arm/arm-smmu/arm-smmu-qcom.c
> index 91d404deb115..0673841167be 100644
> --- a/drivers/iommu/arm/arm-smmu/arm-smmu-qcom.c
> +++ b/drivers/iommu/arm/arm-smmu/arm-smmu-qcom.c
> @@ -122,8 +122,8 @@ static const struct io_pgtable_cfg *qcom_adreno_smmu_get_ttbr1_cfg(
>  		const void *cookie)
>  {
>  	struct arm_smmu_domain *smmu_domain = (void *)cookie;
> -	struct io_pgtable *pgtable =
> -		io_pgtable_ops_to_pgtable(smmu_domain->pgtbl_ops);
> +	struct io_pgtable_params *pgtable =
> +		io_pgtable_ops_to_params(smmu_domain->pgtbl.ops);
>  	return &pgtable->cfg;
>  }
>  
> @@ -137,7 +137,8 @@ static int qcom_adreno_smmu_set_ttbr0_cfg(const void *cookie,
>  		const struct io_pgtable_cfg *pgtbl_cfg)
>  {
>  	struct arm_smmu_domain *smmu_domain = (void *)cookie;
> -	struct io_pgtable *pgtable = io_pgtable_ops_to_pgtable(smmu_domain->pgtbl_ops);
> +	struct io_pgtable_params *pgtable =
> +		io_pgtable_ops_to_params(smmu_domain->pgtbl.ops);
>  	struct arm_smmu_cfg *cfg = &smmu_domain->cfg;
>  	struct arm_smmu_cb *cb = &smmu_domain->smmu->cbs[cfg->cbndx];
>  
> diff --git a/drivers/iommu/arm/arm-smmu/arm-smmu.c b/drivers/iommu/arm/arm-smmu/arm-smmu.c
> index f230d2ce977a..201055254d5b 100644
> --- a/drivers/iommu/arm/arm-smmu/arm-smmu.c
> +++ b/drivers/iommu/arm/arm-smmu/arm-smmu.c
> @@ -614,7 +614,6 @@ static int arm_smmu_init_domain_context(struct iommu_domain *domain,
>  {
>  	int irq, start, ret = 0;
>  	unsigned long ias, oas;
> -	struct io_pgtable_ops *pgtbl_ops;
>  	struct io_pgtable_cfg pgtbl_cfg;
>  	enum io_pgtable_fmt fmt;
>  	struct arm_smmu_domain *smmu_domain = to_smmu_domain(domain);
> @@ -765,11 +764,9 @@ static int arm_smmu_init_domain_context(struct iommu_domain *domain,
>  	if (smmu_domain->pgtbl_quirks)
>  		pgtbl_cfg.quirks |= smmu_domain->pgtbl_quirks;
>  
> -	pgtbl_ops = alloc_io_pgtable_ops(&pgtbl_cfg, smmu_domain);
> -	if (!pgtbl_ops) {
> -		ret = -ENOMEM;
> +	ret = alloc_io_pgtable_ops(&smmu_domain->pgtbl, &pgtbl_cfg, smmu_domain);
> +	if (ret)
>  		goto out_clear_smmu;
> -	}
>  
>  	/* Update the domain's page sizes to reflect the page table format */
>  	domain->pgsize_bitmap = pgtbl_cfg.pgsize_bitmap;
> @@ -808,8 +805,6 @@ static int arm_smmu_init_domain_context(struct iommu_domain *domain,
>  
>  	mutex_unlock(&smmu_domain->init_mutex);
>  
> -	/* Publish page table ops for map/unmap */
> -	smmu_domain->pgtbl_ops = pgtbl_ops;
>  	return 0;
>  
>  out_clear_smmu:
> @@ -846,7 +841,7 @@ static void arm_smmu_destroy_domain_context(struct iommu_domain *domain)
>  		devm_free_irq(smmu->dev, irq, domain);
>  	}
>  
> -	free_io_pgtable_ops(smmu_domain->pgtbl_ops);
> +	free_io_pgtable_ops(&smmu_domain->pgtbl);
>  	__arm_smmu_free_bitmap(smmu->context_map, cfg->cbndx);
>  
>  	arm_smmu_rpm_put(smmu);
> @@ -1181,15 +1176,13 @@ static int arm_smmu_map_pages(struct iommu_domain *domain, unsigned long iova,
>  			      phys_addr_t paddr, size_t pgsize, size_t pgcount,
>  			      int prot, gfp_t gfp, size_t *mapped)
>  {
> -	struct io_pgtable_ops *ops = to_smmu_domain(domain)->pgtbl_ops;
> -	struct arm_smmu_device *smmu = to_smmu_domain(domain)->smmu;
> +	struct arm_smmu_domain *smmu_domain = to_smmu_domain(domain);
> +	struct arm_smmu_device *smmu = smmu_domain->smmu;
>  	int ret;
>  
> -	if (!ops)
> -		return -ENODEV;
> -
>  	arm_smmu_rpm_get(smmu);
> -	ret = ops->map_pages(ops, iova, paddr, pgsize, pgcount, prot, gfp, mapped);
> +	ret = iopt_map_pages(&smmu_domain->pgtbl, iova, paddr, pgsize, pgcount,
> +			     prot, gfp, mapped);
>  	arm_smmu_rpm_put(smmu);
>  
>  	return ret;
> @@ -1199,15 +1192,13 @@ static size_t arm_smmu_unmap_pages(struct iommu_domain *domain, unsigned long io
>  				   size_t pgsize, size_t pgcount,
>  				   struct iommu_iotlb_gather *iotlb_gather)
>  {
> -	struct io_pgtable_ops *ops = to_smmu_domain(domain)->pgtbl_ops;
> -	struct arm_smmu_device *smmu = to_smmu_domain(domain)->smmu;
> +	struct arm_smmu_domain *smmu_domain = to_smmu_domain(domain);
> +	struct arm_smmu_device *smmu = smmu_domain->smmu;
>  	size_t ret;
>  
> -	if (!ops)
> -		return 0;
> -
>  	arm_smmu_rpm_get(smmu);
> -	ret = ops->unmap_pages(ops, iova, pgsize, pgcount, iotlb_gather);
> +	ret = iopt_unmap_pages(&smmu_domain->pgtbl, iova, pgsize, pgcount,
> +			       iotlb_gather);
>  	arm_smmu_rpm_put(smmu);
>  
>  	return ret;
> @@ -1249,7 +1240,6 @@ static phys_addr_t arm_smmu_iova_to_phys_hard(struct iommu_domain *domain,
>  	struct arm_smmu_domain *smmu_domain = to_smmu_domain(domain);
>  	struct arm_smmu_device *smmu = smmu_domain->smmu;
>  	struct arm_smmu_cfg *cfg = &smmu_domain->cfg;
> -	struct io_pgtable_ops *ops= smmu_domain->pgtbl_ops;
>  	struct device *dev = smmu->dev;
>  	void __iomem *reg;
>  	u32 tmp;
> @@ -1277,7 +1267,7 @@ static phys_addr_t arm_smmu_iova_to_phys_hard(struct iommu_domain *domain,
>  			"iova to phys timed out on %pad. Falling back to software table walk.\n",
>  			&iova);
>  		arm_smmu_rpm_put(smmu);
> -		return ops->iova_to_phys(ops, iova);
> +		return iopt_iova_to_phys(&smmu_domain->pgtbl, iova);
>  	}
>  
>  	phys = arm_smmu_cb_readq(smmu, idx, ARM_SMMU_CB_PAR);
> @@ -1299,16 +1289,12 @@ static phys_addr_t arm_smmu_iova_to_phys(struct iommu_domain *domain,
>  					dma_addr_t iova)
>  {
>  	struct arm_smmu_domain *smmu_domain = to_smmu_domain(domain);
> -	struct io_pgtable_ops *ops = smmu_domain->pgtbl_ops;
> -
> -	if (!ops)
> -		return 0;
>  
>  	if (smmu_domain->smmu->features & ARM_SMMU_FEAT_TRANS_OPS &&
>  			smmu_domain->stage == ARM_SMMU_DOMAIN_S1)
>  		return arm_smmu_iova_to_phys_hard(domain, iova);
>  
> -	return ops->iova_to_phys(ops, iova);
> +	return iopt_iova_to_phys(&smmu_domain->pgtbl, iova);
>  }
>  
>  static bool arm_smmu_capable(struct device *dev, enum iommu_cap cap)
> diff --git a/drivers/iommu/arm/arm-smmu/qcom_iommu.c b/drivers/iommu/arm/arm-smmu/qcom_iommu.c
> index 65eb8bdcbe50..56676dd84462 100644
> --- a/drivers/iommu/arm/arm-smmu/qcom_iommu.c
> +++ b/drivers/iommu/arm/arm-smmu/qcom_iommu.c
> @@ -64,7 +64,7 @@ struct qcom_iommu_ctx {
>  };
>  
>  struct qcom_iommu_domain {
> -	struct io_pgtable_ops	*pgtbl_ops;
> +	struct io_pgtable	 pgtbl;
>  	spinlock_t		 pgtbl_lock;
>  	struct mutex		 init_mutex; /* Protects iommu pointer */
>  	struct iommu_domain	 domain;
> @@ -229,7 +229,6 @@ static int qcom_iommu_init_domain(struct iommu_domain *domain,
>  {
>  	struct qcom_iommu_domain *qcom_domain = to_qcom_iommu_domain(domain);
>  	struct iommu_fwspec *fwspec = dev_iommu_fwspec_get(dev);
> -	struct io_pgtable_ops *pgtbl_ops;
>  	struct io_pgtable_cfg pgtbl_cfg;
>  	int i, ret = 0;
>  	u32 reg;
> @@ -250,10 +249,9 @@ static int qcom_iommu_init_domain(struct iommu_domain *domain,
>  	qcom_domain->iommu = qcom_iommu;
>  	qcom_domain->fwspec = fwspec;
>  
> -	pgtbl_ops = alloc_io_pgtable_ops(&pgtbl_cfg, qcom_domain);
> -	if (!pgtbl_ops) {
> +	ret = alloc_io_pgtable_ops(&qcom_domain->pgtbl, &pgtbl_cfg, qcom_domain);
> +	if (ret) {
>  		dev_err(qcom_iommu->dev, "failed to allocate pagetable ops\n");
> -		ret = -ENOMEM;
>  		goto out_clear_iommu;
>  	}
>  
> @@ -308,9 +306,6 @@ static int qcom_iommu_init_domain(struct iommu_domain *domain,
>  
>  	mutex_unlock(&qcom_domain->init_mutex);
>  
> -	/* Publish page table ops for map/unmap */
> -	qcom_domain->pgtbl_ops = pgtbl_ops;
> -
>  	return 0;
>  
>  out_clear_iommu:
> @@ -353,7 +348,7 @@ static void qcom_iommu_domain_free(struct iommu_domain *domain)
>  		 * is on to avoid unclocked accesses in the TLB inv path:
>  		 */
>  		pm_runtime_get_sync(qcom_domain->iommu->dev);
> -		free_io_pgtable_ops(qcom_domain->pgtbl_ops);
> +		free_io_pgtable_ops(&qcom_domain->pgtbl);
>  		pm_runtime_put_sync(qcom_domain->iommu->dev);
>  	}
>  
> @@ -417,13 +412,10 @@ static int qcom_iommu_map(struct iommu_domain *domain, unsigned long iova,
>  	int ret;
>  	unsigned long flags;
>  	struct qcom_iommu_domain *qcom_domain = to_qcom_iommu_domain(domain);
> -	struct io_pgtable_ops *ops = qcom_domain->pgtbl_ops;
> -
> -	if (!ops)
> -		return -ENODEV;
>  
>  	spin_lock_irqsave(&qcom_domain->pgtbl_lock, flags);
> -	ret = ops->map_pages(ops, iova, paddr, pgsize, pgcount, prot, GFP_ATOMIC, mapped);
> +	ret = iopt_map_pages(&qcom_domain->pgtbl, iova, paddr, pgsize, pgcount,
> +			     prot, GFP_ATOMIC, mapped);
>  	spin_unlock_irqrestore(&qcom_domain->pgtbl_lock, flags);
>  	return ret;
>  }
> @@ -435,10 +427,6 @@ static size_t qcom_iommu_unmap(struct iommu_domain *domain, unsigned long iova,
>  	size_t ret;
>  	unsigned long flags;
>  	struct qcom_iommu_domain *qcom_domain = to_qcom_iommu_domain(domain);
> -	struct io_pgtable_ops *ops = qcom_domain->pgtbl_ops;
> -
> -	if (!ops)
> -		return 0;
>  
>  	/* NOTE: unmap can be called after client device is powered off,
>  	 * for example, with GPUs or anything involving dma-buf.  So we
> @@ -447,7 +435,8 @@ static size_t qcom_iommu_unmap(struct iommu_domain *domain, unsigned long iova,
>  	 */
>  	pm_runtime_get_sync(qcom_domain->iommu->dev);
>  	spin_lock_irqsave(&qcom_domain->pgtbl_lock, flags);
> -	ret = ops->unmap_pages(ops, iova, pgsize, pgcount, gather);
> +	ret = iopt_unmap_pages(&qcom_domain->pgtbl, iova, pgsize, pgcount,
> +			       gather);
>  	spin_unlock_irqrestore(&qcom_domain->pgtbl_lock, flags);
>  	pm_runtime_put_sync(qcom_domain->iommu->dev);
>  
> @@ -457,13 +446,12 @@ static size_t qcom_iommu_unmap(struct iommu_domain *domain, unsigned long iova,
>  static void qcom_iommu_flush_iotlb_all(struct iommu_domain *domain)
>  {
>  	struct qcom_iommu_domain *qcom_domain = to_qcom_iommu_domain(domain);
> -	struct io_pgtable *pgtable = container_of(qcom_domain->pgtbl_ops,
> -						  struct io_pgtable, ops);
> -	if (!qcom_domain->pgtbl_ops)
> +
> +	if (!qcom_domain->pgtbl.ops)
>  		return;
>  
>  	pm_runtime_get_sync(qcom_domain->iommu->dev);
> -	qcom_iommu_tlb_sync(pgtable->cookie);
> +	qcom_iommu_tlb_sync(qcom_domain->pgtbl.cookie);
>  	pm_runtime_put_sync(qcom_domain->iommu->dev);
>  }
>  
> @@ -479,13 +467,9 @@ static phys_addr_t qcom_iommu_iova_to_phys(struct iommu_domain *domain,
>  	phys_addr_t ret;
>  	unsigned long flags;
>  	struct qcom_iommu_domain *qcom_domain = to_qcom_iommu_domain(domain);
> -	struct io_pgtable_ops *ops = qcom_domain->pgtbl_ops;
> -
> -	if (!ops)
> -		return 0;
>  
>  	spin_lock_irqsave(&qcom_domain->pgtbl_lock, flags);
> -	ret = ops->iova_to_phys(ops, iova);
> +	ret = iopt_iova_to_phys(&qcom_domain->pgtbl, iova);
>  	spin_unlock_irqrestore(&qcom_domain->pgtbl_lock, flags);
>  
>  	return ret;
> diff --git a/drivers/iommu/io-pgtable-arm-common.c b/drivers/iommu/io-pgtable-arm-common.c
> index 4b3a9ce806ea..359086cace34 100644
> --- a/drivers/iommu/io-pgtable-arm-common.c
> +++ b/drivers/iommu/io-pgtable-arm-common.c
> @@ -48,7 +48,8 @@ static void __arm_lpae_clear_pte(arm_lpae_iopte *ptep, struct io_pgtable_cfg *cf
>  		__arm_lpae_sync_pte(ptep, 1, cfg);
>  }
>  
> -static size_t __arm_lpae_unmap(struct arm_lpae_io_pgtable *data,
> +static size_t __arm_lpae_unmap(struct io_pgtable *iop,
> +			       struct arm_lpae_io_pgtable *data,
>  			       struct iommu_iotlb_gather *gather,
>  			       unsigned long iova, size_t size, size_t pgcount,
>  			       int lvl, arm_lpae_iopte *ptep);
> @@ -74,7 +75,8 @@ static void __arm_lpae_init_pte(struct arm_lpae_io_pgtable *data,
>  		__arm_lpae_sync_pte(ptep, num_entries, cfg);
>  }
>  
> -static int arm_lpae_init_pte(struct arm_lpae_io_pgtable *data,
> +static int arm_lpae_init_pte(struct io_pgtable *iop,
> +			     struct arm_lpae_io_pgtable *data,
>  			     unsigned long iova, phys_addr_t paddr,
>  			     arm_lpae_iopte prot, int lvl, int num_entries,
>  			     arm_lpae_iopte *ptep)
> @@ -95,8 +97,8 @@ static int arm_lpae_init_pte(struct arm_lpae_io_pgtable *data,
>  			size_t sz = ARM_LPAE_BLOCK_SIZE(lvl, data);
>  
>  			tblp = ptep - ARM_LPAE_LVL_IDX(iova, lvl, data);
> -			if (__arm_lpae_unmap(data, NULL, iova + i * sz, sz, 1,
> -					     lvl, tblp) != sz) {
> +			if (__arm_lpae_unmap(iop, data, NULL, iova + i * sz, sz,
> +					     1, lvl, tblp) != sz) {
>  				WARN_ON(1);
>  				return -EINVAL;
>  			}
> @@ -139,10 +141,10 @@ static arm_lpae_iopte arm_lpae_install_table(arm_lpae_iopte *table,
>  	return old;
>  }
>  
> -int __arm_lpae_map(struct arm_lpae_io_pgtable *data, unsigned long iova,
> -		   phys_addr_t paddr, size_t size, size_t pgcount,
> -		   arm_lpae_iopte prot, int lvl, arm_lpae_iopte *ptep,
> -		   gfp_t gfp, size_t *mapped)
> +int __arm_lpae_map(struct io_pgtable *iop, struct arm_lpae_io_pgtable *data,
> +		   unsigned long iova, phys_addr_t paddr, size_t size,
> +		   size_t pgcount, arm_lpae_iopte prot, int lvl,
> +		   arm_lpae_iopte *ptep, gfp_t gfp, size_t *mapped)
>  {
>  	arm_lpae_iopte *cptep, pte;
>  	size_t block_size = ARM_LPAE_BLOCK_SIZE(lvl, data);
> @@ -158,7 +160,8 @@ int __arm_lpae_map(struct arm_lpae_io_pgtable *data, unsigned long iova,
>  	if (size == block_size) {
>  		max_entries = ARM_LPAE_PTES_PER_TABLE(data) - map_idx_start;
>  		num_entries = min_t(int, pgcount, max_entries);
> -		ret = arm_lpae_init_pte(data, iova, paddr, prot, lvl, num_entries, ptep);
> +		ret = arm_lpae_init_pte(iop, data, iova, paddr, prot, lvl,
> +					num_entries, ptep);
>  		if (!ret)
>  			*mapped += num_entries * size;
>  
> @@ -192,7 +195,7 @@ int __arm_lpae_map(struct arm_lpae_io_pgtable *data, unsigned long iova,
>  	}
>  
>  	/* Rinse, repeat */
> -	return __arm_lpae_map(data, iova, paddr, size, pgcount, prot, lvl + 1,
> +	return __arm_lpae_map(iop, data, iova, paddr, size, pgcount, prot, lvl + 1,
>  			      cptep, gfp, mapped);
>  }
>  
> @@ -260,13 +263,13 @@ static arm_lpae_iopte arm_lpae_prot_to_pte(struct arm_lpae_io_pgtable *data,
>  	return pte;
>  }
>  
> -int arm_lpae_map_pages(struct io_pgtable_ops *ops, unsigned long iova,
> +int arm_lpae_map_pages(struct io_pgtable *iop, unsigned long iova,
>  		       phys_addr_t paddr, size_t pgsize, size_t pgcount,
>  		       int iommu_prot, gfp_t gfp, size_t *mapped)
>  {
> -	struct arm_lpae_io_pgtable *data = io_pgtable_ops_to_data(ops);
> +	struct arm_lpae_io_pgtable *data = io_pgtable_ops_to_data(iop->ops);
>  	struct io_pgtable_cfg *cfg = &data->iop.cfg;
> -	arm_lpae_iopte *ptep = data->pgd;
> +	arm_lpae_iopte *ptep = iop->pgd;
>  	int ret, lvl = data->start_level;
>  	arm_lpae_iopte prot;
>  	long iaext = (s64)iova >> cfg->ias;
> @@ -284,7 +287,7 @@ int arm_lpae_map_pages(struct io_pgtable_ops *ops, unsigned long iova,
>  		return 0;
>  
>  	prot = arm_lpae_prot_to_pte(data, iommu_prot);
> -	ret = __arm_lpae_map(data, iova, paddr, pgsize, pgcount, prot, lvl,
> +	ret = __arm_lpae_map(iop, data, iova, paddr, pgsize, pgcount, prot, lvl,
>  			     ptep, gfp, mapped);
>  	/*
>  	 * Synchronise all PTE updates for the new mapping before there's
> @@ -326,7 +329,8 @@ void __arm_lpae_free_pgtable(struct arm_lpae_io_pgtable *data, int lvl,
>  	__arm_lpae_free_pages(start, table_size, &data->iop.cfg);
>  }
>  
> -static size_t arm_lpae_split_blk_unmap(struct arm_lpae_io_pgtable *data,
> +static size_t arm_lpae_split_blk_unmap(struct io_pgtable *iop,
> +				       struct arm_lpae_io_pgtable *data,
>  				       struct iommu_iotlb_gather *gather,
>  				       unsigned long iova, size_t size,
>  				       arm_lpae_iopte blk_pte, int lvl,
> @@ -378,21 +382,24 @@ static size_t arm_lpae_split_blk_unmap(struct arm_lpae_io_pgtable *data,
>  		tablep = iopte_deref(pte, data);
>  	} else if (unmap_idx_start >= 0) {
>  		for (i = 0; i < num_entries; i++)
> -			io_pgtable_tlb_add_page(&data->iop, gather, iova + i * size, size);
> +			io_pgtable_tlb_add_page(cfg, iop, gather,
> +						iova + i * size, size);
>  
>  		return num_entries * size;
>  	}
>  
> -	return __arm_lpae_unmap(data, gather, iova, size, pgcount, lvl, tablep);
> +	return __arm_lpae_unmap(iop, data, gather, iova, size, pgcount, lvl,
> +				tablep);
>  }
>  
> -static size_t __arm_lpae_unmap(struct arm_lpae_io_pgtable *data,
> +static size_t __arm_lpae_unmap(struct io_pgtable *iop,
> +			       struct arm_lpae_io_pgtable *data,
>  			       struct iommu_iotlb_gather *gather,
>  			       unsigned long iova, size_t size, size_t pgcount,
>  			       int lvl, arm_lpae_iopte *ptep)
>  {
>  	arm_lpae_iopte pte;
> -	struct io_pgtable *iop = &data->iop;
> +	struct io_pgtable_cfg *cfg = &data->iop.cfg;
>  	int i = 0, num_entries, max_entries, unmap_idx_start;
>  
>  	/* Something went horribly wrong and we ran out of page table */
> @@ -415,15 +422,16 @@ static size_t __arm_lpae_unmap(struct arm_lpae_io_pgtable *data,
>  			if (WARN_ON(!pte))
>  				break;
>  
> -			__arm_lpae_clear_pte(ptep, &iop->cfg);
> +			__arm_lpae_clear_pte(ptep, cfg);
>  
> -			if (!iopte_leaf(pte, lvl, iop->cfg.fmt)) {
> +			if (!iopte_leaf(pte, lvl, cfg->fmt)) {
>  				/* Also flush any partial walks */
> -				io_pgtable_tlb_flush_walk(iop, iova + i * size, size,
> +				io_pgtable_tlb_flush_walk(cfg, iop, iova + i * size, size,
>  							  ARM_LPAE_GRANULE(data));
>  				__arm_lpae_free_pgtable(data, lvl + 1, iopte_deref(pte, data));
>  			} else if (!iommu_iotlb_gather_queued(gather)) {
> -				io_pgtable_tlb_add_page(iop, gather, iova + i * size, size);
> +				io_pgtable_tlb_add_page(cfg, iop, gather,
> +							iova + i * size, size);
>  			}
>  
>  			ptep++;
> @@ -431,27 +439,28 @@ static size_t __arm_lpae_unmap(struct arm_lpae_io_pgtable *data,
>  		}
>  
>  		return i * size;
> -	} else if (iopte_leaf(pte, lvl, iop->cfg.fmt)) {
> +	} else if (iopte_leaf(pte, lvl, cfg->fmt)) {
>  		/*
>  		 * Insert a table at the next level to map the old region,
>  		 * minus the part we want to unmap
>  		 */
> -		return arm_lpae_split_blk_unmap(data, gather, iova, size, pte,
> -						lvl + 1, ptep, pgcount);
> +		return arm_lpae_split_blk_unmap(iop, data, gather, iova, size,
> +						pte, lvl + 1, ptep, pgcount);
>  	}
>  
>  	/* Keep on walkin' */
>  	ptep = iopte_deref(pte, data);
> -	return __arm_lpae_unmap(data, gather, iova, size, pgcount, lvl + 1, ptep);
> +	return __arm_lpae_unmap(iop, data, gather, iova, size,
> +				pgcount, lvl + 1, ptep);
>  }
>  
> -size_t arm_lpae_unmap_pages(struct io_pgtable_ops *ops, unsigned long iova,
> +size_t arm_lpae_unmap_pages(struct io_pgtable *iop, unsigned long iova,
>  			    size_t pgsize, size_t pgcount,
>  			    struct iommu_iotlb_gather *gather)
>  {
> -	struct arm_lpae_io_pgtable *data = io_pgtable_ops_to_data(ops);
> +	struct arm_lpae_io_pgtable *data = io_pgtable_ops_to_data(iop->ops);
>  	struct io_pgtable_cfg *cfg = &data->iop.cfg;
> -	arm_lpae_iopte *ptep = data->pgd;
> +	arm_lpae_iopte *ptep = iop->pgd;
>  	long iaext = (s64)iova >> cfg->ias;
>  
>  	if (WARN_ON(!pgsize || (pgsize & cfg->pgsize_bitmap) != pgsize || !pgcount))
> @@ -462,15 +471,14 @@ size_t arm_lpae_unmap_pages(struct io_pgtable_ops *ops, unsigned long iova,
>  	if (WARN_ON(iaext))
>  		return 0;
>  
> -	return __arm_lpae_unmap(data, gather, iova, pgsize, pgcount,
> -				data->start_level, ptep);
> +	return __arm_lpae_unmap(iop, data, gather, iova, pgsize,
> +				pgcount, data->start_level, ptep);
>  }
>  
> -phys_addr_t arm_lpae_iova_to_phys(struct io_pgtable_ops *ops,
> -				  unsigned long iova)
> +static phys_addr_t arm_lpae_iova_to_phys(struct io_pgtable *iop, unsigned long iova)
>  {
> -	struct arm_lpae_io_pgtable *data = io_pgtable_ops_to_data(ops);
> -	arm_lpae_iopte pte, *ptep = data->pgd;
> +	struct arm_lpae_io_pgtable *data = io_pgtable_ops_to_data(iop->ops);
> +	arm_lpae_iopte pte, *ptep = iop->pgd;
>  	int lvl = data->start_level;
>  
>  	do {
> diff --git a/drivers/iommu/io-pgtable-arm-v7s.c b/drivers/iommu/io-pgtable-arm-v7s.c
> index 278b4299d757..2dd12fabfaee 100644
> --- a/drivers/iommu/io-pgtable-arm-v7s.c
> +++ b/drivers/iommu/io-pgtable-arm-v7s.c
> @@ -40,7 +40,7 @@
>  	container_of((x), struct arm_v7s_io_pgtable, iop)
>  
>  #define io_pgtable_ops_to_data(x)					\
> -	io_pgtable_to_data(io_pgtable_ops_to_pgtable(x))
> +	io_pgtable_to_data(io_pgtable_ops_to_params(x))
>  
>  /*
>   * We have 32 bits total; 12 bits resolved at level 1, 8 bits at level 2,
> @@ -162,11 +162,10 @@ typedef u32 arm_v7s_iopte;
>  static bool selftest_running;
>  
>  struct arm_v7s_io_pgtable {
> -	struct io_pgtable	iop;
> +	struct io_pgtable_params	iop;
>  
> -	arm_v7s_iopte		*pgd;
> -	struct kmem_cache	*l2_tables;
> -	spinlock_t		split_lock;
> +	struct kmem_cache		*l2_tables;
> +	spinlock_t			split_lock;
>  };
>  
>  static bool arm_v7s_pte_is_cont(arm_v7s_iopte pte, int lvl);
> @@ -424,13 +423,14 @@ static bool arm_v7s_pte_is_cont(arm_v7s_iopte pte, int lvl)
>  	return false;
>  }
>  
> -static size_t __arm_v7s_unmap(struct arm_v7s_io_pgtable *,
> +static size_t __arm_v7s_unmap(struct io_pgtable *, struct arm_v7s_io_pgtable *,
>  			      struct iommu_iotlb_gather *, unsigned long,
>  			      size_t, int, arm_v7s_iopte *);
>  
> -static int arm_v7s_init_pte(struct arm_v7s_io_pgtable *data,
> -			    unsigned long iova, phys_addr_t paddr, int prot,
> -			    int lvl, int num_entries, arm_v7s_iopte *ptep)
> +static int arm_v7s_init_pte(struct io_pgtable *iop,
> +			    struct arm_v7s_io_pgtable *data, unsigned long iova,
> +			    phys_addr_t paddr, int prot, int lvl,
> +			    int num_entries, arm_v7s_iopte *ptep)
>  {
>  	struct io_pgtable_cfg *cfg = &data->iop.cfg;
>  	arm_v7s_iopte pte;
> @@ -446,7 +446,7 @@ static int arm_v7s_init_pte(struct arm_v7s_io_pgtable *data,
>  			size_t sz = ARM_V7S_BLOCK_SIZE(lvl);
>  
>  			tblp = ptep - ARM_V7S_LVL_IDX(iova, lvl, cfg);
> -			if (WARN_ON(__arm_v7s_unmap(data, NULL, iova + i * sz,
> +			if (WARN_ON(__arm_v7s_unmap(iop, data, NULL, iova + i * sz,
>  						    sz, lvl, tblp) != sz))
>  				return -EINVAL;
>  		} else if (ptep[i]) {
> @@ -494,9 +494,9 @@ static arm_v7s_iopte arm_v7s_install_table(arm_v7s_iopte *table,
>  	return old;
>  }
>  
> -static int __arm_v7s_map(struct arm_v7s_io_pgtable *data, unsigned long iova,
> -			 phys_addr_t paddr, size_t size, int prot,
> -			 int lvl, arm_v7s_iopte *ptep, gfp_t gfp)
> +static int __arm_v7s_map(struct io_pgtable *iop, struct arm_v7s_io_pgtable *data,
> +			 unsigned long iova, phys_addr_t paddr, size_t size,
> +			 int prot, int lvl, arm_v7s_iopte *ptep, gfp_t gfp)
>  {
>  	struct io_pgtable_cfg *cfg = &data->iop.cfg;
>  	arm_v7s_iopte pte, *cptep;
> @@ -507,7 +507,7 @@ static int __arm_v7s_map(struct arm_v7s_io_pgtable *data, unsigned long iova,
>  
>  	/* If we can install a leaf entry at this level, then do so */
>  	if (num_entries)
> -		return arm_v7s_init_pte(data, iova, paddr, prot,
> +		return arm_v7s_init_pte(iop, data, iova, paddr, prot,
>  					lvl, num_entries, ptep);
>  
>  	/* We can't allocate tables at the final level */
> @@ -538,14 +538,14 @@ static int __arm_v7s_map(struct arm_v7s_io_pgtable *data, unsigned long iova,
>  	}
>  
>  	/* Rinse, repeat */
> -	return __arm_v7s_map(data, iova, paddr, size, prot, lvl + 1, cptep, gfp);
> +	return __arm_v7s_map(iop, data, iova, paddr, size, prot, lvl + 1, cptep, gfp);
>  }
>  
> -static int arm_v7s_map_pages(struct io_pgtable_ops *ops, unsigned long iova,
> +static int arm_v7s_map_pages(struct io_pgtable *iop, unsigned long iova,
>  			     phys_addr_t paddr, size_t pgsize, size_t pgcount,
>  			     int prot, gfp_t gfp, size_t *mapped)
>  {
> -	struct arm_v7s_io_pgtable *data = io_pgtable_ops_to_data(ops);
> +	struct arm_v7s_io_pgtable *data = io_pgtable_ops_to_data(iop->ops);
>  	int ret = -EINVAL;
>  
>  	if (WARN_ON(iova >= (1ULL << data->iop.cfg.ias) ||
> @@ -557,8 +557,8 @@ static int arm_v7s_map_pages(struct io_pgtable_ops *ops, unsigned long iova,
>  		return 0;
>  
>  	while (pgcount--) {
> -		ret = __arm_v7s_map(data, iova, paddr, pgsize, prot, 1, data->pgd,
> -				    gfp);
> +		ret = __arm_v7s_map(iop, data, iova, paddr, pgsize, prot, 1,
> +				    iop->pgd, gfp);
>  		if (ret)
>  			break;
>  
> @@ -577,26 +577,26 @@ static int arm_v7s_map_pages(struct io_pgtable_ops *ops, unsigned long iova,
>  
>  static void arm_v7s_free_pgtable(struct io_pgtable *iop)
>  {
> -	struct arm_v7s_io_pgtable *data = io_pgtable_to_data(iop);
> +	struct arm_v7s_io_pgtable *data = io_pgtable_ops_to_data(iop->ops);
> +	arm_v7s_iopte *ptep = iop->pgd;
>  	int i;
>  
> -	for (i = 0; i < ARM_V7S_PTES_PER_LVL(1, &data->iop.cfg); i++) {
> -		arm_v7s_iopte pte = data->pgd[i];
> -
> -		if (ARM_V7S_PTE_IS_TABLE(pte, 1))
> -			__arm_v7s_free_table(iopte_deref(pte, 1, data),
> +	for (i = 0; i < ARM_V7S_PTES_PER_LVL(1, &data->iop.cfg); i++, ptep++) {
> +		if (ARM_V7S_PTE_IS_TABLE(*ptep, 1))
> +			__arm_v7s_free_table(iopte_deref(*ptep, 1, data),
>  					     2, data);
>  	}
> -	__arm_v7s_free_table(data->pgd, 1, data);
> +	__arm_v7s_free_table(iop->pgd, 1, data);
>  	kmem_cache_destroy(data->l2_tables);
>  	kfree(data);
>  }
>  
> -static arm_v7s_iopte arm_v7s_split_cont(struct arm_v7s_io_pgtable *data,
> +static arm_v7s_iopte arm_v7s_split_cont(struct io_pgtable *iop,
> +					struct arm_v7s_io_pgtable *data,
>  					unsigned long iova, int idx, int lvl,
>  					arm_v7s_iopte *ptep)
>  {
> -	struct io_pgtable *iop = &data->iop;
> +	struct io_pgtable_cfg *cfg = &data->iop.cfg;
>  	arm_v7s_iopte pte;
>  	size_t size = ARM_V7S_BLOCK_SIZE(lvl);
>  	int i;
> @@ -611,14 +611,15 @@ static arm_v7s_iopte arm_v7s_split_cont(struct arm_v7s_io_pgtable *data,
>  	for (i = 0; i < ARM_V7S_CONT_PAGES; i++)
>  		ptep[i] = pte + i * size;
>  
> -	__arm_v7s_pte_sync(ptep, ARM_V7S_CONT_PAGES, &iop->cfg);
> +	__arm_v7s_pte_sync(ptep, ARM_V7S_CONT_PAGES, cfg);
>  
>  	size *= ARM_V7S_CONT_PAGES;
> -	io_pgtable_tlb_flush_walk(iop, iova, size, size);
> +	io_pgtable_tlb_flush_walk(cfg, iop, iova, size, size);
>  	return pte;
>  }
>  
> -static size_t arm_v7s_split_blk_unmap(struct arm_v7s_io_pgtable *data,
> +static size_t arm_v7s_split_blk_unmap(struct io_pgtable *iop,
> +				      struct arm_v7s_io_pgtable *data,
>  				      struct iommu_iotlb_gather *gather,
>  				      unsigned long iova, size_t size,
>  				      arm_v7s_iopte blk_pte,
> @@ -656,27 +657,28 @@ static size_t arm_v7s_split_blk_unmap(struct arm_v7s_io_pgtable *data,
>  			return 0;
>  
>  		tablep = iopte_deref(pte, 1, data);
> -		return __arm_v7s_unmap(data, gather, iova, size, 2, tablep);
> +		return __arm_v7s_unmap(iop, data, gather, iova, size, 2, tablep);
>  	}
>  
> -	io_pgtable_tlb_add_page(&data->iop, gather, iova, size);
> +	io_pgtable_tlb_add_page(cfg, iop, gather, iova, size);
>  	return size;
>  }
>  
> -static size_t __arm_v7s_unmap(struct arm_v7s_io_pgtable *data,
> +static size_t __arm_v7s_unmap(struct io_pgtable *iop,
> +			      struct arm_v7s_io_pgtable *data,
>  			      struct iommu_iotlb_gather *gather,
>  			      unsigned long iova, size_t size, int lvl,
>  			      arm_v7s_iopte *ptep)
>  {
>  	arm_v7s_iopte pte[ARM_V7S_CONT_PAGES];
> -	struct io_pgtable *iop = &data->iop;
> +	struct io_pgtable_cfg *cfg = &data->iop.cfg;
>  	int idx, i = 0, num_entries = size >> ARM_V7S_LVL_SHIFT(lvl);
>  
>  	/* Something went horribly wrong and we ran out of page table */
>  	if (WARN_ON(lvl > 2))
>  		return 0;
>  
> -	idx = ARM_V7S_LVL_IDX(iova, lvl, &iop->cfg);
> +	idx = ARM_V7S_LVL_IDX(iova, lvl, cfg);
>  	ptep += idx;
>  	do {
>  		pte[i] = READ_ONCE(ptep[i]);
> @@ -698,7 +700,7 @@ static size_t __arm_v7s_unmap(struct arm_v7s_io_pgtable *data,
>  		unsigned long flags;
>  
>  		spin_lock_irqsave(&data->split_lock, flags);
> -		pte[0] = arm_v7s_split_cont(data, iova, idx, lvl, ptep);
> +		pte[0] = arm_v7s_split_cont(iop, data, iova, idx, lvl, ptep);
>  		spin_unlock_irqrestore(&data->split_lock, flags);
>  	}
>  
> @@ -706,17 +708,18 @@ static size_t __arm_v7s_unmap(struct arm_v7s_io_pgtable *data,
>  	if (num_entries) {
>  		size_t blk_size = ARM_V7S_BLOCK_SIZE(lvl);
>  
> -		__arm_v7s_set_pte(ptep, 0, num_entries, &iop->cfg);
> +		__arm_v7s_set_pte(ptep, 0, num_entries, cfg);
>  
>  		for (i = 0; i < num_entries; i++) {
>  			if (ARM_V7S_PTE_IS_TABLE(pte[i], lvl)) {
>  				/* Also flush any partial walks */
> -				io_pgtable_tlb_flush_walk(iop, iova, blk_size,
> +				io_pgtable_tlb_flush_walk(cfg, iop, iova, blk_size,
>  						ARM_V7S_BLOCK_SIZE(lvl + 1));
>  				ptep = iopte_deref(pte[i], lvl, data);
>  				__arm_v7s_free_table(ptep, lvl + 1, data);
>  			} else if (!iommu_iotlb_gather_queued(gather)) {
> -				io_pgtable_tlb_add_page(iop, gather, iova, blk_size);
> +				io_pgtable_tlb_add_page(cfg, iop, gather, iova,
> +							blk_size);
>  			}
>  			iova += blk_size;
>  		}
> @@ -726,27 +729,27 @@ static size_t __arm_v7s_unmap(struct arm_v7s_io_pgtable *data,
>  		 * Insert a table at the next level to map the old region,
>  		 * minus the part we want to unmap
>  		 */
> -		return arm_v7s_split_blk_unmap(data, gather, iova, size, pte[0],
> -					       ptep);
> +		return arm_v7s_split_blk_unmap(iop, data, gather, iova, size,
> +					       pte[0], ptep);
>  	}
>  
>  	/* Keep on walkin' */
>  	ptep = iopte_deref(pte[0], lvl, data);
> -	return __arm_v7s_unmap(data, gather, iova, size, lvl + 1, ptep);
> +	return __arm_v7s_unmap(iop, data, gather, iova, size, lvl + 1, ptep);
>  }
>  
> -static size_t arm_v7s_unmap_pages(struct io_pgtable_ops *ops, unsigned long iova,
> +static size_t arm_v7s_unmap_pages(struct io_pgtable *iop, unsigned long iova,
>  				  size_t pgsize, size_t pgcount,
>  				  struct iommu_iotlb_gather *gather)
>  {
> -	struct arm_v7s_io_pgtable *data = io_pgtable_ops_to_data(ops);
> +	struct arm_v7s_io_pgtable *data = io_pgtable_ops_to_data(iop->ops);
>  	size_t unmapped = 0, ret;
>  
>  	if (WARN_ON(iova >= (1ULL << data->iop.cfg.ias)))
>  		return 0;
>  
>  	while (pgcount--) {
> -		ret = __arm_v7s_unmap(data, gather, iova, pgsize, 1, data->pgd);
> +		ret = __arm_v7s_unmap(iop, data, gather, iova, pgsize, 1, iop->pgd);
>  		if (!ret)
>  			break;
>  
> @@ -757,11 +760,11 @@ static size_t arm_v7s_unmap_pages(struct io_pgtable_ops *ops, unsigned long iova
>  	return unmapped;
>  }
>  
> -static phys_addr_t arm_v7s_iova_to_phys(struct io_pgtable_ops *ops,
> +static phys_addr_t arm_v7s_iova_to_phys(struct io_pgtable *iop,
>  					unsigned long iova)
>  {
> -	struct arm_v7s_io_pgtable *data = io_pgtable_ops_to_data(ops);
> -	arm_v7s_iopte *ptep = data->pgd, pte;
> +	struct arm_v7s_io_pgtable *data = io_pgtable_ops_to_data(iop->ops);
> +	arm_v7s_iopte *ptep = iop->pgd, pte;
>  	int lvl = 0;
>  	u32 mask;
>  
> @@ -780,37 +783,37 @@ static phys_addr_t arm_v7s_iova_to_phys(struct io_pgtable_ops *ops,
>  	return iopte_to_paddr(pte, lvl, &data->iop.cfg) | (iova & ~mask);
>  }
>  
> -static struct io_pgtable *arm_v7s_alloc_pgtable(struct io_pgtable_cfg *cfg,
> -						void *cookie)
> +static int arm_v7s_alloc_pgtable(struct io_pgtable *iop,
> +				 struct io_pgtable_cfg *cfg, void *cookie)
>  {
>  	struct arm_v7s_io_pgtable *data;
>  	slab_flags_t slab_flag;
>  	phys_addr_t paddr;
>  
>  	if (cfg->ias > (arm_v7s_is_mtk_enabled(cfg) ? 34 : ARM_V7S_ADDR_BITS))
> -		return NULL;
> +		return -EINVAL;
>  
>  	if (cfg->oas > (arm_v7s_is_mtk_enabled(cfg) ? 35 : ARM_V7S_ADDR_BITS))
> -		return NULL;
> +		return -EINVAL;
>  
>  	if (cfg->quirks & ~(IO_PGTABLE_QUIRK_ARM_NS |
>  			    IO_PGTABLE_QUIRK_NO_PERMS |
>  			    IO_PGTABLE_QUIRK_ARM_MTK_EXT |
>  			    IO_PGTABLE_QUIRK_ARM_MTK_TTBR_EXT))
> -		return NULL;
> +		return -EINVAL;
>  
>  	/* If ARM_MTK_4GB is enabled, the NO_PERMS is also expected. */
>  	if (cfg->quirks & IO_PGTABLE_QUIRK_ARM_MTK_EXT &&
>  	    !(cfg->quirks & IO_PGTABLE_QUIRK_NO_PERMS))
> -			return NULL;
> +		return -EINVAL;
>  
>  	if ((cfg->quirks & IO_PGTABLE_QUIRK_ARM_MTK_TTBR_EXT) &&
>  	    !arm_v7s_is_mtk_enabled(cfg))
> -		return NULL;
> +		return -EINVAL;
>  
>  	data = kmalloc(sizeof(*data), GFP_KERNEL);
>  	if (!data)
> -		return NULL;
> +		return -ENOMEM;
>  
>  	spin_lock_init(&data->split_lock);
>  
> @@ -860,15 +863,15 @@ static struct io_pgtable *arm_v7s_alloc_pgtable(struct io_pgtable_cfg *cfg,
>  				ARM_V7S_NMRR_OR(7, ARM_V7S_RGN_WBWA);
>  
>  	/* Looking good; allocate a pgd */
> -	data->pgd = __arm_v7s_alloc_table(1, GFP_KERNEL, data);
> -	if (!data->pgd)
> +	iop->pgd = __arm_v7s_alloc_table(1, GFP_KERNEL, data);
> +	if (!iop->pgd)
>  		goto out_free_data;
>  
>  	/* Ensure the empty pgd is visible before any actual TTBR write */
>  	wmb();
>  
>  	/* TTBR */
> -	paddr = virt_to_phys(data->pgd);
> +	paddr = virt_to_phys(iop->pgd);
>  	if (arm_v7s_is_mtk_enabled(cfg))
>  		cfg->arm_v7s_cfg.ttbr = paddr | upper_32_bits(paddr);
>  	else
> @@ -878,12 +881,13 @@ static struct io_pgtable *arm_v7s_alloc_pgtable(struct io_pgtable_cfg *cfg,
>  					 ARM_V7S_TTBR_ORGN_ATTR(ARM_V7S_RGN_WBWA)) :
>  					(ARM_V7S_TTBR_IRGN_ATTR(ARM_V7S_RGN_NC) |
>  					 ARM_V7S_TTBR_ORGN_ATTR(ARM_V7S_RGN_NC)));
> -	return &data->iop;
> +	iop->ops = &data->iop.ops;
> +	return 0;
>  
>  out_free_data:
>  	kmem_cache_destroy(data->l2_tables);
>  	kfree(data);
> -	return NULL;
> +	return -EINVAL;
>  }
>  
>  struct io_pgtable_init_fns io_pgtable_arm_v7s_init_fns = {
> @@ -920,7 +924,7 @@ static const struct iommu_flush_ops dummy_tlb_ops __initconst = {
>  	.tlb_add_page	= dummy_tlb_add_page,
>  };
>  
> -#define __FAIL(ops)	({				\
> +#define __FAIL()	({				\
>  		WARN(1, "selftest: test failed\n");	\
>  		selftest_running = false;		\
>  		-EFAULT;				\
> @@ -928,7 +932,7 @@ static const struct iommu_flush_ops dummy_tlb_ops __initconst = {
>  
>  static int __init arm_v7s_do_selftests(void)
>  {
> -	struct io_pgtable_ops *ops;
> +	struct io_pgtable iop;
>  	struct io_pgtable_cfg cfg = {
>  		.fmt = ARM_V7S,
>  		.tlb = &dummy_tlb_ops,
> @@ -946,8 +950,7 @@ static int __init arm_v7s_do_selftests(void)
>  
>  	cfg_cookie = &cfg;
>  
> -	ops = alloc_io_pgtable_ops(&cfg, &cfg);
> -	if (!ops) {
> +	if (alloc_io_pgtable_ops(&iop, &cfg, &cfg)) {
>  		pr_err("selftest: failed to allocate io pgtable ops\n");
>  		return -EINVAL;
>  	}
> @@ -956,14 +959,14 @@ static int __init arm_v7s_do_selftests(void)
>  	 * Initial sanity checks.
>  	 * Empty page tables shouldn't provide any translations.
>  	 */
> -	if (ops->iova_to_phys(ops, 42))
> -		return __FAIL(ops);
> +	if (iopt_iova_to_phys(&iop, 42))
> +		return __FAIL();
>  
> -	if (ops->iova_to_phys(ops, SZ_1G + 42))
> -		return __FAIL(ops);
> +	if (iopt_iova_to_phys(&iop, SZ_1G + 42))
> +		return __FAIL();
>  
> -	if (ops->iova_to_phys(ops, SZ_2G + 42))
> -		return __FAIL(ops);
> +	if (iopt_iova_to_phys(&iop, SZ_2G + 42))
> +		return __FAIL();
>  
>  	/*
>  	 * Distinct mappings of different granule sizes.
> @@ -971,20 +974,20 @@ static int __init arm_v7s_do_selftests(void)
>  	iova = 0;
>  	for_each_set_bit(i, &cfg.pgsize_bitmap, BITS_PER_LONG) {
>  		size = 1UL << i;
> -		if (ops->map_pages(ops, iova, iova, size, 1,
> +		if (iopt_map_pages(&iop, iova, iova, size, 1,
>  				   IOMMU_READ | IOMMU_WRITE |
>  				   IOMMU_NOEXEC | IOMMU_CACHE,
>  				   GFP_KERNEL, &mapped))
> -			return __FAIL(ops);
> +			return __FAIL();
>  
>  		/* Overlapping mappings */
> -		if (!ops->map_pages(ops, iova, iova + size, size, 1,
> +		if (!iopt_map_pages(&iop, iova, iova + size, size, 1,
>  				    IOMMU_READ | IOMMU_NOEXEC, GFP_KERNEL,
>  				    &mapped))
> -			return __FAIL(ops);
> +			return __FAIL();
>  
> -		if (ops->iova_to_phys(ops, iova + 42) != (iova + 42))
> -			return __FAIL(ops);
> +		if (iopt_iova_to_phys(&iop, iova + 42) != (iova + 42))
> +			return __FAIL();
>  
>  		iova += SZ_16M;
>  		loopnr++;
> @@ -995,17 +998,17 @@ static int __init arm_v7s_do_selftests(void)
>  	size = 1UL << __ffs(cfg.pgsize_bitmap);
>  	while (i < loopnr) {
>  		iova_start = i * SZ_16M;
> -		if (ops->unmap_pages(ops, iova_start + size, size, 1, NULL) != size)
> -			return __FAIL(ops);
> +		if (iopt_unmap_pages(&iop, iova_start + size, size, 1, NULL) != size)
> +			return __FAIL();
>  
>  		/* Remap of partial unmap */
> -		if (ops->map_pages(ops, iova_start + size, size, size, 1,
> +		if (iopt_map_pages(&iop, iova_start + size, size, size, 1,
>  				   IOMMU_READ, GFP_KERNEL, &mapped))
> -			return __FAIL(ops);
> +			return __FAIL();
>  
> -		if (ops->iova_to_phys(ops, iova_start + size + 42)
> +		if (iopt_iova_to_phys(&iop, iova_start + size + 42)
>  		    != (size + 42))
> -			return __FAIL(ops);
> +			return __FAIL();
>  		i++;
>  	}
>  
> @@ -1014,24 +1017,24 @@ static int __init arm_v7s_do_selftests(void)
>  	for_each_set_bit(i, &cfg.pgsize_bitmap, BITS_PER_LONG) {
>  		size = 1UL << i;
>  
> -		if (ops->unmap_pages(ops, iova, size, 1, NULL) != size)
> -			return __FAIL(ops);
> +		if (iopt_unmap_pages(&iop, iova, size, 1, NULL) != size)
> +			return __FAIL();
>  
> -		if (ops->iova_to_phys(ops, iova + 42))
> -			return __FAIL(ops);
> +		if (iopt_iova_to_phys(&iop, iova + 42))
> +			return __FAIL();
>  
>  		/* Remap full block */
> -		if (ops->map_pages(ops, iova, iova, size, 1, IOMMU_WRITE,
> +		if (iopt_map_pages(&iop, iova, iova, size, 1, IOMMU_WRITE,
>  				   GFP_KERNEL, &mapped))
> -			return __FAIL(ops);
> +			return __FAIL();
>  
> -		if (ops->iova_to_phys(ops, iova + 42) != (iova + 42))
> -			return __FAIL(ops);
> +		if (iopt_iova_to_phys(&iop, iova + 42) != (iova + 42))
> +			return __FAIL();
>  
>  		iova += SZ_16M;
>  	}
>  
> -	free_io_pgtable_ops(ops);
> +	free_io_pgtable_ops(&iop);
>  
>  	selftest_running = false;
>  
> diff --git a/drivers/iommu/io-pgtable-arm.c b/drivers/iommu/io-pgtable-arm.c
> index c412500efadf..bee8980c89eb 100644
> --- a/drivers/iommu/io-pgtable-arm.c
> +++ b/drivers/iommu/io-pgtable-arm.c
> @@ -82,40 +82,40 @@ void __arm_lpae_sync_pte(arm_lpae_iopte *ptep, int num_entries,
>  
>  static void arm_lpae_free_pgtable(struct io_pgtable *iop)
>  {
> -	struct arm_lpae_io_pgtable *data = io_pgtable_to_data(iop);
> +	struct arm_lpae_io_pgtable *data = io_pgtable_ops_to_data(iop->ops);
>  
> -	__arm_lpae_free_pgtable(data, data->start_level, data->pgd);
> +	__arm_lpae_free_pgtable(data, data->start_level, iop->pgd);
>  	kfree(data);
>  }
>  
> -static struct io_pgtable *
> -arm_64_lpae_alloc_pgtable_s1(struct io_pgtable_cfg *cfg, void *cookie)
> +int arm_64_lpae_alloc_pgtable_s1(struct io_pgtable *iop,
> +				 struct io_pgtable_cfg *cfg, void *cookie)
>  {
>  	struct arm_lpae_io_pgtable *data;
>  
>  	data = kzalloc(sizeof(*data), GFP_KERNEL);
>  	if (!data)
> -		return NULL;
> +		return -ENOMEM;
>  
>  	if (arm_lpae_init_pgtable_s1(cfg, data))
>  		goto out_free_data;
>  
>  	/* Looking good; allocate a pgd */
> -	data->pgd = __arm_lpae_alloc_pages(ARM_LPAE_PGD_SIZE(data),
> -					   GFP_KERNEL, cfg);
> -	if (!data->pgd)
> +	iop->pgd = __arm_lpae_alloc_pages(ARM_LPAE_PGD_SIZE(data),
> +					  GFP_KERNEL, cfg);
> +	if (!iop->pgd)
>  		goto out_free_data;
>  
>  	/* Ensure the empty pgd is visible before any actual TTBR write */
>  	wmb();
>  
> -	/* TTBR */
> -	cfg->arm_lpae_s1_cfg.ttbr = virt_to_phys(data->pgd);
> -	return &data->iop;
> +	cfg->arm_lpae_s1_cfg.ttbr = virt_to_phys(iop->pgd);
> +	iop->ops = &data->iop.ops;
> +	return 0;
>  
>  out_free_data:
>  	kfree(data);
> -	return NULL;
> +	return -EINVAL;
>  }
>  
>  static int arm_64_lpae_configure_s1(struct io_pgtable_cfg *cfg, size_t *pgd_size)
> @@ -130,34 +130,35 @@ static int arm_64_lpae_configure_s1(struct io_pgtable_cfg *cfg, size_t *pgd_size
>  	return 0;
>  }
>  
> -static struct io_pgtable *
> -arm_64_lpae_alloc_pgtable_s2(struct io_pgtable_cfg *cfg, void *cookie)
> +int arm_64_lpae_alloc_pgtable_s2(struct io_pgtable *iop,
> +				 struct io_pgtable_cfg *cfg, void *cookie)
>  {
>  	struct arm_lpae_io_pgtable *data;
>  
>  	data = kzalloc(sizeof(*data), GFP_KERNEL);
>  	if (!data)
> -		return NULL;
> +		return -ENOMEM;
>  
>  	if (arm_lpae_init_pgtable_s2(cfg, data))
>  		goto out_free_data;
>  
>  	/* Allocate pgd pages */
> -	data->pgd = __arm_lpae_alloc_pages(ARM_LPAE_PGD_SIZE(data),
> -					   GFP_KERNEL, cfg);
> -	if (!data->pgd)
> +	iop->pgd = __arm_lpae_alloc_pages(ARM_LPAE_PGD_SIZE(data),
> +					  GFP_KERNEL, cfg);
> +	if (!iop->pgd)
>  		goto out_free_data;
>  
>  	/* Ensure the empty pgd is visible before any actual TTBR write */
>  	wmb();
>  
>  	/* VTTBR */
> -	cfg->arm_lpae_s2_cfg.vttbr = virt_to_phys(data->pgd);
> -	return &data->iop;
> +	cfg->arm_lpae_s2_cfg.vttbr = virt_to_phys(iop->pgd);
> +	iop->ops = &data->iop.ops;
> +	return 0;
>  
>  out_free_data:
>  	kfree(data);
> -	return NULL;
> +	return -EINVAL;
>  }
>  
>  static int arm_64_lpae_configure_s2(struct io_pgtable_cfg *cfg, size_t *pgd_size)
> @@ -172,46 +173,46 @@ static int arm_64_lpae_configure_s2(struct io_pgtable_cfg *cfg, size_t *pgd_size
>  	return 0;
>  }
>  
> -static struct io_pgtable *
> -arm_32_lpae_alloc_pgtable_s1(struct io_pgtable_cfg *cfg, void *cookie)
> +int arm_32_lpae_alloc_pgtable_s1(struct io_pgtable *iop,
> +				 struct io_pgtable_cfg *cfg, void *cookie)
>  {
>  	if (cfg->ias > 32 || cfg->oas > 40)
> -		return NULL;
> +		return -EINVAL;
>  
>  	cfg->pgsize_bitmap &= (SZ_4K | SZ_2M | SZ_1G);
> -	return arm_64_lpae_alloc_pgtable_s1(cfg, cookie);
> +	return arm_64_lpae_alloc_pgtable_s1(iop, cfg, cookie);
>  }
>  
> -static struct io_pgtable *
> -arm_32_lpae_alloc_pgtable_s2(struct io_pgtable_cfg *cfg, void *cookie)
> +int arm_32_lpae_alloc_pgtable_s2(struct io_pgtable *iop,
> +				 struct io_pgtable_cfg *cfg, void *cookie)
>  {
>  	if (cfg->ias > 40 || cfg->oas > 40)
> -		return NULL;
> +		return -EINVAL;
>  
>  	cfg->pgsize_bitmap &= (SZ_4K | SZ_2M | SZ_1G);
> -	return arm_64_lpae_alloc_pgtable_s2(cfg, cookie);
> +	return arm_64_lpae_alloc_pgtable_s2(iop, cfg, cookie);
>  }
>  
> -static struct io_pgtable *
> -arm_mali_lpae_alloc_pgtable(struct io_pgtable_cfg *cfg, void *cookie)
> +int arm_mali_lpae_alloc_pgtable(struct io_pgtable *iop,
> +				struct io_pgtable_cfg *cfg, void *cookie)
>  {
>  	struct arm_lpae_io_pgtable *data;
>  
>  	/* No quirks for Mali (hopefully) */
>  	if (cfg->quirks)
> -		return NULL;
> +		return -EINVAL;
>  
>  	if (cfg->ias > 48 || cfg->oas > 40)
> -		return NULL;
> +		return -EINVAL;
>  
>  	cfg->pgsize_bitmap &= (SZ_4K | SZ_2M | SZ_1G);
>  
>  	data = kzalloc(sizeof(*data), GFP_KERNEL);
>  	if (!data)
> -		return NULL;
> +		return -ENOMEM;
>  
>  	if (arm_lpae_init_pgtable(cfg, data))
> -		return NULL;
> +		goto out_free_data;
>  
>  	/* Mali seems to need a full 4-level table regardless of IAS */
>  	if (data->start_level > 0) {
> @@ -233,25 +234,26 @@ arm_mali_lpae_alloc_pgtable(struct io_pgtable_cfg *cfg, void *cookie)
>  		(ARM_MALI_LPAE_MEMATTR_IMP_DEF
>  		 << ARM_LPAE_MAIR_ATTR_SHIFT(ARM_LPAE_MAIR_ATTR_IDX_DEV));
>  
> -	data->pgd = __arm_lpae_alloc_pages(ARM_LPAE_PGD_SIZE(data), GFP_KERNEL,
> -					   cfg);
> -	if (!data->pgd)
> +	iop->pgd = __arm_lpae_alloc_pages(ARM_LPAE_PGD_SIZE(data), GFP_KERNEL,
> +					  cfg);
> +	if (!iop->pgd)
>  		goto out_free_data;
>  
>  	/* Ensure the empty pgd is visible before TRANSTAB can be written */
>  	wmb();
>  
> -	cfg->arm_mali_lpae_cfg.transtab = virt_to_phys(data->pgd) |
> +	cfg->arm_mali_lpae_cfg.transtab = virt_to_phys(iop->pgd) |
>  					  ARM_MALI_LPAE_TTBR_READ_INNER |
>  					  ARM_MALI_LPAE_TTBR_ADRMODE_TABLE;
>  	if (cfg->coherent_walk)
>  		cfg->arm_mali_lpae_cfg.transtab |= ARM_MALI_LPAE_TTBR_SHARE_OUTER;
>  
> -	return &data->iop;
> +	iop->ops = &data->iop.ops;
> +	return 0;
>  
>  out_free_data:
>  	kfree(data);
> -	return NULL;
> +	return -EINVAL;
>  }
>  
>  struct io_pgtable_init_fns io_pgtable_arm_64_lpae_s1_init_fns = {
> @@ -310,21 +312,21 @@ static const struct iommu_flush_ops dummy_tlb_ops __initconst = {
>  	.tlb_add_page	= dummy_tlb_add_page,
>  };
>  
> -static void __init arm_lpae_dump_ops(struct io_pgtable_ops *ops)
> +static void __init arm_lpae_dump_ops(struct io_pgtable *iop)
>  {
> -	struct arm_lpae_io_pgtable *data = io_pgtable_ops_to_data(ops);
> +	struct arm_lpae_io_pgtable *data = io_pgtable_ops_to_data(iop->ops);
>  	struct io_pgtable_cfg *cfg = &data->iop.cfg;
>  
>  	pr_err("cfg: pgsize_bitmap 0x%lx, ias %u-bit\n",
>  		cfg->pgsize_bitmap, cfg->ias);
>  	pr_err("data: %d levels, 0x%zx pgd_size, %u pg_shift, %u bits_per_level, pgd @ %p\n",
>  		ARM_LPAE_MAX_LEVELS - data->start_level, ARM_LPAE_PGD_SIZE(data),
> -		ilog2(ARM_LPAE_GRANULE(data)), data->bits_per_level, data->pgd);
> +		ilog2(ARM_LPAE_GRANULE(data)), data->bits_per_level, iop->pgd);
>  }
>  
> -#define __FAIL(ops, i)	({						\
> +#define __FAIL(iop, i)	({						\
>  		WARN(1, "selftest: test failed for fmt idx %d\n", (i));	\
> -		arm_lpae_dump_ops(ops);					\
> +		arm_lpae_dump_ops(iop);					\
>  		selftest_running = false;				\
>  		-EFAULT;						\
>  })
> @@ -336,34 +338,34 @@ static int __init arm_lpae_run_tests(struct io_pgtable_cfg *cfg)
>  		ARM_64_LPAE_S2,
>  	};
>  
> -	int i, j;
> +	int i, j, ret;
>  	unsigned long iova;
>  	size_t size, mapped;
> -	struct io_pgtable_ops *ops;
> +	struct io_pgtable iop;
>  
>  	selftest_running = true;
>  
>  	for (i = 0; i < ARRAY_SIZE(fmts); ++i) {
>  		cfg_cookie = cfg;
>  		cfg->fmt = fmts[i];
> -		ops = alloc_io_pgtable_ops(cfg, cfg);
> -		if (!ops) {
> +		ret = alloc_io_pgtable_ops(&iop, cfg, cfg);
> +		if (ret) {
>  			pr_err("selftest: failed to allocate io pgtable ops\n");
> -			return -ENOMEM;
> +			return ret;
>  		}
>  
>  		/*
>  		 * Initial sanity checks.
>  		 * Empty page tables shouldn't provide any translations.
>  		 */
> -		if (ops->iova_to_phys(ops, 42))
> -			return __FAIL(ops, i);
> +		if (iopt_iova_to_phys(&iop, 42))
> +			return __FAIL(&iop, i);
>  
> -		if (ops->iova_to_phys(ops, SZ_1G + 42))
> -			return __FAIL(ops, i);
> +		if (iopt_iova_to_phys(&iop, SZ_1G + 42))
> +			return __FAIL(&iop, i);
>  
> -		if (ops->iova_to_phys(ops, SZ_2G + 42))
> -			return __FAIL(ops, i);
> +		if (iopt_iova_to_phys(&iop, SZ_2G + 42))
> +			return __FAIL(&iop, i);
>  
>  		/*
>  		 * Distinct mappings of different granule sizes.
> @@ -372,60 +374,60 @@ static int __init arm_lpae_run_tests(struct io_pgtable_cfg *cfg)
>  		for_each_set_bit(j, &cfg->pgsize_bitmap, BITS_PER_LONG) {
>  			size = 1UL << j;
>  
> -			if (ops->map_pages(ops, iova, iova, size, 1,
> +			if (iopt_map_pages(&iop, iova, iova, size, 1,
>  					   IOMMU_READ | IOMMU_WRITE |
>  					   IOMMU_NOEXEC | IOMMU_CACHE,
>  					   GFP_KERNEL, &mapped))
> -				return __FAIL(ops, i);
> +				return __FAIL(&iop, i);
>  
>  			/* Overlapping mappings */
> -			if (!ops->map_pages(ops, iova, iova + size, size, 1,
> +			if (!iopt_map_pages(&iop, iova, iova + size, size, 1,
>  					    IOMMU_READ | IOMMU_NOEXEC,
>  					    GFP_KERNEL, &mapped))
> -				return __FAIL(ops, i);
> +				return __FAIL(&iop, i);
>  
> -			if (ops->iova_to_phys(ops, iova + 42) != (iova + 42))
> -				return __FAIL(ops, i);
> +			if (iopt_iova_to_phys(&iop, iova + 42) != (iova + 42))
> +				return __FAIL(&iop, i);
>  
>  			iova += SZ_1G;
>  		}
>  
>  		/* Partial unmap */
>  		size = 1UL << __ffs(cfg->pgsize_bitmap);
> -		if (ops->unmap_pages(ops, SZ_1G + size, size, 1, NULL) != size)
> -			return __FAIL(ops, i);
> +		if (iopt_unmap_pages(&iop, SZ_1G + size, size, 1, NULL) != size)
> +			return __FAIL(&iop, i);
>  
>  		/* Remap of partial unmap */
> -		if (ops->map_pages(ops, SZ_1G + size, size, size, 1,
> +		if (iopt_map_pages(&iop, SZ_1G + size, size, size, 1,
>  				   IOMMU_READ, GFP_KERNEL, &mapped))
> -			return __FAIL(ops, i);
> +			return __FAIL(&iop, i);
>  
> -		if (ops->iova_to_phys(ops, SZ_1G + size + 42) != (size + 42))
> -			return __FAIL(ops, i);
> +		if (iopt_iova_to_phys(&iop, SZ_1G + size + 42) != (size + 42))
> +			return __FAIL(&iop, i);
>  
>  		/* Full unmap */
>  		iova = 0;
>  		for_each_set_bit(j, &cfg->pgsize_bitmap, BITS_PER_LONG) {
>  			size = 1UL << j;
>  
> -			if (ops->unmap_pages(ops, iova, size, 1, NULL) != size)
> -				return __FAIL(ops, i);
> +			if (iopt_unmap_pages(&iop, iova, size, 1, NULL) != size)
> +				return __FAIL(&iop, i);
>  
> -			if (ops->iova_to_phys(ops, iova + 42))
> -				return __FAIL(ops, i);
> +			if (iopt_iova_to_phys(&iop, iova + 42))
> +				return __FAIL(&iop, i);
>  
>  			/* Remap full block */
> -			if (ops->map_pages(ops, iova, iova, size, 1,
> +			if (iopt_map_pages(&iop, iova, iova, size, 1,
>  					   IOMMU_WRITE, GFP_KERNEL, &mapped))
> -				return __FAIL(ops, i);
> +				return __FAIL(&iop, i);
>  
> -			if (ops->iova_to_phys(ops, iova + 42) != (iova + 42))
> -				return __FAIL(ops, i);
> +			if (iopt_iova_to_phys(&iop, iova + 42) != (iova + 42))
> +				return __FAIL(&iop, i);
>  
>  			iova += SZ_1G;
>  		}
>  
> -		free_io_pgtable_ops(ops);
> +		free_io_pgtable_ops(&iop);
>  	}
>  
>  	selftest_running = false;
> diff --git a/drivers/iommu/io-pgtable-dart.c b/drivers/iommu/io-pgtable-dart.c
> index f981b25d8c98..1bb2e91ed0a7 100644
> --- a/drivers/iommu/io-pgtable-dart.c
> +++ b/drivers/iommu/io-pgtable-dart.c
> @@ -34,7 +34,7 @@
>  	container_of((x), struct dart_io_pgtable, iop)
>  
>  #define io_pgtable_ops_to_data(x)					\
> -	io_pgtable_to_data(io_pgtable_ops_to_pgtable(x))
> +	io_pgtable_to_data(io_pgtable_ops_to_params(x))
>  
>  #define DART_GRANULE(d)						\
>  	(sizeof(dart_iopte) << (d)->bits_per_level)
> @@ -65,12 +65,10 @@
>  #define iopte_deref(pte, d) __va(iopte_to_paddr(pte, d))
>  
>  struct dart_io_pgtable {
> -	struct io_pgtable	iop;
> +	struct io_pgtable_params	iop;
>  
> -	int			tbl_bits;
> -	int			bits_per_level;
> -
> -	void			*pgd[DART_MAX_TABLES];
> +	int				tbl_bits;
> +	int				bits_per_level;
>  };
>  
>  typedef u64 dart_iopte;
> @@ -170,10 +168,14 @@ static dart_iopte dart_install_table(dart_iopte *table,
>  	return old;
>  }
>  
> -static int dart_get_table(struct dart_io_pgtable *data, unsigned long iova)
> +static dart_iopte *dart_get_table(struct io_pgtable *iop,
> +				  struct dart_io_pgtable *data,
> +				  unsigned long iova)
>  {
> -	return (iova >> (3 * data->bits_per_level + ilog2(sizeof(dart_iopte)))) &
> +	int tbl = (iova >> (3 * data->bits_per_level + ilog2(sizeof(dart_iopte)))) &
>  		((1 << data->tbl_bits) - 1);
> +
> +	return iop->pgd + DART_GRANULE(data) * tbl;
>  }
>  
>  static int dart_get_l1_index(struct dart_io_pgtable *data, unsigned long iova)
> @@ -190,12 +192,12 @@ static int dart_get_l2_index(struct dart_io_pgtable *data, unsigned long iova)
>  		 ((1 << data->bits_per_level) - 1);
>  }
>  
> -static  dart_iopte *dart_get_l2(struct dart_io_pgtable *data, unsigned long iova)
> +static  dart_iopte *dart_get_l2(struct io_pgtable *iop,
> +				struct dart_io_pgtable *data, unsigned long iova)
>  {
>  	dart_iopte pte, *ptep;
> -	int tbl = dart_get_table(data, iova);
>  
> -	ptep = data->pgd[tbl];
> +	ptep = dart_get_table(iop, data, iova);
>  	if (!ptep)
>  		return NULL;
>  
> @@ -233,14 +235,14 @@ static dart_iopte dart_prot_to_pte(struct dart_io_pgtable *data,
>  	return pte;
>  }
>  
> -static int dart_map_pages(struct io_pgtable_ops *ops, unsigned long iova,
> +static int dart_map_pages(struct io_pgtable *iop, unsigned long iova,
>  			      phys_addr_t paddr, size_t pgsize, size_t pgcount,
>  			      int iommu_prot, gfp_t gfp, size_t *mapped)
>  {
> -	struct dart_io_pgtable *data = io_pgtable_ops_to_data(ops);
> +	struct dart_io_pgtable *data = io_pgtable_ops_to_data(iop->ops);
>  	struct io_pgtable_cfg *cfg = &data->iop.cfg;
>  	size_t tblsz = DART_GRANULE(data);
> -	int ret = 0, tbl, num_entries, max_entries, map_idx_start;
> +	int ret = 0, num_entries, max_entries, map_idx_start;
>  	dart_iopte pte, *cptep, *ptep;
>  	dart_iopte prot;
>  
> @@ -254,9 +256,7 @@ static int dart_map_pages(struct io_pgtable_ops *ops, unsigned long iova,
>  	if (!(iommu_prot & (IOMMU_READ | IOMMU_WRITE)))
>  		return 0;
>  
> -	tbl = dart_get_table(data, iova);
> -
> -	ptep = data->pgd[tbl];
> +	ptep = dart_get_table(iop, data, iova);
>  	ptep += dart_get_l1_index(data, iova);
>  	pte = READ_ONCE(*ptep);
>  
> @@ -295,11 +295,11 @@ static int dart_map_pages(struct io_pgtable_ops *ops, unsigned long iova,
>  	return ret;
>  }
>  
> -static size_t dart_unmap_pages(struct io_pgtable_ops *ops, unsigned long iova,
> +static size_t dart_unmap_pages(struct io_pgtable *iop, unsigned long iova,
>  				   size_t pgsize, size_t pgcount,
>  				   struct iommu_iotlb_gather *gather)
>  {
> -	struct dart_io_pgtable *data = io_pgtable_ops_to_data(ops);
> +	struct dart_io_pgtable *data = io_pgtable_ops_to_data(iop->ops);
>  	struct io_pgtable_cfg *cfg = &data->iop.cfg;
>  	int i = 0, num_entries, max_entries, unmap_idx_start;
>  	dart_iopte pte, *ptep;
> @@ -307,7 +307,7 @@ static size_t dart_unmap_pages(struct io_pgtable_ops *ops, unsigned long iova,
>  	if (WARN_ON(pgsize != cfg->pgsize_bitmap || !pgcount))
>  		return 0;
>  
> -	ptep = dart_get_l2(data, iova);
> +	ptep = dart_get_l2(iop, data, iova);
>  
>  	/* Valid L2 IOPTE pointer? */
>  	if (WARN_ON(!ptep))
> @@ -328,7 +328,7 @@ static size_t dart_unmap_pages(struct io_pgtable_ops *ops, unsigned long iova,
>  		*ptep = 0;
>  
>  		if (!iommu_iotlb_gather_queued(gather))
> -			io_pgtable_tlb_add_page(&data->iop, gather,
> +			io_pgtable_tlb_add_page(cfg, iop, gather,
>  						iova + i * pgsize, pgsize);
>  
>  		ptep++;
> @@ -338,13 +338,13 @@ static size_t dart_unmap_pages(struct io_pgtable_ops *ops, unsigned long iova,
>  	return i * pgsize;
>  }
>  
> -static phys_addr_t dart_iova_to_phys(struct io_pgtable_ops *ops,
> +static phys_addr_t dart_iova_to_phys(struct io_pgtable *iop,
>  					 unsigned long iova)
>  {
> -	struct dart_io_pgtable *data = io_pgtable_ops_to_data(ops);
> +	struct dart_io_pgtable *data = io_pgtable_ops_to_data(iop->ops);
>  	dart_iopte pte, *ptep;
>  
> -	ptep = dart_get_l2(data, iova);
> +	ptep = dart_get_l2(iop, data, iova);
>  
>  	/* Valid L2 IOPTE pointer? */
>  	if (!ptep)
> @@ -394,56 +394,56 @@ dart_alloc_pgtable(struct io_pgtable_cfg *cfg)
>  	return data;
>  }
>  
> -static struct io_pgtable *
> -apple_dart_alloc_pgtable(struct io_pgtable_cfg *cfg, void *cookie)
> +static int apple_dart_alloc_pgtable(struct io_pgtable *iop,
> +				    struct io_pgtable_cfg *cfg, void *cookie)
>  {
>  	struct dart_io_pgtable *data;
>  	int i;
>  
>  	if (!cfg->coherent_walk)
> -		return NULL;
> +		return -EINVAL;
>  
>  	if (cfg->oas != 36 && cfg->oas != 42)
> -		return NULL;
> +		return -EINVAL;
>  
>  	if (cfg->ias > cfg->oas)
> -		return NULL;
> +		return -EINVAL;
>  
>  	if (!(cfg->pgsize_bitmap == SZ_4K || cfg->pgsize_bitmap == SZ_16K))
> -		return NULL;
> +		return -EINVAL;
>  
>  	data = dart_alloc_pgtable(cfg);
>  	if (!data)
> -		return NULL;
> +		return -ENOMEM;
>  
>  	cfg->apple_dart_cfg.n_ttbrs = 1 << data->tbl_bits;
>  
> -	for (i = 0; i < cfg->apple_dart_cfg.n_ttbrs; ++i) {
> -		data->pgd[i] = __dart_alloc_pages(DART_GRANULE(data), GFP_KERNEL,
> -					   cfg);
> -		if (!data->pgd[i])
> -			goto out_free_data;
> -		cfg->apple_dart_cfg.ttbr[i] = virt_to_phys(data->pgd[i]);
> -	}
> +	iop->pgd = __dart_alloc_pages(cfg->apple_dart_cfg.n_ttbrs *
> +				      DART_GRANULE(data), GFP_KERNEL, cfg);
> +	if (!iop->pgd)
> +		goto out_free_data;
> +
> +	for (i = 0; i < cfg->apple_dart_cfg.n_ttbrs; ++i)
> +		cfg->apple_dart_cfg.ttbr[i] = virt_to_phys(iop->pgd) +
> +					      i * DART_GRANULE(data);
>  
> -	return &data->iop;
> +	iop->ops = &data->iop.ops;
> +	return 0;
>  
>  out_free_data:
> -	while (--i >= 0)
> -		free_pages((unsigned long)data->pgd[i],
> -			   get_order(DART_GRANULE(data)));
>  	kfree(data);
> -	return NULL;
> +	return -ENOMEM;
>  }
>  
>  static void apple_dart_free_pgtable(struct io_pgtable *iop)
>  {
> -	struct dart_io_pgtable *data = io_pgtable_to_data(iop);
> +	struct dart_io_pgtable *data = io_pgtable_ops_to_data(iop->ops);
> +	size_t n_ttbrs = 1 << data->tbl_bits;
>  	dart_iopte *ptep, *end;
>  	int i;
>  
> -	for (i = 0; i < (1 << data->tbl_bits) && data->pgd[i]; ++i) {
> -		ptep = data->pgd[i];
> +	for (i = 0; i < n_ttbrs; ++i) {
> +		ptep = iop->pgd + DART_GRANULE(data) * i;
>  		end = (void *)ptep + DART_GRANULE(data);
>  
>  		while (ptep != end) {
> @@ -456,10 +456,9 @@ static void apple_dart_free_pgtable(struct io_pgtable *iop)
>  				free_pages(page, get_order(DART_GRANULE(data)));
>  			}
>  		}
> -		free_pages((unsigned long)data->pgd[i],
> -			   get_order(DART_GRANULE(data)));
>  	}
> -
> +	free_pages((unsigned long)iop->pgd,
> +		   get_order(DART_GRANULE(data) * n_ttbrs));
>  	kfree(data);
>  }
>  
> diff --git a/drivers/iommu/io-pgtable.c b/drivers/iommu/io-pgtable.c
> index 2aba691db1da..acc6802b2f50 100644
> --- a/drivers/iommu/io-pgtable.c
> +++ b/drivers/iommu/io-pgtable.c
> @@ -34,27 +34,30 @@ io_pgtable_init_table[IO_PGTABLE_NUM_FMTS] = {
>  #endif
>  };
>  
> -struct io_pgtable_ops *alloc_io_pgtable_ops(struct io_pgtable_cfg *cfg,
> -					    void *cookie)
> +int alloc_io_pgtable_ops(struct io_pgtable *iop, struct io_pgtable_cfg *cfg,
> +			 void *cookie)
>  {
> -	struct io_pgtable *iop;
> +	int ret;
> +	struct io_pgtable_params *params;
>  	const struct io_pgtable_init_fns *fns;
>  
>  	if (cfg->fmt >= IO_PGTABLE_NUM_FMTS)
> -		return NULL;
> +		return -EINVAL;
>  
>  	fns = io_pgtable_init_table[cfg->fmt];
>  	if (!fns)
> -		return NULL;
> +		return -EINVAL;
>  
> -	iop = fns->alloc(cfg, cookie);
> -	if (!iop)
> -		return NULL;
> +	ret = fns->alloc(iop, cfg, cookie);
> +	if (ret)
> +		return ret;
> +
> +	params = io_pgtable_ops_to_params(iop->ops);
>  
>  	iop->cookie	= cookie;
> -	iop->cfg	= *cfg;
> +	params->cfg	= *cfg;
>  
> -	return &iop->ops;
> +	return 0;
>  }
>  EXPORT_SYMBOL_GPL(alloc_io_pgtable_ops);
>  
> @@ -62,16 +65,17 @@ EXPORT_SYMBOL_GPL(alloc_io_pgtable_ops);
>   * It is the IOMMU driver's responsibility to ensure that the page table
>   * is no longer accessible to the walker by this point.
>   */
> -void free_io_pgtable_ops(struct io_pgtable_ops *ops)
> +void free_io_pgtable_ops(struct io_pgtable *iop)
>  {
> -	struct io_pgtable *iop;
> +	struct io_pgtable_params *params;
>  
> -	if (!ops)
> +	if (!iop)
>  		return;
>  
> -	iop = io_pgtable_ops_to_pgtable(ops);
> -	io_pgtable_tlb_flush_all(iop);
> -	io_pgtable_init_table[iop->cfg.fmt]->free(iop);
> +	params = io_pgtable_ops_to_params(iop->ops);
> +	io_pgtable_tlb_flush_all(&params->cfg, iop);
> +	io_pgtable_init_table[params->cfg.fmt]->free(iop);
> +	memset(iop, 0, sizeof(*iop));
>  }
>  EXPORT_SYMBOL_GPL(free_io_pgtable_ops);
>  
> diff --git a/drivers/iommu/ipmmu-vmsa.c b/drivers/iommu/ipmmu-vmsa.c
> index 4a1927489635..3ff21e6bf939 100644
> --- a/drivers/iommu/ipmmu-vmsa.c
> +++ b/drivers/iommu/ipmmu-vmsa.c
> @@ -73,7 +73,7 @@ struct ipmmu_vmsa_domain {
>  	struct iommu_domain io_domain;
>  
>  	struct io_pgtable_cfg cfg;
> -	struct io_pgtable_ops *iop;
> +	struct io_pgtable iop;
>  
>  	unsigned int context_id;
>  	struct mutex mutex;			/* Protects mappings */
> @@ -458,11 +458,11 @@ static int ipmmu_domain_init_context(struct ipmmu_vmsa_domain *domain)
>  
>  	domain->context_id = ret;
>  
> -	domain->iop = alloc_io_pgtable_ops(&domain->cfg, domain);
> -	if (!domain->iop) {
> +	ret = alloc_io_pgtable_ops(&domain->iop, &domain->cfg, domain);
> +	if (ret) {
>  		ipmmu_domain_free_context(domain->mmu->root,
>  					  domain->context_id);
> -		return -EINVAL;
> +		return ret;
>  	}
>  
>  	ipmmu_domain_setup_context(domain);
> @@ -592,7 +592,7 @@ static void ipmmu_domain_free(struct iommu_domain *io_domain)
>  	 * been detached.
>  	 */
>  	ipmmu_domain_destroy_context(domain);
> -	free_io_pgtable_ops(domain->iop);
> +	free_io_pgtable_ops(&domain->iop);
>  	kfree(domain);
>  }
>  
> @@ -664,8 +664,8 @@ static int ipmmu_map(struct iommu_domain *io_domain, unsigned long iova,
>  {
>  	struct ipmmu_vmsa_domain *domain = to_vmsa_domain(io_domain);
>  
> -	return domain->iop->map_pages(domain->iop, iova, paddr, pgsize, pgcount,
> -				      prot, gfp, mapped);
> +	return iopt_map_pages(&domain->iop, iova, paddr, pgsize, pgcount, prot,
> +			      gfp, mapped);
>  }
>  
>  static size_t ipmmu_unmap(struct iommu_domain *io_domain, unsigned long iova,
> @@ -674,7 +674,7 @@ static size_t ipmmu_unmap(struct iommu_domain *io_domain, unsigned long iova,
>  {
>  	struct ipmmu_vmsa_domain *domain = to_vmsa_domain(io_domain);
>  
> -	return domain->iop->unmap_pages(domain->iop, iova, pgsize, pgcount, gather);
> +	return iopt_unmap_pages(&domain->iop, iova, pgsize, pgcount, gather);
>  }
>  
>  static void ipmmu_flush_iotlb_all(struct iommu_domain *io_domain)
> @@ -698,7 +698,7 @@ static phys_addr_t ipmmu_iova_to_phys(struct iommu_domain *io_domain,
>  
>  	/* TODO: Is locking needed ? */
>  
> -	return domain->iop->iova_to_phys(domain->iop, iova);
> +	return iopt_iova_to_phys(&domain->iop, iova);
>  }
>  
>  static int ipmmu_init_platform_device(struct device *dev,
> diff --git a/drivers/iommu/msm_iommu.c b/drivers/iommu/msm_iommu.c
> index 2c05a84ec1bf..6dae6743e11b 100644
> --- a/drivers/iommu/msm_iommu.c
> +++ b/drivers/iommu/msm_iommu.c
> @@ -41,7 +41,7 @@ struct msm_priv {
>  	struct list_head list_attached;
>  	struct iommu_domain domain;
>  	struct io_pgtable_cfg	cfg;
> -	struct io_pgtable_ops	*iop;
> +	struct io_pgtable	iop;
>  	struct device		*dev;
>  	spinlock_t		pgtlock; /* pagetable lock */
>  };
> @@ -339,6 +339,7 @@ static void msm_iommu_domain_free(struct iommu_domain *domain)
>  
>  static int msm_iommu_domain_config(struct msm_priv *priv)
>  {
> +	int ret;
>  	spin_lock_init(&priv->pgtlock);
>  
>  	priv->cfg = (struct io_pgtable_cfg) {
> @@ -350,10 +351,10 @@ static int msm_iommu_domain_config(struct msm_priv *priv)
>  		.iommu_dev = priv->dev,
>  	};
>  
> -	priv->iop = alloc_io_pgtable_ops(&priv->cfg, priv);
> -	if (!priv->iop) {
> +	ret = alloc_io_pgtable_ops(&priv->iop, &priv->cfg, priv);
> +	if (ret) {
>  		dev_err(priv->dev, "Failed to allocate pgtable\n");
> -		return -EINVAL;
> +		return ret;
>  	}
>  
>  	msm_iommu_ops.pgsize_bitmap = priv->cfg.pgsize_bitmap;
> @@ -453,7 +454,7 @@ static void msm_iommu_detach_dev(struct iommu_domain *domain,
>  	struct msm_iommu_ctx_dev *master;
>  	int ret;
>  
> -	free_io_pgtable_ops(priv->iop);
> +	free_io_pgtable_ops(&priv->iop);
>  
>  	spin_lock_irqsave(&msm_iommu_lock, flags);
>  	list_for_each_entry(iommu, &priv->list_attached, dom_node) {
> @@ -480,8 +481,8 @@ static int msm_iommu_map(struct iommu_domain *domain, unsigned long iova,
>  	int ret;
>  
>  	spin_lock_irqsave(&priv->pgtlock, flags);
> -	ret = priv->iop->map_pages(priv->iop, iova, pa, pgsize, pgcount, prot,
> -				   GFP_ATOMIC, mapped);
> +	ret = iopt_map_pages(&priv->iop, iova, pa, pgsize, pgcount, prot,
> +			     GFP_ATOMIC, mapped);
>  	spin_unlock_irqrestore(&priv->pgtlock, flags);
>  
>  	return ret;
> @@ -504,7 +505,7 @@ static size_t msm_iommu_unmap(struct iommu_domain *domain, unsigned long iova,
>  	size_t ret;
>  
>  	spin_lock_irqsave(&priv->pgtlock, flags);
> -	ret = priv->iop->unmap_pages(priv->iop, iova, pgsize, pgcount, gather);
> +	ret = iopt_unmap_pages(&priv->iop, iova, pgsize, pgcount, gather);
>  	spin_unlock_irqrestore(&priv->pgtlock, flags);
>  
>  	return ret;
> diff --git a/drivers/iommu/mtk_iommu.c b/drivers/iommu/mtk_iommu.c
> index 0d754d94ae52..615d9ade575e 100644
> --- a/drivers/iommu/mtk_iommu.c
> +++ b/drivers/iommu/mtk_iommu.c
> @@ -244,7 +244,7 @@ struct mtk_iommu_data {
>  
>  struct mtk_iommu_domain {
>  	struct io_pgtable_cfg		cfg;
> -	struct io_pgtable_ops		*iop;
> +	struct io_pgtable		iop;
>  
>  	struct mtk_iommu_bank_data	*bank;
>  	struct iommu_domain		domain;
> @@ -587,6 +587,7 @@ static int mtk_iommu_domain_finalise(struct mtk_iommu_domain *dom,
>  {
>  	const struct mtk_iommu_iova_region *region;
>  	struct mtk_iommu_domain	*m4u_dom;
> +	int ret;
>  
>  	/* Always use bank0 in sharing pgtable case */
>  	m4u_dom = data->bank[0].m4u_dom;
> @@ -615,8 +616,8 @@ static int mtk_iommu_domain_finalise(struct mtk_iommu_domain *dom,
>  	else
>  		dom->cfg.oas = 35;
>  
> -	dom->iop = alloc_io_pgtable_ops(&dom->cfg, data);
> -	if (!dom->iop) {
> +	ret = alloc_io_pgtable_ops(&dom->iop, &dom->cfg, data);
> +	if (ret) {
>  		dev_err(data->dev, "Failed to alloc io pgtable\n");
>  		return -ENOMEM;
>  	}
> @@ -730,7 +731,7 @@ static int mtk_iommu_map(struct iommu_domain *domain, unsigned long iova,
>  		paddr |= BIT_ULL(32);
>  
>  	/* Synchronize with the tlb_lock */
> -	return dom->iop->map_pages(dom->iop, iova, paddr, pgsize, pgcount, prot, gfp, mapped);
> +	return iopt_map_pages(&dom->iop, iova, paddr, pgsize, pgcount, prot, gfp, mapped);
>  }
>  
>  static size_t mtk_iommu_unmap(struct iommu_domain *domain,
> @@ -740,7 +741,7 @@ static size_t mtk_iommu_unmap(struct iommu_domain *domain,
>  	struct mtk_iommu_domain *dom = to_mtk_domain(domain);
>  
>  	iommu_iotlb_gather_add_range(gather, iova, pgsize * pgcount);
> -	return dom->iop->unmap_pages(dom->iop, iova, pgsize, pgcount, gather);
> +	return iopt_unmap_pages(&dom->iop, iova, pgsize, pgcount, gather);
>  }
>  
>  static void mtk_iommu_flush_iotlb_all(struct iommu_domain *domain)
> @@ -773,7 +774,7 @@ static phys_addr_t mtk_iommu_iova_to_phys(struct iommu_domain *domain,
>  	struct mtk_iommu_domain *dom = to_mtk_domain(domain);
>  	phys_addr_t pa;
>  
> -	pa = dom->iop->iova_to_phys(dom->iop, iova);
> +	pa = iopt_iova_to_phys(&dom->iop, iova);
>  	if (IS_ENABLED(CONFIG_PHYS_ADDR_T_64BIT) &&
>  	    dom->bank->parent_data->enable_4GB &&
>  	    pa >= MTK_IOMMU_4GB_MODE_REMAP_BASE)
> -- 
> 2.39.0
> 
