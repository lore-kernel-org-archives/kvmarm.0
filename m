Return-Path: <SRS0=MRwa=HJ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1C66C433DB
	for <kvmarm@archiver.kernel.org>; Sun,  7 Feb 2021 17:59:58 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E930864E31
	for <kvmarm@archiver.kernel.org>; Sun,  7 Feb 2021 17:59:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E930864E31
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.intel.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 57D804B5CE;
	Sun,  7 Feb 2021 12:59:57 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id bRjxCWKzAaOR; Sun,  7 Feb 2021 12:59:56 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 044A14B59A;
	Sun,  7 Feb 2021 12:59:56 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D3EE84B52B
 for <kvmarm@lists.cs.columbia.edu>; Sun,  7 Feb 2021 05:02:04 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id T4TtbxovkR4J for <kvmarm@lists.cs.columbia.edu>;
 Sun,  7 Feb 2021 05:02:03 -0500 (EST)
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1C4214B517
 for <kvmarm@lists.cs.columbia.edu>; Sun,  7 Feb 2021 05:02:02 -0500 (EST)
IronPort-SDR: Cqivwy7X3XQFaMUIEHS06iPdw9aeS5f5Yp03cCHqyWNWe2cE8KpDHgzO9mFe4rjNIqZuH1RSAl
 OGRYzOgpqTWA==
X-IronPort-AV: E=McAfee;i="6000,8403,9887"; a="180823142"
X-IronPort-AV: E=Sophos;i="5.81,159,1610438400"; d="scan'208";a="180823142"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
 by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
 07 Feb 2021 02:02:01 -0800
IronPort-SDR: Mp8oKFuCuA6dAZ2YZ/k3bHQSVYlOl31EFoAhZtw2KltKpjEurl1bATYaVs9WFlQSWAC71xuHE6
 2n62yqCcbYLg==
X-IronPort-AV: E=Sophos;i="5.81,159,1610438400"; d="scan'208";a="394665971"
Received: from yisun1-ubuntu.bj.intel.com (HELO yi.y.sun) ([10.238.156.116])
 by orsmga008-auth.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-SHA256;
 07 Feb 2021 02:01:56 -0800
Date: Sun, 7 Feb 2021 17:56:30 +0800
From: Yi Sun <yi.y.sun@linux.intel.com>
To: Keqian Zhu <zhukeqian1@huawei.com>
Subject: Re: [RFC PATCH 10/11] vfio/iommu_type1: Optimize dirty bitmap
 population based on iommu HWDBM
Message-ID: <20210207095630.GA28580@yi.y.sun>
References: <20210128151742.18840-1-zhukeqian1@huawei.com>
 <20210128151742.18840-11-zhukeqian1@huawei.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210128151742.18840-11-zhukeqian1@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Mailman-Approved-At: Sun, 07 Feb 2021 12:59:55 -0500
Cc: kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
 Kirti Wankhede <kwankhede@nvidia.com>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu, Marc Zyngier <maz@kernel.org>,
 kevin.tian@intel.com, yan.y.zhao@intel.com,
 Alex Williamson <alex.williamson@redhat.com>,
 linux-arm-kernel@lists.infradead.org, Cornelia Huck <cohuck@redhat.com>,
 linux-kernel@vger.kernel.org, lushenming@huawei.com,
 iommu@lists.linux-foundation.org, Robin Murphy <robin.murphy@arm.com>,
 baolu.lu@linux.intel.com
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

Hi,

On 21-01-28 23:17:41, Keqian Zhu wrote:

[...]

> +static void vfio_dma_dirty_log_start(struct vfio_iommu *iommu,
> +				     struct vfio_dma *dma)
> +{
> +	struct vfio_domain *d;
> +
> +	list_for_each_entry(d, &iommu->domain_list, next) {
> +		/* Go through all domain anyway even if we fail */
> +		iommu_split_block(d->domain, dma->iova, dma->size);
> +	}
> +}

This should be a switch to prepare for dirty log start. Per Intel
Vtd spec, there is SLADE defined in Scalable-Mode PASID Table Entry.
It enables Accessed/Dirty Flags in second-level paging entries.
So, a generic iommu interface here is better. For Intel iommu, it
enables SLADE. For ARM, it splits block.

> +
> +static void vfio_dma_dirty_log_stop(struct vfio_iommu *iommu,
> +				    struct vfio_dma *dma)
> +{
> +	struct vfio_domain *d;
> +
> +	list_for_each_entry(d, &iommu->domain_list, next) {
> +		/* Go through all domain anyway even if we fail */
> +		iommu_merge_page(d->domain, dma->iova, dma->size,
> +				 d->prot | dma->prot);
> +	}
> +}

Same as above comment, a generic interface is required here.

> +
> +static void vfio_iommu_dirty_log_switch(struct vfio_iommu *iommu, bool start)
> +{
> +	struct rb_node *n;
> +
> +	/* Split and merge even if all iommu don't support HWDBM now */
> +	for (n = rb_first(&iommu->dma_list); n; n = rb_next(n)) {
> +		struct vfio_dma *dma = rb_entry(n, struct vfio_dma, node);
> +
> +		if (!dma->iommu_mapped)
> +			continue;
> +
> +		/* Go through all dma range anyway even if we fail */
> +		if (start)
> +			vfio_dma_dirty_log_start(iommu, dma);
> +		else
> +			vfio_dma_dirty_log_stop(iommu, dma);
> +	}
> +}
> +
>  static int vfio_iommu_type1_dirty_pages(struct vfio_iommu *iommu,
>  					unsigned long arg)
>  {
> @@ -2812,8 +2900,10 @@ static int vfio_iommu_type1_dirty_pages(struct vfio_iommu *iommu,
>  		pgsize = 1 << __ffs(iommu->pgsize_bitmap);
>  		if (!iommu->dirty_page_tracking) {
>  			ret = vfio_dma_bitmap_alloc_all(iommu, pgsize);
> -			if (!ret)
> +			if (!ret) {
>  				iommu->dirty_page_tracking = true;
> +				vfio_iommu_dirty_log_switch(iommu, true);
> +			}
>  		}
>  		mutex_unlock(&iommu->lock);
>  		return ret;
> @@ -2822,6 +2912,7 @@ static int vfio_iommu_type1_dirty_pages(struct vfio_iommu *iommu,
>  		if (iommu->dirty_page_tracking) {
>  			iommu->dirty_page_tracking = false;
>  			vfio_dma_bitmap_free_all(iommu);
> +			vfio_iommu_dirty_log_switch(iommu, false);
>  		}
>  		mutex_unlock(&iommu->lock);
>  		return 0;
> -- 
> 2.19.1
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
