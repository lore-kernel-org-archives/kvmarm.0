Return-Path: <SRS0=/ONs=GQ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5289C433E0
	for <kvmarm@archiver.kernel.org>; Wed, 13 Jan 2021 15:34:12 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2AB4F23382
	for <kvmarm@archiver.kernel.org>; Wed, 13 Jan 2021 15:34:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2AB4F23382
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=nvidia.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 359934B169;
	Wed, 13 Jan 2021 10:34:11 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@nvidia.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id sEnmPAOyIV3s; Wed, 13 Jan 2021 10:34:07 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9B7424B197;
	Wed, 13 Jan 2021 10:34:07 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B6E794B175
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 Jan 2021 07:36:12 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id wHqCu6TCspvr for <kvmarm@lists.cs.columbia.edu>;
 Wed, 13 Jan 2021 07:36:10 -0500 (EST)
Received: from hqnvemgate25.nvidia.com (hqnvemgate25.nvidia.com
 [216.228.121.64])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 33E374B15F
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 Jan 2021 07:36:10 -0500 (EST)
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by
 hqnvemgate25.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
 id <B5ffee9390003>; Wed, 13 Jan 2021 04:36:09 -0800
Received: from HQMAIL107.nvidia.com ([172.20.161.6])
 by hqpgpgate101.nvidia.com (PGP Universal service);
 Wed, 13 Jan 2021 04:36:09 -0800
X-PGP-Universal: processed;
 by hqpgpgate101.nvidia.com on Wed, 13 Jan 2021 04:36:09 -0800
