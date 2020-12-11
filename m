Return-Path: <SRS0=r53t=FP=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A1D4C433FE
	for <kvmarm@archiver.kernel.org>; Fri, 11 Dec 2020 06:52:05 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 8081C23F2A
	for <kvmarm@archiver.kernel.org>; Fri, 11 Dec 2020 06:52:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8081C23F2A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D3EC04B1FD;
	Fri, 11 Dec 2020 01:52:03 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id fW1DyZ-qAUJQ; Fri, 11 Dec 2020 01:52:02 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A8E9C4B246;
	Fri, 11 Dec 2020 01:52:02 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B5C0D4B1FD
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Dec 2020 01:52:01 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 8a0CJtXN+hva for <kvmarm@lists.cs.columbia.edu>;
 Fri, 11 Dec 2020 01:51:59 -0500 (EST)
Received: from szxga07-in.huawei.com (szxga07-in.huawei.com [45.249.212.35])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5F5F64B1E3
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Dec 2020 01:51:58 -0500 (EST)
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.60])
 by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4CshJn1TbZz7CXq;
 Fri, 11 Dec 2020 14:51:21 +0800 (CST)
Received: from [10.174.187.37] (10.174.187.37) by
 DGGEMS410-HUB.china.huawei.com (10.3.19.210) with Microsoft SMTP Server id
 14.3.487.0; Fri, 11 Dec 2020 14:51:48 +0800
Subject: Re: [PATCH 1/7] vfio: iommu_type1: Clear added dirty bit when unwind
 pin
To: Alex Williamson <alex.williamson@redhat.com>
References: <20201210073425.25960-1-zhukeqian1@huawei.com>
 <20201210073425.25960-2-zhukeqian1@huawei.com>
 <20201210121646.24fb3cd8@omen.home>
From: zhukeqian <zhukeqian1@huawei.com>
Message-ID: <aaba64dd-a038-2cb7-8874-e7aed19511c3@huawei.com>
Date: Fri, 11 Dec 2020 14:51:47 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <20201210121646.24fb3cd8@omen.home>
X-Originating-IP: [10.174.187.37]
X-CFilter-Loop: Reflected
Cc: Andrew Morton <akpm@linux-foundation.org>, kvm@vger.kernel.org, Marc
 Zyngier <maz@kernel.org>, Joerg Roedel <joro@8bytes.org>,
 Cornelia Huck <cohuck@redhat.com>, linux-kernel@vger.kernel.org,
 Sean Christopherson <sean.j.christopherson@intel.com>,
 Alexios Zavras <alexios.zavras@intel.com>, iommu@lists.linux-foundation.org,
 Mark Brown <broonie@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>,
 Thomas Gleixner <tglx@linutronix.de>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
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



