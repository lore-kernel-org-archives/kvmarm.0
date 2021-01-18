Return-Path: <SRS0=ax30=GV=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.4 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C48DFC433DB
	for <kvmarm@archiver.kernel.org>; Mon, 18 Jan 2021 12:25:33 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 5DDED22286
	for <kvmarm@archiver.kernel.org>; Mon, 18 Jan 2021 12:25:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5DDED22286
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8DB1E4B291;
	Mon, 18 Jan 2021 07:25:30 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 4dMNhCTowepo; Mon, 18 Jan 2021 07:25:29 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6BA834B298;
	Mon, 18 Jan 2021 07:25:29 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 040704B28B
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Jan 2021 07:25:28 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id sht13Fmyha8C for <kvmarm@lists.cs.columbia.edu>;
 Mon, 18 Jan 2021 07:25:26 -0500 (EST)
Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id ED2E74B289
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Jan 2021 07:25:24 -0500 (EST)
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.58])
 by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4DK9v05GwMzMLhC;
 Mon, 18 Jan 2021 20:23:56 +0800 (CST)
Received: from [10.174.184.42] (10.174.184.42) by
 DGGEMS409-HUB.china.huawei.com (10.3.19.209) with Microsoft SMTP Server id
 14.3.498.0; Mon, 18 Jan 2021 20:25:10 +0800
Subject: Re: [PATCH v2 1/2] vfio/iommu_type1: Populate full dirty when detach
 non-pinned group
To: Alex Williamson <alex.williamson@redhat.com>
References: <20210115092643.728-1-zhukeqian1@huawei.com>
 <20210115092643.728-2-zhukeqian1@huawei.com>
 <20210115110144.61e3c843@omen.home.shazbot.org>
From: Keqian Zhu <zhukeqian1@huawei.com>
Message-ID: <f8de434c-1993-cfe8-c451-2235be1ceb85@huawei.com>
Date: Mon, 18 Jan 2021 20:25:09 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <20210115110144.61e3c843@omen.home.shazbot.org>
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



On 2021/1/16 2:01, Alex Williamson wrote:
> On Fri, 15 Jan 2021 17:26:42 +0800
> Keqian Zhu <zhukeqian1@huawei.com> wrote:
> 
>> If a group with non-pinned-page dirty scope is detached with dirty
>> logging enabled, we should fully populate the dirty bitmaps at the
>> time it's removed since we don't know the extent of its previous DMA,
>> nor will the group be present to trigger the full bitmap when the user
>> retrieves the dirty bitmap.
>>
>> Fixes: d6a4c185660c ("vfio iommu: Implementation of ioctl for dirty pages tracking")
>> Suggested-by: Alex Williamson <alex.williamson@redhat.com>
>> Signed-off-by: Keqian Zhu <zhukeqian1@huawei.com>
>> ---
>>  drivers/vfio/vfio_iommu_type1.c | 18 +++++++++++++++++-
>>  1 file changed, 17 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
>> index 0b4dedaa9128..4e82b9a3440f 100644
>> --- a/drivers/vfio/vfio_iommu_type1.c
>> +++ b/drivers/vfio/vfio_iommu_type1.c
>> @@ -236,6 +236,19 @@ static void vfio_dma_populate_bitmap(struct vfio_dma *dma, size_t pgsize)
>>  	}
>>  }
>>  
>> +static void vfio_iommu_populate_bitmap_full(struct vfio_iommu *iommu)
>> +{
>> +	struct rb_node *n;
>> +	unsigned long pgshift = __ffs(iommu->pgsize_bitmap);
>> +
>> +	for (n = rb_first(&iommu->dma_list); n; n = rb_next(n)) {
>> +		struct vfio_dma *dma = rb_entry(n, struct vfio_dma, node);
>> +
>> +		if (dma->iommu_mapped)
>> +			bitmap_set(dma->bitmap, 0, dma->size >> pgshift);
>> +	}
>> +}
>> +
>>  static int vfio_dma_bitmap_alloc_all(struct vfio_iommu *iommu, size_t pgsize)
>>  {
>>  	struct rb_node *n;
>> @@ -2415,8 +2428,11 @@ static void vfio_iommu_type1_detach_group(void *iommu_data,
>>  	 * Removal of a group without dirty tracking may allow the iommu scope
>>  	 * to be promoted.
>>  	 */
>> -	if (update_dirty_scope)
>> +	if (update_dirty_scope) {
>>  		update_pinned_page_dirty_scope(iommu);
>> +		if (iommu->dirty_page_tracking)
>> +			vfio_iommu_populate_bitmap_full(iommu);
>> +	}
>>  	mutex_unlock(&iommu->lock);
>>  }
>>  
> 
> This doesn't do the right thing.  This marks the bitmap dirty if:
> 
>  * The detached group dirty scope was not limited to pinned pages
> 
>  AND
> 
>  * Dirty tracking is enabled
> 
>  AND
> 
>  * The vfio_dma is *currently* (ie. after the detach) iommu_mapped
> 
> We need to mark the bitmap dirty based on whether the vfio_dma *was*
> iommu_mapped by the group that is now detached.  Thanks,
> 
> Alex
> 
Hi Alex,

Yes, I missed this point again :-(. The update_dirty_scope means we detached
an iommu backed group, and that means the vfio_dma *was* iommu_mapped by this
group, so we can populate full bitmap unconditionally, right?

Thanks,
Keqian


> .
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