Received: from [10.40.103.89] (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 13 Jan
 2021 12:35:46 +0000
Subject: Re: [PATCH 1/5] vfio/iommu_type1: Fixes vfio_dma_populate_bitmap to
 avoid dirty lose
To: Alex Williamson <alex.williamson@redhat.com>, Keqian Zhu
 <zhukeqian1@huawei.com>
References: <20210107092901.19712-1-zhukeqian1@huawei.com>
 <20210107092901.19712-2-zhukeqian1@huawei.com>
 <20210112142059.074c1b0f@omen.home.shazbot.org>
X-Nvconfidentiality: public
From: Kirti Wankhede <kwankhede@nvidia.com>
Message-ID: <3f4f9a82-0934-b114-8bd8-452e9e56712f@nvidia.com>
Date: Wed, 13 Jan 2021 18:05:43 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <20210112142059.074c1b0f@omen.home.shazbot.org>
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Language: en-US
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
 t=1610541369; bh=NXvEaFvWAjNZyMiCK0/ZtTN/Aeg3+K/9PUTICC5Nef0=;
 h=X-PGP-Universal:Subject:To:CC:References:X-Nvconfidentiality:From:
 Message-ID:Date:User-Agent:MIME-Version:In-Reply-To:
 X-Originating-IP:X-ClientProxiedBy:Content-Type:Content-Language:
 Content-Transfer-Encoding;
 b=EqUP4hL/s2jMR9Jg3Ic52ftGx1THPEep69a2vyp+C+jkj6XM5Q+j633FTvWCop+DF
 KzsGJSxvMtdKjJj2+Rss2HM1N9FnSwq/1MFwZCu8gsToekA29NzCFoZII3AWZnDFzv
 x3mGeD5+O2+rcI8c0uPy52Ugfn0sKqiIJA4fJBjqnCxetHwSeSum7O8BLUfBs+SG04
 hgOdNHY4XD1ZKys1Cw2pOHoP9ZHsx47QUWV/GK+L2kEQd36JlqW1C+KtU5CEvQZKME
 SqQB2h2y40IYvuWIMVfg3HBlz/TMFmx2WW698ZH0KjMmegjxtieyI3ASVo3uzVtnky
 cDyVekLMfXaDw==
X-Mailman-Approved-At: Wed, 13 Jan 2021 10:34:07 -0500
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>,
 Andrew Morton <akpm@linux-foundation.org>, kvm@vger.kernel.org,
 Marc Zyngier <maz@kernel.org>, Joerg Roedel <joro@8bytes.org>,
 Cornelia Huck <cohuck@redhat.com>, linux-kernel@vger.kernel.org,
 Alexios Zavras <alexios.zavras@intel.com>, iommu@lists.linux-foundation.org,
 Catalin Marinas <catalin.marinas@arm.com>, Thomas
 Gleixner <tglx@linutronix.de>, Will
 Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, Robin Murphy <robin.murphy@arm.com>
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



On 1/13/2021 2:50 AM, Alex Williamson wrote:
> On Thu, 7 Jan 2021 17:28:57 +0800
> Keqian Zhu <zhukeqian1@huawei.com> wrote:
> 
>> Defer checking whether vfio_dma is of fully-dirty in update_user_bitmap
>> is easy to lose dirty log. For example, after promoting pinned_scope of
>> vfio_iommu, vfio_dma is not considered as fully-dirty, then we may lose
>> dirty log that occurs before vfio_iommu is promoted.
>>
>> The key point is that pinned-dirty is not a real dirty tracking way, it
>> can't continuously track dirty pages, but just restrict dirty scope. It
>> is essentially the same as fully-dirty. Fully-dirty is of full-scope and
>> pinned-dirty is of pinned-scope.
>>
>> So we must mark pinned-dirty or fully-dirty after we start dirty tracking
>> or clear dirty bitmap, to ensure that dirty log is marked right away.
> 
> I was initially convinced by these first three patches, but upon
> further review, I think the premise is wrong.  AIUI, the concern across
> these patches is that our dirty bitmap is only populated with pages
> dirtied by pinning and we only take into account the pinned page dirty
> scope at the time the bitmap is retrieved by the user.  You suppose
> this presents a gap where if a vendor driver has not yet identified
> with a page pinning scope that the entire bitmap should be considered
> dirty regardless of whether that driver later pins pages prior to the
> user retrieving the dirty bitmap.
> 
> I don't think this is how we intended the cooperation between the iommu
> driver and vendor driver to work.  By pinning pages a vendor driver is
> not declaring that only their future dirty page scope is limited to
> pinned pages, instead they're declaring themselves as a participant in
> dirty page tracking and take responsibility for pinning any necessary
> pages.  For example we might extend VFIO_IOMMU_DIRTY_PAGES_FLAG_START
> to trigger a blocking notification to groups to not only begin dirty
> tracking, but also to synchronously register their current device DMA
> footprint.  This patch would require a vendor driver to possibly perform
> a gratuitous page pinning in order to set the scope prior to dirty
> logging being enabled, or else the initial bitmap will be fully dirty.
> 
> Therefore, I don't see that this series is necessary or correct.  Kirti,
> does this match your thinking?
> 

That's correct Alex and I agree with you.

> Thinking about these semantics, it seems there might still be an issue
> if a group with non-pinned-page dirty scope is detached with dirty
> logging enabled.  

Hot-unplug a device while migration process has started - is this 
scenario supported?

Thanks,
Kirti

> It seems this should in fact fully populate the dirty
> bitmaps at the time it's removed since we don't know the extent of its
> previous DMA, nor will the group be present to trigger the full bitmap
> when the user retrieves the dirty bitmap.  Creating fully populated
> bitmaps at the time tracking is enabled negates our ability to take
> advantage of later enlightenment though.  Thanks,
> 
> Alex
> 
>> Fixes: d6a4c185660c ("vfio iommu: Implementation of ioctl for dirty pages tracking")
>> Signed-off-by: Keqian Zhu <zhukeqian1@huawei.com>
>> ---
>>   drivers/vfio/vfio_iommu_type1.c | 33 ++++++++++++++++++++++-----------
>>   1 file changed, 22 insertions(+), 11 deletions(-)
>>
>> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
>> index bceda5e8baaa..b0a26e8e0adf 100644
>> --- a/drivers/vfio/vfio_iommu_type1.c
>> +++ b/drivers/vfio/vfio_iommu_type1.c
>> @@ -224,7 +224,7 @@ static void vfio_dma_bitmap_free(struct vfio_dma *dma)
>>   	dma->bitmap = NULL;
>>   }
>>   
>> -static void vfio_dma_populate_bitmap(struct vfio_dma *dma, size_t pgsize)
>> +static void vfio_dma_populate_bitmap_pinned(struct vfio_dma *dma, size_t pgsize)
>>   {
>>   	struct rb_node *p;
>>   	unsigned long pgshift = __ffs(pgsize);
>> @@ -236,6 +236,25 @@ static void vfio_dma_populate_bitmap(struct vfio_dma *dma, size_t pgsize)
>>   	}
>>   }
>>   
>> +static void vfio_dma_populate_bitmap_full(struct vfio_dma *dma, size_t pgsize)
>> +{
>> +	unsigned long pgshift = __ffs(pgsize);
>> +	unsigned long nbits = dma->size >> pgshift;
>> +
>> +	bitmap_set(dma->bitmap, 0, nbits);
>> +}
>> +
>> +static void vfio_dma_populate_bitmap(struct vfio_iommu *iommu,
>> +				     struct vfio_dma *dma)
>> +{
>> +	size_t pgsize = (size_t)1 << __ffs(iommu->pgsize_bitmap);
>> +
>> +	if (iommu->pinned_page_dirty_scope)
>> +		vfio_dma_populate_bitmap_pinned(dma, pgsize);
>> +	else if (dma->iommu_mapped)
>> +		vfio_dma_populate_bitmap_full(dma, pgsize);
>> +}
>> +
>>   static int vfio_dma_bitmap_alloc_all(struct vfio_iommu *iommu)
>>   {
>>   	struct rb_node *n;
>> @@ -257,7 +276,7 @@ static int vfio_dma_bitmap_alloc_all(struct vfio_iommu *iommu)
>>   			}
>>   			return ret;
>>   		}
>> -		vfio_dma_populate_bitmap(dma, pgsize);
>> +		vfio_dma_populate_bitmap(iommu, dma);
>>   	}
>>   	return 0;
>>   }
>> @@ -987,13 +1006,6 @@ static int update_user_bitmap(u64 __user *bitmap, struct vfio_iommu *iommu,
>>   	unsigned long shift = bit_offset % BITS_PER_LONG;
>>   	unsigned long leftover;
>>   
>> -	/*
>> -	 * mark all pages dirty if any IOMMU capable device is not able
>> -	 * to report dirty pages and all pages are pinned and mapped.
>> -	 */
>> -	if (!iommu->pinned_page_dirty_scope && dma->iommu_mapped)
>> -		bitmap_set(dma->bitmap, 0, nbits);
>> -
>>   	if (shift) {
>>   		bitmap_shift_left(dma->bitmap, dma->bitmap, shift,
>>   				  nbits + shift);
>> @@ -1019,7 +1031,6 @@ static int vfio_iova_dirty_bitmap(u64 __user *bitmap, struct vfio_iommu *iommu,
>>   	struct vfio_dma *dma;
>>   	struct rb_node *n;
>>   	unsigned long pgshift = __ffs(iommu->pgsize_bitmap);
>> -	size_t pgsize = (size_t)1 << pgshift;
>>   	int ret;
>>   
>>   	/*
>> @@ -1055,7 +1066,7 @@ static int vfio_iova_dirty_bitmap(u64 __user *bitmap, struct vfio_iommu *iommu,
>>   		 * pages which are marked dirty by vfio_dma_rw()
>>   		 */
>>   		bitmap_clear(dma->bitmap, 0, dma->size >> pgshift);
>> -		vfio_dma_populate_bitmap(dma, pgsize);
>> +		vfio_dma_populate_bitmap(iommu, dma);
>>   	}
>>   	return 0;
>>   }
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
