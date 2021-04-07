Return-Path: <SRS0=nct1=JE=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1C91C433ED
	for <kvmarm@archiver.kernel.org>; Wed,  7 Apr 2021 07:39:50 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 3DE026139B
	for <kvmarm@archiver.kernel.org>; Wed,  7 Apr 2021 07:39:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3DE026139B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AD0864B829;
	Wed,  7 Apr 2021 03:39:49 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id KzaI2RvCZEJO; Wed,  7 Apr 2021 03:39:48 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4D0764B759;
	Wed,  7 Apr 2021 03:39:48 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CF8414B7AE
 for <kvmarm@lists.cs.columbia.edu>; Wed,  7 Apr 2021 03:39:47 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id LVwxgdvAQD2M for <kvmarm@lists.cs.columbia.edu>;
 Wed,  7 Apr 2021 03:39:45 -0400 (EDT)
Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2397E4B72F
 for <kvmarm@lists.cs.columbia.edu>; Wed,  7 Apr 2021 03:39:45 -0400 (EDT)
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.58])
 by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4FFbp23T1xz19GSt;
 Wed,  7 Apr 2021 15:37:30 +0800 (CST)
Received: from [10.174.185.179] (10.174.185.179) by
 DGGEMS410-HUB.china.huawei.com (10.3.19.210) with Microsoft SMTP Server id
 14.3.498.0; Wed, 7 Apr 2021 15:39:33 +0800
Subject: Re: [PATCH v14 08/13] dma-iommu: Implement NESTED_MSI cookie
To: Eric Auger <eric.auger@redhat.com>
References: <20210223205634.604221-1-eric.auger@redhat.com>
 <20210223205634.604221-9-eric.auger@redhat.com>
From: Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <791bb74a-cd74-7b96-1f0d-cf7a602eb159@huawei.com>
Date: Wed, 7 Apr 2021 15:39:30 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20210223205634.604221-9-eric.auger@redhat.com>
Content-Language: en-US
X-Originating-IP: [10.174.185.179]
X-CFilter-Loop: Reflected
Cc: kvm@vger.kernel.org, vivek.gautam@arm.com, kvmarm@lists.cs.columbia.edu,
 eric.auger.pro@gmail.com, jean-philippe@linaro.org, yi.l.liu@intel.com,
 wangxingang5@huawei.com, maz@kernel.org, joro@8bytes.org, vsethi@nvidia.com,
 zhangfei.gao@linaro.org, jacob.jun.pan@linux.intel.com, will@kernel.org,
 nicoleotsuka@gmail.com, alex.williamson@redhat.com,
 linux-kernel@vger.kernel.org, lushenming@huawei.com,
 iommu@lists.linux-foundation.org, robin.murphy@arm.com
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Hi Eric,

On 2021/2/24 4:56, Eric Auger wrote:
> Up to now, when the type was UNMANAGED, we used to
> allocate IOVA pages within a reserved IOVA MSI range.
> 
> If both the host and the guest are exposed with SMMUs, each
> would allocate an IOVA. The guest allocates an IOVA (gIOVA)
> to map onto the guest MSI doorbell (gDB). The Host allocates
> another IOVA (hIOVA) to map onto the physical doorbell (hDB).
> 
> So we end up with 2 unrelated mappings, at S1 and S2:
>           S1             S2
> gIOVA    ->     gDB
>                 hIOVA    ->    hDB
> 
> The PCI device would be programmed with hIOVA.
> No stage 1 mapping would existing, causing the MSIs to fault.
> 
> iommu_dma_bind_guest_msi() allows to pass gIOVA/gDB
> to the host so that gIOVA can be used by the host instead of
> re-allocating a new hIOVA.
> 
>           S1           S2
> gIOVA    ->    gDB    ->    hDB
> 
> this time, the PCI device can be programmed with the gIOVA MSI
> doorbell which is correctly mapped through both stages.
> 
> Nested mode is not compatible with HW MSI regions as in that
> case gDB and hDB should have a 1-1 mapping. This check will
> be done when attaching each device to the IOMMU domain.
> 
> Signed-off-by: Eric Auger <eric.auger@redhat.com>

[...]

> diff --git a/drivers/iommu/dma-iommu.c b/drivers/iommu/dma-iommu.c
> index f659395e7959..d25eb7cecaa7 100644
> --- a/drivers/iommu/dma-iommu.c
> +++ b/drivers/iommu/dma-iommu.c
> @@ -19,6 +19,7 @@
>   #include <linux/irq.h>
>   #include <linux/mm.h>
>   #include <linux/mutex.h>
> +#include <linux/mutex.h>

Duplicated include.

