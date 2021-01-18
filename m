Return-Path: <SRS0=ax30=GV=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.4 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C1B0C433DB
	for <kvmarm@archiver.kernel.org>; Mon, 18 Jan 2021 13:16:33 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 92A7322B4E
	for <kvmarm@archiver.kernel.org>; Mon, 18 Jan 2021 13:16:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 92A7322B4E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CA5674B29F;
	Mon, 18 Jan 2021 08:16:31 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id x+z5FalKuVh4; Mon, 18 Jan 2021 08:16:27 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9618B4B2A4;
	Mon, 18 Jan 2021 08:16:27 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B79EF4B2A1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Jan 2021 08:16:26 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 9N+Fc-CV4pwC for <kvmarm@lists.cs.columbia.edu>;
 Mon, 18 Jan 2021 08:16:24 -0500 (EST)
Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B1A1D4B29F
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Jan 2021 08:16:23 -0500 (EST)
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.60])
 by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4DKC1r5CHCzMLqq;
 Mon, 18 Jan 2021 21:14:56 +0800 (CST)
Received: from [10.174.184.42] (10.174.184.42) by
 DGGEMS401-HUB.china.huawei.com (10.3.19.201) with Microsoft SMTP Server id
 14.3.498.0; Mon, 18 Jan 2021 21:16:09 +0800
Subject: Re: [PATCH v2 2/2] vfio/iommu_type1: Sanity check pfn_list when
 remove vfio_dma
To: Alex Williamson <alex.williamson@redhat.com>
References: <20210115092643.728-1-zhukeqian1@huawei.com>
 <20210115092643.728-3-zhukeqian1@huawei.com>
 <20210115121447.54c96857@omen.home.shazbot.org>
From: Keqian Zhu <zhukeqian1@huawei.com>
Message-ID: <32f8b347-587a-1a9a-bee8-569f09a03a15@huawei.com>
Date: Mon, 18 Jan 2021 21:16:08 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <20210115121447.54c96857@omen.home.shazbot.org>
X-Originating-IP: [10.174.184.42]
X-CFilter-Loop: Reflected
Cc: kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
 Kirti Wankhede <kwankhede@nvidia.com>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu, Marc
 Zyngier <maz@kernel.org>, Joerg Roedel <joro@8bytes.org>,
 Daniel Lezcano <daniel.lezcano@linaro.org>,
 Alexios Zavras <alexios.zavras@intel.com>,
 Thomas Gleixner <tglx@linutronix.de>, linux-arm-kernel@lists.infradead.org,
 Cornelia Huck <cohuck@redhat.com>, linux-kernel@vger.kernel.org,
 iommu@lists.linux-foundation.org, Andrew Morton <akpm@linux-foundation.org>,
 Robin Murphy <robin.murphy@arm.com>
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



On 2021/1/16 3:14, Alex Williamson wrote:
> On Fri, 15 Jan 2021 17:26:43 +0800
> Keqian Zhu <zhukeqian1@huawei.com> wrote:
> 
>> vfio_sanity_check_pfn_list() is used to check whether pfn_list of
>> vfio_dma is empty when remove the external domain, so it makes a
>> wrong assumption that only external domain will add pfn to dma pfn_list.
>>
>> Now we apply this check when remove a specific vfio_dma and extract
>> the notifier check just for external domain.
> 
> The page pinning interface is gated by having a notifier registered for
> unmaps, therefore non-external domains would also need to register a
> notifier.  There's currently no other way to add entries to the
> pfn_list.  So if we allow pinning for such domains, then it's wrong to
> WARN_ON() when the notifier list is not-empty when removing an external
> domain.  Long term we should probably extend page {un}pinning for the
> caller to pass their notifier to be validated against the notifier list
> rather than just allowing page pinning if *any* notifier is registered.
> Thanks,
I was misled by the code comments. So when the commit a54eb55045ae is added, the only
user of pin interface is mdev vendor driver, but now we also allow iommu backed group
to use this interface to constraint dirty scope. Is vfio_iommu_unmap_unpin_all() a
proper place to put this WARN()?

Thanks,
Keqian

> 
> Alex
>  
>> Fixes: a54eb55045ae ("vfio iommu type1: Add support for mediated devices")
>> Signed-off-by: Keqian Zhu <zhukeqian1@huawei.com>
>> ---
>>  drivers/vfio/vfio_iommu_type1.c | 24 +++++-------------------
>>  1 file changed, 5 insertions(+), 19 deletions(-)
>>
>> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
>> index 4e82b9a3440f..a9bc15e84a4e 100644
>> --- a/drivers/vfio/vfio_iommu_type1.c
>> +++ b/drivers/vfio/vfio_iommu_type1.c
>> @@ -958,6 +958,7 @@ static long vfio_unmap_unpin(struct vfio_iommu *iommu, struct vfio_dma *dma,
>>  
>>  static void vfio_remove_dma(struct vfio_iommu *iommu, struct vfio_dma *dma)
>>  {
>> +	WARN_ON(!RB_EMPTY_ROOT(&dma->pfn_list);
>>  	vfio_unmap_unpin(iommu, dma, true);
>>  	vfio_unlink_dma(iommu, dma);
>>  	put_task_struct(dma->task);
>> @@ -2251,23 +2252,6 @@ static void vfio_iommu_unmap_unpin_reaccount(struct vfio_iommu *iommu)
>>  	}
>>  }
>>  
>> -static void vfio_sanity_check_pfn_list(struct vfio_iommu *iommu)
>> -{
>> -	struct rb_node *n;
>> -
>> -	n = rb_first(&iommu->dma_list);
>> -	for (; n; n = rb_next(n)) {
>> -		struct vfio_dma *dma;
>> -
>> -		dma = rb_entry(n, struct vfio_dma, node);
>> -
>> -		if (WARN_ON(!RB_EMPTY_ROOT(&dma->pfn_list)))
>> -			break;
>> -	}
>> -	/* mdev vendor driver must unregister notifier */
>> -	WARN_ON(iommu->notifier.head);
>> -}
>> -
>>  /*
>>   * Called when a domain is removed in detach. It is possible that
>>   * the removed domain decided the iova aperture window. Modify the
>> @@ -2367,7 +2351,8 @@ static void vfio_iommu_type1_detach_group(void *iommu_data,
>>  			kfree(group);
>>  
>>  			if (list_empty(&iommu->external_domain->group_list)) {
>> -				vfio_sanity_check_pfn_list(iommu);
>> +				/* mdev vendor driver must unregister notifier */
>> +				WARN_ON(iommu->notifier.head);
>>  
>>  				if (!IS_IOMMU_CAP_DOMAIN_IN_CONTAINER(iommu))
>>  					vfio_iommu_unmap_unpin_all(iommu);
>> @@ -2491,7 +2476,8 @@ static void vfio_iommu_type1_release(void *iommu_data)
>>  
>>  	if (iommu->external_domain) {
>>  		vfio_release_domain(iommu->external_domain, true);
>> -		vfio_sanity_check_pfn_list(iommu);
>> +		/* mdev vendor driver must unregister notifier */
>> +		WARN_ON(iommu->notifier.head);
>>  		kfree(iommu->external_domain);
>>  	}
>>  
> 
> .
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