On 2020/12/11 3:16, Alex Williamson wrote:
> On Thu, 10 Dec 2020 15:34:19 +0800
> Keqian Zhu <zhukeqian1@huawei.com> wrote:
> 
>> Currently we do not clear added dirty bit of bitmap when unwind
>> pin, so if pin failed at halfway, we set unnecessary dirty bit
>> in bitmap. Clearing added dirty bit when unwind pin, userspace
>> will see less dirty page, which can save much time to handle them.
>>
>> Note that we should distinguish the bits added by pin and the bits
>> already set before pin, so introduce bitmap_added to record this.
>>
>> Signed-off-by: Keqian Zhu <zhukeqian1@huawei.com>
>> ---
>>  drivers/vfio/vfio_iommu_type1.c | 33 ++++++++++++++++++++++-----------
>>  1 file changed, 22 insertions(+), 11 deletions(-)
>>
>> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
>> index 67e827638995..f129d24a6ec3 100644
>> --- a/drivers/vfio/vfio_iommu_type1.c
>> +++ b/drivers/vfio/vfio_iommu_type1.c
>> @@ -637,7 +637,11 @@ static int vfio_iommu_type1_pin_pages(void *iommu_data,
>>  	struct vfio_iommu *iommu = iommu_data;
>>  	struct vfio_group *group;
>>  	int i, j, ret;
>> +	unsigned long pgshift = __ffs(iommu->pgsize_bitmap);
>>  	unsigned long remote_vaddr;
>> +	unsigned long bitmap_offset;
>> +	unsigned long *bitmap_added;
>> +	dma_addr_t iova;
>>  	struct vfio_dma *dma;
>>  	bool do_accounting;
>>  
>> @@ -650,6 +654,12 @@ static int vfio_iommu_type1_pin_pages(void *iommu_data,
>>  
>>  	mutex_lock(&iommu->lock);
>>  
>> +	bitmap_added = bitmap_zalloc(npage, GFP_KERNEL);
>> +	if (!bitmap_added) {
>> +		ret = -ENOMEM;
>> +		goto pin_done;
>> +	}
> 
> 
> This is allocated regardless of whether dirty tracking is enabled, so
> this adds overhead to the common case in order to reduce user overhead
> (not correctness) in the rare condition that dirty tracking is enabled,
> and the even rarer condition that there's a fault during that case.
> This is not a good trade-off.  Thanks,

Hi Alex,

We can allocate the bitmap when dirty tracking is active, do you accept this?
Or we can set the dirty bitmap after all pins succeed, but this costs cpu time
to locate vfio_dma with iova.

Thanks,
Keqian

> 
> Alex
> 
> 
>> +
>>  	/* Fail if notifier list is empty */
>>  	if (!iommu->notifier.head) {
>>  		ret = -EINVAL;
>> @@ -664,7 +674,6 @@ static int vfio_iommu_type1_pin_pages(void *iommu_data,
>>  	do_accounting = !IS_IOMMU_CAP_DOMAIN_IN_CONTAINER(iommu);
>>  
>>  	for (i = 0; i < npage; i++) {
>> -		dma_addr_t iova;
>>  		struct vfio_pfn *vpfn;
>>  
>>  		iova = user_pfn[i] << PAGE_SHIFT;
>> @@ -699,14 +708,10 @@ static int vfio_iommu_type1_pin_pages(void *iommu_data,
>>  		}
>>  
>>  		if (iommu->dirty_page_tracking) {
>> -			unsigned long pgshift = __ffs(iommu->pgsize_bitmap);
>> -
>> -			/*
>> -			 * Bitmap populated with the smallest supported page
>> -			 * size
>> -			 */
>> -			bitmap_set(dma->bitmap,
>> -				   (iova - dma->iova) >> pgshift, 1);
>> +			/* Populated with the smallest supported page size */
>> +			bitmap_offset = (iova - dma->iova) >> pgshift;
>> +			if (!test_and_set_bit(bitmap_offset, dma->bitmap))
>> +				set_bit(i, bitmap_added);
>>  		}
>>  	}
>>  	ret = i;
>> @@ -722,14 +727,20 @@ static int vfio_iommu_type1_pin_pages(void *iommu_data,
>>  pin_unwind:
>>  	phys_pfn[i] = 0;
>>  	for (j = 0; j < i; j++) {
>> -		dma_addr_t iova;
>> -
>>  		iova = user_pfn[j] << PAGE_SHIFT;
>>  		dma = vfio_find_dma(iommu, iova, PAGE_SIZE);
>>  		vfio_unpin_page_external(dma, iova, do_accounting);
>>  		phys_pfn[j] = 0;
>> +
>> +		if (test_bit(j, bitmap_added)) {
>> +			bitmap_offset = (iova - dma->iova) >> pgshift;
>> +			clear_bit(bitmap_offset, dma->bitmap);
>> +		}
>>  	}
>>  pin_done:
>> +	if (bitmap_added)
>> +		bitmap_free(bitmap_added);
>> +
>>  	mutex_unlock(&iommu->lock);
>>  	return ret;
>>  }
> 
> .
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