>   #include <linux/pci.h>
>   #include <linux/swiotlb.h>
>   #include <linux/scatterlist.h>
> @@ -29,12 +30,15 @@
>   struct iommu_dma_msi_page {
>   	struct list_head	list;
>   	dma_addr_t		iova;
> +	dma_addr_t		gpa;
>   	phys_addr_t		phys;
> +	size_t			s1_granule;
>   };
>   
>   enum iommu_dma_cookie_type {
>   	IOMMU_DMA_IOVA_COOKIE,
>   	IOMMU_DMA_MSI_COOKIE,
> +	IOMMU_DMA_NESTED_MSI_COOKIE,
>   };
>   
>   struct iommu_dma_cookie {
> @@ -46,6 +50,7 @@ struct iommu_dma_cookie {
>   		dma_addr_t		msi_iova;

msi_iova is unused in the nested mode, but we still set it to the start
address of the RESV_SW_MSI region (in iommu_get_msi_cookie()), which
looks a bit strange to me.

>   	};
>   	struct list_head		msi_page_list;
> +	spinlock_t			msi_lock;

Should msi_lock be grabbed everywhere msi_page_list is populated?
Especially in iommu_dma_get_msi_page(), which can be invoked from the
irqchip driver.

>   
>   	/* Domain for flush queue callback; NULL if flush queue not in use */
>   	struct iommu_domain		*fq_domain;
> @@ -87,6 +92,7 @@ static struct iommu_dma_cookie *cookie_alloc(enum iommu_dma_cookie_type type)
>   
>   	cookie = kzalloc(sizeof(*cookie), GFP_KERNEL);
>   	if (cookie) {
> +		spin_lock_init(&cookie->msi_lock);
>   		INIT_LIST_HEAD(&cookie->msi_page_list);
>   		cookie->type = type;
>   	}
> @@ -120,14 +126,17 @@ EXPORT_SYMBOL(iommu_get_dma_cookie);
>    *
>    * Users who manage their own IOVA allocation and do not want DMA API support,
>    * but would still like to take advantage of automatic MSI remapping, can use
> - * this to initialise their own domain appropriately. Users should reserve a
> + * this to initialise their own domain appropriately. Users may reserve a
>    * contiguous IOVA region, starting at @base, large enough to accommodate the
>    * number of PAGE_SIZE mappings necessary to cover every MSI doorbell address
> - * used by the devices attached to @domain.
> + * used by the devices attached to @domain. The other way round is to provide
> + * usable iova pages through the iommu_dma_bind_doorbell API (nested stages

s/iommu_dma_bind_doorbell/iommu_dma_bind_guest_msi/ ?

> + * use case)
>    */
>   int iommu_get_msi_cookie(struct iommu_domain *domain, dma_addr_t base)
>   {
>   	struct iommu_dma_cookie *cookie;
> +	int nesting, ret;
>   
>   	if (domain->type != IOMMU_DOMAIN_UNMANAGED)
>   		return -EINVAL;
> @@ -135,7 +144,12 @@ int iommu_get_msi_cookie(struct iommu_domain *domain, dma_addr_t base)
>   	if (domain->iova_cookie)
>   		return -EEXIST;
>   
> -	cookie = cookie_alloc(IOMMU_DMA_MSI_COOKIE);
> +	ret =  iommu_domain_get_attr(domain, DOMAIN_ATTR_NESTING, &nesting);

Redundant space.

> +	if (!ret && nesting)
> +		cookie = cookie_alloc(IOMMU_DMA_NESTED_MSI_COOKIE);
> +	else
> +		cookie = cookie_alloc(IOMMU_DMA_MSI_COOKIE);
> +
>   	if (!cookie)
>   		return -ENOMEM;
>   
> @@ -156,6 +170,7 @@ void iommu_put_dma_cookie(struct iommu_domain *domain)
>   {
>   	struct iommu_dma_cookie *cookie = domain->iova_cookie;
>   	struct iommu_dma_msi_page *msi, *tmp;
> +	bool s2_unmap = false;
>   
>   	if (!cookie)
>   		return;
> @@ -163,7 +178,15 @@ void iommu_put_dma_cookie(struct iommu_domain *domain)
>   	if (cookie->type == IOMMU_DMA_IOVA_COOKIE && cookie->iovad.granule)
>   		put_iova_domain(&cookie->iovad);
>   
> +	if (cookie->type == IOMMU_DMA_NESTED_MSI_COOKIE)
> +		s2_unmap = true;
> +
>   	list_for_each_entry_safe(msi, tmp, &cookie->msi_page_list, list) {
> +		if (s2_unmap && msi->phys) {

I don't think @s2_unmap is necessary. Checking 'cookie->type==NESTED'
directly shouldn't be that expensive.

> +			size_t size = cookie_msi_granule(cookie);
> +
> +			WARN_ON(iommu_unmap(domain, msi->gpa, size) != size);
> +		}
>   		list_del(&msi->list);
>   		kfree(msi);
>   	}
> @@ -172,6 +195,92 @@ void iommu_put_dma_cookie(struct iommu_domain *domain)
>   }
>   EXPORT_SYMBOL(iommu_put_dma_cookie);
>   
> +/**
> + * iommu_dma_bind_guest_msi - Allows to pass the stage 1
> + * binding of a virtual MSI doorbell used by @dev.
> + *
> + * @domain: domain handle
> + * @iova: guest iova

Can we change it to 'giova' (to match the unbind side)?

> + * @gpa: gpa of the virtual doorbell
> + * @size: size of the granule used for the stage1 mapping
> + *
> + * In nested stage use case, the user can provide IOVA/IPA bindings
> + * corresponding to a guest MSI stage 1 mapping. When the host needs
> + * to map its own MSI doorbells, it can use @gpa as stage 2 input
> + * and map it onto the physical MSI doorbell.
> + */
> +int iommu_dma_bind_guest_msi(struct iommu_domain *domain,
> +			     dma_addr_t iova, phys_addr_t gpa, size_t size)
> +{
> +	struct iommu_dma_cookie *cookie = domain->iova_cookie;
> +	struct iommu_dma_msi_page *msi;
> +	int ret = 0;
> +
> +	if (!cookie)
> +		return -EINVAL;
> +
> +	if (cookie->type != IOMMU_DMA_NESTED_MSI_COOKIE)
> +		return -EINVAL;
> +
> +	iova = iova & ~(dma_addr_t)(size - 1);
> +	gpa = gpa & ~(phys_addr_t)(size - 1);
> +
> +	spin_lock(&cookie->msi_lock);
> +
> +	list_for_each_entry(msi, &cookie->msi_page_list, list) {
> +		if (msi->iova == iova)
> +			goto unlock; /* this page is already registered */
> +	}
> +
> +	msi = kzalloc(sizeof(*msi), GFP_ATOMIC);
> +	if (!msi) {
> +		ret = -ENOMEM;
> +		goto unlock;
> +	}
> +
> +	msi->iova = iova;
> +	msi->gpa = gpa;
> +	msi->s1_granule = size;
> +	list_add(&msi->list, &cookie->msi_page_list);
> +unlock:
> +	spin_unlock(&cookie->msi_lock);
> +	return ret;
> +}
> +EXPORT_SYMBOL(iommu_dma_bind_guest_msi);
> +
> +void iommu_dma_unbind_guest_msi(struct iommu_domain *domain, dma_addr_t giova)
> +{
> +	struct iommu_dma_cookie *cookie = domain->iova_cookie;
> +	struct iommu_dma_msi_page *msi;
> +
> +	if (!cookie)
> +		return;
> +
> +	if (cookie->type != IOMMU_DMA_NESTED_MSI_COOKIE)
> +		return;
> +
> +	spin_lock(&cookie->msi_lock);
> +
> +	list_for_each_entry(msi, &cookie->msi_page_list, list) {
> +		dma_addr_t aligned_giova =
> +			giova & ~(dma_addr_t)(msi->s1_granule - 1);
> +
> +		if (msi->iova == aligned_giova) {
> +			if (msi->phys) {
> +				/* unmap the stage 2 */
> +				size_t size = cookie_msi_granule(cookie);
> +
> +				WARN_ON(iommu_unmap(domain, msi->gpa, size) != size);
> +			}
> +			list_del(&msi->list);
> +			kfree(msi);
> +			break;
> +		}
> +	}
> +	spin_unlock(&cookie->msi_lock);
> +}
> +EXPORT_SYMBOL(iommu_dma_unbind_guest_msi);
> +
>   /**
>    * iommu_dma_get_resv_regions - Reserved region driver helper
>    * @dev: Device from iommu_get_resv_regions()
> @@ -1343,6 +1452,33 @@ static struct iommu_dma_msi_page *iommu_dma_get_msi_page(struct device *dev,
>   		if (msi_page->phys == msi_addr)
>   			return msi_page;
>   
> +	/*
> +	 * In nested stage mode, we do not allocate an MSI page in
> +	 * a range provided by the user. Instead, IOVA/IPA bindings are
> +	 * individually provided. We reuse thise IOVAs to build the

s/thise/these/

> +	 * GIOVA -> GPA -> MSI HPA nested stage mapping.
> +	 */
> +	if (cookie->type == IOMMU_DMA_NESTED_MSI_COOKIE) {
> +		list_for_each_entry(msi_page, &cookie->msi_page_list, list)
> +			if (!msi_page->phys) {
> +				int ret;
> +
> +				/* do the stage 2 mapping */
> +				ret = iommu_map(domain,
> +						msi_page->gpa, msi_addr, size,

Shouldn't we make sure that the size of S2 mapping is not less than
s1_granule? Although what we need is actually a 32-bit TRANSLATER
register, we don't know where it is mapped in S1.

> +						IOMMU_MMIO | IOMMU_WRITE);

Is it intentional to drop the IOMMU_NOEXEC flag (from @prot)?

> +				if (ret) {
> +					pr_warn("MSI S2 mapping failed (%d)\n",
> +						ret);
> +					return NULL;
> +				}
> +				msi_page->phys = msi_addr;
> +				return msi_page;
> +			}
> +		pr_warn("%s no MSI binding found\n", __func__);
> +		return NULL;
> +	}
> +
>   	msi_page = kzalloc(sizeof(*msi_page), GFP_KERNEL);
>   	if (!msi_page)
>   		return NULL;


Thanks,
Zenghui
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
